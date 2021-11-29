#region Set-BluGenieCommands (Function)
    Function Set-BluGenieCommands
    {
        <#
        .SYNOPSIS
            Set-BluGenieCommands is an add-on to manage the Command list in the BluGenie Console

        .DESCRIPTION
            Set-BluGenieCommands is an add-on to manage the Command list in the BluGenie Console

            Commands can be BluGenie Functions or any command Posh can run.
                Note: The Commands action is a specific order.

            o 1st   - Command section will run in synchronous order
            o 2nd   - Parallel Command section will run all items at the same time.
                    - Parallel Commands run after all Commands in the Command section finish
            o 3rd   - Post Command section will run in synchronous order
                    - Post Commands run after all the Parallel Commands have finished

        .PARAMETER Add
            Description: Add items to the list
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER Remove
            Description: Remove items from the list
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER RemoveIndex
            Description: Remove items from the list using the index value
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER RemoveAll
            Description: Remove all commands from the Command list
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER Walkthrough
            Description: An automated process to walk through the current function and all the parameters
            Notes:
            Alias:
            ValidateSet:

        .EXAMPLE
            Command: Set-BluGenieCommands
            Description: This will give you a list of identified Commands
            Notes:
            OutType:

        .EXAMPLE
            Command: Set-BluGenieCommands 'Get-SystemInfo'
            Description: This will add the specified Commands to the Command list
            Notes:
            OutType:

        .EXAMPLE
            Command: Set-BluGenieCommands -Add 'Get-SystemInfo','Invoke-Netstat','Get-ProcessList'
            Description: This will add all of the specified Commands to the Command list
            Notes:
            OutType:

        .EXAMPLE
            ommand: Set-BluGenieCommands -Remove '^G'
            Description: The -Remove command excepts (RegEx).  This will remove all items with a ( G ) as the first character
            Notes:
            OutType:

        .EXAMPLE
            Command: Command -Remove 'Get-SystemInfo'
            Description: The -Remove command excepts (RegEx).  This will remove all items with 'Get-SystemInfo' in the name
            Notes:
            OutType:

        .EXAMPLE
            Command: Set-BluGenieCommands -Remove '^Get-SystemInfo$','^Get-ProcessList$'
            Description: The -Remove command excepts (RegEx).  This will remove all items with that have an exact match of the Command name
            Notes:
            OutType:

        .EXAMPLE
            Command: Set-BluGenieCommands -RemoveIndex 1
            Description: This will remove the first item in the Command list
            Notes:
            OutType:

        .EXAMPLE
            Command: Set-BluGenieCommands -RemoveIndex 1,10,12,15
            Description: This will remove all the items from the Command list that have the specified index value.
            Notes: To get the Index value you can run (Set-BluGenieCommands).  This will show the Command list and the index values.
            OutType:

        .EXAMPLE
            Command: Set-BluGenieCommands -RemoveAll
            Description: This will remove all commands from the Command list
            Notes:
            OutType:

        .NOTES

            * Original Author           : Michael Arroyo
            * Original Build Version    : 1907.3101
            * Latest Author             : Michael Arroyo
            * Latest Build Version      : 20.06.0201
            * Comments                  :
            * Dependencies              :
                ~
            * Build Version Details     :
                ~ 1907.3101: * [Michael Arroyo] Posted
                ~ 1908.0701: * [Michael Arroyo] Add the ( RemoveAll ) parameter
                ~ 20.06.0201:* [Michael Arroyo] Added check for the ConsoleCommands global variable

    #>
        [Alias('Commands')]
        Param
        (
            [String[]]$Add,

            [String[]]$Remove,

            [Int[]]$RemoveIndex,

            [Switch]$RemoveAll,

            [Alias('Help')]
            [Switch]$Walkthrough
        )

        #region WalkThrough (Dynamic Help)
            If ($Walkthrough) {
                If ($($PSCmdlet.MyInvocation.InvocationName)) {
                    $Function = $($PSCmdlet.MyInvocation.InvocationName)
                } Else {
                    If ($Host.Name -match 'ISE') {
                        $Function = $(Split-Path -Path $psISE.CurrentFile.FullPath -Leaf) -replace '((?:.[^.\r\n]*){1})$'
                    }
                }

                If (Get-Command | Select-Object -Property Invoke-WalkThrough) {
                    If ($Function -eq 'Invoke-WalkThrough') {
                        #Disable Invoke-WalkThrough looping
                        Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function -RemoveRun }
                        Return
                    } Else {
                        Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function }
                        Return
                    }
                } Else {
                    Get-Help -Name $Function -Full
                    Return
                }
            }
        #endregion WalkThrough (Dynamic Help)

        #region Main
            #region Check Global Variable
                If
                (
                    -Not $Global:ConsoleCommands
                )
                {
                    [System.Collections.ArrayList]$Global:ConsoleCommands = @()
                }
            #endregion Check Global Variable

            Switch
            (
                $null
            )
            {
                #region Add items to list
                    {$Add}
                    {
                        $Add | ForEach-Object `
                        -Process `
                        {
                            If
                            (
                                $global:ConsoleCommands -contains $_
                            )
                            {
                                $ConsoleCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                $ConsoleCommandsMsg = '..Already Added..'
                                write-host -NoNewline $("`n{0}" -f $ConsoleCommandsText) -ForegroundColor Yellow
                                Write-Host -NoNewline $ConsoleCommandsMsg -ForegroundColor Red
                            }
                            Else
                            {
                                $null = $global:ConsoleCommands.Add($_)
                                $ConsoleCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                $ConsoleCommandsMsg = '..Added..'
                                write-host -NoNewline $("`n{0}" -f $ConsoleCommandsText) -ForegroundColor Yellow
                                Write-Host -NoNewline $ConsoleCommandsMsg -ForegroundColor Green
                            }
                        }

                        Write-Host "`n"
                    }
                #endregion Add items to list

                #region Remove items from list
                    {$Remove}
                    {
                        If
                        (
                            $global:ConsoleCommands
                        )
                        {
                            $RemoveFilter = $Remove | ForEach-Object `
                            -Process `
                            {
                                $CurRemoveItem = $_
                                $global:ConsoleCommands | Select-String -Pattern $CurRemoveItem
                            }

                            If
                            (
                                $RemoveFilter
                            )
                            {
                                $RemoveFilter | ForEach-Object `
                                -Process `
                                {
                                    If
                                    (
                                        $global:ConsoleCommands -contains $_
                                    )
                                    {
                                        $null = $global:ConsoleCommands.Remove("$_")
                                        $ConsoleCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                        $ConsoleCommandsMsg = '..Removed..'
                                        write-host -NoNewline $("`n{0}" -f $ConsoleCommandsText) -ForegroundColor Yellow
                                        Write-Host -NoNewline $ConsoleCommandsMsg -ForegroundColor Green
                                    }
                                    Else
                                    {
                                        $ConsoleCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                        $ConsoleCommandsMsg = '..Item Not Found..'
                                        write-host -NoNewline $("`n{0}" -f $ConsoleCommandsText) -ForegroundColor Yellow
                                        Write-Host -NoNewline $ConsoleCommandsMsg -ForegroundColor Red
                                    }
                                }

                                Write-Host "`n"
                            }
                            Else
                            {
                                $Remove | ForEach-Object `
                                -Process `
                                {
                                    $ConsoleCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                    $ConsoleCommandsMsg = '..Item Not Found..'
                                    write-host -NoNewline $("`n{0}" -f $ConsoleCommandsText) -ForegroundColor Yellow
                                    Write-Host -NoNewline $ConsoleCommandsMsg -ForegroundColor Red
                                }

                                Write-Host "`n"
                            }
                        }
                        Else
                        {
                            Write-Host 'No Commands identified' -ForegroundColor Red
                        }

                    }
                #endregion Remove items from list

                #region Remove items from list
                    {$RemoveAll -eq $true}
                    {
                        If
                        (
                            $global:ConsoleCommands
                        )
                        {
                            $global:ConsoleCommands | ForEach-Object `
                            -Process `
                            {
                                $ConsoleCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                $ConsoleCommandsMsg = '..Removed..'
                                write-host -NoNewline $("`n{0}" -f $ConsoleCommandsText) -ForegroundColor Yellow
                                Write-Host -NoNewline $ConsoleCommandsMsg -ForegroundColor Green
                            }
                            Write-Host "`n"
                        }
                        Else
                        {
                            Write-Host 'No Commands identified' -ForegroundColor Red
                        }

                        [System.Collections.ArrayList]$global:ConsoleCommands = @()
                    }
                #endregion Remove items from list

                #region Remove items from list using the index value
                    {$RemoveIndex}
                    {
                        If
                        (
                            $global:ConsoleCommands
                        )
                        {
                            $RemoveIndex | Sort-Object -Descending | ForEach-Object `
                            -Process `
                            {
                                $CurStringValue = $global:ConsoleCommands[$($_ - 1)]

                                If
                                (
                                    $global:ConsoleCommands[$($_ - 1)]
                                )
                                {
                                    $null = $global:ConsoleCommands.RemoveAt($_ - 1)
                                    $ConsoleCommandsText = "$CurStringValue".PadRight(25,' ') + "|| `t"
                                    $ConsoleCommandsMsg = '..Removed..'
                                    write-host -NoNewline $("`n{0}" -f $ConsoleCommandsText) -ForegroundColor Yellow
                                    Write-Host -NoNewline $ConsoleCommandsMsg -ForegroundColor Green
                                }
                                Else
                                {
                                    $ConsoleCommandsText = "$CurStringValue".PadRight(25,' ') + "|| `t"
                                    $ConsoleCommandsMsg = '..Item Not Found..'
                                    write-host -NoNewline $("`n{0}" -f $ConsoleCommandsText) -ForegroundColor Yellow
                                    Write-Host -NoNewline $ConsoleCommandsMsg -ForegroundColor Red
                                }
                            }

                            Write-Host "`n"
                        }
                        Else
                        {
                            Write-Host 'No Commands identified' -ForegroundColor Red
                        }
                    }
                #endregion Remove items from list using the index value

                #region Default (Show list values)
                    Default
                    {
                        If
                        (
                            $global:ConsoleCommands
                        )
                        {
                            $IndexCounter = 1

                            Write-Host 'Commands identified' -ForegroundColor Yellow
                            $global:ConsoleCommands | ForEach-Object `
                            -Process `
                            {
                                $ConsoleCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                $ConsoleCommandsMsg = $('..Index [{0}]..' -f $IndexCounter)
                                write-host -NoNewline $("`n{0}" -f $ConsoleCommandsText) -ForegroundColor Green
                                Write-Host -NoNewline $ConsoleCommandsMsg -ForegroundColor Yellow
                                $IndexCounter ++
                            }

                            Write-Host "`n"
                        }
                        Else
                        {
                            Write-Host 'No Commands identified' -ForegroundColor Red
                        }
                    }
                #endregion Default (Show list values)
            }
        #endregion Main
    }
#endregion Set-BluGenieCommands (Function)