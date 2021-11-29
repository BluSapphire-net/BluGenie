#Requires -Version 3
#region Get-BluGenieServiceStatus (Function)
Function Get-BluGenieServiceStatus
{
<#
    .SYNOPSIS
        Report on the Status of the BluGenie Windows Service

    .DESCRIPTION
        Report on the Status of the BluGenie Windows Service
		
		Report includes 
			* Jobs that are currently waiting to run
			* Processing Jobs
			* Completed Jobs
			* Completed JSON reports
			* Service State
			* Service CPU Resources
			* Service Memory Resources
			* BluGenie Service Event Viewer Logs

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
        Command: Get-BluGenieServiceStatus
        Description: Report on the Status of the BluGenie Windows Service
        Notes:

    .EXAMPLE
        Command: Get-BGServiceStatus
        Description: Use the Alias to report on the Status of the BluGenie Windows Service
        Notes:

    .EXAMPLE
        Command: Get-BluGenieServiceStatus -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieServiceStatus -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BGServiceStatus -OutUnEscapedJSON
        Description: Return a detailed function report in an UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BGServiceStatus -OutYaml
        Description: Return a detailed function report in YAML format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BGServiceStatus -ReturnObject
        Description: Return Output as a Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
                This parameter is also used with the ForMat

    .EXAMPLE
        Command: Get-BluGenieServiceStatus -ReturnObject -FormatView Yaml
        Description: Output PSObject information in Yaml format
        Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
                Default is set to (None) and normal PSObject.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • [Original Author]
            o  Michael Arroyo
        • [Original Build Version]
            o  20.01.2101 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o
        • [Latest Build Version]
            o
        • [Comments]
            o
        • [PowerShell Compatibility]
            o  3,4,5.x
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
    o 21.01.1701: * [Michael Arroyo] Function Template
    o 21.01.2101: * [Michael Arroyo] Posted
#>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Get-BGServiceStatus')]
    #region Parameters
        Param
        (
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
        $HashReturn['GetBGServiceStatus'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetBGServiceStatus'].StartTime = $($StartTime).DateTime
        $HashReturn['GetBGServiceStatus'].ParameterSetResults = @()
        $HashReturn['GetBGServiceStatus']['Service'] = @()
        $HashReturn['GetBGServiceStatus']['Processing'] = @()
        $HashReturn['GetBGServiceStatus']['LoadedJobs'] = @()
        $HashReturn['GetBGServiceStatus']['CompletedJobs'] = @()
        $HashReturn['GetBGServiceStatus']['Events'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['GetBGServiceStatus'].ParameterSetResults += $PSBoundParameters
    #endregion Parameter Set Results

    #region Dynamic parameter update
        If
        (
            $PSVersionTable.PSVersion.Major -eq 2
        )
        {
            $IsPosh2 = $true
            Return
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
        }
    #endregion Dynamic parameter update

    #region Main
        If
        (
            Get-Module | Where-Object -Property Name -eq $($CurServiceObj.Service)
        )
        {
            $BGModulePath = Split-Path -Path $(Get-Module | Where-Object -Property Name -eq $($CurServiceObj.Service) | `
                Select-Object -ExpandProperty Path)
            $BGServicePath = $('{0}\BGService' -f $(Split-Path -Path $BGModulePath -Parent))
        }
        Else
        {
            $BGServicePath = Split-Path -Path $(Get-Process -Id $PID | Select-Object -ExpandProperty Path)
        }

        $BGSJobPath = $('{0}\Jobs' -f $BGServicePath)
        $BGSProcessPath = $('{0}\Processing' -f $BGServicePath)
        $BGSReportPath = $('{0}\Logs' -f $BGServicePath)
        $CurServiceObj = [PSCustomObject]@{
            Service      = 'BluGenie'
            State        = 'Not Found'
            ProcessID    = $PID
            AllocatedCPU = @()
            AllocatedMem = 0
        }

        #region Service Info
            if
            (
                Get-Service | Where-Object -Property Name -eq  $($CurServiceObj.Service)
            )
            {
                $CurServiceObj.State = $(Get-Service -Name $($CurServiceObj.Service) | Select-Object -ExpandProperty 'Status' | `
                    Out-String).Trim()
                $ProcessName = (Get-Process -Id $PID).Name
                $CpuCores = (Get-CimInstance -ClassName Win32_ComputerSystem).NumberOfLogicalProcessors
                $SampleCounter = (Get-Counter "\Process($Processname*)\% Processor Time").CounterSamples
                $CurServiceObj.AllocatedCPU = $SampleCounter | `
                    Select-Object -Property InstanceName, @{Name="CPU %";Expression={[Decimal]::Round(($_.CookedValue / $CpuCores), 2)}}
                $CurServiceObj.AllocatedMem = $(Get-Process -id $PID | Select-Object -ExpandProperty WorkingSet64) / 1kb
            }

            $HashReturn['GetBGServiceStatus']['Service'] += $CurServiceObj
        #endregion Service Info

        #region Job Status
            If
            (
                Test-Path -Path $BGSJobPath
            )
            {
                $CurBGSJobs = Get-ChildItem -Path $BGSJobPath -Filter *.json | Select-Object -ExpandProperty FullName

                If
                (
                    $CurBGSJobs
                )
                {
                    $HashReturn['GetBGServiceStatus']['LoadedJobs'] += $CurBGSJobs
                }
            }
        #endregion Job Status

        #region Processing Job Status
            If
            (
                Test-Path -Path $BGSProcessPath
            )
            {
                $CurBGSProcessingJobs = Get-ChildItem -Path $BGSProcessPath -Filter *.json | `
                    Select-Object -ExpandProperty FullName

                If
                (
                    $CurBGSProcessingJobs
                )
                {
                    $HashReturn['GetBGServiceStatus']['Processing'] += $CurBGSProcessingJobs
                }
            }
        #endregion Processing Job Status

        #region Completed Job Status
            If
            (
                Test-Path -Path $BGSReportPath
            )
            {
                $ArrCurBGSCompletedJobs = @()
                $CurBGSCompletedJobs = Get-ChildItem -Path $BGSReportPath -Directory | Select-Object -Property FullName,BaseName

                If
                (
                    $CurBGSCompletedJobs
                )
                {
                    $CurBGSCompletedJobs | ForEach-Object `
                        -Process `
                        {
                            $CurReportObj = [PSCustomObject]@{
                                    JobID      = $_.BaseName
                                    JobPath    = $_.FullName
                                    JobLogs    = @(Get-ChildItem -Path $_.FullName -Filter *.log | Select-Object -ExpandProperty Name)
                                    JobReports = @(Get-ChildItem -Path $_.FullName -Filter *.json | Select-Object -ExpandProperty Name)
                                }

                            $ArrCurBGSCompletedJobs += $CurReportObj
                        }
                }

                If
                (
                    $ArrCurBGSCompletedJobs
                )
                {
                    $HashReturn['GetBGServiceStatus']['CompletedJobs'] += $ArrCurBGSCompletedJobs
                }
            }
        #endregion Completed Job Status

        #region Windows Event Log Status
            $HashReturn['GetBGServiceStatus']['Events'] += Get-EventLog -LogName Application -Source 'BGService' | `
                Select-Object -Property Source,
                                        Message,
                                        @{
                                            Name = 'TimeGenerated'
                                            Expression = {$($_.TimeGenerated | Out-String).Trim()}
                                        }
        #endregion Windows Event Log Status

    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetBGServiceStatus'].EndTime = $($EndTime).DateTime
        $HashReturn['GetBGServiceStatus'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            -Not $($VerbosePreference -eq 'Continue')
        )
        {
            #Add Hash Properties that are not needed without Verbose enabled.
            $null = $HashReturn['GetBGServiceStatus'].Remove('StartTime')
            $null = $HashReturn['GetBGServiceStatus'].Remove('ParameterSetResults')
            $null = $HashReturn['GetBGServiceStatus'].Remove('EndTime')
            $null = $HashReturn['GetBGServiceStatus'].Remove('ElapsedTime')
        }

        #region Output Type
            $ResultSet = $CurServiceObj

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
                                        $ResultSet = Get-Content -Path $CachePath
                                        If
                                        (
                                            $RemoveCache
                                        )
                                        {
                                            $Null = Remove-Item -Path $CachePath -Force -ErrorAction SilentlyContinue
                                        }

                                        Return $($ResultSet)
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
#endregion Get-BluGenieServiceStatus (Function)