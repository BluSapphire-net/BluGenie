#region Set-BluGenieSystems (Function)
    Function Set-BluGenieSystems
    {
        <#
        .SYNOPSIS
            Set-BluGenieSystems is an add-on to manage the System list in the BluGenie Console

        .DESCRIPTION
            Set-BluGenieSystems is an add-on to manage the System list in the BluGenie Console

            Computer Objects are the list of computers you want to action an event on.
            You can add Computer Objects manuall, throught text files, and throught AD Groups.

        .PARAMETER Add
            Description: Add computer objects to the global systems catalogue
            Notes:  To parse a file for a list of computers use the "File:" prefix
                        o Example: file:.\collections\systems.txt
                    To parse a domain group for a list of computers use the "Group:" prefix
                        o Example: group:S_Wrk_Posh3Systems
                    To parse a domain group with a specific domain name, append to the end of the Group name ":Domain.com"
                        o Example: group:S_Wrk_Posh3Systems:TestLab.com
                        o Note:  The domain needs to be a trusted domain and the account running this command needs to have access to it.
            Alias:
            ValidateSet:

        .PARAMETER Remove
            Description: Remove a specific computer object from the global systems catalogue
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER RemoveIndex
            Description: Remove a specific index from the global systems catalogue using an index value
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER RemoveAll
            Description: Remove all system objects from the global systems catalogue
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER Walkthrough
            Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
            Notes:
            Alias: Help
            ValidateSet:

        .EXAMPLE
            Command: Set-BluGenieSystems
            Description:  Use this command to identify any systems in the global systems catalogue
            Notes:

        .EXAMPLE
            Command: Systems 'TestPC1'
            Description: Use this short-hand alias to add a single computer to the global systems catalogue
            Notes:

        .EXAMPLE
            Command: Systems -Add 'TestPC1','TestPC2','10.20.136.50','10.20.136.50'
            Description:  Use this command to add multiple computers (Using Host Names and IP Addresses) to the global systems catalogue
            Notes:

        .EXAMPLE
            Command: Systems 'file:.\collections\systems.txt'
            Description:  Use this command to parse a file for a list of systems to add to the global systems catalogue
            Notes: A File is identified by using the "File:" prefix

        .EXAMPLE
            Command: Systems 'group:S_Wrk_Posh3Systems'
            Description: Use this command to parse a Domain Group for a list of systems to add to the global systems catalogue
            Notes: A Group is identified by using the "Group:" prefix
                        If no domain is specified the domain is pulled from the local registry

        .EXAMPLE
            Command: Systems 'group:S_Wrk_Posh3Systems:TestLab.com'
            Description: Use this command to parse a domain group with a specific domain name and add systems to the global systems catalogue
            Notes: Append the ":<Domain.com>" to the end of the Group name
                        If no domain is specified the domain is pulled from the local registry

        .EXAMPLE
            Command: Systems -Remove ^\d
            Description: Use this command to remove all items with a digit as the first character of the name from the global systems catalogue
            Notes: The -Remove command excepts (RegEx).

        .EXAMPLE
            Command: System -Remove Test
            Description: Use this command to remove all items with Test in the name from the global systems catalogue
            Notes: The -Remove command excepts (RegEx).

        .EXAMPLE
            Command: Systems -Remove '^TestPC1$','^TestPC2$'
            Description: Use this command to remove all items that have an exact match of the system name from the global systems catalogue
            Notes: The -Remove command excepts (RegEx).

        .EXAMPLE
            Command: Systems -RemoveIndex 1
            Description: Use this command to remove the first item in the global systems catalogue
            Notes:

        .EXAMPLE
            Command: Systems -RemoveIndex 1,10,12,15
            Description: Use this command to remove specific index items from the global systems catalogue
            Notes: To get the Index value you can run (Set-BluGenieSystems).  This will show the system list and the index values.

        .EXAMPLE
            Command: Systems -RemoveAll
            Description: Use this command to remove all the systems from the global systems catalogue
            Notes:

        .OUTPUTS
                TypeName: System.String

        .NOTES

            • [Original Author]
                o  Michael Arroyo
            • [Original Build Version]
                o  19.07.3101 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
            • [Latest Author]
                o Michael Arroyo
            • [Latest Build Version]
                o 21.05.0601
            • [Comments]
                o
            • [PowerShell Compatibility]
                o  2,3,4,5.x
            • [Forked Project]
                o
            • [Links]
                o
            • [Dependencies]
                o  Invoke-BluGenieWalkThrough or Invoke-WalkThrough - interactive help menu system
                o  Get-BluGenieErrorAction or Get-ErrorAction - Round up any errors into a smiple, clean object
                o  New-BluGenieUID or New-UID - Create a New UID
                o  ConvertTo-Yaml - ConvertTo Yaml
                o  Clear-BlugenieMemory or Clear-Memory or CM - Free up any garbage collecting that Powershell is managing
                o  ConvertFrom-Yaml - Convert From Yaml
    #>

    #region Build Notes
    <#
    ~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
        o 19.07.3101• [Michael Arroyo] Posted
        o 19.08.0701• [Michael Arroyo] Added the ( RemoveAll ) parameter
        o 21.05.0601• [Michael Arroyo] Udpdated the script based on the Current PSScriptAnalyzerSettings.psd1 settings
                    • [Michael Arroyo] Updated the script based on the new Function template to add more support for the interactive help
                    • [Michael Arroyo] Updated the WalkThrough function to the latest
                    • [Michael Arroyo] Added support to querying Domain Groups for computer objects
                    • [Michael Arroyo] Added support to querying Files for computer objects
    #>
    #endregion Build Notes
        [Alias('Systems','BGSystems')]
        #region Parameters
            Param
            (
                [String[]]$Add,

                [String[]]$Remove,

                [Int[]]$RemoveIndex,

                [Switch]$RemoveAll,

                [Alias('Help')]
                [Switch]$Walkthrough
            )
        #endregion Parameters

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
                    Test-Path -Path Function:\Invoke-WalkThrough
                )
                {
                    If
                    (
                        $Function -eq 'Invoke-WalkThrough'
                    )
                    {
                        #Disable Invoke-BluGenieWalkThrough looping
                        Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function -RemoveRun }
                        Return
                    }
                    Else
                    {
                        Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function }
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

        #region Main
            If
            (
                -Not $global:ConsoleSystems
            )
            {
                [System.Collections.ArrayList]$Global:ConsoleSystems = @()
            }

            Switch
            (
                $null
            )
            {
                #region Add items to list
                    {$Add}
                    {
                        Switch -Regex ($Add)
                        {
                            '^group\:'
                            {
                                $SplitADInfo = $Add -Split '\:'
                                If
                                (
                                    $SplitADInfo.Count -gt 2
                                )
                                {
                                    $CurSystemList = Get-BGADGroupMembers -GroupName $($SplitADInfo[1]) -Domain $()$SplitADInfo[2] -ReturnObject
                                }
                                else
                                {
                                    $CurSystemList = Get-BGADGroupMembers -GroupName $($SplitADInfo[1]) -ReturnObject
                                }
                                break
                            }

                            '^file\:'
                            {
                                $SplitADInfo = $Add -Split '\:'
                                $CurSystemList = Get-Content -Path $($SplitADInfo[1])
                                break
                            }

                            default
                            {
                                If
                                (
                                    $Add -Match ','
                                )
                                {
                                    $CurSystemList = $Add -split ','
                                }
                                Else
                                {
                                    $CurSystemList = $Add
                                }
                            }
                        }

                        $CurSystemList | ForEach-Object `
                        -Process `
                        {
                            If
                            (
                                $global:ConsoleSystems -contains $_
                            )
                            {
                                $ConsoleSystemsText = "$_".PadRight(25,' ') + "|| `t"
                                $ConsoleSystemsMsg = '..Already Added..'
                                write-host -NoNewline $("`n{0}" -f $ConsoleSystemsText) -ForegroundColor Yellow
                                Write-Host -NoNewline $ConsoleSystemsMsg -ForegroundColor Red
                            }
                            Else
                            {
                                $null = $global:ConsoleSystems.Add($_)
                                $ConsoleSystemsText = "$_".PadRight(25,' ') + "|| `t"
                                $ConsoleSystemsMsg = '..Added..'
                                write-host -NoNewline $("`n{0}" -f $ConsoleSystemsText) -ForegroundColor Yellow
                                Write-Host -NoNewline $ConsoleSystemsMsg -ForegroundColor Green
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
                            $global:ConsoleSystems
                        )
                        {
                            $RemoveFilter = $Remove | ForEach-Object `
                            -Process `
                            {
                                $CurRemoveItem = $_
                                $global:ConsoleSystems | Select-String -Pattern $CurRemoveItem
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
                                        $global:ConsoleSystems -contains $_
                                    )
                                    {
                                        $null = $global:ConsoleSystems.Remove("$_")
                                        $ConsoleSystemsText = "$_".PadRight(25,' ') + "|| `t"
                                        $ConsoleSystemsMsg = '..Removed..'
                                        write-host -NoNewline $("`n{0}" -f $ConsoleSystemsText) -ForegroundColor Yellow
                                        Write-Host -NoNewline $ConsoleSystemsMsg -ForegroundColor Green
                                    }
                                    Else
                                    {
                                        $ConsoleSystemsText = "$_".PadRight(25,' ') + "|| `t"
                                        $ConsoleSystemsMsg = '..Item Not Found..'
                                        write-host -NoNewline $("`n{0}" -f $ConsoleSystemsText) -ForegroundColor Yellow
                                        Write-Host -NoNewline $ConsoleSystemsMsg -ForegroundColor Red
                                    }
                                }

                                Write-Host "`n"
                            }
                            Else
                            {
                                $Remove | ForEach-Object `
                                -Process `
                                {
                                    $ConsoleSystemsText = "$_".PadRight(25,' ') + "|| `t"
                                    $ConsoleSystemsMsg = '..Item Not Found..'
                                    write-host -NoNewline $("`n{0}" -f $ConsoleSystemsText) -ForegroundColor Yellow
                                    Write-Host -NoNewline $ConsoleSystemsMsg -ForegroundColor Red
                                }

                                Write-Host "`n"
                            }
                        }
                        Else
                        {
                            Write-Host 'No systems identified' -ForegroundColor Red
                        }
                    }
                #endregion Remove items from list

                #region Remove All items from list
                    {$RemoveAll -eq $true}
                    {
                        If
                        (
                            $global:ConsoleSystems
                        )
                        {
                            $global:ConsoleSystems | ForEach-Object `
                            -Process `
                            {
                                $ConsoleSystemsText = "$_".PadRight(25,' ') + "|| `t"
                                $ConsoleSystemsMsg = '..Removed..'
                                write-host -NoNewline $("`n{0}" -f $ConsoleSystemsText) -ForegroundColor Yellow
                                Write-Host -NoNewline $ConsoleSystemsMsg -ForegroundColor Green
                            }
                            Write-Host "`n"
                        }
                        Else
                        {
                            Write-Host 'No systems identified' -ForegroundColor Red
                        }
                        
                        [System.Collections.ArrayList]$global:ConsoleSystems = @()
                    }
                #endregion Remove items from list

                #region Remove items from list using the index value
                    {$RemoveIndex}
                    {
                        If
                        (
                            $global:ConsoleSystems
                        )
                        {
                            $RemoveIndex | Sort-Object -Descending | ForEach-Object `
                            -Process `
                            {
                                $CurStringValue = $global:ConsoleSystems[$($_ - 1)]

                                If
                                (
                                    $global:ConsoleSystems[$($_ - 1)]
                                )
                                {
                                    $null = $global:ConsoleSystems.RemoveAt($_ - 1)
                                    $ConsoleSystemsText = "$CurStringValue".PadRight(25,' ') + "|| `t"
                                    $ConsoleSystemsMsg = '..Removed..'
                                    write-host -NoNewline $("`n{0}" -f $ConsoleSystemsText) -ForegroundColor Yellow
                                    Write-Host -NoNewline $ConsoleSystemsMsg -ForegroundColor Green
                                }
                                Else
                                {
                                    $ConsoleSystemsText = "$_".PadRight(25,' ') + "|| `t"
                                    $ConsoleSystemsMsg = '..Index Not Found..'
                                    write-host -NoNewline $("`n{0}" -f $ConsoleSystemsText) -ForegroundColor Yellow
                                    Write-Host -NoNewline $ConsoleSystemsMsg -ForegroundColor Red
                                }
                            }

                            Write-Host "`n"
                        }
                        Else
                        {
                            Write-Host 'No systems identified' -ForegroundColor Red
                        }
                    }
                #endregion Remove items from list using the index value

                #region Default (Show list values)
                    Default
                    {
                        If
                        (
                            $global:ConsoleSystems
                        )
                        {
                            $IndexCounter = 1

                            Write-Host 'Systems identified' -ForegroundColor Yellow
                            $global:ConsoleSystems | ForEach-Object `
                            -Process `
                            {
                                $ConsoleSystemsText = "$_".PadRight(25,' ') + "|| `t"
                                $ConsoleSystemsMsg = $('..Index [{0}]..' -f $IndexCounter)
                                write-host -NoNewline $("`n{0}" -f $ConsoleSystemsText) -ForegroundColor Green
                                Write-Host -NoNewline $ConsoleSystemsMsg -ForegroundColor Yellow
                                $IndexCounter ++
                            }

                            Write-Host "`n"
                        }
                        Else
                        {
                            Write-Host 'No systems identified' -ForegroundColor Red
                        }
                    }
                #endregion Default (Show list values)
            }
        #endregion Main
    }
#endregion Set-BluGenieSystems (Function)