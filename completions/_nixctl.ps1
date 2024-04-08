
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
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('-V', 'V ', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('--version', 'version', [CompletionResultType]::ParameterName, 'Print version')
            [CompletionResult]::new('clean', 'clean', [CompletionResultType]::ParameterValue, 'Removes unsed files from nix store')
            [CompletionResult]::new('purge', 'purge', [CompletionResultType]::ParameterValue, 'Deletes all previous generations from nix store')
            [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Updates flake.lock')
            [CompletionResult]::new('upgrade', 'upgrade', [CompletionResultType]::ParameterValue, 'Upgrades system (also updates flake.lock)')
            [CompletionResult]::new('build', 'build', [CompletionResultType]::ParameterValue, '(Re)Builds system')
            [CompletionResult]::new('analyse', 'analyse', [CompletionResultType]::ParameterValue, 'Analyses storage usage of nix store')
            [CompletionResult]::new('optimise', 'optimise', [CompletionResultType]::ParameterValue, 'Optimises nix store')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'nixctl;clean' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;purge' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;update' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;upgrade' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;build' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;analyse' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;optimise' {
            [CompletionResult]::new('-h', 'h', [CompletionResultType]::ParameterName, 'Print help')
            [CompletionResult]::new('--help', 'help', [CompletionResultType]::ParameterName, 'Print help')
            break
        }
        'nixctl;help' {
            [CompletionResult]::new('clean', 'clean', [CompletionResultType]::ParameterValue, 'Removes unsed files from nix store')
            [CompletionResult]::new('purge', 'purge', [CompletionResultType]::ParameterValue, 'Deletes all previous generations from nix store')
            [CompletionResult]::new('update', 'update', [CompletionResultType]::ParameterValue, 'Updates flake.lock')
            [CompletionResult]::new('upgrade', 'upgrade', [CompletionResultType]::ParameterValue, 'Upgrades system (also updates flake.lock)')
            [CompletionResult]::new('build', 'build', [CompletionResultType]::ParameterValue, '(Re)Builds system')
            [CompletionResult]::new('analyse', 'analyse', [CompletionResultType]::ParameterValue, 'Analyses storage usage of nix store')
            [CompletionResult]::new('optimise', 'optimise', [CompletionResultType]::ParameterValue, 'Optimises nix store')
            [CompletionResult]::new('help', 'help', [CompletionResultType]::ParameterValue, 'Print this message or the help of the given subcommand(s)')
            break
        }
        'nixctl;help;clean' {
            break
        }
        'nixctl;help;purge' {
            break
        }
        'nixctl;help;update' {
            break
        }
        'nixctl;help;upgrade' {
            break
        }
        'nixctl;help;build' {
            break
        }
        'nixctl;help;analyse' {
            break
        }
        'nixctl;help;optimise' {
            break
        }
        'nixctl;help;help' {
            break
        }
    })

    $completions.Where{ $_.CompletionText -like "$wordToComplete*" } |
        Sort-Object -Property ListItemText
}
