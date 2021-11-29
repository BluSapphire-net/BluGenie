#region Set-BluGeniePostCommands (Function)
    Function Set-BluGeniePostCommands
    {
    <#
    .SYNOPSIS
        Set-BluGeniePostCommands is an add-on to manage the Post Command list in the BluGenie Console

    .DESCRIPTION
        Set-BluGeniePostCommands is an add-on to manage the Post Command list in the BluGenie Console

        Post Commands can be BluGenie Functions or any command Posh can run.
            Note: Post Command section will run in synchronous order
                    Post Commands run after all the Parallel Commands have finished

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
        Command: Set-BluGeniePostCommands
        Description: This will give you a list of identified Post Commands
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGeniePostCommands 'Get-SystemInfo'
        Description: This will add the specified Command to the Post Command list
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGeniePostCommands -Add 'Get-SystemInfo','Invoke-Netstat','Get-ProcessList'
        Description: This will add all of the specified Commands to the Post Command list
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGeniePostCommands -Remove '^G'
        Description: The -Remove command excepts (RegEx).  This will remove all items with a ( G ) as the first character
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGeniePostCommands -Remove 'Get-SystemInfo'
        Description: The -Remove command excepts (RegEx).  This will remove all items with 'Get-SystemInfo' in the name
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGeniePostCommands -Remove '^Get-SystemInfo$','^Get-ProcessList$'
        Description: The -Remove command excepts (RegEx).  This will remove all items with that have an exact match of the Post Command
name
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGeniePostCommands -RemoveAll
        Description: This will remove all items from the Post Command List
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGeniePostCommands -RemoveIndex 1
        Description: This will remove the first item in the Command list
        Notes:
        OutType:

    .EXAMPLE
        Command: Set-BluGeniePostCommands -RemoveIndex 1,10,12,15
        Description: This will remove all the items from the Command list that have the specified index value.
        Notes: To get the Index value you can run ( Set-BluGeniePostCommands ).  This will show the Post Command list and the index
values.
        OutType:

    .OUTPUTS
                TypeName: System.String

        .NOTES

            * Original Author           : Michael Arroyo
            * Original Build Version    : 1908.0201
            * Latest Author             : Michael Arroyo
            * Latest Build Version      : 20.06.0201
            * Comments                  :
            * Dependencies              :
                ~
            * Build Version Details     :
                ~ 1908.0201: * [Michael Arroyo] Posted
                ~ 1908.0701: * [Michael Arroyo] Added the ( RemoveAll ) Parameter
                ~ 20.06.0201:* [Michael Arroyo] Added check for the ConsolePostCommands global variable
    #>
        [Alias('PostCommands')]
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
                If (-Not $Global:ConsolePostCommands) {
                    [System.Collections.ArrayList]$Global:ConsolePostCommands = @()
                }
            #endregion Check Global Variable

            Switch ($null) {
                #region Add items to list
                    {$Add} {
                        $Add | ForEach-Object -Process  {
                            If ($global:ConsolePostCommands -contains $_) {
                                $ConsolePostCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                $ConsolePostCommandsMsg = '..Already Added..'
                                write-host -NoNewline $("`n{0}" -f $ConsolePostCommandsText) -ForegroundColor Yellow
                                Write-Host -NoNewline $ConsolePostCommandsMsg -ForegroundColor Red
                            } Else {
                                $null = $global:ConsolePostCommands.Add($_)
                                $ConsolePostCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                $ConsolePostCommandsMsg = '..Added..'
                                write-host -NoNewline $("`n{0}" -f $ConsolePostCommandsText) -ForegroundColor Yellow
                                Write-Host -NoNewline $ConsolePostCommandsMsg -ForegroundColor Green
                            }
                        }

                        Write-Host "`n"
                    }
                #endregion Add items to list

                #region Remove items from list
                    {$Remove} {
                        If ($global:ConsolePostCommands) {
                            $RemoveFilter = $Remove | ForEach-Object -Process {
                                $CurRemoveItem = $_
                                $global:ConsolePostCommands | Select-String -Pattern $CurRemoveItem
                            }

                            If ($RemoveFilter) {
                                $RemoveFilter | ForEach-Object -Process {
                                    If ($global:ConsolePostCommands -contains $_) {
                                        $null = $global:ConsolePostCommands.Remove("$_")
                                        $ConsolePostCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                        $ConsolePostCommandsMsg = '..Removed..'
                                        write-host -NoNewline $("`n{0}" -f $ConsolePostCommandsText) -ForegroundColor Yellow
                                        Write-Host -NoNewline $ConsolePostCommandsMsg -ForegroundColor Green
                                    } Else {
                                        $ConsolePostCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                        $ConsolePostCommandsMsg = '..Item Not Found..'
                                        write-host -NoNewline $("`n{0}" -f $ConsolePostCommandsText) -ForegroundColor Yellow
                                        Write-Host -NoNewline $ConsolePostCommandsMsg -ForegroundColor Red
                                    }
                                }

                                Write-Host "`n"
                            } Else {
                                $Remove | ForEach-Object -Process {
                                    $ConsolePostCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                    $ConsolePostCommandsMsg = '..Item Not Found..'
                                    write-host -NoNewline $("`n{0}" -f $ConsolePostCommandsText) -ForegroundColor Yellow
                                    Write-Host -NoNewline $ConsolePostCommandsMsg -ForegroundColor Red
                                }

                                Write-Host "`n"
                            }
                        } Else {
                            Write-Host 'No Post Commands identified' -ForegroundColor Red
                        }
                    }
                #endregion Remove items from list

                #region Remove items from list using the index value
                    {$RemoveIndex} {
                        If ($global:ConsolePostCommands) {

                            $RemoveIndex | Sort-Object -Descending | ForEach-Object -Process {
                                $CurStringValue = $global:ConsolePostCommands[$($_ - 1)]

                                If ($global:ConsolePostCommands[$($_ - 1)]) {
                                    $null = $global:ConsolePostCommands.RemoveAt($_ - 1)
                                    $ConsolePostCommandsText = "$CurStringValue".PadRight(25,' ') + "|| `t"
                                    $ConsolePostCommandsMsg = '..Removed..'
                                    write-host -NoNewline $("`n{0}" -f $ConsolePostCommandsText) -ForegroundColor Yellow
                                    Write-Host -NoNewline $ConsolePostCommandsMsg -ForegroundColor Green
                                } Else {
                                    $ConsolePostCommandsText = "$($_ - 1)".PadRight(25,' ') + "|| `t"
                                    $ConsolePostCommandsMsg = '..Index Not Found..'
                                    write-host -NoNewline $("`n{0}" -f $ConsolePostCommandsText) -ForegroundColor Yellow
                                    Write-Host -NoNewline $ConsolePostCommandsMsg -ForegroundColor Red
                                }
                            }

                            Write-Host "`n"
                        } Else {
                            Write-Host 'No Post Commands identified' -ForegroundColor Red
                        }
                    }
                #endregion Remove items from list using the index value

                #region Remove All items from list
                    {$RemoveAll -eq $true} {
                        If ($global:ConsolePostCommands) {
                            $global:ConsolePostCommands | ForEach-Object -Process {
                                $ConsolePostCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                $ConsolePostCommandsMsg = $('..Removed..')
                                write-host -NoNewline $("`n{0}" -f $ConsolePostCommandsText) -ForegroundColor Green
                                Write-Host -NoNewline $ConsolePostCommandsMsg -ForegroundColor Yellow
                            }

                            Write-Host "`n"
                        } Else {
                            Write-Host 'No Post Commands identified' -ForegroundColor Red
                        }

                        [System.Collections.ArrayList]$global:ConsolePostCommands = @()
                    }
                #endregion Remove All items from list

                #region Default (Show list values)
                    Default {
                        If ($global:ConsolePostCommands) {
                            $IndexCounter = 1

                            Write-Host 'Post Commands identified' -ForegroundColor Yellow
                            $global:ConsolePostCommands | ForEach-Object -Process {
                                $ConsolePostCommandsText = "$_".PadRight(25,' ') + "|| `t"
                                $ConsolePostCommandsMsg = $('..Index [{0}]..' -f $IndexCounter)
                                write-host -NoNewline $("`n{0}" -f $ConsolePostCommandsText) -ForegroundColor Green
                                Write-Host -NoNewline $ConsolePostCommandsMsg -ForegroundColor Yellow
                                $IndexCounter ++
                            }

                            Write-Host "`n"
                        } Else {
                            Write-Host 'No Post Commands identified' -ForegroundColor Red
                        }
                    }
                #endregion Default (Show list values)
            }
        #endregion Main
    }
#endregion Set-BluGeniePostCommands (Function)