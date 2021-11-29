#region New-BluGenieHelpMenu (Function)
    Function New-BluGenieHelpMenu
    {
    <#
        .SYNOPSIS
            New-BluGenieHelpMenu is a Dynamic Console menu system creator for any CmdLet that has a valid Help header

        .PARAMETER Command
            Select which Command to buld the menu for

            <Type>ValidateSet<Type>
            <ValidateSet>Add-FirewallRule,Disable-FirewallRule,Enable-AllFirewallRules,Get-ProcessList,Set-RemoteDesktopProcess,Enable-FirewallRule,Disable-AllFirewallRules,Set-FirewallStatus,Get-SystemInfo,Remove-FirewallRule,Update-FirewallProfileStatus,Get-ChildItemList,Manage-ProcessHash,Get-LiteralPath,Get-FirewallRules,Set-FirewallGPOStatus,Get-HashInfo,Invoke-NetStat,Get-Registry,Get-ServiceList,Get-SchTaskInfo,Update-Sysinternals,Get-Signature,Get-COMObjectInfo,Get-LoadedRegHives,Invoke-LoadAllProfileHives,Invoke-UnLoadAllProfileHives,Get-MRUActivityView,Get-ADMachineInfo,Get-RegistryProcessTracking,Set-Prefetch,Get-AuditProcessTracking,Set-AuditProcessPol,Get-WindowsUpdates,Get-AutoRuns,Get-RegSnapshot,Get-FileSnapshot,Build-Command,Send-Item,Install-Harvester,Expand-ArchivePS2,Install-SysMon,Systems,ParallelCommands,PostCommands,ThreadCount,Range,Json,Wipe,Settings,Resolve-BgDnsName,Ping,Connect-ToSystem,Connect,SetTrapping,Invoke-PSQuery,PSQuery,Invoke-Process,Run,Enable-WinRMoverWMI,Enable-WinRM<ValidateSet>

        .PARAMETER Console
            Specify if this is an internal BluGenie call.  Remove the Run command and build out a BluGenie Console sample command

            <Type>SwitchParameter<Type>

        .PARAMETER Walkthrough
            An automated process to walk through the current function and all the parameters

            <Type>SwitchParameter<Type>

        .EXAMPLE
            New-BluGenieHelpMenu -Command Get-HashInfo

            This will parse the Get-HashInfo help information and display a dynamic console menu system

        .EXAMPLE
            New-BluGenieHelpMenu -Command Get-HashInfo -Console

            This will parse the Get-HashInfo help information and display a dynamic console menu system.
            The Run command is removed and a BluGenie Console sample script is created as well.

        .EXAMPLE
            New-BluGenieHelpMenu -Help

            This will display the dynamic console menu for this command

        .OUTPUTS
            None

        .NOTES

            * Original Author           : Michael Arroyo
            * Original Build Version    : 1902.0601
            * Latest Author             : Michael Arroyo
            * Latest Build Version      : 1909.2401
            * Comments                  :
            * Dependencies              :
                                            ~
            * Build Version Details     :
                                            ~ 1902.0601: * [Michael Arroyo] Posted
                                            ~ 1902.1401: * [Michael Arroyo] Added Command Update-Sysinternals to the Validation Set List
                                            ~ 1902.1801: * [Michael Arroyo] Added Command Get-Signature to the Validation Set List
                                            ~ 1902.2101: * [Michael Arroyo] Removed the Get-AppTaskMgrList parameter
                                            ~ 1902.2701: * [Michael Arroyo] Added Command Get-COMObjectInfo to the validation Set List
                                            ~ 1903.0601: * [Michael Arroyo] Added Command Get-LoadedRegHives to the validation Set List
                                            ~ 1903.0701: * [Michael Arroyo] Added Command Invoke-LoadAllProfileHives to the validation Set List
                                            ~ 1903.0701: * [Michael Arroyo] Added Command Invoke-UnLoadAllProfileHives to the validation Set List
                                            ~ 1903.1101: * [Michael Arroyo] Added Command Get-MRUActivityView to the validation Set List
                                            ~ 1903.1501: * [Michael Arroyo] Added Command Get-ADMachineInfo to the validation Set List
                                            ~ 1903.2201: * [Michael Arroyo] Added Command Get-RegistryProcessTracking to the validation Set List
                                            ~ 1903.2501: * [Michael Arroyo] Added Command Set-Prefetch to the validation Set List
                                            ~ 1903.2801: * [Michael Arroyo] Added Command Get-AuditProcessTracking to the validation Set List
                                            ~ 1903.2802: * [Michael Arroyo] Added Command Set-AuditProcessPol to the validation Set List
                                            ~ 1903.2802: * [Michael Arroyo] Added Command Get-WindowsUpdates to the validation Set List
                                            ~ 1904.0501: * [Michael Arroyo] Added Command Get-AutoRuns to the validation Set List
                                            ~ 1904.0801: * [Michael Arroyo] Updated the error control for the entire process to support External Help (XML) files
                                                         * [Michael Arroyo] Updated the ** Parameters ** section to bypass the Help indicator to support External Help (XML) files
                                                         * [Michael Arroyo] Updated the ** Options ** section to bypass the Help indicator to support External Help (XML) files
                                                         * [Michael Arroyo] Added an Export function to export the configured BluGenie Console Command to a JSON Pack file
                                            ~ 1904.1501: * [Michael Arroyo] Updated the JSON output to a Here String with new parameters
                                                         * [Michael Arroyo] Added a pause after saving Output
                                                         * [Michael Arroyo] Added Command Get-RegSnapshot to the validation Set List
                                            ~ 1904.2401: * [Michael Arroyo] Removed the Build-HelpMenu item from the Help menu.  This is causing a loop as the command it really this script.
                                                         * [Michael Arroyo] Added Command Get-FileSnapshot to the validation Set List
                                            ~ 1904.2501: * [Michael Arroyo] Added Command Build-Command to the validation Set List
                                                         * [Michael Arroyo] Added Command Send-Item to the validation Set List
                                            ~ 1905.0201: * [Michael Arroyo] Added Aliases (HelpMenu, HM, and ??)
                                            ~ 1905.1301: * [Michael Arroyo] Added Command Install-Harvester
                                                         * [Michael Arroyo] Added Command Expand-ArchivePS2
                                                         * [Michael Arroyo] Update the WalkThrough function to (Ver: 1905.1302)
                                                         * [Michael Arroyo] Update all Where-Object references to PowerShell 2
                                            ~ 1905.2501: * [Michael Arroyo] Updates synax based on Script Analyzer
                                                         * [Michael Arroyo] Added Command ( Install-SysMon ) to the validation Set List
                                            ~ 1908.0801: * [Michael Arroyo] Added Command ( Systems ) to the validation Set List
                                                         * [Michael Arroyo] Added Command ( ParallelCommands ) to the validation Set List
                                                         * [Michael Arroyo] Added Command ( PostCommands ) to the validation Set List
                                                         * [Michael Arroyo] Added Command ( ThreadCount ) to the validation Set List
                                                         * [Michael Arroyo] Added Command ( Range ) to the validation Set List
                                                         * [Michael Arroyo] Added Command ( Json ) to the validation Set List
                                                         * [Michael Arroyo] Added Command ( Wipe ) to the validation Set List
                                                         * [Michael Arroyo] Added Command ( Settings ) to the validation Set List
                                                         * [Michael Arroyo] Added Command ( Resolve-BgDnsName ) to the validation Set List
                                                         * [Michael Arroyo] Added Command ( Ping ) to the validation Set List
                                                         * [Michael Arroyo] Added Command ( Connect-ToSystem ) to the validation Set List
                                                         * [Michael Arroyo] Added Command ( Connect ) to the validation Set List
                                            ~ 1908.2201: * [Michael Arroyo] Added Command ( SetTrapping ) to the validation Set List
                                            ~ 1909.2401: * [Michael Arroyo] Added Command ( Invoke-PSQuery ) to the validation Set List
                                                         * [Michael Arroyo] Added Command ( PSQuery ) to the validation Set List
        #>

        [CmdletBinding(ConfirmImpact='Medium')]
        [Alias('HelpMenu','HM','??', 'Build-HelpMenu')]

        param
        (
            [Parameter(Position=1,
                        Mandatory=$true)]
            [ValidateSet('Add-FirewallRule','Disable-FirewallRule','Enable-AllFirewallRules','Get-ProcessList','Set-RemoteDesktopProcess','Enable-FirewallRule','Disable-AllFirewallRules','Set-FirewallStatus','Get-SystemInfo','Remove-FirewallRule','Update-FirewallProfileStatus','Get-ChildItemList','Manage-ProcessHash','Get-LiteralPath','Get-FirewallRules','Set-FirewallGPOStatus','Get-HashInfo','Invoke-NetStat','Get-Registry','Get-ServiceList','Get-SchTaskInfo','Update-Sysinternals', 'Get-Signature','Get-COMObjectInfo','Get-LoadedRegHives','Invoke-LoadAllProfileHives','Invoke-UnLoadAllProfileHives','Get-MRUActivityView','Get-ADMachineInfo','Get-RegistryProcessTracking','Set-Prefetch','Get-AuditProcessTracking','Set-AuditProcessPol','Get-WindowsUpdates','Get-AutoRuns','Get-RegSnapshot','Get-FileSnapshot','Build-Command','Send-Item','Install-Harvester','Expand-ArchivePS2','Install-SysMon','Systems','ParallelCommands','PostCommands','ThreadCount','Range','Json','Wipe','Settings','Resolve-BgDnsName','Ping','Connect-ToSystem','Connect','SetTrapping','Invoke-PSQuery','PSQuery','Invoke-Process','Run','Enable-WinRMoverWMI','Enable-WinRM')]
            [String]$Command,

            [Parameter(Position=2)]
            [Switch]$Console = $true,

            [Parameter(Position=3)]
            [Alias('Help')]
            [Switch]$Walkthrough
        )
            1..2 | ForEach-Object `
            -Process `
            {
                Write-Host ''
            }

            #region WalkThrough (Ver: 1905.2401)
            <#.NOTES
                
                * Original Author           : Michael Arroyo
                * Original Build Version    : 1902.0505
                * Latest Author             : Michael Arroyo
                * Latest Build Version      : 1905.2401
                * Comments                  : 
                * Dependencies              : 
                                                ~
                * Build Version Details     : 
                                                ~ 1902.0505: * [Michael Arroyo] Posted
                                                ~ 1904.0801: * [Michael Arroyo] Updated the error control for the entire process to support External Help (XML) files
                                                             * [Michael Arroyo] Updated the ** Parameters ** section to bypass the Help indicator to support External Help (XML) files
                                                             * [Michael Arroyo] Updated the ** Options ** section to bypass the Help indicator to support External Help (XML) files
                                                ~ 1905.1302: * [Michael Arroyo] Converted all Where-Object references to PowerShell 2
                                                ~ 1905.2401: * [Michael Arroyo] Updated syntax based on PSAnalyzer
            #>
                If
                (
                    $Walkthrough
                )
                {
                    #region WalkThrough Defined Variables
                        $Function = $($PSCmdlet.MyInvocation.InvocationName)
                        $CurHelp = $(Get-Help -Name $Function -ErrorAction SilentlyContinue)
                        $CurExamples = $CurHelp.examples
                        $CurParameters = $CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -NE 'Walkthrough' } | Select-Object -ExpandProperty Name
                        $CurSyntax = $CurHelp.syntax
                        $LeaveWalkThrough = $false
                    #endregion

                    #region Main Do Until
                        Do
                        {
                            #region Build Current Command
                                $Walk_Command = $('{0}' -f $Function)
                                $CurParameters | ForEach-Object `
                                -Process `
                                {
                                    $CurParameter = $_
                                    $CurValue = $(Get-Item -Path $('Variable:\{0}' -f $CurParameter) -ErrorAction SilentlyContinue).Value
                                    If
                                    (
                                        $CurValue
                                    )
                                    {
                                        Switch
                                        (
                                            $CurValue
                                        )
                                        {
                                            $true
                                            {
                                                $Walk_Command += $(' -{0}' -f $CurParameter)
                                            }
                                            $false
                                            {
                                                
                                            }
                                            Default
                                            {
                                                $Walk_Command += $(' -{0} "{1}"' -f $CurParameter, $CurValue)
                                            }
                                        }
                                    }
                                }
                            #endregion

                            #region Build Main Menu
                                #region Main Header
                                    Write-Host $("`n")
                                    Write-Host $('** Command Syntax **') -ForegroundColor Green
                                    Write-Host $('{0}' -f $($CurSyntax | Out-String).Trim()) -ForegroundColor Cyan

                                    Write-Host $("`n")
                                    Write-Host $('** Current Command **') -ForegroundColor Green
                                    Write-Host $('{0}' -f $Walk_Command) -ForegroundColor Cyan
                                    Write-Host $("`n")
	
									Write-Host $('** Parameters **') -ForegroundColor Green
									$CurParameters | ForEach-Object `
									-Process `
									{
										If
										(
											$_ -ne 'Help'
										)
										{
											Write-Host $('{0}: {1}' -f $_, $(Get-Item -Path Variable:\$_ -ErrorAction SilentlyContinue).Value) -ForegroundColor Cyan
										}
									}
									
									Write-Host $("`n")
						            Write-Host $('** Options **') -ForegroundColor Green
									$CurParameters | ForEach-Object `
									-Process `
									{
										If
										(
											$_ -ne 'Help'
										)
										{
											Write-Host $("Type '{0}' to update value" -f $_) -ForegroundColor Yellow
										}
									}
									Write-Host $("Type 'Help' to view the Description for each Parameter") -ForegroundColor Yellow
                                    Write-Host $("Type 'Examples' to view any Examples") -ForegroundColor Yellow
                                    Write-Host $("Type 'Run' to Run the above (Current Command)") -ForegroundColor Yellow
                                    Write-Host $("Type 'Exit' to Exit without running") -ForegroundColor Yellow

                                    Write-Host $("`n")
                                #endregion

                                #region Main Prompt
                                    $UpdateItem = Read-Host -Prompt 'Please make a selection'
                                #endregion

                                #region Main Switch for menu interaction
                                    switch ($UpdateItem)
                                    {
                                        #region Exit Main menu
                                            'Exit'
                                            {
                                                Return
                                            }
                                        #endregion

                                        #region Pull Parameter Type from the Static Help Parameter (If String)
                                            {
                                                Try
                                                {
                                                    $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'String'
                                                }
                                                Catch
                                                {
                                                    $null
                                                }
                                            }
                                            {
                                                Clear-Host
                                                $null = Remove-Variable -Name $UpdateItem -Force -ErrorAction SilentlyContinue
                                                $null = New-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $(Read-Host -Prompt $('Enter-{0}' -f $UpdateItem)) -Force -ErrorAction SilentlyContinue
                                            }
                                        #endregion

                                        #region Pull Parameter Type from the Static Help Parameter (If Int)
                                            {
                                                Try
                                                {
                                                    $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'Int'
                                                }
                                                Catch
                                                {
                                                    $null
                                                }
                                            }
                                            {
                                                Clear-Host
                                                $IntValue = $(Read-Host -Prompt $('Enter-{0}' -f $UpdateItem))
                                                Switch
                                                (
                                                    $IntValue
                                                )
                                                {
                                                    ''
                                                    {
                                                         $null = Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $null -Force -ErrorAction SilentlyContinue
                                                    }
                                                    {
                                                        $IntValue -match '^[\d\.]+$'
                                                    }
                                                    {
                                                        $null = Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $IntValue -Force -ErrorAction SilentlyContinue
                                                    }
                                                    Default
                                                    {
                                                        Clear-Host
                                                        Write-Host $('({0}) is not a valid [Int].  Please try again.' -f $IntValue) -ForegroundColor Red
                                                        Write-Host $("`n")
                                                        Pause
                                                    }
                                                }
                                            }
                                        #endregion

                                        #region Pull Parameter Type from the Static Help Parameter (If SwitchParameter)
                                            {
                                                Try
                                                {
                                                    $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'SwitchParameter'
                                                }
                                                Catch
                                                {
                                                    $null
                                                }
                                            }
                                            {
                                                Clear-Host
                                                If
                                                (
                                                    $(Get-Item -Path $('Variable:\{0}' -f $UpdateItem)).Value -eq $true
                                                )
                                                {
                                                    $CurToggle = $false
                                                }
                                                Else
                                                {
                                                    $CurToggle = $true
                                                }
                                                $null = Remove-Variable -Name $UpdateItem -Force -ErrorAction SilentlyContinue
                                                $null = New-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $CurToggle -Force
                                                $null = Remove-Variable -Name $CurToggle -Force -ErrorAction SilentlyContinue
                                            }
                                        #endregion

                                        #region Pull Parameter Type from the Static Help Parameter (If ValidateSet)
                                            {
                                                Try
                                                {
                                                    $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'ValidateSet'
                                                }
                                                Catch
                                                {
                                                    $null
                                                }
                                            }
                                            {
                                                $AllowedValues = $($($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem }) | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<ValidateSet\>')[1] -split ','
                                                Clear-Host

                                                Do
                                                {
                                                    Write-Host $('** Validation Set **') -ForegroundColor Green
                                                    $AllowedValues | ForEach-Object -Process { Write-Host $("Type '{0}' to update value" -f $_) -ForegroundColor Yellow}
                                                    Write-Host $("Type 'Back' to go back to the main menu") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Null' to remove the current value") -ForegroundColor Yellow

                                                    Write-Host $("`n")
                                                    $ValidateSetInput = $null
                                                    $ValidateSetInput = Read-Host -Prompt 'Please make a selection'

                                                    Switch
                                                    (
                                                        $ValidateSetInput
                                                    )
                                                    {
                                                        'Back'
                                                        {
                                                            $LeaveValidateSet = $true
                                                        }
                                                        'Null'
                                                        {
                                                            Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $null -ErrorAction SilentlyContinue
                                                            $LeaveValidateSet = $true
                                                        }
                                                        {
                                                            $AllowedValues -contains $ValidateSetInput
                                                        }
                                                        {
                                                            Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $ValidateSetInput -ErrorAction SilentlyContinue
                                                            $LeaveValidateSet = $true
                                                        }
                                                        Default
                                                        {
                                                            Clear-Host
                                                            Write-Host $('({0}) is not a valid option.  Please try again.' -f $ValidateSetInput) -ForegroundColor Red
                                                            Write-Host $("`n")
                                                            $LeaveValidateSet = $false
                                                        }
                                                    }
                                                }
                                                Until
                                                (
                                                    $LeaveValidateSet -eq $true
                                                )
                                            }
                                        #endregion

                                        #region Pull the Help information for each Parameter and Dynamically build the menu system
                                            'Help'
                                            {
                                                Clear-Host
                                                $LeaveHelpInput = $false

                                                Do
                                                {
                                                    Write-Host $('** Help Parameter Information **') -ForegroundColor Green
                                                    $CurParameters | ForEach-Object -Process { Write-Host $("Type '{0}' to view Help" -f $_) -ForegroundColor Yellow}
                                                    Write-Host $("Type 'All' to list all Parameters and Help Information") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Help' to view the General Help information") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Full' to view the Detailed Help information") -ForegroundColor Yellow
                                                    Write-Host $("Type 'ShowWin' to view the Detailed Help information in a Win-Form") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Back' to go back to the main menu") -ForegroundColor Yellow

                                                    Write-Host $("`n")
                                                    $HelpInput = $null
                                                    $HelpInput = Read-Host -Prompt 'Please make a selection'

                                                    Switch
                                                    (
                                                        $HelpInput
                                                    )
                                                    {
                                                        'Back'
                                                        {
                                                            $LeaveHelpInput = $true
                                                        }
                                                        {
                                                            $CurParameters -contains $HelpInput
                                                        }
                                                        {
                                                            $CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $HelpInput } | Out-String
                                                            Pause
                                                        }
                                                        'All'
                                                        {
                                                            $CurHelp.parameters.parameter | Out-String
                                                            Pause
                                                        }
                                                        'Help'
                                                        {
                                                            Get-Help -Name $Function | Out-String
                                                            Pause
                                                        }
                                                        'Full'
                                                        {
                                                            Get-Help -Name $Function -Full | Out-String
                                                            Pause
                                                        }
                                                        'ShowWin'
                                                        {
                                                            Get-Help -Name $Function -ShowWindow
                                                            Pause
                                                        }
                                                        Default
                                                        {
                                                            Clear-Host
                                                            Write-Host $('({0}) is not a valid option.  Please try again.' -f $HelpInput) -ForegroundColor Red
                                                            Write-Host $("`n")
                                                        }
                                                    }
                                                }
                                                Until
                                                (
                                                    $LeaveHelpInput -eq $true
                                                )
                                            }
                                        #endregion

                                        #region Pull the Examples information and Dynamically build the menu system
                                            'Examples'
                                            {
                                                Clear-Host
                                                $LeaveExampleInput = $false
                                                $CurExamplesList = $($CurHelp.examples.example | Select-Object -ExpandProperty Title) -replace ('-') -replace (' ') -replace ('EXAMPLE')

                                                Do
                                                {
                                                    Write-Host $('** Examples **') -ForegroundColor Green
                                                    $CurExamplesList | ForEach-Object -Process { Write-Host $("Type '{0}' to view Example{0}" -f $_) -ForegroundColor Yellow}
                                                    Write-Host $("Type 'All' to list all Examples") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Back' to go back to the main menu") -ForegroundColor Yellow

                                                    Write-Host $("`n")
                                                    $ExampleInput = $null
                                                    $ExampleInput = Read-Host -Prompt 'Please make a selection'

                                                    Switch
                                                    (
                                                        $ExampleInput
                                                    )
                                                    {
                                                        'Back'
                                                        {
                                                            $LeaveExampleInput = $true
                                                        }
                                                        {
                                                            $CurExamplesList -contains $ExampleInput
                                                        }
                                                        {
                                                            $CurHelp.examples.example | Where-Object -FilterScript { $_.Title -Match $('EXAMPLE\s{0}' -f $ExampleInput) }
                                                            Pause
                                                        }
                                                        'All'
                                                        {
                                                            $CurHelp.examples.example
                                                            Pause
                                                        }
                                                        Default
                                                        {
                                                            Clear-Host
                                                            Write-Host $('({0}) is not a valid option.  Please try again.' -f $ExampleInput) -ForegroundColor Red
                                                            Write-Host $("`n")
                                                        }
                                                    }
                                                }
                                                Until
                                                (
                                                    $LeaveExampleInput -eq $true
                                                )
                                            }
                                        #endregion

                                        #region Run the Current Command
                                            'Run'
                                            {
                                                #Exiting Switch and Running set Parameters
                                                $LeaveWalkThrough = $true
                                            }
                                        #endregion

                                        #region Default (Error Control)
                                            Default
                                            {
                                                Clear-Host
                                                Write-Host $('({0}) is not a valid option.  Please try again.' -f $UpdateItem) -ForegroundColor Red
                                                Write-Host $("`n")
                                                $LeaveWalkThrough = $false
                                                Pause
                                            }
                                        #endregion
                                    }
                                #endregion
                            #endregion
                        }
                        Until
                        (
                            $LeaveWalkThrough -eq $true
                        )
                    #endregion
                }
            #endregion

            #region WalkThrough Defined Variables
                $Function = $($Command)
                $CurHelp = $(Get-Help -Name $Command)
                $CurExamples = $CurHelp.examples
                $CurParameters = $CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -NE 'Walkthrough' } | Select-Object -ExpandProperty Name
                $CurSyntax = $CurHelp.syntax
                $LeaveWalkThrough = $false
            #endregion

            #region Build Variables
                $CurParameters | ForEach-Object `
                -Process `
                {
                    $CurParam = $_
                    $null = New-Item -Path Variable:\ -Name $CurParam -Value $($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $CurParam }).defaultvalue -Force -ErrorAction SilentlyContinue
                }
            #endregion

            #region Main Do Until
                Do
                {
                    #region Build Current Command
                        $Walk_Command = $('{0}' -f $Function)
                        $CurParameters | ForEach-Object `
                        -Process `
                        {
                            $CurParameter = $_
                            $CurValue = $(Get-Item -Path $('Variable:\{0}' -f $CurParameter) -ErrorAction SilentlyContinue).Value
                            If
                            (
                                $CurValue
                            )
                            {
                                Switch
                                (
                                    $CurValue
                                )
                                {
                                    $true
                                    {
                                        $Walk_Command += $(' -{0}' -f $CurParameter)
                                    }
                                    $false
                                    {

                                    }
                                    Default
                                    {
                                        $Walk_Command += $(' -{0} "{1}"' -f $CurParameter, $CurValue)
                                    }
                                }
                            }
                        }
                    #endregion

                    #region Build Main Menu
                        #region Main Header
                            Write-Host $("`n")
                            Write-Host $('** Command Syntax **') -ForegroundColor Green
                            Write-Host $('{0}' -f $($CurSyntax | Out-String).Trim()) -ForegroundColor Cyan

                            Write-Host $("`n")
                            Write-Host $('** Current Command **') -ForegroundColor Green
                            Write-Host $('{0}' -f $Walk_Command) -ForegroundColor Cyan
                            Write-Host $("`n")

                            If
                            (
                                $Console
                            )
                            {
                                Write-Host $('** BluGenie Console Example **') -ForegroundColor Green
                                Write-Host $('Invoke-Process -System "192.168.25.1" -Command {0}{1}{0} -JobId "0001"' -f "'",$Walk_Command) -ForegroundColor Cyan
                                Write-Host $("`n")
                            }

                            Write-Host $('** Parameters **') -ForegroundColor Green
                            $CurParameters | ForEach-Object `
								-Process `
								{
									If
									(
										$_ -ne 'Help'
									)
									{
										Write-Host $('{0}: {1}' -f $_, $(Get-Item -Path Variable:\$_ -ErrorAction SilentlyContinue).Value) -ForegroundColor Cyan
									}
								}

                            Write-Host $("`n")
                            Write-Host $('** Options **') -ForegroundColor Green
                            $CurParameters | ForEach-Object `
								-Process `
								{
									If
									(
										$_ -ne 'Help'
									)
									{
										Write-Host $("Type '{0}' to update value" -f $_) -ForegroundColor Yellow
									}
								}


                            Write-Host $("Type 'Help' to view the Description for each Parameter") -ForegroundColor Yellow
                            Write-Host $("Type 'Examples' to view any Examples") -ForegroundColor Yellow

                            If
                            (
                                -Not $Console
                            )
                            {
                                Write-Host $("Type 'Run' to Run the above (Current Command)") -ForegroundColor Yellow
                            }

                            If
                            (
                                $Console
                            )
                            {
                                Write-Host $("Type 'Export' to Export the current BluGenie Command to JSON") -ForegroundColor Yellow
                            }

                            Write-Host $("Type 'Exit' to Exit without running") -ForegroundColor Yellow

                            Write-Host $("`n")
                        #endregion

                        #region Main Prompt
                            $UpdateItem = Read-Host -Prompt 'Please make a selection'
                        #endregion

                        #region Main Switch for menu interaction
                            switch ($UpdateItem)
                            {
                                #region Exit Main menu
                                    'Exit'
                                    {
                                        Return
                                    }
                                #endregion

                                #region Pull Parameter Type from the Static Help Parameter (If String)
                                    {
                                        Try
                                        {
                                            $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'String'
                                        }
                                        Catch
                                        {
                                            $null
                                        }
                                    }
                                    {
                                        1..2 | ForEach-Object `
                                        -Process `
                                        {
                                            Write-Host ''
                                        }
                                        $null = Remove-Variable -Name $UpdateItem -Force -ErrorAction SilentlyContinue
                                        $null = New-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $(Read-Host -Prompt $('Enter-{0}' -f $UpdateItem)) -Force -ErrorAction SilentlyContinue
                                    }
                                #endregion

                                #region Pull Parameter Type from the Static Help Parameter (If Int)
                                    {
                                        Try
                                        {
                                            $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'Int'
                                        }
                                        Catch
                                        {
                                            $null
                                        }
                                    }
                                    {
                                        1..2 | ForEach-Object `
                                        -Process `
                                        {
                                            Write-Host ''
                                        }
                                        $IntValue = $(Read-Host -Prompt $('Enter-{0}' -f $UpdateItem))
                                        Switch
                                        (
                                            $IntValue
                                        )
                                        {
                                            ''
                                            {
                                                    $null = Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $null -Force -ErrorAction SilentlyContinue
                                            }
                                            {
                                                $IntValue -match '^[\d\.]+$'
                                            }
                                            {
                                                $null = Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $IntValue -Force -ErrorAction SilentlyContinue
                                            }
                                            Default
                                            {
                                                1..2 | ForEach-Object `
                                                -Process `
                                                {
                                                    Write-Host ''
                                                }
                                                Write-Host $('({0}) is not a valid [Int].  Please try again.' -f $IntValue) -ForegroundColor Red
                                                Write-Host $("`n")
                                                Pause
                                            }
                                        }
                                    }
                                #endregion

                                #region Pull Parameter Type from the Static Help Parameter (If SwitchParameter)
                                    {
                                        Try
                                        {
                                            $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'SwitchParameter'
                                        }
                                        Catch
                                        {
                                            $null
                                        }
                                    }
                                    {
                                        1..2 | ForEach-Object `
                                        -Process `
                                        {
                                            Write-Host ''
                                        }
                                        If
                                        (
                                            $(Get-Item -Path $('Variable:\{0}' -f $UpdateItem)).Value -eq $true
                                        )
                                        {
                                            $CurToggle = $false
                                        }
                                        Else
                                        {
                                            $CurToggle = $true
                                        }
                                        $null = Remove-Variable -Name $UpdateItem -Force -ErrorAction SilentlyContinue
                                        $null = New-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $CurToggle -Force
                                        $null = Remove-Variable -Name $CurToggle -Force -ErrorAction SilentlyContinue
                                    }
                                #endregion

                                #region Pull Parameter Type from the Static Help Parameter (If ValidateSet)
                                    {
                                        Try
                                        {
                                            $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'ValidateSet'
                                        }
                                        Catch
                                        {
                                            $null
                                        }
                                    }
                                    {
                                        $AllowedValues = $($($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem }) | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<ValidateSet\>')[1] -split ','
                                        1..2 | ForEach-Object `
                                        -Process `
                                        {
                                            Write-Host ''
                                        }

                                        Do
                                        {
                                            Write-Host $('** Validation Set **') -ForegroundColor Green
                                            $AllowedValues | ForEach-Object -Process { Write-Host $("Type '{0}' to update value" -f $_) -ForegroundColor Yellow}
                                            Write-Host $("Type 'Back' to go back to the main menu") -ForegroundColor Yellow
                                            Write-Host $("Type 'Null' to remove the current value") -ForegroundColor Yellow

                                            Write-Host $("`n")
                                            $ValidateSetInput = $null
                                            $ValidateSetInput = Read-Host -Prompt 'Please make a selection'

                                            Switch
                                            (
                                                $ValidateSetInput
                                            )
                                            {
                                                'Back'
                                                {
                                                    $LeaveValidateSet = $true
                                                }
                                                'Null'
                                                {
                                                    Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $null -ErrorAction SilentlyContinue
                                                    $LeaveValidateSet = $true
                                                }
                                                {
                                                    $AllowedValues -contains $ValidateSetInput
                                                }
                                                {
                                                    Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $ValidateSetInput -ErrorAction SilentlyContinue
                                                    $LeaveValidateSet = $true
                                                }
                                                Default
                                                {
                                                    1..2 | ForEach-Object `
                                                    -Process `
                                                    {
                                                        Write-Host ''
                                                    }
                                                    Write-Host $('({0}) is not a valid option.  Please try again.' -f $ValidateSetInput) -ForegroundColor Red
                                                    Write-Host $("`n")
                                                    $LeaveValidateSet = $false
                                                }
                                            }
                                        }
                                        Until
                                        (
                                            $LeaveValidateSet -eq $true
                                        )
                                    }
                                #endregion

                                #region Pull the Help information for each Parameter and Dynamically build the menu system
                                    'Help'
                                    {
                                        1..2 | ForEach-Object `
                                        -Process `
                                        {
                                            Write-Host ''
                                        }
                                        $LeaveHelpInput = $false

                                        Do
                                        {
                                            Write-Host $('** Help Parameter Information **') -ForegroundColor Green
                                            $CurParameters | ForEach-Object -Process { Write-Host $("Type '{0}' to view Help" -f $_) -ForegroundColor Yellow}
                                            Write-Host $("Type 'All' to list all Parameters and Help Information") -ForegroundColor Yellow
                                            Write-Host $("Type 'Help' to view the General Help information") -ForegroundColor Yellow

                                            If
                                            (
                                                -Not $Console
                                            )
                                            {
                                                Write-Host $("Type 'Full' to view the Detailed Help information") -ForegroundColor Yellow
                                                Write-Host $("Type 'ShowWin' to view the Detailed Help information in a Win-Form") -ForegroundColor Yellow
                                            }
                                            Write-Host $("Type 'Back' to go back to the main menu") -ForegroundColor Yellow

                                            Write-Host $("`n")
                                            $HelpInput = $null
                                            $HelpInput = Read-Host -Prompt 'Please make a selection'

                                            Switch
                                            (
                                                $HelpInput
                                            )
                                            {
                                                'Back'
                                                {
                                                    $LeaveHelpInput = $true
                                                }
                                                {
                                                    $CurParameters -contains $HelpInput
                                                }
                                                {
                                                    $CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $HelpInput } | Out-String
                                                    Pause
                                                }
                                                'All'
                                                {
                                                    $CurHelp.parameters.parameter | Out-String
                                                    Pause
                                                }
                                                'Help'
                                                {
                                                    Get-Help -Name $Function | Out-String
                                                    Pause
                                                }
                                                'Full'
                                                {
                                                    Get-Help -Name $Function -Full | Out-String
                                                    Pause
                                                }
                                                'ShowWin'
                                                {
                                                    Get-Help -Name $Function -ShowWindow
                                                    Pause
                                                }
                                                Default
                                                {
                                                    1..2 | ForEach-Object `
                                                    -Process `
                                                    {
                                                        Write-Host ''
                                                    }
                                                    Write-Host $('({0}) is not a valid option.  Please try again.' -f $HelpInput) -ForegroundColor Red
                                                    Write-Host $("`n")
                                                }
                                            }
                                        }
                                        Until
                                        (
                                            $LeaveHelpInput -eq $true
                                        )
                                    }
                                #endregion

                                #region Pull the Examples information and Dynamically build the menu system
                                    'Examples'
                                    {
                                        1..2 | ForEach-Object `
                                        -Process `
                                        {
                                            Write-Host ''
                                        }
                                        $LeaveExampleInput = $false
                                        $CurExamplesList = $($CurHelp.examples.example | Select-Object -ExpandProperty Title) -replace ('-') -replace (' ') -replace ('EXAMPLE')

                                        Do
                                        {
                                            Write-Host $('** Examples **') -ForegroundColor Green
                                            $CurExamplesList | ForEach-Object -Process { Write-Host $("Type '{0}' to view Example{0}" -f $_) -ForegroundColor Yellow}
                                            Write-Host $("Type 'All' to list all Examples") -ForegroundColor Yellow
                                            Write-Host $("Type 'Back' to go back to the main menu") -ForegroundColor Yellow

                                            Write-Host $("`n")
                                            $ExampleInput = $null
                                            $ExampleInput = Read-Host -Prompt 'Please make a selection'

                                            Switch
                                            (
                                                $ExampleInput
                                            )
                                            {
                                                'Back'
                                                {
                                                    $LeaveExampleInput = $true
                                                }
                                                {
                                                    $CurExamplesList -contains $ExampleInput
                                                }
                                                {
                                                    $CurHelp.examples.example | Where-Object -FilterScript { $_.Title -Match $('EXAMPLE\s{0}' -f $ExampleInput) }
                                                    Pause
                                                }
                                                'All'
                                                {
                                                    $CurHelp.examples.example
                                                    Pause
                                                }
                                                Default
                                                {
                                                    1..2 | ForEach-Object `
                                                    -Process `
                                                    {
                                                        Write-Host ''
                                                    }
                                                    Write-Host $('({0}) is not a valid option.  Please try again.' -f $ExampleInput) -ForegroundColor Red
                                                    Write-Host $("`n")
                                                }
                                            }
                                        }
                                        Until
                                        (
                                            $LeaveExampleInput -eq $true
                                        )
                                    }
                                #endregion

                                #region Run the Current Command
                                    'Run'
                                    {
                                        $Walk_CommandScriptBlock = [ScriptBlock]::Create($Walk_Command)
                                        $null = Remove-Item -Path Variable:\Function -Force -ErrorAction SilentlyContinue
                                        Invoke-Command -ScriptBlock $Walk_CommandScriptBlock

                                        Return
                                    }
                                #endregion

                                    #region Export the Current Command
                                    'Export'
                                    {
                                            1..2 | ForEach-Object `
                                        -Process `
                                        {
                                            Write-Host ''
                                        }

                                        $LeaveExport = $true

                                        Do
                                        {
                                            Write-Host $("** Export to JSON **`n") -ForegroundColor Green
                                            Write-Host $('Type the name of the file and press [Enter]') -ForegroundColor Yellow
                                            Write-Host $("Type 'Back' to go back to the main menu") -ForegroundColor Yellow

                                            $ExportFileName = $null
                                            $ExportFileName = Read-Host -Prompt 'Please make a selection'

                                            Switch
                                            (
                                                $ExportFileName
                                            )
                                            {
                                                'Back'
                                                {
                                                    Write-Host $('No filename defined.  No action taken.')
                                                    $LeaveExport = $true
                                                }
                                                ''
                                                {
                                                    Write-Host $('No filename defined.  Please type in a filename.')
                                                }
                                                Default
                                                {
                                                    $OutJson = (@'
{{
"description": "{0}",
"queryID":   "{1}",
"jobid":  null,
"systems": [
null
],
"range":  null,
"commands": [
{2}
],
"comments":  {{
            "System":  [
                        "Notes: Can be 1 or more IP / Hostname entries",
                        "Example:  192.168.25.155,Win10001,LABTST-01"
                    ],
            "Range":  [
                        "Notes: a range of IP Address - This will dismiss the -System parameter",
                        "Example: 192.168.15.100-192.168.15.200"
                    ],
            "RunJSON":  {{
						"description": "01159701-Get System Information",
						"queryID":   "01159701",
						"jobid":  "222",
						"systems":  [
										"192.168.25.155",
										"192.168.25.147",
										"192.168.25.108"
									],
						"range":  null,
						"commands":  [
										"Get-FirewallRules -Type Enabled -AllProperties",
										"Get-SystemInfo"
									]
                        }},
			"JobID":  [
						"Notes: Job Identifier - Numbers Only.  Note: If a JobID is not defined, an ID will be set for you based on the current date and time.",
                        "Example: 1234"
                    ],
            "Command":  [
                            "Notes: A list of functions are available below.  This holds a list of commands to execute on the remote host",
                            "Example: Add-FirewallRule -RuleName BGAgent_445_Inbound_TCP,BGAgent_445_Inbound_UDP"
                        ]
        }}
}}
'@ -f $ExportFileName, (New-UID -NumPerSet 2 -NumOfSets 3 -Delimiter '' -ErrorAction SilentlyContinue), ($Walk_Command | ConvertTo-Json))


                                                    $null = New-Item -Path  $('{0}\JSONPacks' -f $ScriptDirectory) -ItemType Directory -ErrorAction SilentlyContinue
                                                    $OutJson | Out-File -FilePath $('{0}\JSONPacks\{1}.JSON' -f $ScriptDirectory,$ExportFileName) -Force -ErrorAction SilentlyContinue

                                                    Write-Host $('Filed Saved > {0}\JSONPacks\{1}.JSON' -f $ScriptDirectory,$ExportFileName) -ForegroundColor Green
                                                    Read-host -Prompt '<Press Any Key To Continue>'
                                                    $LeaveExport = $true
                                                }
                                            }
                                        }
                                        Until
                                        (
                                            $LeaveExport -eq $true
                                        )
                                    }
                                #endregion

                                #region Default (Error Control)
                                    Default
                                    {
                                        1..2 | ForEach-Object `
                                        -Process `
                                        {
                                            Write-Host ''
                                        }
                                        Write-Host $('({0}) is not a valid option.  Please try again.' -f $UpdateItem) -ForegroundColor Red
                                        Write-Host $("`n")
                                        $LeaveWalkThrough = $false
                                        Pause
                                    }
                                #endregion
                            }
                        #endregion
                    #endregion
                }
                Until
                (
                    $LeaveWalkThrough -eq $true
                )
            #endregion
    }
#endregion New-BluGenieHelpMenu (Function)