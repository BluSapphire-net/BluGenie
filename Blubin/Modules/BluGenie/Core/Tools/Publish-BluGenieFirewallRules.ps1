#region Publish-BluGenieFirewallRules (Function)
    Function Publish-BluGenieFirewallRules
    {
        <#
            .SYNOPSIS 
                Publish-BluGenieFirewallRules will search the $ScriptDirectory for *.Rule [FireWall Rule Files] to import

            .DESCRIPTION
                Publish-BluGenieFirewallRules will search the $ScriptDirectory for *.Rule [FireWall Rule Files] to import

            .EXAMPLE
                Publish-BluGenieFirewallRules

                This will search the $ScriptDirectory for *.Rule [FireWall Rule Files] to import
        
            .OUTPUTS
                

            .NOTES
                
                * Original Author           : Michael Arroyo
                * Original Build Version    : *
                * Latest Author             : Michael Arroyo
                * Latest Build Version      : 1905.2001
                * Comments                  : 
                * Dependencies              : 
                                                ~
                * Build Version Details     : 
                                                ~ *        : * [Michael Arroyo] Posted
                                                ~ 1905.2001: * [Michael Arroyo] Updated source to support PowerShell 3.0
        #>
        [Alias('Pull-FirewallRules')]
        Param()
        $HashFirewallRules = @{ 'Names'=@() }

        Get-ChildItem -Path $('{0}\Tools\Blubin\FirewallRules' -f $ScriptDirectory) -Filter *.RULE | ForEach-Object `
        -Process `
        {
            $CurFWRuleName = $_.BaseName
            $CurFWRulePath = $_.FullName
            $CurFWRuleContent = $((Get-Content -Path $CurFWRulePath -ErrorAction SilentlyContinue) -join "") | ConvertFrom-Json -ErrorAction SilentlyContinue

            $HashFirewallRules.$CurFWRuleName = $CurFWRuleContent
            $HashFirewallRules.Names += $CurFWRuleName
        }

        Return $HashFirewallRules
    }
#endregion Publish-BluGenieFirewallRules (Function)