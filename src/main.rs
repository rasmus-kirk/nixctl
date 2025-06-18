use anyhow::Context;
use chrono::{Duration, NaiveDate, Utc};
use clap::{Parser, Subcommand};
use colored::*;
use duct::{cmd, Expression};
use regex::Regex;
use std::{
    env::{self, temp_dir}, fs,
    path::{Path, PathBuf},
    process::exit,
};

use config::{Config, File};
use serde::Deserialize;

#[derive(Debug, Deserialize)]
struct AppConfig {
    machine: Option<String>,
    config_dir: Option<PathBuf>,
    impure: Option<bool>,
    debug: Option<bool>,
}

/// nixctl: A CLI wrapper around Nix, NixOS, and Home Manager commands.
///
/// This tool streamlines common Nix-related operations like upgrades,
/// testing, rollback, and option inspection by wrapping `nixos-rebuild`,
/// `home-manager`, and `nix` invocations. It supports configuration via
/// command-line arguments, environment variables, or an optional config file.
///
/// Configuration precedence: CLI > Env > Config File
#[derive(Parser, Debug)]
#[command(version, about = "Wrapper for Nix, NixOS, and Home Manager tools", long_about = None)]
pub struct Args {
    #[arg(long, env = "NIXCTL_MACHINE")]
    machine: Option<String>,

    #[arg(long, env = "NIXCTL_CONFIG_DIR")]
    config_dir: Option<PathBuf>,

    #[arg(long, env = "NIXCTL_CONFIG")]
    nixctl_config_file: Option<PathBuf>,

    #[arg(long, env = "IMPURE", default_value_t = false)]
    impure: bool,

    #[arg(long, env = "DEBUG", default_value_t = false)]
    debug: bool,

    #[command(subcommand)]
    cmd: Commands,
}

#[derive(Subcommand, Debug, Clone)]
enum Commands {
    /// Operate Home Manager
    #[command(subcommand)]
    HomeManager(Sub),
    /// Operate NixOS
    #[command(subcommand)]
    NixOs(Sub),
}

#[derive(Subcommand, Debug, Clone)]
enum Sub {
    /// Removes unsed files from nix store
    Clean,
    /// Updates flake.lock
    Update,
    /// Upgrades system (also updates flake.lock)
    Upgrade,
    /// Show configuration options
    Options,
    /// rebuild
    Rebuild,
    /// rollback
    Rollback,
    /// test
    Test,
}

// Helper
fn run_with_command(output: Result<std::process::Output, std::io::Error>, msg: &str) {
    match output {
        Ok(output) => {
            // Check if the command executed successfully
            if output.status.success() {
                println!("\n{}", msg.green());
            } else {
                // Print error message from stderr
                let error_msg = String::from_utf8_lossy(&output.stderr).red();
                println!("{}", error_msg);
                exit(1);
            }
        }
        Err(e) => {
            // Print error if the command couldn't be executed
            println!("{}", e);
            exit(1);
        }
    }
}

macro_rules! print_err {
    ($($arg:tt)*) => {{
        use colored::Colorize;
        println!("{} {}", "[NIXCTL_ERROR]:".bold().red(), format!($($arg)*));
    }};
}
macro_rules! print_warn {
    ($($arg:tt)*) => {{
        use colored::Colorize;
        println!("{} {}", "[NIXCTL_WARNING]:".bold().yellow(), format!($($arg)*));
    }};
}
macro_rules! print_info {
    ($($arg:tt)*) => {{
        use colored::Colorize;
        println!("{} {}", "[NIXCTL_INFO]:".bold(), format!($($arg)*));
    }};
}

