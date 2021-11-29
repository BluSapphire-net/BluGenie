#Requires -Version 3
#region Send-BluGenieItem (Function)
    Function Send-BluGenieItem
    {
        <#
            .SYNOPSIS
                Send-BluGenieItem will copy files and folders to a new location.

            .DESCRIPTION
                Send-BluGenieItem will copy files and folders to a new location.  Copying items can be over SMB and WinRM.  You can also copy items from a remote machine.

            .PARAMETER Source
                Description: The Source path to the items to want to send
                Notes:  This can be one or more files.  If your using ToSession or FromSession a sinle connection will be set to run all copies
                Alias:
                ValidateSet:

            .PARAMETER Destination
                Description: The Destination path
                Notes:
                Alias:
                ValidateSet:

            .PARAMETER Container
                Description: Sets the Copy to a directory instead of a file
                Notes:
                Alias:
                ValidateSet:

            .PARAMETER Force
                Description: Forces the file or directory creation or overwrite
                Notes:
                Alias:
                ValidateSet:

            .PARAMETER Filter
                Description: Filter what files you would like to Send to the destination
                Notes:
                Alias:
                ValidateSet:

            .PARAMETER Include
                Description: Include what files you would like to Send to the destination
                Notes:
                Alias:
                ValidateSet:

            .PARAMETER Exclude
                Description: Exclude what files you don't want to Send to the destination
                Notes:
                Alias:
                ValidateSet:

            .PARAMETER FromSession
                Description: Copy from a remote session over WinRM
                Notes:
                Alias:
                ValidateSet:

            .PARAMETER ToSession
                Description: Copy to a remote session over WinRM
                Notes:
                Alias:
                ValidateSet:

            .PARAMETER RelativePath
                Description: RelativePath is a string path that will be placed by the Destination path while keeping the entire directory tree
                Notes:
                Alias:
                ValidateSet:

            .PARAMETER Recurse
                Description: Recurse through subdirectories
                Notes:
                Alias:
                ValidateSet:

            .PARAMETER ComputerName
                Description: Remote computer name
                Notes:
                Alias:
                ValidateSet:

            .PARAMETER ShowProgress
                Description: Show Progress Bar when copying data
                Notes: Disabled by default
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
                Send-BluGenieItem

                This will output a Parameter Check validation error.
                If the
                    * Source
                    * Destination
                    * ComputerName (if -ToSession is used)
                    * ComputerName (if -FromSession is used)
                values are empty the command will Return an error

            .EXAMPLE
                Send-BluGenieItem -Source C:\Source\git.exe -Destination '\\computer1\c$\Source' -Force

                This will copy a file from the local machine to the destination computers UNC Share over SMB and force the file copy if the file already exists.

            .EXAMPLE
                Send-BluGenieItem -Source C:\Source\*.* -Destination C:\Source -Force -ToSession -ComputerName computer1

                This will copy file(s) from the local machine to the destination computer over WinRM and force the file copy if the file already exists.

            .EXAMPLE
                Send-BluGenieItem -Source C:\Source\*.* -Destination C:\Source -ToSession -ComputerName computer1 -Recurse

                This will copy file(s) and sub-directories from the local machine to the destination computer over WinRM

            .EXAMPLE
                Send-BluGenieItem -Source C:\Source\*.* -Destination C:\Source -ToSession -ComputerName computer1 -Recurse -Exclude *.log

                This will copy file(s) and sub-directories from the local machine to the destination computer over WinRM excluding all *.log files.

            .EXAMPLE
                Send-BluGenieItem -Source C:\Source\ErrorDetails.log -Destination C:\Source\computer1 -FromSession -ComputerName computer1 -Force

                This will copy ErrorDetails.log from the local remote machine to the local computer over WinRM.
                If the destination path doesn't exist the directory will be created on the fly.

            .EXAMPLE
                Send-BluGenieItem -Source C:\Source\*.* -Destination C:\Source -Force -ToSession -ComputerName computer1  -ReturnObject

                This will copy file(s) from the local machine to the destination computer over WinRM and force the file copy if the file already exists
                and return just the Object content

                Note:  The default output is a HashTable

            .EXAMPLE
                Send-BluGenieItem -Source C:\Source\*.* -Destination C:\Source -Force -ToSession -ComputerName computer1 -OutUnEscapedJSON

                This will copy file(s) from the local machine to the destination computer over WinRM and force the file copy if the file already exists
                and the return data will be in a beautified json format

            .OUTPUTS
                System.Collections.Hashtable

            .NOTES

                * Original Author           : Michael Arroyo
                * Original Build Version    : 1904.2801
                * Latest Author             : Michael Arroyo
                * Latest Build Version      : 21.03.2201
                * Comments                  :
                * Dependencies              :
                    ~
        #>

        #region Build Notes
            <#
            ~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
                o 1904.2801:• [Michael Arroyo] Posted
                o 1905.3001:• [Michael Arroyo] Updated all the Dynamic help sub functions to version 1905.2401
                o 1906.2601:• [Michael Arroyo] Updated the default powershell copy command.  If the directory doesn't exist the data would be
                                copied to the newly created directory, however if the directory does exist the origianl directory will get copied
                                to the new directory as a nested directory.  Now all copied directories will get processed as nested directories.
                            • [Michael Arroyo] Added Start, End, and Time Spane values to the returning JSON
                            • [Michael Arroyo] Updated the error controls.
                o 1907.0201:• [Michael Arroyo] Updated the path check to pull the Container name from the Destination Path
                o 1907.0202:• [Michael Arroyo] Added a PSSession Manager process to stop Other sessions from being removed or updated
                            • [Michael Arroyo] Updated the Copy Session sub functions to manage directory creation at prior to item copy
                o 1907.0205:• [Michael Arroyo] Updated the Session name to escape any (-)'s in the computer name.
                o 1907.0801:• [Michael Arroyo] Removed the (-) from the Computer Name prior to building the Session Name variable.
                                PowerShell doesn't like (-)'s in variable names.
                o 1908.0901:• [Michael Arroyo] Removed the (.) from the Computer Name prior to building the Session Name variable.
                                PowerShell doesn't like (.)'s in variable names.
                                Note:  This became an issue once we started supporting FQDN's.
                o 20.05.2101• [Michael Arroyo] Updated function requirement to Posh 3
                o 20.05.2101• [Michael Arroyo] Bug Fix - When copying a file even if the file is there but the force switch is not set, the file
                                will be updated.  The change is if you set the Destination as the full path including the file name a pre-check
                                will validate if the file already exists.  This bug was only when running Copy-Item over WinRM.
                            • [Michael Arroyo] Added a new parameter ( ShowProgress ).  This is to manage the Progress Bar Display.  In powershell
                                by defauult this is always enabled. Now you can choose to show the progress bar or by default for this function
                                the progress bar will be disabled.
                o 21.03.2201• [Michael Arroyo] Updated the WalkThrought Function to the latest version
                            • [Michael Arroyo] Modified the Build Notes to the new standard
                            • [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
                            • [Michael Arroyo] Updated the WalkThrough Function to the latest version
                            • [Michael Arroyo] Updated parameter Source to allow multiple sources to be copied to a single system at once without
                                using a Directory or Container as the parent copy item
                            • [Michael Arroyo] Added a new parameter called RelativePath.  This string will help remove the current source path
                                and replace it with the new Destination path while keeping the entire directory tree intact.
                            • [Michael Arroyo] Updated all the parameters to no longer have a position parameter path.  This is no longer needed.
                                Meaning the Parameters had to be in a specific order if no named parameter was set.
                            • [Michael Arroyo] Added Clean Garbage to the overall process to help clean up memory after the function runs.
                            • [Michael Arroyo] Added Parameter OutYaml to return a Yaml specific output
                            • [Michael Arroyo] Added Parameter FormatView to give a bigger selection of output formats
                            • [Michael Arroyo] Added a new HashReturn property called Command.  This property will show each command line ran to
                                copy a file to the remote machine.
                            • [Michael Arroyo] Added a new HashReturn property called Process.  This property will show which file(s) have been
                                copied to the remote machine
                            • [Michael Arroyo] Added the Standard Functions Dynamic parameter update region
                            • [Michael Arroyo] Updated the core process to run a ForEach on the Source list.  If copying to or from a session the
                                computer name will have a remote connection established only once and all files and or folders will be copied as
                                needed without creating new sessions per file like before.
            #>
        #endregion Build Notes
        [CmdletBinding()]
        [Alias('Send-Item')]
        #region Parameters
            Param
            (
                [Parameter(Position = 0)]
                [Alias("Path")]
                [String[]]$Source,

                [Parameter(Position = 1)]
                [String]$Destination,

                [String]$RelativePath,

                [Switch]$Container,

                [Switch]$Force,

                [String]$Filter,

                [String]$Include,

                [String]$Exclude,

                [Switch]$Recurse,

                [Switch]$FromSession,

                [Switch]$ToSession,

                [String]$ComputerName,

                [Switch]$ShowProgress,

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

        #region Create Hash
            $HashReturn = @{}
            $HashReturn.SendItem = @{}
            $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn.SendItem.StartTime = $($StartTime).DateTime
            $HashReturn.SendItem.Command = @()
            $HashReturn.SendItem.Process = @()
        #endregion Create Hash

        #region Parameter Set Results
            $HashReturn.SendItem.ParameterSetResults = $PSBoundParameters
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

        #region Parameter Check
            $Error.Clear()
            Switch
            (
                $null
            )
            {
                {-Not $Source}
                {
                    Write-Error -Message 'No Source information specified' -ErrorAction SilentlyContinue
                    $HashReturn.SendItem.ParameterCheck = @{
                        'Parameter' = 'Source'
                        'Status'    = $false
                        'Error'     = $($Error.Exception | out-string).trim()
                    }
                    Break
                }
                {$Destination -eq $null}
                {
                    Write-Error -Message 'No Destination information specified' -ErrorAction SilentlyContinue
                    $HashReturn.SendItem.ParameterCheck = @{
                        'Parameter' = 'Destination'
                        'Status'    = $false
                        'Error'     = $($Error.Exception | out-string).trim()
                    }
                    Break
                }
                {$ToSession -eq $true}
                {
                    if
                    (
                        $ComputerName -eq $null
                    )
                    {
                        Write-Error -Message 'No Computer Name specified.  A Computer Name needs to be set if using -ToSession' -ErrorAction SilentlyContinue
                        $HashReturn.SendItem.ParameterCheck = @{
                            'Parameter' = 'ComputerName'
                            'Status'    = $false
                            'Error'     = $($Error.Exception | out-string).trim()
                        }
                        Break
                    }
                }
                {$FromSession -eq $true}
                {
                    if
                    (
                        $ComputerName -eq $null
                    )
                    {
                        Write-Error -Message 'No Computer Name specified.  A Computer Name needs to be set if using -FromSession' -ErrorAction SilentlyContinue
                        $HashReturn.SendItem.ParameterCheck = @{
                            'Parameter' = 'ComputerName'
                            'Status'    = $false
                            'Error'     = $($Error.Exception | out-string).trim()
                        }
                        Break
                    }
                }
            }
        #endregion Parameter Check

        #region Main
            If
            (
                -Not $Error
            )
            {
                $Source | ForEach-Object `
                    -Begin `
                    {
                        #region Show Progress Check
                            $ProgressPreferenceOld = $ProgressPreference

                            If
                            (
                                -Not $ShowProgress
                            )
                            {
                                $ProgressPreference = 'SilentlyContinue' # hide the progress bar
                            }
                        #endregion Show Progress Check

                        #region Create Session
                            If
                            (
                                $ToSession -or $FromSession
                            )
                            {
                                $SessionName = $('{0}{1}' -f $($ComputerName -replace '[/.|-]'), $(New-UID -NumPerSet 3 -NumOfSets 2 -Delimiter '' -ErrorAction SilentlyContinue))
                                New-Variable -Name $SessionName -Value $(New-PSSession -ComputerName $ComputerName -ErrorAction SilentlyContinue) -Force -ErrorAction SilentlyContinue
                            }
                        #endregion Create Session
                    }`
                    -Process `
                    {
                        $CurSrce = Get-LiteralPath -Path $_ -ErrorAction SilentlyContinue

                        #region Update Variable Paths
                            $UpdateDestination = Get-LiteralPath -Path $Destination -ErrorAction SilentlyContinue
                        #endregion Update Variable Paths

                        #region Set RelativePath
                            If
                            (
                                $RelativePath
                            )
                            {
                                $CurDest = Join-Path -Path $UpdateDestination -ChildPath $($CurSrce.Replace("$RelativePath",''))
                            }
                            Else
                            {
                                $CurDest = $UpdateDestination
                            }
                        #endregion Set RelativePath

                        #region Build Copy Command
                            switch
                            (
                                $null
                            )
                            {
                                { $ToSession -eq $true }
                                {
                                    #region Destination Check
                                        Switch -Regex (
                                            $CurDest
                                        )
                                        {
                                            '\w\.\w{3,4}$' #Looks to be a file
                                            {
                                                $DestinationCheck = $(Invoke-Command -ScriptBlock {Test-Path -Path $args[0] -ErrorAction SilentlyContinue} -Session $(Get-Item -Path $('Variable:\{0}' -f $SessionName) -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Value) -ArgumentList $($CurDest | Split-Path -Parent -ErrorAction SilentlyContinue))
                                                $FileExists = $(Invoke-Command -ScriptBlock {Test-Path -Path $args[0] -ErrorAction SilentlyContinue} -Session $(Get-Item -Path $('Variable:\{0}' -f $SessionName) -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Value) -ArgumentList $CurDest)

                                                If
                                                (
                                                    -Not $DestinationCheck
                                                )
                                                {
                                                    $null = $(Invoke-Command -ScriptBlock {New-Item -Path $args[0] -ErrorAction SilentlyContinue -Force -ItemType Directory} -Session $(Get-Item -Path $('Variable:\{0}' -f $SessionName) -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Value) -ArgumentList $($CurDest | Split-Path -Parent -ErrorAction SilentlyContinue))
                                                }
                                            }
                                            default
                                            {
                                                $DestinationCheck = $(Invoke-Command -ScriptBlock {Test-Path -Path $args[0] -ErrorAction SilentlyContinue} -Session $(Get-Item -Path $('Variable:\{0}' -f $SessionName) -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Value) -ArgumentList $CurDest)

                                                If
                                                (
                                                    -Not $DestinationCheck
                                                )
                                                {
                                                    $null = $(Invoke-Command -ScriptBlock {New-Item -Path $args[0] -ErrorAction SilentlyContinue -Force -ItemType Directory} -Session $(Get-Item -Path $('Variable:\{0}' -f $SessionName) -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Value) -ArgumentList $CurDest)
                                                }
                                            }
                                        }
                                    #endregion Destination Check

                                    #region Build Command
                                        $ArrParamList = New-Object -TypeName PSObject -Property @{
                                            'Path'        = $('"{0}"' -f $CurSrce)
                                            'Destination' = $('"{0}"' -f $CurDest)
                                            'Filter'      = $Filter
                                            'Container'   = $Container
                                            'Include'     = $Include
                                            'Exclude'     = $Exclude
                                            'Recurse'     = $Recurse
                                            'Force'       = $Force
                                            'ToSession'   = $('${0}' -f $SessionName)
                                        }

                                        $NewCommand = Build-Command -Name 'Copy-Item' -BoundParameters $ArrParamList -ErrorAction SilentlyContinue
                                    #endregion Build Command

                                    Break
                                }
                                { $FromSession -eq $true }
                                {
                                    #region Destination Check
                                        Switch -Regex (
                                            $CurDest
                                        )
                                        {
                                            '\w\.\w{3,4}$' #Looks to be a file
                                            {
                                                $DestinationCheck = $(Test-Path -Path $($CurDest | Split-Path -Parent -ErrorAction SilentlyContinue) -ErrorAction SilentlyContinue)

                                                If
                                                (
                                                    -Not $DestinationCheck
                                                )
                                                {
                                                    $null = $(New-Item -Path $($CurDest | Split-Path -Parent -ErrorAction SilentlyContinue) -ErrorAction SilentlyContinue -Force -ItemType Directory)
                                                }
                                            }
                                            default
                                            {
                                                $DestinationCheck = $(Test-Path -Path $CurDest -ErrorAction SilentlyContinue)

                                                If
                                                (
                                                    -Not $DestinationCheck
                                                )
                                                {
                                                    $null = $(New-Item -Path $CurDest -ErrorAction SilentlyContinue -Force -ItemType Directory)
                                                }
                                            }
                                        }
                                    #endregion Destination Check

                                    #region Build Command
                                        $ArrParamList = New-Object -TypeName PSObject -Property @{
                                            'Path'        = $('"{0}"' -f $CurSrce)
                                            'Destination' = $('"{0}"' -f $CurDest)
                                            'Filter'      = $Filter
                                            'Container'   = $Container
                                            'Include'     = $Include
                                            'Exclude'     = $Exclude
                                            'Recurse'     = $Recurse
                                            'Force'       = $Force
                                            'FromSession'   = $('${0}' -f $SessionName)
                                        }

                                        $NewCommand = Build-Command -Name 'Copy-Item' -BoundParameters $ArrParamList -ErrorAction SilentlyContinue
                                    #endregion Build Command
                                    Break
                                }
                                default
                                {
                                    #region Build Command
                                        $ArrParamList = New-Object -TypeName PSObject -Property @{
                                            'Path'        = $('"{0}"' -f $CurSrce)
                                            'Destination' = $('"{0}"' -f $CurDest)
                                            'Filter'      = $Filter
                                            'Container'   = $Container
                                            'Include'     = $Include
                                            'Exclude'     = $Exclude
                                            'Recurse'     = $Recurse
                                            'Force'       = $Force
                                        }

                                        $NewCommand = Build-Command -Name 'Copy-Item' -BoundParameters $ArrParamList -ErrorAction SilentlyContinue
                                    #endregion Build Command
                                }
                            }

                            $HashReturn.SendItem.Command += $NewCommand.ToString()
                        #endregion Build Copy Command

                        #region Process Copy Command
                            If
                            (
                                $NewCommand
                            )
                            {
                                $Error.Clear()

                                If
                                (
                                    -Not $FileExists
                                )
                                {
                                    $null = Invoke-Command -ScriptBlock $NewCommand -ErrorAction SilentlyContinue
                                }
                                Else
                                {
                                    If
                                    (
                                        $Force
                                    )
                                    {
                                        $null = Invoke-Command -ScriptBlock $NewCommand -ErrorAction SilentlyContinue
                                    }
                                }

                                if
                                (
                                    -Not $Error.Exception
                                )
                                {
                                    If
                                    (
                                        $FileExists -and -$(-Not $Force)
                                    )
                                    {
                                        $HashReturn.SendItem.Process += New-Object PSObject -Property @{
                                            'Path'      = $CurDest
                                            'Status'    = 'True'
                                            'Comment'   = 'File Already Exists'
                                            'Error'     = ''
                                        }
                                    }
                                    Else
                                    {
                                        $HashReturn.SendItem.Process += New-Object PSObject -Property @{
                                            'Path'      = $CurDest
                                            'Status'    = 'True'
                                            'Comment'   = ''
                                            'Error'     = ''
                                        }
                                    }
                                }
                                else
                                {
                                    if
                                    (
                                        $Error.Exception -match 'Unable to index into an object of type System\.IO'
                                    )
                                    {
                                        $Recheck = Invoke-Command -Session $(Invoke-Expression -Command $('${0}' -f $SessionName)) -ScriptBlock {Test-Path -Path $args} -ArgumentList $CurDest -ErrorAction SilentlyContinue

                                        If
                                        (
                                            $Recheck -eq $true
                                        )
                                        {
                                            $HashReturn.SendItem.Process += New-Object PSObject -Property @{
                                                'Path'      = $CurDest
                                                'Status'    = 'True'
                                                'Comment'   = ''
                                                'Error'     = ''
                                            }
                                        }
                                        Else
                                        {
                                            $HashReturn.SendItem.Process += New-Object PSObject -Property @{
                                                'Path'      = $CurDest
                                                'Status'    = 'False'
                                                'Comment'   = ''
                                                'Error'     = $($Error.Exception | out-string).trim()
                                            }
                                        }

                                    }
                                    Else
                                    {
                                        $HashReturn.SendItem.Process += New-Object PSObject -Property @{
                                            'Path'      = $CurDest
                                            'Status'    = 'False'
                                            'Comment'   = ''
                                            'Error'     = $($Error.Exception | out-string).trim()
                                        }
                                    }
                                }
                            }
                        #endregion Process Copy Command
                    }`
                    -End `
                    {
                        $null = Remove-PSSession -Session $(Get-Item -Path $('Variable:\{0}' -f $SessionName) -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Value) -ErrorAction SilentlyContinue
                        $null = Remove-Variable -Name $($SessionName) -Force -ErrorAction SilentlyContinue
                    }
            }
        #endregion Main

        #region Output
            $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn['SendItem'].EndTime = $($EndTime).DateTime
            $HashReturn['SendItem'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
                | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

            $ProgressPreference = $ProgressPreferenceOld

            If
            (
                -Not $($VerbosePreference -eq 'Continue')
            )
            {
                #Add Hash Properties that are not needed without Verbose enabled.
                $null = $HashReturn['SendItem'].Remove('StartTime')
                $null = $HashReturn['SendItem'].Remove('ParameterSetResults')
                $null = $HashReturn['SendItem'].Remove('CachePath')
                $null = $HashReturn['SendItem'].Remove('EndTime')
                $null = $HashReturn['SendItem'].Remove('ElapsedTime')
                $null = $HashReturn['SendItem'].Remove('Command')
                $null = $HashReturn['SendItem'].Remove('ParameterCheck')
            }

            If
            (
                $ClearGarbageCollecting
            )
            {
                $null = Clear-BlugenieMemory
            }

            #region Output Type
                $ResultSet = $HashReturn.SendItem.Process

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
#endregion Send-BluGenieItem (Function)