
use builtin;
use str;

set edit:completion:arg-completer[nixctl] = {|@words|
    fn spaces {|n|
        builtin:repeat $n ' ' | str:join ''
    }
    fn cand {|text desc|
        edit:complex-candidate $text &display=$text' '(spaces (- 14 (wcswidth $text)))$desc
    }
    var command = 'nixctl'
    for word $words[1..-1] {
        if (str:has-prefix $word '-') {
            break
        }
        set command = $command';'$word
    }
    var completions = [
        &'nixctl'= {
            cand --machine 'machine'
            cand --config-dir 'config-dir'
            cand --nixctl-config-file 'nixctl-config-file'
            cand --impure 'impure'
            cand --debug 'debug'
            cand -h 'Print help'
            cand --help 'Print help'
            cand -V 'Print version'
            cand --version 'Print version'
            cand home-manager 'Operate Home Manager'
            cand nix-os 'Operate NixOS'
            cand help 'Print this message or the help of the given subcommand(s)'
        }
        &'nixctl;home-manager'= {
            cand -h 'Print help'
            cand --help 'Print help'
            cand clean 'Removes unsed files from nix store'
            cand update 'Updates flake.lock'
            cand upgrade 'Upgrades system (also updates flake.lock)'
            cand options 'Show configuration options'
            cand rebuild 'rebuild'
            cand rollback 'rollback'
            cand test 'test'
            cand help 'Print this message or the help of the given subcommand(s)'
        }
        &'nixctl;home-manager;clean'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;home-manager;update'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;home-manager;upgrade'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;home-manager;options'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;home-manager;rebuild'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;home-manager;rollback'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;home-manager;test'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;home-manager;help'= {
            cand clean 'Removes unsed files from nix store'
            cand update 'Updates flake.lock'
            cand upgrade 'Upgrades system (also updates flake.lock)'
            cand options 'Show configuration options'
            cand rebuild 'rebuild'
            cand rollback 'rollback'
            cand test 'test'
            cand help 'Print this message or the help of the given subcommand(s)'
        }
        &'nixctl;home-manager;help;clean'= {
        }
        &'nixctl;home-manager;help;update'= {
        }
        &'nixctl;home-manager;help;upgrade'= {
        }
        &'nixctl;home-manager;help;options'= {
        }
        &'nixctl;home-manager;help;rebuild'= {
        }
        &'nixctl;home-manager;help;rollback'= {
        }
        &'nixctl;home-manager;help;test'= {
        }
        &'nixctl;home-manager;help;help'= {
        }
        &'nixctl;nix-os'= {
            cand -h 'Print help'
            cand --help 'Print help'
            cand clean 'Removes unsed files from nix store'
            cand update 'Updates flake.lock'
            cand upgrade 'Upgrades system (also updates flake.lock)'
            cand options 'Show configuration options'
            cand rebuild 'rebuild'
            cand rollback 'rollback'
            cand test 'test'
            cand help 'Print this message or the help of the given subcommand(s)'
        }
        &'nixctl;nix-os;clean'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;nix-os;update'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;nix-os;upgrade'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;nix-os;options'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;nix-os;rebuild'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;nix-os;rollback'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;nix-os;test'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;nix-os;help'= {
            cand clean 'Removes unsed files from nix store'
            cand update 'Updates flake.lock'
            cand upgrade 'Upgrades system (also updates flake.lock)'
            cand options 'Show configuration options'
            cand rebuild 'rebuild'
            cand rollback 'rollback'
            cand test 'test'
            cand help 'Print this message or the help of the given subcommand(s)'
        }
        &'nixctl;nix-os;help;clean'= {
        }
        &'nixctl;nix-os;help;update'= {
        }
        &'nixctl;nix-os;help;upgrade'= {
        }
        &'nixctl;nix-os;help;options'= {
        }
        &'nixctl;nix-os;help;rebuild'= {
        }
        &'nixctl;nix-os;help;rollback'= {
        }
        &'nixctl;nix-os;help;test'= {
        }
        &'nixctl;nix-os;help;help'= {
        }
        &'nixctl;help'= {
            cand home-manager 'Operate Home Manager'
            cand nix-os 'Operate NixOS'
            cand help 'Print this message or the help of the given subcommand(s)'
        }
        &'nixctl;help;home-manager'= {
            cand clean 'Removes unsed files from nix store'
            cand update 'Updates flake.lock'
            cand upgrade 'Upgrades system (also updates flake.lock)'
            cand options 'Show configuration options'
            cand rebuild 'rebuild'
            cand rollback 'rollback'
            cand test 'test'
        }
        &'nixctl;help;home-manager;clean'= {
        }
        &'nixctl;help;home-manager;update'= {
        }
        &'nixctl;help;home-manager;upgrade'= {
        }
        &'nixctl;help;home-manager;options'= {
        }
        &'nixctl;help;home-manager;rebuild'= {
        }
        &'nixctl;help;home-manager;rollback'= {
        }
        &'nixctl;help;home-manager;test'= {
        }
        &'nixctl;help;nix-os'= {
            cand clean 'Removes unsed files from nix store'
            cand update 'Updates flake.lock'
            cand upgrade 'Upgrades system (also updates flake.lock)'
            cand options 'Show configuration options'
            cand rebuild 'rebuild'
            cand rollback 'rollback'
            cand test 'test'
        }
        &'nixctl;help;nix-os;clean'= {
        }
        &'nixctl;help;nix-os;update'= {
        }
        &'nixctl;help;nix-os;upgrade'= {
        }
        &'nixctl;help;nix-os;options'= {
        }
        &'nixctl;help;nix-os;rebuild'= {
        }
        &'nixctl;help;nix-os;rollback'= {
        }
        &'nixctl;help;nix-os;test'= {
        }
        &'nixctl;help;help'= {
        }
    ]
    $completions[$command]
}
