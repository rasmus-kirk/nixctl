
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
            cand -h 'Print help'
            cand --help 'Print help'
            cand -V 'Print version'
            cand --version 'Print version'
            cand clean 'Removes unsed files from nix store'
            cand purge 'Deletes all previous generations from nix store'
            cand update 'Updates flake.lock'
            cand upgrade 'Upgrades system (also updates flake.lock)'
            cand build '(Re)Builds system'
            cand analyse 'Analyses storage usage of nix store'
            cand optimise 'Optimises nix store'
            cand help 'Print this message or the help of the given subcommand(s)'
        }
        &'nixctl;clean'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;purge'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;update'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;upgrade'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;build'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;analyse'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;optimise'= {
            cand -h 'Print help'
            cand --help 'Print help'
        }
        &'nixctl;help'= {
            cand clean 'Removes unsed files from nix store'
            cand purge 'Deletes all previous generations from nix store'
            cand update 'Updates flake.lock'
            cand upgrade 'Upgrades system (also updates flake.lock)'
            cand build '(Re)Builds system'
            cand analyse 'Analyses storage usage of nix store'
            cand optimise 'Optimises nix store'
            cand help 'Print this message or the help of the given subcommand(s)'
        }
        &'nixctl;help;clean'= {
        }
        &'nixctl;help;purge'= {
        }
        &'nixctl;help;update'= {
        }
        &'nixctl;help;upgrade'= {
        }
        &'nixctl;help;build'= {
        }
        &'nixctl;help;analyse'= {
        }
        &'nixctl;help;optimise'= {
        }
        &'nixctl;help;help'= {
        }
    ]
    $completions[$command]
}
