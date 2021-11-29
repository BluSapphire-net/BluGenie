# PSScriptAnalyzerSettings.psd1
# Settings for PSScriptAnalyzer invocation.
@{
    IncludeDefaultRules = $True
    ExcludeRules = @(
        'PSAvoidUsingEmptyCatchBlock',
        'PSUseShouldProcessForStateChangingFunctions',
        'PSAvoidUsingInvokeExpression',
        'PSUseDeclaredVarsMoreThanAssignments',
        'PSAvoidOverwritingBuiltInCmdlets',
        'PSAvoidUsingWriteHost',
        'PSAvoidUsingWMICmdlet',
        'PSUseOutputTypeCorrectly',
        'PSUseProcessBlockForPipelineCommand',
        'PSUseSingularNouns',
        'PSAvoidGlobalVars',
        'PSReviewUnusedParameter',
        'PSAlignAssignmentStatement',
        'PSPossibleIncorrectComparisonWithNull',
        'PSUseApprovedVerbs'
        )
    Rules  = @{
        PSAlignAssignmentStatement  = @{
            Enable = $True
        }
        PSAvoidTrailingWhitespace = @{
            Enable = $True
        }
        PSAvoidUsingCmdletAliases = @{
            'Whitelist' = @('cd')
        }
        PSPlaceCloseBrace = @{
            Enable             = $true
            NoEmptyLineBefore  = $true
            IgnoreOneLineBlock = $false
            NewLineAfter       = $false
        }
        PSPlaceOpenBrace                    = @{
            Enable             = $true
            OnSameLine         = $true
            NewLineAfter       = $false
            IgnoreOneLineBlock = $false
        }
        PSUseCompatibleCmdlets              = @{
            'compatibility' = @(
                                "desktop-5.1.14393.206-windows",
                                "desktop-4.0-windows (taken from Windows Server 2012R2)",
                                "desktop-3.0-windows",
                                "desktop-2.0-windows"
            )
        }
        PSUseLiteralInitializerForHashtable = @{
            Enable = $True
        }
        PSUseCompatibleCommands             = @{
            # Turns the rule on
            Enable         = $true

            # Lists the PowerShell platforms we want to check compatibility with
            TargetProfiles = @(
                'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework',
                'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework',
                'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework',
                'win-8_x64_6.3.9600.0_4.0_x64_4.0.30319.42000_framework',
                'win-8_x64_6.2.9200.0_3.0_x64_4.0.30319.42000_framework'
            )

            # You can specify commands to not check like this, which also will ignore its parameters:
            IgnoreCommands = @(
                'Write-Host',
                'Clear-Host',
                'Pause',
                'Get-Date'
            )
        }
        PSUseCompatibleSyntax               = @{
            # This turns the rule on (setting it to false will turn it off)
            Enable         = $true

            # Simply list the targeted versions of PowerShell here
            TargetVersions = @(
                '3.0',
                '4.0',
                '5.0',
                '5.1'
            )
        }
    }
}