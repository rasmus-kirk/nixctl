
using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Register-ArgumentCompleter -Native -CommandName 'nixctl' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    $commandElements = $commandAst.CommandElements
    $command = @(
        'nixctl'
        for ($i = 1; $i -lt $commandElements.Count; $i++) {
            $element = $commandElements[$i]
            if ($element -isnot [StringConstantExpressionAst] -or
                $element.StringConstantType -ne [StringConstantType]::BareWord -or
                $element.Value.StartsWith('-') -or
                $element.Value -eq $wordToComplete) {
                break
        }
        $element.Value
    }) -join ';'

    $completions = @(switch ($command) {
        'nixctl' {
            [CompletionResult]::new('--machine', 'machine', [CompletionResultType]::ParameterName, 'machine')
            [CompletionResult]::new('--config-dir', 'config-dir', [CompletionResultType]::ParameterName, 'config-dir')
            [CompletionResult]::new('--nixctl-config-file', 'nixctl-config-file', [CompletionResultType]::ParameterName, 'nixctl-config-file')
            [CompletionResult]::new('--impure', 'impure', [CompletionResultType]::ParameterName, 'impure')
            [CompletionResult]::new('--debug', 'debug', [CompletionResultType]::ParameterName, 'debug')
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('-V', 'V ', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('home-manager', 'home-manager', [CompletionResultType]::ParameterValue, 'Operate Home Manager')
            [CompletionResult]::new('nix-os', 'nix-os', [CompletionResultType]::ParameterValue, 'Operate NixOS')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'nixctl;home-manager' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('clean', 'clean', [CompletionResultType]::ParameterValue, 'Removes unsed files from nix store')
            [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Updates flake.lock')
            [CompletionResult]::new('upgrade', 'upgrade', [CompletionResultType]::ParameterValue, 'Upgrades system (also updates flake.lock)')
            [CompletionResult]::new('options', 'options', [CompletionResultType]::ParameterValue, 'Show configuration options')
            [CompletionResult]::new('rebuild', 'rebuild', [CompletionResultType]::ParameterValue, 'rebuild')
            [CompletionResult]::new('rollback', 'rollback', [CompletionResultType]::ParameterValue, 'rollback')
            [CompletionResult]::new('test', 'test', [CompletionResultType]::ParameterValue, 'test')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'nixctl;home-manager;clean' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;home-manager;update' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;home-manager;upgrade' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;home-manager;options' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;home-manager;rebuild' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;home-manager;rollback' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;home-manager;test' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;home-manager;help' {
            [CompletionResult]::new('clean', 'clean', [CompletionResultType]::ParameterValue, 'Removes unsed files from nix store')
            [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Updates flake.lock')
            [CompletionResult]::new('upgrade', 'upgrade', [CompletionResultType]::ParameterValue, 'Upgrades system (also updates flake.lock)')
            [CompletionResult]::new('options', 'options', [CompletionResultType]::ParameterValue, 'Show configuration options')
            [CompletionResult]::new('rebuild', 'rebuild', [CompletionResultType]::ParameterValue, 'rebuild')
            [CompletionResult]::new('rollback', 'rollback', [CompletionResultType]::ParameterValue, 'rollback')
            [CompletionResult]::new('test', 'test', [CompletionResultType]::ParameterValue, 'test')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'nixctl;home-manager;help;clean' {
            break
        }
        'nixctl;home-manager;help;update' {
            break
        }
        'nixctl;home-manager;help;upgrade' {
            break
        }
        'nixctl;home-manager;help;options' {
            break
        }
        'nixctl;home-manager;help;rebuild' {
            break
        }
        'nixctl;home-manager;help;rollback' {
            break
        }
        'nixctl;home-manager;help;test' {
            break
        }
        'nixctl;home-manager;help;help' {
            break
        }
        'nixctl;nix-os' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('clean', 'clean', [CompletionResultType]::ParameterValue, 'Removes unsed files from nix store')
            [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Updates flake.lock')
            [CompletionResult]::new('upgrade', 'upgrade', [CompletionResultType]::ParameterValue, 'Upgrades system (also updates flake.lock)')
            [CompletionResult]::new('options', 'options', [CompletionResultType]::ParameterValue, 'Show configuration options')
            [CompletionResult]::new('rebuild', 'rebuild', [CompletionResultType]::ParameterValue, 'rebuild')
            [CompletionResult]::new('rollback', 'rollback', [CompletionResultType]::ParameterValue, 'rollback')
            [CompletionResult]::new('test', 'test', [CompletionResultType]::ParameterValue, 'test')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'nixctl;nix-os;clean' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;nix-os;update' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;nix-os;upgrade' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;nix-os;options' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;nix-os;rebuild' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;nix-os;rollback' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;nix-os;test' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;nix-os;help' {
            [CompletionResult]::new('clean', 'clean', [CompletionResultType]::ParameterValue, 'Removes unsed files from nix store')
            [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Updates flake.lock')
            [CompletionResult]::new('upgrade', 'upgrade', [CompletionResultType]::ParameterValue, 'Upgrades system (also updates flake.lock)')
            [CompletionResult]::new('options', 'options', [CompletionResultType]::ParameterValue, 'Show configuration options')
            [CompletionResult]::new('rebuild', 'rebuild', [CompletionResultType]::ParameterValue, 'rebuild')
            [CompletionResult]::new('rollback', 'rollback', [CompletionResultType]::ParameterValue, 'rollback')
            [CompletionResult]::new('test', 'test', [CompletionResultType]::ParameterValue, 'test')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'nixctl;nix-os;help;clean' {
            break
        }
        'nixctl;nix-os;help;update' {
            break
        }
        'nixctl;nix-os;help;upgrade' {
            break
        }
        'nixctl;nix-os;help;options' {
            break
        }
        'nixctl;nix-os;help;rebuild' {
            break
        }
        'nixctl;nix-os;help;rollback' {
            break
        }
        'nixctl;nix-os;help;test' {
            break
        }
        'nixctl;nix-os;help;help' {
            break
        }
        'nixctl;help' {
            [CompletionResult]::new('home-manager', 'home-manager', [CompletionResultType]::ParameterValue, 'Operate Home Manager')
            [CompletionResult]::new('nix-os', 'nix-os', [CompletionResultType]::ParameterValue, 'Operate NixOS')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'nixctl;help;home-manager' {
            [CompletionResult]::new('clean', 'clean', [CompletionResultType]::ParameterValue, 'Removes unsed files from nix store')
            [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Updates flake.lock')
            [CompletionResult]::new('upgrade', 'upgrade', [CompletionResultType]::ParameterValue, 'Upgrades system (also updates flake.lock)')
            [CompletionResult]::new('options', 'options', [CompletionResultType]::ParameterValue, 'Show configuration options')
            [CompletionResult]::new('rebuild', 'rebuild', [CompletionResultType]::ParameterValue, 'rebuild')
            [CompletionResult]::new('rollback', 'rollback', [CompletionResultType]::ParameterValue, 'rollback')
            [CompletionResult]::new('test', 'test', [CompletionResultType]::ParameterValue, 'test')
            break
        }
        'nixctl;help;home-manager;clean' {
            break
        }
        'nixctl;help;home-manager;update' {
            break
        }
        'nixctl;help;home-manager;upgrade' {
            break
        }
        'nixctl;help;home-manager;options' {
            break
        }
        'nixctl;help;home-manager;rebuild' {
            break
        }
        'nixctl;help;home-manager;rollback' {
            break
        }
        'nixctl;help;home-manager;test' {
            break
        }
        'nixctl;help;nix-os' {
            [CompletionResult]::new('clean', 'clean', [CompletionResultType]::ParameterValue, 'Removes unsed files from nix store')
            [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Updates flake.lock')
            [CompletionResult]::new('upgrade', 'upgrade', [CompletionResultType]::ParameterValue, 'Upgrades system (also updates flake.lock)')
            [CompletionResult]::new('options', 'options', [CompletionResultType]::ParameterValue, 'Show configuration options')
            [CompletionResult]::new('rebuild', 'rebuild', [CompletionResultType]::ParameterValue, 'rebuild')
            [CompletionResult]::new('rollback', 'rollback', [CompletionResultType]::ParameterValue, 'rollback')
            [CompletionResult]::new('test', 'test', [CompletionResultType]::ParameterValue, 'test')
            break
        }
        'nixctl;help;nix-os;clean' {
            break
        }
        'nixctl;help;nix-os;update' {
            break
        }
        'nixctl;help;nix-os;upgrade' {
            break
        }
        'nixctl;help;nix-os;options' {
            break
        }
        'nixctl;help;nix-os;rebuild' {
            break
        }
        'nixctl;help;nix-os;rollback' {
            break
        }
        'nixctl;help;nix-os;test' {
            break
        }
        'nixctl;help;help' {
            break
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
