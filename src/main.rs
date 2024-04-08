use clap::{Parser, Subcommand};
use colored::*;
use dialoguer::{theme::ColorfulTheme, Confirm};
use duct::cmd;
use std::{env, process::exit};
/// Simple wrapper around various nix tools.
#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
pub struct Args {
    #[command(subcommand)]
    cmd: Commands,
}
#[derive(Subcommand, Debug, Clone)]
enum Commands {
    /// Removes unsed files from nix store
    Clean,
    /// Deletes all previous generations from nix store
    Purge,
    /// Updates flake.lock
    Update,
    /// Upgrades system (also updates flake.lock)
    Upgrade,
    /// (Re)Builds system
    Build,
    /// Analyses storage usage of nix store
    Analyse,
    /// Optimises nix store
    Optimise,
}
fn print_result(output: Result<std::process::Output, std::io::Error>, msg: &str) {
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

fn main() {
    let cli = Args::parse();
    if let Err(err) = env::set_current_dir("/etc/nixos/") {
        eprintln!("Error: {}", err);
        return;
    }

    match &cli.cmd {
        Commands::Clean => {
            print_result(
                cmd!("sudo", "nix-collect-garbage").run(),
                "Clean and fresh!",
            );
        }
        Commands::Purge => {
            if !Confirm::with_theme(&ColorfulTheme::default())
                .with_prompt("Do you really want to delete all previous generations?")
                .interact()
                .unwrap()
            {
                exit(0);
            }

            print_result(
                cmd!("sudo", "nix-collect-garbage", "-d").run(),
                "Super clean and fresh!",
            );
        }
        Commands::Update => {
            if !Confirm::with_theme(&ColorfulTheme::default())
                .with_prompt("Do you really want to update flake.lock?")
                .interact()
                .unwrap()
            {
                exit(0);
            }
            print_result(
                cmd!("sudo", "nix", "flake", "update").run(),
                "Flake.lock updated",
            );
        }
        Commands::Upgrade => {
            if !Confirm::with_theme(&ColorfulTheme::default())
                .with_prompt("Do you really want to upgrade?")
                .interact()
                .unwrap()
            {
                exit(0);
            }

            print_result(
                cmd!("sudo", "nix", "flake", "update").run(),
                "Flake.lock updated",
            );

            print_result(
                cmd!("sudo", "nixos-rebuild", "switch", "--upgrade").run(),
                "System upgrade complete",
            );
        }
        Commands::Build => {
            print_result(
                cmd!("sudo", "nixos-rebuild", "switch").run(),
                "System build complete",
            );
        }
        Commands::Analyse => {
            duct_sh::sh(
                "nix-shell -p gnome.eog graphviz nix-du --command '
                TMP_FILE=$(mktemp -q /tmp/store.XXXXXX.png)
                nix-du -s=500MB | dot -Tpng > $TMP_FILE && eog $TMP_FILE &'",
            )
            .run();
        }
        Commands::Optimise => {
            print_result(
                cmd!("sudo", "nix-store", "--optimise").run(),
                "Nix store optimised!",
            );
        }
    }
}
