#region Remove-BluGenieModule (Function)
Function Remove-BluGenieModule
{
<#
    .SYNOPSIS
        Remove-BluGenieModule is a BluGenie function to cleanup the BluGenie Module and Service installation

    .DESCRIPTION
        Remove-BluGenieModule is a BluGenie function to cleanup the BluGenie Module and Service installation.  All files and
        directories copied will be removed and if the BluGenie service is running it will be stopped, and removed from the system.

        All removed and failed to remove files are captured to the Returning Hash Table

    .PARAMETER ClearGarbageCollecting
        Description: Garbage Collection in Powershell to Speed up Scripts and help lower memory consumption
        Notes: This is enabled by default.  To disable use -ClearGarbageCollecting:$False
        Alias:
        ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .PARAMETER ReturnObject
        Description: Return information as an Object
        Notes: By default the data is returned as a Hash Table
        Alias:
        ValidateSet:

    .PARAMETER OutUnEscapedJSON
        Description: Remove UnEsacped Char from the JSON information.
        Notes: This will beautify json and clean up the formatting.
        Alias:
        ValidateSet:

    .PARAMETER OutYaml
        Description: Return detailed information in Yaml Format
        Notes: Only supported in Posh 3.0 and above
        Alias:
        ValidateSet:

    .PARAMETER FormatView
        Description: Automatically format the Return Object
        Notes: Yaml is only supported in Posh 3.0 and above
        Alias:
        ValidateSet: 'Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml'

    .EXAMPLE
        Command: Remove-BluGenieModule
        Description: Remove all files, directories, and BluGenie Services
        Notes:

    .EXAMPLE
        Command: Remove-BGModule
        Description: Remove all files, directories, and BluGenie Services
        Notes:

    .EXAMPLE
        Command: RemoveMods
        Description: Remove all files, directories, and BluGenie Services
        Notes:

    .EXAMPLE
        Command: Remove-BluGenieModule -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Remove-BluGenieModule -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Remove-BluGenieModule -OutUnEscapedJSON
        Description: Return a detailed function report in an UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Remove-BluGenieModule -OutYaml
        Description: Return a detailed function report in YAML format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Remove-BluGenieModule -ReturnObject
        Description: Return Output as a Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
                This parameter is also used with the FormatView

    .EXAMPLE
        Command: Remove-BluGenieModule -ReturnObject -FormatView Yaml
        Description: Output PSObject information in Yaml format
        Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
                Default is set to (None) and normal PSObject.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • [Original Author]
            o  Michael Arroyo
        • [Original Build Version]
            o  21.03.0801 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o
        • [Latest Build Version]
            o
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
            o  Invoke-SQLiteBulkCopy - Inject Bulk data into a SQL Lite Database
#>

#region Build Notes
<#
~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
    o 21.02.2401: • [Michael Arroyo] Posted
#>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Remove-BGModule','RemoveMods')]
    #region Parameters
        Param
        (
            [Switch]$ClearGarbageCollecting,

            [Alias('Help')]
            [Switch]$Walkthrough,

            [Switch]$ReturnObject,

            [Switch]$OutUnEscapedJSON,

            [Switch]$OutYaml,

            [ValidateSet('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')]
            [string]$FormatView = 'None'
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
                Test-Path -Path Function:\Invoke-BluGenieWalkThrough
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

    #region Create Return hash
        $HashReturn = @{}
        $HashReturn['Remove-BluGenieModule'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['Remove-BluGenieModule'].StartTime = $($StartTime).DateTime
        $HashReturn['Remove-BluGenieModule'].ParameterSetResults = @()
        $HashReturn['Remove-BluGenieModule'].Removed = @()
        $HashReturn['Remove-BluGenieModule'].FailedtoRemove = @()
        $HashReturn['Remove-BluGenieModule'].BGServiceWasRunning = 'FALSE'
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['Remove-BluGenieModule'].ParameterSetResults += $PSBoundParameters
    #endregion Parameter Set Results

    #region Dynamic parameter update
        If
        (
            $PSVersionTable.PSVersion.Major -eq 2
        )
        {
            $IsPosh2 = $true
        }
        Else
        {
            $IsPosh2 = $false
        }

        Switch
        (
            $null
        )
        {
            {$FormatView -eq 'Yaml' -and $IsPosh2}
            {
                $FormatView -eq 'None'
            }

            {$FormatView -match 'JSON' -and $IsPosh2}
            {
                $FormatView -eq 'None'
            }

            {$OutYaml -and $IsPosh2}
            {
                $OutYaml -eq $false
                $FormatView -eq 'None'
            }

            {$FormatView -eq 'Yaml'}
            {
                $UseCache = $true
            }

            { -Not $($ClearGarbageCollecting -eq $false)}
            {
                $ClearGarbageCollecting = $true
            }
        }
    #endregion Dynamic parameter update

    #region Main
        $BgSvc = Get-Service | Where-Object -FilterScript { $_.Name -eq 'BluGenie'  }

        If
        (
            $BgSvc
        )
        {
            $BgSvc | Stop-Service -Force
            $BgSvc.WaitForStatus('Stopped','00:02:00')
            $null = Remove-BGService
            $HashReturn['Remove-BluGenieModule'].BGServiceWasRunning = 'TRUE'
        }

        If
        (
            Test-Path -Path $('{0}\BluGenie' -f $Env:ProgramFiles)
        )
        {
            Get-ChildItem -Path $('{0}\BluGenie' -f $Env:ProgramFiles) -Recurse -File | Select-Object -ExpandProperty Fullname | `
                ForEach-Object `
                -Process `
                {
                    $CurFullName = $_
                    Try
                    {
                        Remove-Item -Path $_ -Force -ErrorAction Stop
                        $HashReturn['Remove-BluGenieModule'].Removed += $CurFullName
                    }
                    Catch
                    {
                        $HashReturn['Remove-BluGenieModule'].FailedtoRemove += $CurFullName
                    }
                }

            Get-ChildItem -Path $('{0}\BluGenie' -f $Env:ProgramFiles) -Recurse -Directory | Select-Object -ExpandProperty Fullname | `
                ForEach-Object `
                -Process `
                {
                    $CurFullName
                    Try
                    {
                        Remove-Item -Path $_ -Force -Recurse -ErrorAction SilentlyContinue
                        $HashReturn['Remove-BluGenieModule'].Removed += $CurFullName
                    }
                    Catch
                    {
                        $HashReturn['Remove-BluGenieModule'].FailedtoRemove += $CurFullName
                    }
                }
        }

        If
        (
            $ClearGarbageCollecting
        )
        {
                $null = Clear-BlugenieMemory
        }
        #>
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['Remove-BluGenieModule'].EndTime = $($EndTime).DateTime
        $HashReturn['Remove-BluGenieModule'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            -Not $($VerbosePreference -eq 'Continue')
        )
        {
            #Add Hash Properties that are not needed without Verbose enabled.
            $null = $HashReturn['Remove-BluGenieModule'].Remove('StartTime')
            $null = $HashReturn['Remove-BluGenieModule'].Remove('ParameterSetResults')
            $null = $HashReturn['Remove-BluGenieModule'].Remove('EndTime')
            $null = $HashReturn['Remove-BluGenieModule'].Remove('ElapsedTime')
        }

        If
        (
            $ClearGarbageCollecting
        )
        {
            $null = Clear-BlugenieMemory
        }

        #region Output Type
            $ResultSet = New-Object -TypeName PSObject -Property @{
                'Removed' = $HashReturn['Remove-BluGenieModule'].Removed
                'FailedtoRemove' = $HashReturn['Remove-BluGenieModule'].FailedtoRemove
                'BGServiceWasRunning' = $HashReturn['Remove-BluGenieModule'].BGServiceWasRunning
            }

            switch
            (
                $Null
            )
            {
                #region Beautify the JSON return and not Escape any Characters
                    { $OutUnEscapedJSON }
                    {
                        Return $($HashReturn | ConvertTo-Json -Depth 10 | ForEach-Object -Process { [regex]::Unescape($_) })
                    }
                #endregion Beautify the JSON return and not Escape any Characters

                #region Yaml Output of Hash Information
                    { $OutYaml }
                    {
                        Return $($HashReturn | ConvertTo-Yaml)
                    }
                #endregion Yaml Output of Hash Information

                #region Return a PowerShell Object
                    { $ReturnObject }
                    {
                        #region Switch FormatView
                            switch
                            (
                                $FormatView
                            )
                            {
                                #region Table
                                    'Table'
                                    {
                                        Return $($ResultSet | Format-Table -AutoSize -Wrap)
                                    }
                                #endregion Table

                                #region CSV
                                    'CSV'
                                    {
                                        Return $($ResultSet | ConvertTo-Csv -NoTypeInformation)
                                    }
                                #endregion CSV

                                #region Yaml
                                    'Yaml'
                                    {
                                        Return $($ResultSet | ConvertTo-Yaml)
                                    }
                                #endregion Yaml

                                #region CustomModified
                                    'CustomModified'
                                    {
                                        Return $($ResultSet | Format-Custom | Out-String) -replace '}\s\s','},' `
                                        -replace '\sclass\s.*\s'
                                    }
                                #endregion CustomModified

                                #region Custom
                                    'Custom'
                                    {
                                        Return $($ResultSet | Format-Custom)
                                    }
                                #endregion Custom

                                #region JSON
                                    'JSON'
                                    {
                                        Return $($ResultSet | ConvertTo-Json -Depth 10)
                                    }
                                #endregion JSON

                                #region OutUnEscapedJSON
                                    'OutUnEscapedJSON'
                                    {
                                        Return $($ResultSet | ConvertTo-Json -Depth 10 | ForEach-Object `
                                            -Process `
                                            {
                                                [regex]::Unescape($_)
                                            }
                                        )
                                    }
                                #endregion OutUnEscapedJSON

                                #region Default
                                    Default
                                    {
                                        Return $ResultSet
                                    }
                                #endregion Default
                            }
                        #endregion Switch Statement RegEx
                    }
                #endregion Return a PowerShell Object

                #region Default
                    Default
                    {
                        Return $HashReturn
                    }
                #endregion Default
            }
        #endregion Output Type
    #endregion Output
}
#endregion Remove-BluGenieModule (Function)