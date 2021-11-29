#region Set-BluGenieParallelCommands (Function)
Function Set-BluGenieParallelCommands
{
    <#
    .SYNOPSIS
        Set-BluGenieParallelCommands is an add-on to manage the Parallel Command list in the BluGenie Console

    .DESCRIPTION
        Set-BluGenieParallelCommands is an add-on to manage the Parallel Command list in the BluGenie Console

        Parallel Commands can be BluGenie Functions or any command Posh can run.
            Note: The Parallel Command section will run all items at the same time.

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

    .PARAMETER RemoveAll
        Description: Remove all items from the list
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER RemoveIndex
        Description: Remove items from the list using the index value
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER Walkthrough
        Description: An automated process to walk through the current function and all the parameters
        Notes:
        Alias:
        ValidateSet:

    .EXAMPLE
        Command: Set-BluGenieParallelCommands
        Description: This will give you a list of identified Parallel Commands
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGenieParallelCommands 'Get-SystemInfo'
        Description: This will add the specified Command to the Parallel Command list
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGenieParallelCommands -Add 'Get-SystemInfo','Invoke-Netstat','Get-ProcessList'
        Description: This will add all of the specified Commands to the Parallel Command list
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGenieParallelCommands -Remove '^G'
        Description: The -Remove command excepts (RegEx).  This will remove all items with a ( G ) as the first character
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGenieParallelCommands -Remove 'Get-SystemInfo'
        Description: The -Remove command excepts (RegEx).  This will remove all items with 'Get-SystemInfo' in the name
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGenieParallelCommands -Remove '^Get-SystemInfo$','^Get-ProcessList$'
        Description: The -Remove command excepts (RegEx).  This will remove all items with that have an exact match of the Parallel Command
name
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGenieParallelCommands -RemoveAll
        Description: This will remove all items from the Parallel Command List
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGenieParallelCommands -RemoveIndex 1
        Description: This will remove the first item in the Command list
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGenieParallelCommands -RemoveIndex 1,10,12,15
        Description: This will remove all the items from the Command list that have the specified index value.
        Notes: To get the Index value you can run ( Set-BluGenieParallelCommands ).  This will show the Parallel Command list and the index
values.
        OutType:

    .OUTPUTS
            TypeName: System.String

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
            ~ 20.06.0201:* [Michael Arroyo] Added a check for the ConsoleParallelCommands global variable
#>
    [Alias('ParallelCommands')]
    Param (
        [String[]]$Add,

        [String[]]$Remove,

        [Switch]$RemoveAll,

        [Int[]]$RemoveIndex,

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

            If (Test-Path -Path Function:\Invoke-BluGenieWalkThrough) {
                If ($Function -eq 'Invoke-BluGenieWalkThrough') {
                    #Disable Invoke-BluGenieWalkThrough looping
                    Invoke-Command -ScriptBlock { Invoke-BluGenieWalkThrough -Name $Function -RemoveRun }
                    Return
                } Else {
                    Invoke-Command -ScriptBlock { Invoke-BluGenieWalkThrough -Name $Function }
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
            If (-Not $($Global:ConsoleParallelCommands)) {
                [System.Collections.ArrayList]$Global:ConsoleParallelCommands = @()
            }
        #endregion Check Global Variable

        Switch ($null) {
            #region Add items to list
                {$Add} {
                    $Add | ForEach-Object -Process {
                        If ($global:ConsoleParallelCommands -contains $_) {
                            $ConsoleParallelCommandsText = "$_".PadRight(25,' ') + "|| `t"
                            $ConsoleParallelCommandsMsg = '..Already Added..'
                            write-host -NoNewline $("`n{0}" -f $ConsoleParallelCommandsText) -ForegroundColor Yellow
                            Write-Host -NoNewline $ConsoleParallelCommandsMsg -ForegroundColor Red
                        } Else {
                            $null = $global:ConsoleParallelCommands.Add($_)
                            $ConsoleParallelCommandsText = "$_".PadRight(25,' ') + "|| `t"
                            $ConsoleParallelCommandsMsg = '..Added..'
                            write-host -NoNewline $("`n{0}" -f $ConsoleParallelCommandsText) -ForegroundColor Yellow
                            Write-Host -NoNewline $ConsoleParallelCommandsMsg -ForegroundColor Green
                        }
                    }

                    Write-Host "`n"
                }
            #endregion Add items to list

            #region Remove items from list
                {$Remove} {
                    If ($global:ConsoleParallelCommands) {
                        $RemoveFilter = $Remove | ForEach-Object -Process {
                            $CurRemoveItem = $_
                            $global:ConsoleParallelCommands | Select-String -Pattern $CurRemoveItem
                        }

                        If ($RemoveFilter) {
                            $RemoveFilter | ForEach-Object -Process {
                                If ($global:ConsoleParallelCommands -contains $_) {
                                    $null = $global:ConsoleParallelCommands.Remove("$_")
                                    $ConsoleParallelCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                    $ConsoleParallelCommandsMsg = '..Removed..'
                                    write-host -NoNewline $("`n{0}" -f $ConsoleParallelCommandsText) -ForegroundColor Yellow
                                    Write-Host -NoNewline $ConsoleParallelCommandsMsg -ForegroundColor Green
                                } Else {
                                    $ConsoleParallelCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                    $ConsoleParallelCommandsMsg = '..Item Not Found..'
                                    write-host -NoNewline $("`n{0}" -f $ConsoleParallelCommandsText) -ForegroundColor Yellow
                                    Write-Host -NoNewline $ConsoleParallelCommandsMsg -ForegroundColor Red
                                }
                            }

                            Write-Host "`n"
                        } Else {
                            $Remove | ForEach-Object -Process {
                                $ConsoleParallelCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                $ConsoleParallelCommandsMsg = '..Item Not Found..'
                                write-host -NoNewline $("`n{0}" -f $ConsoleParallelCommandsText) -ForegroundColor Yellow
                                Write-Host -NoNewline $ConsoleParallelCommandsMsg -ForegroundColor Red
                            }

                            Write-Host "`n"
                        }
                    } Else {
                        Write-Host 'No Parallel Commands identified' -ForegroundColor Red
                    }
                }
            #endregion Remove items from list

            #region RemoveAll items from list
                {$RemoveAll -eq $true} {
                    If ($global:ConsoleParallelCommands) {
                        0..$($global:ConsoleParallelCommands.Count -1) | Sort-Object -Descending | ForEach-Object -Process {
                            $CurRemoveItem = $global:ConsoleParallelCommands[$_]
                            $ConsoleParallelCommandsText = "$CurRemoveItem" + "`t|| `t"
                            $ConsoleParallelCommandsMsg = '..Removed..'
                            write-host -NoNewline $("`n{0}" -f $ConsoleParallelCommandsText) -ForegroundColor Yellow
                            Write-Host -NoNewline $ConsoleParallelCommandsMsg -ForegroundColor Green
                        }

                        Write-Host "`n"
                        [System.Collections.ArrayList]$global:ConsoleParallelCommands = @()
                    } Else {
                        Write-Host 'No Parallel Commands identified' -ForegroundColor Red
                    }
                }
            #endregion Remove items from list

            #region Remove items from list using the index value
                {$RemoveIndex} {
                    If ($global:ConsoleParallelCommands) {
                        $RemoveIndex | Sort-Object -Descending | ForEach-Object -Process {
                            $CurStringValue = $global:ConsoleParallelCommands[$($_ - 1)]

                            If ($global:ConsoleParallelCommands[$($_ - 1)]) {
                                $null = $global:ConsoleParallelCommands.RemoveAt($_ - 1)
                                $ConsoleParallelCommandsText = "$CurStringValue".PadRight(25,' ') + "|| `t"
                                $ConsoleParallelCommandsMsg = '..Removed..'
                                write-host -NoNewline $("`n{0}" -f $ConsoleParallelCommandsText) -ForegroundColor Yellow
                                Write-Host -NoNewline $ConsoleParallelCommandsMsg -ForegroundColor Green
                            } Else {
                                $ConsoleParallelCommandsText = "$($_ - 1)".PadRight(25,' ') + "|| `t"
                                $ConsoleParallelCommandsMsg = '..Index Not Found..'
                                write-host -NoNewline $("`n{0}" -f $ConsoleParallelCommandsText) -ForegroundColor Yellow
                                Write-Host -NoNewline $ConsoleParallelCommandsMsg -ForegroundColor Red
                            }
                        }

                        Write-Host "`n"
                    } Else {
                        Write-Host 'No Parallel Commands identified' -ForegroundColor Red
                    }
                }
            #endregion Remove items from list using the index value

            #region Default (Show list values)
                Default {
                    If ($global:ConsoleParallelCommands) {
                        $IndexCounter = 1

                        Write-Host 'Parallel Commands identified' -ForegroundColor Yellow
                        $global:ConsoleParallelCommands | ForEach-Object -Process {
                            $ConsoleParallelCommandsText = "$_".PadRight(25,' ') + "|| `t"
                            $ConsoleParallelCommandsMsg = $('..Index [{0}]..' -f $IndexCounter)
                            write-host -NoNewline $("`n{0}" -f $ConsoleParallelCommandsText) -ForegroundColor Green
                            Write-Host -NoNewline $ConsoleParallelCommandsMsg -ForegroundColor Yellow
                            $IndexCounter ++
                        }

                        Write-Host "`n"
                    } Else {
                        Write-Host 'No Parallel Commands identified' -ForegroundColor Red
                    }
                }
            #endregion Default (Show list values)
        }
    #endregion Main
}
#endregion Set-BluGenieParallelCommands (Function)