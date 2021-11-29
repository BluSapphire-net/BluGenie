#region Install-BluGenieSysMon (Function)
Function Install-BluGenieSysMon
{
    <#
        .SYNOPSIS
            Install-BluGenieSysMon will Install, Update, or Uninstall SysMon

        .DESCRIPTION
            Install-BluGenieSysMon will Install, Update, or Uninstall the SysMon SysInternals tool

        .PARAMETER SourcePath
            Description: The Source location of the SysMon tools
            Notes: The default is set to BluGenie's Tools Directory $ToolsDirectory\SysMonService
            Alias:
            ValidateSet:

        .PARAMETER ConfigFile
            Description: Full file path for a SysMon Configuation XML
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER Uninstall
            Description: Stop and Remove the SysMon Service
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER ForceInstall
            Description: Overwrite the current installation and remove and reinstall the service.
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER DBName
            Description: Database Name (Without extention)
            Notes: The default name is set to 'BluGenie'
            Alias:
            ValidateSet:

        .PARAMETER DBPath
            Description: Path to either Save or Update the Database
            Notes: The default path is $('{0}\BluGenie' -f $env:ProgramFiles)  Example: C:\Program Files\BluGenie
            Alias:
            ValidateSet:

        .PARAMETER UpdateDB
            Description: Save return data to the Sqlite Database
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER ForceDBUpdate
            Description: Force an update of the return data to the Sqlite Database
            Notes: By default only new items are saved.  The primary key is ( FullName )
            Alias:
            ValidateSet:

        .PARAMETER NewDBTable
            Description: Delete and Recreate the Database Table
            Notes:
            Alias:
            ValidateSet:

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
            Command: Install-BluGenieSysMon
            Description: This will copy the SysMon Source to the remote systems destination and install the the SysMon service.
            Notes:

        .EXAMPLE
            Command: Install-BluGenieSysMon -Help
            Description: Call Help Information
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter

        .EXAMPLE
            Command: Install-BluGenieSysMon -WalkThrough
            Description: Call Help Information [2]
            Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter

        .EXAMPLE
            Command: Install-BluGenieSysMon -OutUnEscapedJSON
            Description: Return a detailed function report in an UnEscaped JSON format
            Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

        .EXAMPLE
            Command: Install-BluGenieSysMon -OutYaml
            Description: Return a detailed function report in YAML format
            Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

        .EXAMPLE
            Command: Install-BluGenieSysMon -ReturnObject
            Description: Return Output as a Object
            Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
                    This parameter is also used with the FormatView

        .EXAMPLE
            Command: Install-BluGenieSysMon -ReturnObject -FormatView Yaml
            Description: Output PSObject information in Yaml format
            Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
                    Default is set to (None) and normal PSObject.

        .OUTPUTS
            System.Collections.Hashtable

        .NOTES

            • [Original Author]
                o  Michael Arroyo
            • [Original Build Version]
                o  19.05.2201 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
            • [Latest Author]
                o Michael Arroyo
            • [Latest Build Version]
                o 21.05.1901
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
    o 21.02.1201• [Michael Arroyo] Function Template
    o 19.05.2201• [Michael Arroyo] Posted
    o 19.06.2501• [Michael Arroyo] Updated installation default settings.
                • [Michael Arroyo] Updated copy command to use Send-Item
                • [Michael Arroyo] Added Start, End, and Time Spane values to the returning JSON
                • [Michael Arroyo] Added parameter CopyOnly.  This will copy the files specified but not process an install
                • [Michael Arroyo] Added a PSSession Manager to clean up any bad or offline PS Sessions per host
                • [Michael Arroyo] Added a process to allow for low level errors to be sent to the main log.  By default only script fault errors
                    would be sent.
                • [Michael Arroyo] Updated the installation process to use Start-Process
                • [Michael Arroyo] Updated application from Sysmon.exe to SysMon64.exe.  (Microsoft updated their process and Sysmon.exe will no
                    longer process on x64 systems)
    o 19.07.0201• [Michael Arroyo] Added support for both X86 and X64 systems.
                • [Michael Arroyo] Added a Last Pass Uninstall Process to make sure there is no left over service information.
    o 19.07.0202• [Michael Arroyo] Removed the Session Management process.  This is now done by the sub function Send-Item (Only).
                • [Michael Arroyo] Updated the Source String to included all files.  This is no longer copying the directory.
    o 21.05.1901• [Michael Arroyo]
#>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Install-SysMon')]
    #region Parameters
        Param
        (
            [String]$SourcePath = $(Join-Path -Path $ToolsDirectory -ChildPath 'SysMon'),

            [String]$ConfigFile,

            [Switch]$Uninstall,

            [Switch]$ForceInstall,

            [Switch]$ClearGarbageCollecting,

            [String]$DBName = 'BluGenie',

            [String]$DBPath = $('{0}\BluGenie' -f $env:ProgramFiles),

            [Switch]$UpdateDB,

            [Switch]$ForceDBUpdate,

            [Switch]$NewDBTable,

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

    #region Create Hash
        $HashReturn = @{ }
        $HashReturn['SysMon'] = @{ }
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['SysMon'].StartTime = $($StartTime).DateTime
        $HashReturn['SysMon'].Is64BitOperatingSystem = 'False'
        $HashReturn['SysMon'].Source = ''
        $HashReturn['SysMon'].ToolCheck = 'False'
        $HashReturn['SysMon'].ProcessType = 'Install'
        $HashReturn['SysMon'].ProcessStatus = 'False'
        $HashReturn['SysMon'].PreviouslyInstalled = 'False'
        $HashReturn['SysMon'].ParameterSetResults = ''
        $HashReturn['SysMon'].CommandLine = ''
        $HashReturn['SysMon'].ConfigurationSchema = ''
        $HashReturn['SysMon']['Comment'] = @()
    #endregion Create Hash

    #region Parameter Set Results
        $HashReturn['SysMon'].ParameterSetResults = $PSBoundParameters
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

            { $ForceDBUpdate }
            {
                $UpdateDB = $true
            }

            { $NewDBTable }
            {
                $UpdateDB = $true
            }

            { $IsPosh2 }
            {
                $UpdateDB = $false
            }
        }
    #endregion Dynamic parameter update

    #region Build Data Table Hash Table
        If
        (
            $UpdateDB
        )
        {
            #region Create Hash Table
                $HSqlite = @{}
            #endregion Create Hash Table

            #region Set Database Full Path
                $HSqlite.DBPath = $DBPath
                $HSqlite.DBName = $DBName
                $HSqlite.Database = Join-Path -Path $($HSqlite.DBPath) -ChildPath $('{0}.SQLite' -f $($HSqlite.DBName))
            #endregion Set Database Full Path

            #region Table Name
                $HSqlite.TableName = 'Verb-NounSample'
            #endregion Table Name

            #region Set Column Information
                #***Sample Column Names (Please Change)***
                $HSqlite.TableColumns = 'FullName TEXT PRIMARY KEY,
                Name TEXT,
                Hash TEXT,
                ShortName TEXT,
                ShortPath TEXT,
                Path TEXT,
                Owner TEXT,
                SizeInBytes INTEGER'
            #endregion Set Column Information

            #region Set Create Table SQL String
                $HSqlite.CreateTableStr = $('CREATE TABLE IF NOT EXISTS {0} ({1})' -f $HSqlite.TableName, $HSqlite.TableColumns)
            #endregion Set Create Table SQL String

            #region Drop Table SQL String
                $HSqlite.DropTableStr = $('DROP TABLE IF EXISTS {0}' -f $HSqlite.TableName)
            #endregion Drop Table SQL String

            #region Set Check Table SQL String
                $HSqlite.CheckTables = $('PRAGMA table_info({0})' -f $HSqlite.TableName)
            #endregion Set Check Table SQL String

            #region Create DB Table
                If
                (
                    -Not $(Test-Path -Path $DBPath)
                )
                {
                    $null = New-Item -Path  $DBPath -ItemType Directory -Force
                }

                #region New DB Table
                    If
                    (
                        $NewDBTable
                    )
                    {
                        Invoke-SqliteQuery -DataSource $HSqlite.Database -Query $HSqlite.DropTableStr
                    }
                #endregion New DB Table

                Invoke-SqliteQuery -DataSource $HSqlite.Database -Query $HSqlite.CreateTableStr
            #endregion Create DB Table
        }
    #endregion Build Data Table Hash Table

    #region Main
        #region Process Check
            Switch
            (
                [System.Environment]::Is64BitOperatingSystem
            )
            {
                $false
                {
                    $SysMon = 'Sysmon'
                }
                default
                {
                    $SysMon = 'Sysmon64'
                    $HashReturn['SysMon'].Is64BitOperatingSystem = 'True'
                }
            }

            If
            (
                Test-Path -Path $('{0}\{1}.exe' -f $SourcePath,$SysMon)
            )
            {
                $HashReturn['SysMon'].ToolCheck = 'True'
                $HashReturn['SysMon'].Source = Resolve-Path -Path $('{0}\{1}.exe' -f $SourcePath,$SysMon) -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path
            }
        #endregion Process Check

        #region Install SysMon
            If
            (
                -Not $Uninstall -and $($HashReturn['SysMon'].ToolCheck -eq 'True')
            )
            {
                #region SysMon Install Check
                    If
                    (
                        $(Get-Service -Name $($SysMon) -ErrorAction SilentlyContinue)
                    )
                    {
                        $HashReturn['SysMon'].PreviouslyInstalled = 'True'
                    }
                #endregion SysMon Install Check

                #region SysMon Install
                    If
                    (
                        $($HashReturn['SysMon'].PreviouslyInstalled) -eq 'True'
                    )
                    {
                        If
                        (
                            $ForceInstall
                        )
                        {
                            #region Check for Service
                                If
                                (
                                    $(Get-Service | Where-Object -FilterScript { $_.Name -eq $($SysMon) })
                                )
                                {
                                    $Error.Clear()
                                    Try
                                    {
                                        $Null = Stop-Process -Name $($SysMon) -Force -ErrorAction Stop
                                        Start-Sleep -Seconds 5
                                        $HashReturn['SysMon'].CommandLine = $('"{0}" {1}' -f $($HashReturn['SysMon'].Source), '-accepteula -u force')
                                        $null = Start-Process -FilePath $($HashReturn['SysMon'].Source) -ArgumentList '-accepteula -u force' -Wait -NoNewWindow -ErrorAction Stop
                                    }
                                    Catch
                                    {
                                        If
                                        (
                                            $Error
                                        )
                                        {
                                            $Error | ForEach-Object `
                                            -Process `
                                            {
                                                $CurError = $_
                                                $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                                                $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                                                Name = 'Exception'
                                                                                                                                Expression = {$CurErrorMsg}
                                                                                                                            },
                                                                                                                            FullyQualifiedErrorId,
                                                                                                                            ScriptStackTrace)
                                            }
                                        }
                                    }
                                }
                            #endregion Check for Service

                            #region Process Install with Arguments
                                If
                                (
                                    $ConfigFile
                                )
                                {
                                    Try
                                    {
                                        $Error.Clear()
                                        $HashReturn['SysMon'].CommandLine = $('"{0}" {1}' -f $($HashReturn['SysMon'].Source), $('-accepteula -i "{0}"' -f $ConfigFile))
                                        $null = Start-Process -FilePath $($HashReturn['SysMon'].Source) -ArgumentList $('-accepteula -i "{0}"' -f $ConfigFile) -Wait -NoNewWindow -ErrorAction Stop
                                    }
                                    Catch
                                    {
                                        If
                                        (
                                            $Error
                                        )
                                        {
                                            $Error | ForEach-Object `
                                            -Process `
                                            {
                                                $CurError = $_
                                                $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                                                $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                                                Name = 'Exception'
                                                                                                                                Expression = {$CurErrorMsg}
                                                                                                                            },
                                                                                                                            FullyQualifiedErrorId,
                                                                                                                            ScriptStackTrace)
                                            }
                                        }
                                    }
                                }
                                Else
                                {
                                    Try
                                    {
                                        $HashReturn['SysMon'].CommandLine = $('"{0}" {1}' -f $($HashReturn['SysMon'].Source), '-accepteula -i')
                                        $null = Start-Process -FilePath $($HashReturn['SysMon'].Source) -ArgumentList '-accepteula -i' -Wait -NoNewWindow -ErrorAction Stop
                                    }
                                    Catch
                                    {
                                        If
                                        (
                                            $Error
                                        )
                                        {
                                            $Error | ForEach-Object `
                                            -Process `
                                            {
                                                $CurError = $_
                                                $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                                                $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                                                Name = 'Exception'
                                                                                                                                Expression = {$CurErrorMsg}
                                                                                                                            },
                                                                                                                            FullyQualifiedErrorId,
                                                                                                                            ScriptStackTrace)
                                            }
                                        }
                                    }
                                }
                            #endregion Process Install with Arguments

                            Start-Sleep -Seconds 5

                            If
                            (
                                -Not $(Get-Service | Where-Object -FilterScript { $_.Name -eq $($SysMon) } | Select-Object -ExpandProperty Status) -eq 'Running'
                            )
                            {
                                If
                                (
                                    $ConfigFile
                                )
                                {
                                    Try
                                    {
                                        $Error.Clear()
                                        $HashReturn['SysMon'].CommandLine = $('"{0}" {1}' -f $($HashReturn['SysMon'].Source), $('-accepteula -i "{0}"' -f $ConfigFile))
                                        $null = Start-Process -FilePath $($HashReturn['SysMon'].Source) -ArgumentList $('-accepteula -i "{0}"' -f $ConfigFile) -Wait -NoNewWindow -ErrorAction Stop
                                    }
                                    Catch
                                    {
                                        If
                                        (
                                            $Error
                                        )
                                        {
                                            $Error | ForEach-Object `
                                            -Process `
                                            {
                                                $CurError = $_
                                                $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                                                $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                                                Name = 'Exception'
                                                                                                                                Expression = {$CurErrorMsg}
                                                                                                                            },
                                                                                                                            FullyQualifiedErrorId,
                                                                                                                            ScriptStackTrace)
                                            }
                                        }
                                    }
                                }
                                Else
                                {
                                    Try
                                    {
                                        $HashReturn['SysMon'].CommandLine = $('"{0}" {1}' -f $($HashReturn['SysMon'].Source), '-accepteula -i')
                                        $null = Start-Process -FilePath $($HashReturn['SysMon'].Source) -ArgumentList '-accepteula -i' -Wait -NoNewWindow -ErrorAction Stop
                                    }
                                    Catch
                                    {
                                        If
                                        (
                                            $Error
                                        )
                                        {
                                            $Error | ForEach-Object `
                                            -Process `
                                            {
                                                $CurError = $_
                                                $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                                                $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                                                Name = 'Exception'
                                                                                                                                Expression = {$CurErrorMsg}
                                                                                                                            },
                                                                                                                            FullyQualifiedErrorId,
                                                                                                                            ScriptStackTrace)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Else
                        {
                            If
                            (
                                $ConfigFile
                            )
                            {
                                Try
                                {
                                    $Error.Clear()
                                    $HashReturn['SysMon'].CommandLine = $('"{0}" {1}' -f $($HashReturn['SysMon'].Source), $('-accepteula -i "{0}"' -f $ConfigFile))
                                    $null = Start-Process -FilePath $($HashReturn['SysMon'].Source) -ArgumentList $('-accepteula -i "{0}"' -f $ConfigFile) -Wait -NoNewWindow -ErrorAction Stop
                                }
                                Catch
                                {
                                    If
                                    (
                                        $Error
                                    )
                                    {
                                        $Error | ForEach-Object `
                                        -Process `
                                        {
                                            $CurError = $_
                                            $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                                            $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                                            Name = 'Exception'
                                                                                                                            Expression = {$CurErrorMsg}
                                                                                                                            },
                                                                                                                            FullyQualifiedErrorId,
                                                                                                                            ScriptStackTrace)
                                        }
                                    }
                                }
                            }
                            Else
                            {
                                Try
                                {
                                    $HashReturn['SysMon'].CommandLine = $('"{0}" {1}' -f $($HashReturn['SysMon'].Source), '-accepteula -i')
                                    $null = Start-Process -FilePath $($HashReturn['SysMon'].Source) -ArgumentList '-accepteula -i' -Wait -NoNewWindow -ErrorAction Stop
                                }
                                Catch
                                {
                                    If
                                    (
                                        $Error
                                    )
                                    {
                                        $Error | ForEach-Object `
                                        -Process `
                                        {
                                            $CurError = $_
                                            $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                                            $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                                            Name = 'Exception'
                                                                                                                            Expression = {$CurErrorMsg}
                                                                                                                            },
                                                                                                                            FullyQualifiedErrorId,
                                                                                                                            ScriptStackTrace)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Else
                    {
                        If
                        (
                            $ConfigFile
                        )
                        {
                            Try
                            {
                                $Error.Clear()
                                $HashReturn['SysMon'].CommandLine = $('"{0}" {1}' -f $($HashReturn['SysMon'].Source), $('-accepteula -i "{0}"' -f $ConfigFile))
                                $null = Start-Process -FilePath $($HashReturn['SysMon'].Source) -ArgumentList $('-accepteula -i "{0}"' -f $ConfigFile) -Wait -NoNewWindow -ErrorAction Stop
                            }
                            Catch
                            {
                                If
                                (
                                    $Error
                                )
                                {
                                    $Error | ForEach-Object `
                                    -Process `
                                    {
                                        $CurError = $_
                                        $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                                        $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                                        Name = 'Exception'
                                                                                                                        Expression = {$CurErrorMsg}
                                                                                                                        },
                                                                                                                        FullyQualifiedErrorId,
                                                                                                                        ScriptStackTrace)
                                    }
                                }
                            }
                        }
                        Else
                        {
                            Try
                            {
                                $HashReturn['SysMon'].CommandLine = $('"{0}" {1}' -f $($HashReturn['SysMon'].Source), '-accepteula -i')
                                $null = Start-Process -FilePath $($HashReturn['SysMon'].Source) -ArgumentList '-accepteula -i' -Wait -NoNewWindow -ErrorAction Stop
                            }
                            Catch
                            {
                                If
                                (
                                    $Error
                                )
                                {
                                    $Error | ForEach-Object `
                                    -Process `
                                    {
                                        $CurError = $_
                                        $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                                        $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                                        Name = 'Exception'
                                                                                                                        Expression = {$CurErrorMsg}
                                                                                                                        },
                                                                                                                        FullyQualifiedErrorId,
                                                                                                                        ScriptStackTrace)
                                    }
                                }
                            }
                        }
                    }
                #endregion SysMon Install

                #region SysMon Install ReCheck
                    Start-Sleep -Seconds 5
                    If
                    (
                        $(Get-Service | Where-Object -FilterScript { $_.Name -eq $($SysMon) })
                    )
                    {
                        $null = Start-Service -Name $($SysMon) -ErrorAction SilentlyContinue
                        Start-Sleep -Seconds 2
                        $HashReturn['SysMon'].ProcessStatus = $($(Get-Service | Where-Object -FilterScript { $_.Name -eq $($SysMon) } -ErrorAction SilentlyContinue) | Select-Object -ExpandProperty Status | Out-String).Trim()
                        If
                        (
                            $($VerbosePreference -eq 'Continue')
                        )
                        {
                            $CurErrorActionPreference = $ErrorActionPreference
                            $ErrorActionPreference = 'SilentlyContinue'
                            $HashReturn['SysMon'].ConfigurationSchema = & "$($HashReturn['SysMon'].Source)" "`-s"
                            If
                            (
                                $Error
                            )
                            {
                                $Error.RemoveAt('0')
                            }
                            $ErrorActionPreference = $CurErrorActionPreference
                        }
                    }
                #endregion SysMon Install ReCheck

                #region SysMon Error Check
                    If
                    (
                        $Error
                    )
                    {
                        $Error | ForEach-Object `
                        -Process `
                        {
                            $CurError = $_
                            $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                            $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                            Name = 'Exception'
                                                                                                            Expression = {$CurErrorMsg}
                                                                                                            },
                                                                                                            FullyQualifiedErrorId,
                                                                                                            ScriptStackTrace)
                        }
                    }
                #endregion SysMon Error Check
            }
        #endregion Install SysMon

        #region UnInstall SysMon
            If
            (
                $Uninstall -and $($HashReturn['SysMon'].ToolCheck -eq 'True')
            )
            {
                #region Uninstall HashTable Header
                    $HashReturn['SysMon'].ProcessType = 'UnInstall'
                #endregion Uninstall HashTable Header

                #region SysMon Uninstall Check
                    If
                    (
                        $(Get-Service | Where-Object -FilterScript { $_.Name -eq $($SysMon) })
                    )
                    {
                        $HashReturn['SysMon'].PreviouslyInstalled = 'True'
                    }
                #endregion SysMon Uninstall Check

                #region SysMon Uninstall
                    If
                    (
                        $($HashReturn['SysMon'].PreviouslyInstalled -eq 'True')
                    )
                    {
                        $Error.Clear()
                        Try
                        {
                            $Null = Stop-Process -Name $($SysMon) -Force -ErrorAction Stop
                            Start-Sleep -Seconds 5
                            $HashReturn['SysMon'].CommandLine = $('"{0}" {1}' -f $($HashReturn['SysMon'].Source), '-accepteula -u force')
                            $null = Start-Process -FilePath $($HashReturn['SysMon'].Source) -ArgumentList '-accepteula -u force' -Wait -NoNewWindow -ErrorAction Stop
                        }
                        Catch
                        {
                            If
                            (
                                $Error
                            )
                            {
                                $Error | ForEach-Object `
                                -Process `
                                {
                                    $CurError = $_
                                    $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                                    $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                                    Name = 'Exception'
                                                                                                                    Expression = {$CurErrorMsg}
                                                                                                                    },
                                                                                                                    FullyQualifiedErrorId,
                                                                                                                    ScriptStackTrace)
                                }
                            }
                        }
                    }
                #endregion SysMon Uninstall

                #region SysMon Uninstall Last Pass
                    Try
                    {
                        $Error.Clear()
                        $SysMonService = Get-WmiObject -Class Win32_Service -Filter $("Name='{0}'" -f $SysMon) -ErrorAction SilentlyContinue

                        If
                        (
                            $SysMonService
                        )
                        {
                            $null = $SysMonService.delete()
                        }
                    }
                    Catch
                    {
                        If
                        (
                            $Error
                        )
                        {
                            $Error | ForEach-Object `
                            -Process `
                            {
                                $CurError = $_
                                $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                                $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                                Name = 'Exception'
                                                                                                                Expression = {$CurErrorMsg}
                                                                                                                },
                                                                                                                FullyQualifiedErrorId,
                                                                                                                ScriptStackTrace)
                            }
                        }
                    }
                #endregion SysMon Uninstall Last Pass

                #region SysMon Error Check
                    If
                    (
                        $Error
                    )
                    {
                        $Error | ForEach-Object `
                        -Process `
                        {
                            $CurError = $_
                            $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                            $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                            Name = 'Exception'
                                                                                                            Expression = {$CurErrorMsg}
                                                                                                            },
                                                                                                            FullyQualifiedErrorId,
                                                                                                            ScriptStackTrace)
                        }
                    }
                #endregion SysMon Error Check

                #region SysMon Uninstall ReCheck
                    If
                    (
                        -Not $(Get-Service | Where-Object -FilterScript { $_.Name -eq $($SysMon) })
                    )
                    {
                        $HashReturn['SysMon'].ProcessStatus = 'NotInstalled'
                    }
                    Else
                    {
                        #region SysMon Uninstall
                            If
                            (
                                $($HashReturn['SysMon'].PreviouslyInstalled -eq 'True')
                            )
                            {
                                $Error.Clear()
                                Try
                                {
                                    $Null = Stop-Process -Name $($SysMon) -Force -ErrorAction Stop
                                    Start-Sleep -Seconds 5
                                    $HashReturn['SysMon'].CommandLine = $('"{0}" {1}' -f $($HashReturn['SysMon'].Source), '-accepteula -u force')
                                    $null = Start-Process -FilePath $($HashReturn['SysMon'].Source) -ArgumentList '-accepteula -u force' -Wait -NoNewWindow -ErrorAction Stop
                                }
                                Catch
                                {
                                    If
                                    (
                                        $Error
                                    )
                                    {
                                        $Error | ForEach-Object `
                                        -Process `
                                        {
                                            $CurError = $_
                                            $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                                            $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                                            Name = 'Exception'
                                                                                                                            Expression = {$CurErrorMsg}
                                                                                                                            },
                                                                                                                            FullyQualifiedErrorId,
                                                                                                                            ScriptStackTrace)
                                        }
                                    }
                                }
                            }
                        #endregion SysMon Uninstall

                        #region SysMon Uninstall Last Pass
                            Try
                            {
                                $Error.Clear()
                                $SysMonService = Get-WmiObject -Class Win32_Service -Filter $("Name='{0}'" -f $SysMon) -ErrorAction SilentlyContinue

                                If
                                (
                                    $SysMonService
                                )
                                {
                                    $null = $SysMonService.delete()
                                }
                            }
                            Catch
                            {
                                If
                                (
                                    $Error
                                )
                                {
                                    $Error | ForEach-Object `
                                    -Process `
                                    {
                                        $CurError = $_
                                        $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                                        $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                                        Name = 'Exception'
                                                                                                                        Expression = {$CurErrorMsg}
                                                                                                                        },
                                                                                                                        FullyQualifiedErrorId,
                                                                                                                        ScriptStackTrace)
                                    }
                                }
                            }
                        #endregion SysMon Uninstall Last Pass

                        #region SysMon Error Check
                            If
                            (
                                $Error
                            )
                            {
                                $Error | ForEach-Object `
                                -Process `
                                {
                                    $CurError = $_
                                    $CurErrorMsg = $CurError | Select-Object -ExpandProperty Exception | Select-Object -ExpandProperty Message
                                    $HashReturn['SysMon']['Comment'] += $($CurError | Select-Object -Property @{
                                                                                                                    Name = 'Exception'
                                                                                                                    Expression = {$CurErrorMsg}
                                                                                                                    },
                                                                                                                    FullyQualifiedErrorId,
                                                                                                                    ScriptStackTrace)
                                }
                            }
                        #endregion SysMon Error Check
                    }
                #endregion SysMon Uninstall ReCheck
            }
        #endregion UnInstall SysMon
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['SysMon'].EndTime = $($EndTime).DateTime
        $HashReturn['SysMon'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            -Not $($VerbosePreference -eq 'Continue')
        )
        {
            #Add Hash Properties that are not needed without Verbose enabled.
            $null = $HashReturn['SysMon'].Remove('StartTime')
            $null = $HashReturn['SysMon'].Remove('ParameterSetResults')
            $null = $HashReturn['SysMon'].Remove('EndTime')
            $null = $HashReturn['SysMon'].Remove('ElapsedTime')
            $null = $HashReturn['SysMon'].Remove('Is64BitOperatingSystem')
            $null = $HashReturn['SysMon'].Remove('Source')
            $null = $HashReturn['SysMon'].Remove('ToolCheck')
            $null = $HashReturn['SysMon'].Remove('CommandLine')
            $null = $HashReturn['SysMon'].Remove('ConfigurationSchema')
        }

        If
        (
            $ClearGarbageCollecting
        )
        {
            $null = Clear-BlugenieMemory
        }

        #region Output Type
            $ResultSet = '' | Select-Object -Property @{
                    Name = 'ProcessType'
                    Expression = {$($HashReturn.SysMon.ProcessType)}
                },
                @{
                    Name = 'ProcessStatus'
                    Expression = {$($HashReturn.SysMon.ProcessStatus)}
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
#endregion Install-BluGenieSysMon (Function)