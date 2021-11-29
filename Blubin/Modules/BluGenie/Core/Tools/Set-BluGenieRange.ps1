#region Set-BluGenieRange (Function)
    Function Set-BluGenieRange
    {
        <#
        .SYNOPSIS 
            Set-BluGenieRange is an add-on to manage the IP Range in the BluGenie Console

        .DESCRIPTION
            Set-BluGenieRange is an add-on to manage the IP Range in the BluGenie Console

        .PARAMETER Update
            Update the current value

            <Type>String<Type>

        .PARAMETER Remove
            Remove any IP Range value

            <Type>SwitchParameter<Type>

        .PARAMETER Walkthrough
            An automated process to walk through the current function and all the parameters

            <Type>SwitchParameter<Type>

        .EXAMPLE
            Set-BluGenieRange

            This will give you the currect IP Range value

        .EXAMPLE
            Set-BluGenieRange 10.20.136.1-10.20.136.50

            This will update the current IP Range value to 10.20.136.1-10.20.136.50
        
        .EXAMPLE
            Set-BluGenieRange -Update 10.20.136.1-10.20.136.150

            This will update the current IP Range value to 10.20.136.1-10.20.136.150

        .EXAMPLE
            Set-BluGenieRange -Remove

            This will remove the set IP Range value

        .OUTPUTS
                TypeName: System.String

        .NOTES
            
            * Original Author           : Michael Arroyo
            * Original Build Version    : 1908.0501
            * Latest Author             : 
            * Latest Build Version      : 
            * Comments                  : 
            * Dependencies              : 
                                            ~
            * Build Version Details     : 
                                            ~ 1908.0501: * [Michael Arroyo] Posted
                                           
    #>
        [Alias('Set-BluGenieRange')]
        Param
        (
            [String]$Update,

            [Switch]$Remove,

            [Alias('Help')]
            [Switch]$Walkthrough
        )

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
                    #$Function = $($PSCmdlet.MyInvocation.InvocationName)
                    $Function = 'Range'
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

        #region Main
            Switch
            (
                $null
            )
            {
                #region Update item
                    {$Update}
                    {
                        If
                        (
                            $Update -match '\d+?\.\d+?\.\d+?\.\d+?-\d+?\.\d+?\.\d+?\.\d.*'
                        )
                        {
                            $ConsoleRangeText = "$Update".PadRight(40,' ') + "|| `t"
                            $ConsoleRangeMsg = '..Updated IP Range..'
                            write-host -NoNewline $("`n{0}" -f $ConsoleRangeText) -ForegroundColor Yellow
                            Write-Host -NoNewline $ConsoleRangeMsg -ForegroundColor Green
                    
                            Write-Host "`n"
                            $global:ConsoleRange = $Update
                        }
                        Else
                        {
                            $ConsoleRangeText = "$Update".PadRight(40,' ') + "|| `t"
                            $ConsoleRangeMsg = '..Does not match a valid IP Range value..'
                            write-host -NoNewline $("`n{0}" -f $ConsoleRangeText) -ForegroundColor Yellow
                            Write-Host -NoNewline $ConsoleRangeMsg -ForegroundColor Red
                    
                            Write-Host "`n"
                        }

                        
                    }
                #endregion Update item

                #region Remove value
                    {$Remove -eq $true}
                    {
                        [String]$global:ConsoleRange = $null
                        $ConsoleCommandsText = "IP Range Value".PadRight(40,' ') + "|| `t"
                        $ConsoleCommandsMsg = '..Removed..'
                        Write-host -NoNewline $("`n{0}" -f $ConsoleCommandsText) -ForegroundColor Yellow
                        Write-Host -NoNewline $ConsoleCommandsMsg -ForegroundColor Green
                        Write-Host "`n"
                    }
                #endregion Remove value

                #region Default (Show value)
                    Default
                    {
                        If
                        (
                            $Global:ConsoleRange -eq $null -or $global:ConsoleRange -eq ''
                        )
                        {
                            $ConsoleRangeText = "IP Range Value".PadRight(40,' ') + "|| `t"
                            $ConsoleRangeMsg = $('..Not Set..')
                            write-host -NoNewline $("`n{0}" -f $ConsoleRangeText) -ForegroundColor Yellow
                            Write-Host -NoNewline $ConsoleRangeMsg -ForegroundColor Red
                            Write-Host "`n"
                        }
                        Else
                        {
                            $ConsoleRangeText = "$Global:ConsoleRange".PadRight(40,' ') + "|| `t"
                            $ConsoleRangeMsg = $('..IP Range..')
                            write-host -NoNewline $("`n{0}" -f $ConsoleRangeText) -ForegroundColor Green
                            Write-Host -NoNewline $ConsoleRangeMsg -ForegroundColor Yellow
                            Write-Host "`n"
                        }
                    }
                #endregion Default (Show list values)
            }
        #endregion Main
    }
#endregion Set-BluGenieRange (Function)