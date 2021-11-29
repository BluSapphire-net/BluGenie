#region Invoke-BluGenieWalkThrough (Function)
Function Invoke-WalkThrough
{
    <#
    .SYNOPSIS
        Invoke-BluGenieWalkThrough is an interactive help menu system

    .DESCRIPTION
        Invoke-BluGenieWalkThrough is an interactive help menu system.  It will convert the static PowerShell help into an interactive menu system
            -Added with a few new tag descriptors for (Parameter and Examples).  This information will structure the help 
            information displayed and also help with bulding  the dynamic help menu

            Example
             PARAMETER <parameter>
                Description:  Desciption of the Parameter
                Notes:        Any Notes
                Alias:        Alias if any
                ValidateSet:  ValidationSet Array Items

             EXAMPLE
                Command:     Your command string
                Description: Decription of what the command above will do
                Notes:       Any Notes

    .PARAMETER Name
        Description:  Specify the Function name to help build a Dynamic Help menu for
        Notes:  
        Alias:
        ValidateSet:  

    .PARAMETER RemoveRun
        Description:  This will remove the Run menu item and command from the Help menu
        Notes:  
        Alias:
        ValidateSet:  

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:  
        Alias: Help
        ValidateSet: 

    .EXAMPLE
	    Command: <Verb-Function_Name> -Help
        Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
        Notes: Snippet to add to your script function (Read the #region WalkThrough (Dynamic Help)) as part of this script.  Make sure to add both the snippet and the parameter to your function.

    .EXAMPLE
	    Command: <Verb-Function_Name> -WalkThrough
        Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
        Notes: Snippet to add to your script function (Read the #region WalkThrough (Dynamic Help)) as part of this script.  Make sure to add both the snippet and the parameter to your function.

    .EXAMPLE
	    Command: Invoke-BluGenieWalkThrough -Name <Verb-Function_Name>
        Description: This will start the Dynamic help menu system on the called function
        Notes: 

    .EXAMPLE
	    Command: Invoke-BluGenieWalkThrough -Name <Verb-Function_Name> -RemoveRun
        Description: This will start the Dynamic help menu system on the called function
        Notes: The menu system item ( Run ) will be disabled

    .OUTPUTS

    .NOTES
                        
        * Original Author           : Michael Arroyo
        * Original Build Version    : 1902.0505
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 1911.2001
        * Comments                  : 
        * Dependencies              : 
                                        ~
        * Build Version Details     : 
            ~ 1902.0505: * [Michael Arroyo] Posted
            ~ 1904.0801: * [Michael Arroyo] Updated the error control for the entire process to support External Help (XML) files
                            * [Michael Arroyo] Updated the ** Parameters ** section to bypass the Help indicator to support External Help (XML) files
                            * [Michael Arroyo] Updated the ** Options ** section to bypass the Help indicator to support External Help (XML) files
            ~ 1905.2401: * [Michael Arroyo] Updated syntax based on PSAnalyzer
            ~ 1910.0801: * [Michael Arroyo] Rebuilt the entire process to an an external (Only) call.
                            * [Michael Arroyo] All Variables are now defined in this script only.  Default values for any parameters are pulled from the Help Information
                            * [Michael Arroyo] Parameter and Example attributes have been updated to provide a better syntax standard and help automate the menu system.
                            * [Michael Arroyo] All functions are -ge PowerShell 2.0 compliant
            ~ 1910.3001: * [Michael Arroyo] Updated Example Title call to pull the exact match.  Prior, if there was more then 10 examples both 1 and 10 would show when only requesting Example 1.
            ~ 1911.2001: * [Michael Arroyo] Updated the Parameter Validate Set RegEx Parser to support multiple line scrapping
							* [Michael Arroyo] Updated the Example Set RegEx Parser to support multiple line scrapping
            ~ 2011.1301: * [Michael Arroyo] Removed the Alias [Invoke-WalkThrough] and copied this script over to a Function Script called [Invoke-Walkthrough].  Other scripts are looking for a function
                                named [Invoke-Walkthrough], not an Alias.


    #>
    [CmdletBinding()]
    #[Alias('Invoke-WalkThrough')]
    Param
    (
        [Parameter(Position = 0)]
        [String]$Name,

        [Parameter(Position = 1)]
        [Switch]$RemoveRun,

        [Parameter(Position=2)]
        [Alias('Help')]
        [Switch]$Walkthrough
    )

    #region WalkThrough (Dynamic Help)
        If
        (
            $Walkthrough
        )
        {
            If
            (
                $($PSCmdlet.MyInvocation.InvocationName)
            )
            {
                $Function = $($PSCmdlet.MyInvocation.InvocationName)
            }
            Else
            {
                If
                (
                    $Host.Name -match 'ISE'
                )
                {
                    $Function = $(Split-Path -Path $psISE.CurrentFile.FullPath -Leaf) -replace '((?:.[^.\r\n]*){1})$'
                }
            }

            If
            (
                Test-Path -Path Function:\Invoke-BluGenieWalkThrough -ErrorAction SilentlyContinue
            )
            {
                If
                (
                    $Function -eq 'Invoke-BluGenieWalkThrough'
                )
                {
                    #Disable Invoke-BluGenieWalkThrough looping
                    Invoke-Command -ScriptBlock { Invoke-BluGenieWalkThrough -Name $Function -RemoveRun }
                    Return
                }
                Else
                {
                    Invoke-Command -ScriptBlock { Invoke-BluGenieWalkThrough -Name $Function }
                    Return
                }
            }
            Else
            {
                Get-Help -Name $Function -Full
                Return
            }
        }
    #endregion WalkThrough (Dynamic Help)

    #region Check Name Parameter
        If
        (
            -Not $PSBoundParameters.Name
        )
        {
            Return
        }
    #endregion Check Name Parameter
    
    #region WalkThrough Defined Variables
        
        #region Query WalkThroughFunction Name
            $WalkThroughFunction = $PSBoundParameters.Name
            $WalkThroughRemoveRun = $PSBoundParameters.RemoveRun
        #endregion Query WalkThroughFunction Name
        
        #region Query Help Information
            $CurHelp = $(Get-Help -Name $WalkThroughFunction -ErrorAction SilentlyContinue)
        #endregion Query Help Information

        #region Query All Help Examples
            $CurExamples = $CurHelp.examples
            $CurExamplesObject = $null
            $CurExamplesObject = $CurHelp.examples.example | Select-Object -Property title,
                                                                                    code,
                                                                                    remarks,
                                                                                    @{
                                                                                        Name = 'Description'
                                                                                        Expression = {$null}
                                                                                    },
                                                                                    @{
                                                                                        Name = 'Notes'
                                                                                        Expression = {$null}
                                                                                    }

            #Query and Set Example Flags
            $CurExamplesObject | ForEach-Object `
            -Process `
            {
                $CurExampleInfoText = $_

                $CurExampleDescription = $($CurExampleInfoText.remarks.text) -replace '\n','{ENTER}' | Out-String
                        
                $Matches = $null
                $null = $CurExampleDescription -match 'Description\:(?<Description>.*)Notes\:'
                $CurExampleInfoText.Description = $Matches.Description  -replace '^\s+|\s+$' -replace '{ENTER}$' -replace '{ENTER}',"`n"
                        
                $Matches = $null
                $null =  $CurExampleDescription -match 'Notes\:(?<Notes>.*)'
                $CurExampleInfoText.Notes = $Matches.Notes -replace '^\s+|\s+$' -replace '{ENTER}$' -replace '{ENTER}',"`n"
            }
        #endregion Query All Help Examples
                                
        #region Query WalkThroughFunction Parameters
            $CurParameters = $CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -NE 'Walkthrough' } | Select-Object -Property Name,
                                                                                                                ParameterValue,
                                                                                                                DefaultValue,
                                                                                                                @{
                                                                                                                    Name = 'Info'
                                                                                                                    Expression = {$_.Description}
                                                                                                                },
                                                                                                                @{
                                                                                                                    Name = 'Description'
                                                                                                                    Expression = {$null}
                                                                                                                },
                                                                                                                @{
                                                                                                                    Name = 'Notes'
                                                                                                                    Expression = {$null}
                                                                                                                },
                                                                                                                @{
                                                                                                                    Name = 'Alias'
                                                                                                                    Expression = {$null}
                                                                                                                },
                                                                                                                @{
                                                                                                                    Name = 'ValidateSet'
                                                                                                                    Expression = {$null}
                                                                                                                }
            #Query and Set Help Flags
            $CurParameters | ForEach-Object `
            -Process `
            {
                $CurParameterInfoText = $_

                Switch -Regex ($CurParameterInfoText.Info.Text -replace '\n','{ENTER}' -replace '\s\s+')
                {
                    'Description\:(?<Description>.*)Notes\:'
                    {
                        $CurParameterInfoText.'Description' = $Matches.Description -replace '^\s+|\s+$' -replace '{ENTER}$' -replace '{ENTER}',"`n"
                    }
                    'Notes\:(?<Notes>.*)Alias\:'
                    {
                        $CurParameterInfoText.'Notes' = $Matches.Notes -replace '^\s+|\s+$' -replace '{ENTER}$' -replace '{ENTER}',"`n"
                    }
                    'Alias\:(?<Alias>.*)ValidateSet\:'
                    {
                        $CurParameterInfoText.'Alias' = $Matches.Alias -replace '^\s+|\s+$' -replace '{ENTER}$' -replace '{ENTER}',"`n"
                    }
                    'ValidateSet\:(?<ValidateSet>.*)'
                    {
                        $CurParameterInfoText.'ValidateSet' = $( $Matches.ValidateSet ) -replace '"|\(|\)' -replace "'" -replace '^\s+|\s+$'
                    }
                }
            }
        #endregion Query WalkThroughFunction Parameters

        #region Query WalkThroughFunction Syntax
            $CurSyntax = $CurHelp.syntax
        #endregion Query WalkThroughFunction Syntax

        #region Exit Flag set to False
            $LeaveWalkThrough = $false
        #endregion Exit Flag set to False
    #endregion WalkThrough Defined Variables

    #region Main Do Until
        Do
        {
            #region Build Current Command
                $WalkCommand = $('{0}' -f $WalkThroughFunction)
                $CurParameters | ForEach-Object `
                -Process `
                {
                    $CurParameter = $_
                    If
                    (
                        $CurParameter.defaultValue
                    )
                    {
                        Switch
                        (
                            $null
                        )
                        {
                            {$CurParameter.defaultValue -eq $true}
                            {
                                $WalkCommand += $(' -{0}' -f $CurParameter.name)
                            }
                            {$CurParameter.defaultValue -eq $false}
                            {
                                    #Do Nothing               
                            }
                            {$CurParameter.parameterValue -match 'Int'}
                            {
                                $WalkCommand += $(' -{0} {1}' -f $CurParameter.name, $CurParameter.defaultValue)
                            }
                            Default
                            {
                                Try
                                {
                                    $WalkCommand += $(' -{0} "{1}"' -f $CurParameter.name, $($CurParameter.defaultValue -Join ',' -replace '\,','","') )
                                }
                                Catch
                                {
                                    $WalkCommand += $(' -{0} "{1}"' -f $CurParameter.name, $CurParameter.defaultValue)
                                }
                            }
                        }
                    }
                }
            #endregion Build Current Command

            #region Build Main Menu
                #region Main Header
					Write-Host $("`n")
                    Write-Host $('** Command Description **') -ForegroundColor Green
                    Write-Host $('{0}' -f $($CurHelp.description | Out-String).Trim()) -ForegroundColor Cyan
				
                    Write-Host $("`n")
                    Write-Host $('** Command Syntax **') -ForegroundColor Green
                    Write-Host $('{0}' -f $($CurSyntax | Out-String).Trim()) -ForegroundColor Cyan

                    Write-Host $("`n")
                    Write-Host $('** Current Command **') -ForegroundColor Green
                    Write-Host $('{0}' -f $WalkCommand) -ForegroundColor Cyan
                    Write-Host $("`n")
			
					Write-Host $('** Parameters **'.PadRight(20,' ')  + '||  ** Set Values **') -ForegroundColor Green
					$CurParameters.Name | ForEach-Object `
					-Process `
					{
                        $CurParameterName = $_

						If
						(
							$CurParameterName -ne 'Walkthrough'
						)
						{
                            $CurParameterValue =  $CurParameters | Where-Object -FilterScript { $_.Name -eq $CurParameterName} | Select-Object -ExpandProperty defaultValue
                            Try
                            {
                                $CurParameterJoinValue = $( '"{0}"' -f $($CurParameterValue -Join ',' -replace '\,','","') )
                                If
                                (
                                    $CurParameterJoinValue -notmatch '\"\,\"'
                                )
                                {
                                    $CurParameterJoinValue = $CurParameterJoinValue -replace '\"'
                                }
                                Write-Host $("{0} " -f $($CurParameterName.PadRight(20,' ') + "|| ")) -ForegroundColor Cyan -NoNewline
                                Write-Host $("{0}" -f, $CurParameterJoinValue) -ForegroundColor White
                            }
                            Catch
                            {
                                $CurParameterJoinValue = $CurParameterValue
                                Write-Host $("{0} " -f $($CurParameterName.PadRight(20,' ') + "|| ")) -ForegroundColor Cyan -NoNewline
                                Write-Host $("{0}" -f, $CurParameterJoinValue) -ForegroundColor White
                            }
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
							Write-Host $("Type '{0}' to update value" -f $_.Name) -ForegroundColor Yellow
						}
					}
					Write-Host $("Type 'Help' to view the Description for each Parameter") -ForegroundColor Yellow
                    Write-Host $("Type 'Examples' to view any Examples") -ForegroundColor Yellow
                    If
                    (
                        -Not $WalkThroughRemoveRun -eq $true
                    )
                    {
                        Write-Host $("Type 'Run' to Run the above (Current Command)") -ForegroundColor Yellow
                    }
                    Write-Host $("Type 'Exit' or (Leave Blank) to Exit without running") -ForegroundColor Yellow

                    Write-Host $("`n")
                #endregion

                #region Main Prompt
                    $UpdateItem = Read-Host -Prompt 'Please make a selection'
                #endregion

                #region Main Switch for menu interaction
                    switch
                    (
                        $UpdateItem
                    )
                    {
                        #region Exit Main menu
                            'Exit'
                            {
                                Return
                            }
                        #endregion Exit Main menu

                        #region Exit Main menu
                            ''
                            {
                                Return
                            }
                        #endregion Exit Main menu

                        #region Pull Parameter Type from the Static Help Parameter (If String)
                            { $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty parameterValue)  -match 'String' }
                            {
                                Switch
                                (
                                    $null
                                )
                                {
                                    #ValidateSet
                                    { $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty ValidateSet) }
                                    {

                                        $AllowedValues = $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty ValidateSet) -replace "\(|\)|\[|\]|\'" -replace '\,\s',',' -replace '\s\,',',' -split ','
                                        Clear-Host

                                        Do
                                        {
                                            Write-Host $('** Validation Set **') -ForegroundColor Green
                                            $AllowedValues | ForEach-Object -Process { Write-Host $("Type '{0}' to update value" -f $_) -ForegroundColor Yellow}
                                            Write-Host $("Type 'Back' or (Leave Blank) to go back to the main menu") -ForegroundColor Yellow
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
                                                    break
                                                }
                                                'Null'
                                                {
                                                    $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem}).defaultValue = $null
                                                    $LeaveValidateSet = $true
                                                    Break
                                                }
                                                { $AllowedValues -contains $ValidateSetInput }
                                                {
                                                    $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem}).defaultValue = $ValidateSetInput
                                                    $LeaveValidateSet = $true
                                                    Break
                                                }
                                                ''
                                                {
                                                    $LeaveValidateSet = $true
                                                    break
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
                                                
                                        Break
                                    }
                                    #String[] (Mulit String)
                                    { $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty parameterValue)  -match 'String\[\]' }
                                    {
                                        $ArrUpdateItem = @()
                                        $PromptCount = 0
                                        Clear-Host
                                                
                                        Do
                                        {
                                            $UpdateItemPrompt = Read-Host -Prompt $('Enter a value for ( {0}[{1}] )' -f $UpdateItem, $PromptCount)
                                            $PromptCount ++

                                            If
                                            (
                                                $UpdateItemPrompt
                                            )
                                            {
                                                $ArrUpdateItem += $UpdateItemPrompt
                                            }

                                        }
                                        Until
                                        (
                                            $UpdateItemPrompt -eq ''
                                        )

                                        $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem}).defaultValue = $ArrUpdateItem

                                        Break
                                    }
                                    #String (Single String)
                                    Default
                                    {
                                        Clear-Host
                                        $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem}).defaultValue = $(Read-Host -Prompt $('Enter a value for ( {0} )' -f $UpdateItem))
                                    }

                                }
                            }
                        #endregion Pull Parameter Type from the Static Help Parameter (If String)

                        #region Pull Parameter Type from the Static Help Parameter (If Object)
                            { $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty parameterValue)  -match 'Object' }
                            {
                                Clear-Host
                                $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem}).defaultValue = $(Read-Host -Prompt $('Enter a value for ( {0} )' -f $UpdateItem))
                            }
                        #endregion Pull Parameter Type from the Static Help Parameter (If Object)

                        #region Pull Parameter Type from the Static Help Parameter (If Int)
                            { $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty parameterValue)  -match 'Int' }
                            {
                                Clear-Host
                                $IntValue = $(Read-Host -Prompt $('Enter a value for ( {0} )'))
                                Switch
                                (
                                    $IntValue
                                )
                                {
                                    ''
                                    {
                                        $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem}).defaultValue = $null
                                    }
                                    {
                                        $IntValue -match '^[\d\.]+$'
                                    }
                                    {
                                        $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem}).defaultValue = $IntValue
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
                        #endregion Pull Parameter Type from the Static Help Parameter (If Int)

                        #region Pull Parameter Type from the Static Help Parameter (If SwitchParameter)
                            { $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty parameterValue)  -match 'SwitchParameter' }
                            {
                                Clear-Host
                                If
                                (
                                    $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem}).defaultValue -eq $true
                                )
                                {
                                    $CurToggle = $false
                                }
                                Else
                                {
                                    $CurToggle = $true
                                }
                                $null = Remove-Variable -Name $UpdateItem -Force -ErrorAction SilentlyContinue
                                $($CurParameters | Where-Object -FilterScript { $_.Name -eq $UpdateItem}).defaultValue = $CurToggle
                                $null = Remove-Variable -Name $CurToggle -Force -ErrorAction SilentlyContinue
                            }
                        #endregion Pull Parameter Type from the Static Help Parameter (If SwitchParameter)

                        #region Pull the Help information for each Parameter and Dynamically build the menu system
                            'Help'
                            {
                                Clear-Host
                                $LeaveHelpInput = $false

                                Do
                                {
                                    Write-Host $('** Help Parameter Information **') -ForegroundColor Green
                                    $CurParameters.Name | ForEach-Object -Process { Write-Host $("Type '{0}' to view Help" -f $_) -ForegroundColor Yellow}
                                    Write-Host $("Type 'All' to list all Parameters and Help Information") -ForegroundColor Yellow
                                    Write-Host $("Type 'Help' to view the General Help information") -ForegroundColor Yellow
                                    Write-Host $("Type 'Full' to view the Detailed Help information") -ForegroundColor Yellow
                                    Write-Host $("Type 'Back' or (Leave Blank) to go back to the main menu") -ForegroundColor Yellow

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
                                            $CurParameters.Name -contains $HelpInput
                                        }
                                        {
                                            $CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $HelpInput } | Out-String
                                            Pause
                                            Clear-Host
                                        }
                                        'All'
                                        {
                                            $CurHelp.parameters.parameter | Out-String
                                            Pause
                                            Clear-Host
                                        }
                                        'Help'
                                        {
                                            Get-Help -Name $WalkThroughFunction | Out-String
                                            Pause
                                            Clear-Host
                                        }
                                        'Full'
                                        {
                                            Get-Help -Name $WalkThroughFunction -Full | Out-String
                                            Pause
                                            Clear-Host
                                        }
                                        ''
                                        {
                                            $LeaveHelpInput = $true
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
                        #endregion Pull the Help information for each Parameter and Dynamically build the menu system

                        #region Pull the Examples information and Dynamically build the menu system
                            'Examples'
                            {
                                Clear-Host
                                $LeaveExampleInput = $false

                                Do
                                {
                                    Write-Host $('** Examples **') -ForegroundColor Green
                                    $CurExamplesObject  | ForEach-Object -Process { Write-Host $("Type '{0}' to view Example: {1}" -f $($_.Title -replace 'EXAMPLE|\s|\-'), $($_.Description)) -ForegroundColor Yellow}
                                    Write-Host $("Type '{0}' to list all Examples" -f $($CurExamplesObject.Count + 1)) -ForegroundColor Yellow
                                    Write-Host $("Type '0' or (Leave Blank) to go back to the main menu") -ForegroundColor Yellow

                                    Write-Host $("`n")
                                    $ExampleInput = $null
                                    [Int]$ExampleInput = Read-Host -Prompt 'Please make a selection'

                                    Switch
                                    (
                                        $ExampleInput
                                    )
                                    {
                                        '0'
                                        {
                                            $LeaveExampleInput = $true
                                            Break
                                        }
                                        ''
                                        {
                                            $LeaveExampleInput = $true
                                            Break
                                        }
                                        "$($CurExamplesObject.Count + 1)"
                                        {
                                            $CurHelp.examples.example
                                            Pause
                                            Clear-Host
                                            Break
                                        }
                                        { $CurExamplesObject[$($ExampleInput - 1)] }
                                        {
                                            $CurHelp.examples.example | Where-Object -FilterScript { $_.Title -Match $('EXAMPLE\s{0}\s' -f $ExampleInput) }
                                            Pause
                                            Clear-Host
                                            Break
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
                        #endregion Pull the Examples information and Dynamically build the menu system

                        #region Run the Current Command
                            'Run'
                            {
                                If
                                (
                                    -Not $WalkThroughRemoveRun -eq $true
                                )
                                {
                                    #Exiting Switch and Running set Parameters
                                    $InvokeReturn = Invoke-Expression -Command $($WalkCommand)
                                    Return $InvokeReturn
                                }
                                Else
                                {
                                    Clear-Host
                                    Write-Host $('({0}) is not a valid option.  Please try again.' -f $UpdateItem) -ForegroundColor Red
                                    Write-Host $("`n")
                                    $LeaveWalkThrough = $false
                                    Pause
                                }
                            }
                        #endregion Run the Current Command

                        #region Default (Error Control)
                            Default
                            {
                                Clear-Host
                                Write-Host $('({0}) is not a valid option.  Please try again.' -f $UpdateItem) -ForegroundColor Red
                                Write-Host $("`n")
                                $LeaveWalkThrough = $false
                                Pause
                            }
                        #endregion Default (Error Control)
                    }
                #endregion Main Switch for menu interaction
            #endregion Build Main Menu
        }
        Until
        (
            $LeaveWalkThrough -eq $true
        )
    #endregion Main Do Until
}
#endregion Invoke-BluGenieWalkThrough (Function)