fn main() -> anyhow::Result<()> {
    let cli = Args::parse();

    let settings = Config::builder()
        .add_source(File::with_name("config"))
        .build()?
        .try_deserialize::<AppConfig>()?;

    println!("Loaded config: {:#?}", settings);
    let config_dir = settings.config_dir.unwrap();
    let machine = settings.machine.unwrap();
    let impure = match settings.impure {
        Some(true) => "--impure",
        _ => "",
    };

    let user_cache = match env::var("XDG_CACHE_HOME") {
        Err(_) => {
            let home = env::var("HOME")?;
            PathBuf::from(home).join(".cache")
        }
        Ok(s) => PathBuf::from(s),
    };
    let user_config = match env::var("XDG_CONFIG_HOME") {
        Err(_) => {
            let home = env::var("HOME")?;
            PathBuf::from(home).join(".config")
        }
        Ok(s) => PathBuf::from(s),
    };
    let hm_last_update_file = user_cache.join("nixctl").join("home-manager-last-update");
    let nos_last_update_file = user_cache.join("nixctl").join("nixos-last-update");

    let handle_mimeapps = || -> anyhow::Result<()> {
        let mimeapps_list = user_config.join("mimeapps.list");
        let mimeapps_list_backup = user_config.join("mimeapps.list.backup");
        println!("{:?}", mimeapps_list.exists());
        println!("{:?}", mimeapps_list_backup.exists());
        if mimeapps_list.is_file() && mimeapps_list_backup.is_file() {
            print_info!("Trashing {}...", mimeapps_list_backup.display());
            if !cmd!("trash-put", &mimeapps_list).run()?.status.success() {
                print_err!("Failed to trash {}", mimeapps_list.display());
            }
        }
        if mimeapps_list.is_file() {
            fs::copy(&mimeapps_list, mimeapps_list_backup)?;
            if !cmd!("trash-put", &mimeapps_list).run()?.status.success() {
                print_err!("Failed to trash {}", mimeapps_list.display());
            }
        };
        Ok(())
    };

    let clean = || -> anyhow::Result<()> {
        print_info!("Garbage collecting the Nix store...");
        cmd!("home-manager", "expire-generations", "-30 days").run()?;
        cmd!(
            "nix",
            "profile",
            "wipe-history",
            "--older-than",
            "30d",
            "--no-warn-dirty"
        )
        .run()?;
        cmd!("nix", "store", "gc", "--no-warn-dirty").run()?;
        cmd!("nix", "store", "optimise", "--no-warn-dirty").run()?;
        Ok(())
    };

    let update = || -> anyhow::Result<()> {
        print_info!("Updating packages for the next rebuild, by updating the Nix flake inputs...");
        cmd!(
            "nix",
            "flake",
            "update",
            "--flake",
            &config_dir,
            "--no-warn-dirty"
        )
        .run()?;
        Ok(())
    };

    let generic_rebuild = |info_msg: &str, upgrade_command: &str, update_file: &Path, rebuild_expr: Expression| -> anyhow::Result<()> {
        print_info!("{info_msg}");

        if !hm_last_update_file.is_file() {
            print_warn!("Could not determine last full upgrade, please run \"{upgrade_command}\"",);
        } else {
            // Read last update date or fallback to 31 days ago
            let last_update_str = fs::read_to_string(update_file)
                .map(|s| s.trim().to_string())
                .unwrap_or_else(|_| {
                    // fallback to 31 days ago formatted as YYYY-MM-DD
                    let fallback_date = (Utc::now() - Duration::days(31)).date_naive();
                    fallback_date.format("%Y-%m-%d").to_string()
                });

            let today = Utc::now().date_naive();
            let last_update_date = NaiveDate::parse_from_str(&last_update_str, "%Y-%m-%d")?;
            let date_diff = (today - last_update_date).num_days();

            if date_diff > 30 {
                print_warn!(
                    "Last full upgrade was {date_diff} days ago, please run \"{upgrade_command}\""
                );
            }
        }

        handle_mimeapps()?;

        cmd!("git", "add", ".").dir(&config_dir).run()?;

        rebuild_expr.dir(&config_dir).run()?;
        cmd!(
            "home-manager",
            "switch",
            "-b",
            "backup",
            "--flake",
            format!(".#{machine}"),
            "--option",
            "warn-dirty",
            "false"
        )
        .dir(&config_dir)
        .run()?;

        Ok(())
    };
    let hm_rebuild = || -> anyhow::Result<()> {
        generic_rebuild(
            "Rebuilding Home Manager configuration...",
            "nixctl home-manager upgrade",
            &hm_last_update_file,
            cmd!(
                "home-manager",
                "switch",
                "-b",
                "backup",
                "--flake",
                format!(".#{machine}"),
                "--option",
                "warn-dirty",
                "false"
            )
        )
    };
    let nos_rebuild = || -> anyhow::Result<()> {
        generic_rebuild(
            "Rebuilding NixOS configuration...",
            "nixctl nixos upgrade",
            &hm_last_update_file,
            cmd!(
                "nixos-rebuild",
                "switch",
                "--flake",
                format!(".#{machine}"),
                impure,
                "--option",
                "warn-dirty",
                "false"
            )
        )
    };

    match &cli.cmd {
        Commands::HomeManager(sub) => {
            match sub {
                Sub::Clean => clean()?,
                Sub::Update => update()?,
                Sub::Options => { cmd!("man", "home-configuration.nix").run()?; },
                Sub::Rebuild => hm_rebuild()?,
                Sub::Rollback => {
                    let output = cmd!("home-manager", "generations")
                        .pipe(cmd!("fzf"))
                        .read()?;

                    // Exit early if nothing selected
                    if output.trim().is_empty() {
                        print_err!("No generation selected. Aborting.");
                        exit(1);
                    }

                    let gen_path_re = Regex::new(r"/nix/store/[^\s]+")?;
                    let gen_id_re = Regex::new(r"id (\d+)")?;

                    let gen_path = gen_path_re
                        .find(&output)
                        .with_context(|| "Could not extract generation path")?
                        .as_str()
                        .to_string();

                    let gen_id = gen_id_re
                        .captures(&output)
                        .and_then(|caps| caps.get(1))
                        .map(|m| m.as_str().to_string())
                        .with_context(|| "Could not extract generation ID")?;

                    handle_mimeapps()?;

                    print_info!("Activating generation {gen_id}:");
                    cmd!(format!("{}/activate", gen_path)).run()?;
                }
                Sub::Upgrade => {
                    update()?;
                    hm_rebuild()?;
                    clean()?;

                    let cache_dir = hm_last_update_file
                        .parent()
                        .with_context(|| "unable to get parent of {hm_last_update_file}")?;
                    fs::create_dir_all(cache_dir)?;

                    let cur_date = Utc::now().format("%Y-%m-%d").to_string();
                    fs::write(hm_last_update_file, cur_date)?;
                }
                Sub::Test => {
                    let tmp = temp_dir();
                    print_info!("Building the test configuration to {}...", tmp.display());
                    cmd!(
                        "home-manager",
                        "build",
                        "--flake",
                        format!("{}#{machine}", config_dir.display())
                    )
                    .dir(&tmp)
                    .run()?;
                }
            }
        }
        Commands::NixOs(sub) => {
            match sub {
                Sub::Clean => clean()?,
                Sub::Update => update()?,
                Sub::Upgrade => {
                    update()?;
                    nos_rebuild()?;
                    clean()?;

                    let cache_dir = nos_last_update_file
                        .parent()
                        .with_context(|| "unable to get parent of {nos_last_update_file}")?;
                    fs::create_dir_all(cache_dir)?;

                    let cur_date = Utc::now().format("%Y-%m-%d").to_string();
                    fs::write(nos_last_update_file, cur_date)?;
                },
                Sub::Options => { cmd!("man", "configuration.nix").run()?; },
                Sub::Rebuild => nos_rebuild()?,
                Sub::Rollback => {
                    let history_output = cmd!("nix", "profile", "history", "--profile", "/nix/var/nix/profiles/system")
                        .read()?;

                    let version_lines: Vec<&str> = history_output
                        .lines()
                        .filter(|line| line.starts_with("Version "))
                        .collect();

                    let fzf_input = version_lines.join("\n");

                    let selected = cmd!("fzf")
                        .stdin_bytes(fzf_input)
                        .read()?;

                    if selected.trim().is_empty() {
                        eprintln!("[ERROR] No generation selected. Aborting.");
                        exit(1);
                    }

                    let gen_id_re = Regex::new(r"Version (\d+)")?;

                    let gen_id = gen_id_re
                        .captures(&selected)
                        .and_then(|caps| caps.get(1))
                        .map(|m| m.as_str().to_string())
                        .with_context(|| "Could not extract generation ID")?;

                    let gen_path = format!("/nix/var/nix/profiles/system-{gen_id}-link");

                    handle_mimeapps()?;
                    
                    println!("[INFO] Activating system generation {gen_id}...");
                    cmd!(format!("{}/activate", gen_path)).run()?;
                },
                Sub::Test => {
                    let tmp = temp_dir();
                    print_info!("Building the test configuration to {}...", tmp.display());
                    cmd!(
                        "nixos-rebuild",
                        "build",
                        "--flake",
                        format!("{}#{machine}", config_dir.display()),
                        impure,
                        "--option",
                        "warn-dirty",
                        "false"
                    )
                    .dir(&tmp)
                    .run()?;
                },
            }
        }
    }

    Ok(())
}
