#region Invoke-BluGeniePython (Function)
Function Invoke-BluGeniePython
{
<#
    .SYNOPSIS
        Invoke-BluGeniePython will enable a BluGenie Managed Portable version of Python

    .DESCRIPTION
        Invoke-BluGeniePython will enable a BluGenie Managed Portable version of Python

    .PARAMETER Reset
        Description: Reset the BluGenie Managed Python to a predetermined (clean state)
        Notes:  Any changes to the current BluGenie Managed Python will be lost.
        Alias:
        ValidateSet:

    .PARAMETER Remove
        Description:  Remove the BluGenie Managed Python from disk
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER PYFile
        Description: Path to a Python Script
        Notes:  When running a Python Script Invoke-BluGeniePython will wait for the script to finish and return any information captured
        Alias:
        ValidateSet:

    .PARAMETER Console
        Description: Open up the current BluGenie Managed Python Console
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER WinPyConsole
        Description: Open up the current BluGenie Managed WinPython Command Prompt
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
        Command: Invoke-BluGeniePython
        Description:  Use this command to Setup the Blugenie Managed version of Python
        Notes:  This will not change the default Python if one is installed.
                However any internal BluGenie calls to Python will go to the BluGenie Managed Version and not the default.

    .EXAMPLE
        Command: Invoke-BluGeniePython -Remove
        Description:  Use this command to remove the Blugenie Managed version of Python
        Notes:  This will not change the default Python if one is installed.

    .EXAMPLE
        Command: Invoke-BluGeniePython -Reset
        Description:  Use this command to reset the BluGenie Managed version of Python to it's default environment state.
        Notes:  This command can also Setup the BluGenie Managed version of Python if it's not installed already.

    .EXAMPLE
        Command: Invoke-BluGeniePython -PYFile C:\Windows\Temp\MyTest.py
        Description: Use this command to run a specifc Python script file
        Notes:

    .EXAMPLE
        Command: Invoke-BluGeniePython -PYFile C:\Windows\Temp\MyTest.py -ReturnObject
        Description:  Use this command to return the STDOut from the Python script as an Object.
        Notes:  The Property name is called ( ProcessAction )

    .EXAMPLE
        Command: Invoke-BluGeniePython -PYFile C:\Windows\Temp\MyTest.py -ReturnObject | Select-Object -ExpandProperty ProcessAction
        Description:  Use this command to return only the STDOut from the Python script.
        Notes:  The Property name ( ProcessAction ) is expanded to only return the value.

    .EXAMPLE
        Command: Invoke-BluGeniePython -Console
        Description:  Use this command to show the Console of the BluGenie Managed verison of Python
        Notes:  You can use the Console to edit the BluGenie Managed version of Python or run command Python commands and scripts.

    .EXAMPLE
        Command: Invoke-BluGeniePython -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Invoke-BluGeniePython -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Invoke-BluGeniePython -OutUnEscapedJSON
        Description: Return a detailed function report in an UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Invoke-BluGeniePython -OutYaml
        Description: Return a detailed function report in YAML format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Invoke-BluGeniePython -ReturnObject
        Description: Return Output as a Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
                This parameter is also used with the FormatView

    .EXAMPLE
        Command: Invoke-BluGeniePython -ReturnObject -FormatView Yaml
        Description: Output PSObject information in Yaml format
        Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
                Default is set to (None) and normal PSObject.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • [Original Author]
            o  Michael Arroyo
        • [Original Build Version]
            o  21.06.0701 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o  Michael Arroyo
        • [Latest Build Version]
            o  21.08.0201
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
    o 21.02.1201:   • [Michael Arroyo] Function Template
    o 21.06.0701:   • [Michael Arroyo] Posted
    o 21.06.2301:   • [Michael Arroyo] Added a Dynamic Path process to update the pyvenv.cfg file based on where the BGPython directory is located
                    • [Michael Arroyo] -Remove will now search the current env:path to make sure you didn't load the BluGenie Python into the
                                        normal env.  If so, it will remove it as well as the BGPython Directory.
                    • [Michael Arroyo] Successful setup is now based on checks to the $env:Path and the pyvenv.cfg to make sure they match
                    • [Michael Arroyo] Once BGPython is setup you can now run Python commands in the BGConsole without running BluGenie commands
                                        Example: Python --version
                                        Example: Python $env:temp\MyScript.py
    o 21.06.2501:   • [Michael Arroyo] Added parameter WinPyConsole.  This will open up the WinPython Command Prompt.
                    • [Michael Arroyo] Added $ToolsDirectory\BGPython\scripts to the env path
                    • [Michael Arroyo] Updated the env to support EQL calls directory
                    • [Michael Arroyo] Updated the env to support EQLLib calls directory
                    • [Michael Arroyo] Updated the env to support Python calls Directory
                    • [Michael Arroyo] Added env startup script to rebuild or add to the env dynamically by adding Lib / Pip installs to ->
                        $ToolsDirectory\BGPython\settings\BGSetup.ps1
    o 21.07.2601:   • [Michael Arroyo] Remove Progress Bar while processing to speed up performance.
                    • [Michael Arroyo] Fixed some of the region headers in Main
                    • [Michael Arroyo] Updated BGSetup.ps1 to support Local Wheel installs
                    • [Michael Arroyo] Added a new directory to house the local wheel installs $ToolsDirectory\BGPython\settings\localwheels
                    • [Michael Arroyo] Added local wheel install (psutil-5.8.0-cp38-cp38-win_amd64.whl)
                    • [Michael Arroyo] Added local wheel install (pywin32-301-cp38-cp38-win_amd64.whl)
                    • [Michael Arroyo] Added local wheel install (regex-2021.7.6-cp38-cp38-win_amd64.whl)
                    • [Michael Arroyo] Added local wheel install (WMI-1.5.1-py2.py3-none-any.whl)
                    • [Michael Arroyo] Added Verbose Logging to the BGSetup.ps1 if -Verbose is used with Invoke-BluGeniePython
    o 21.08.0201:   • [Michael Arroyo] Set the $Global:ProgressPreference on Start and End of this script
#>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Invoke-BGPython','BGPython')]
    #region Parameters
        Param
        (
            [Switch]$Reset,

            [Switch]$Remove,

            [String]$PYFile,

            [Switch]$Console,

            [Switch]$WinPyConsole,

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
        $HashReturn['InvokeBGPython'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['InvokeBGPython'].StartTime = $($StartTime).DateTime
        $HashReturn['InvokeBGPython'].ParameterSetResults = @()
        $HashReturn['InvokeBGPython']['PythonCheck'] = $false
        $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize'
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['InvokeBGPython'].ParameterSetResults = $PSBoundParameters
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

    #region Set ProgressPreference
        $OrgProgressPreference = $ProgressPreference
        $Global:ProgressPreference = 'SilentlyContinue'
    #endregion Set ProgressPreference

    #region Main
        $BGPythonPath = Join-Path -Path $(Resolve-Path -Path $ToolsDirectory | Select-Object -ExpandProperty Path) -ChildPath 'BGPython'
        $BGPythonScriptPath = $(Join-Path -Path $BGPythonPath -ChildPath 'scripts')
        $BGPythonArchive = $('{0}.zip' -f $BGPythonPath)
        $BGPythonConfig = $(Join-Path -Path $BGPythonPath -ChildPath 'pyvenv.cfg')
        $BGPythonEnvPath = $(Join-Path -Path $BGPythonPath -ChildPath 'python-3.8.7.amd64')

        Switch
        (
            $null
        )
        {
            {$Remove}
            {
                If
                (
                    Test-Path -Path $BGPythonPath -ErrorAction SilentlyContinue
                )
                {
                    $HashReturn['InvokeBGPython']['PythonCheck'] = $true

                    Try
                    {
                        Remove-Item -Path $BGPythonPath -Force -Recurse -ErrorAction Stop -Confirm:$False
                        If
                        (
                            $env:Path | Select-String -SimpleMatch $BGPythonEnvPath
                        )
                        {
                            $env:Path = $($env:Path).replace("$('{0};' -f $BGPythonEnvPath)",'')
                        }
                        $HashReturn['InvokeBGPython']['ProcessAction'] = 'Removed:Successful'
                    }
                    Catch
                    {
                        $HashReturn['InvokeBGPython']['ProcessAction'] = 'Removed:Failed'
                    }
                }
                Else
                {
                    $HashReturn['InvokeBGPython']['ProcessAction'] = 'Removed:Successful'
                }
                break
            }

            {$Reset}
            {
                If
                (
                    $(Test-Path -Path $BGPythonPath -ErrorAction SilentlyContinue) -and $(Test-Path -Path $BGPythonArchive -ErrorAction SilentlyContinue)
                )
                {
                    $HashReturn['InvokeBGPython']['PythonCheck'] = $true

                    Try
                    {
                        Remove-Item -Path $BGPythonPath -Force -Recurse -ErrorAction Stop -Confirm:$False
                        $HashReturn['InvokeBGPython']['ProcessAction'] = 'Removed:Successful'

                        #region Expand Archive
                            Try
                            {
                                If
                                (
                                    -Not $(Get-Command | Where-Object -FilterScript { $_.Name -eq 'Expand-Archive'  })
                                )
                                {
                                    Expand-ArchivePS2 -Path $BGPythonArchive -Destination $ToolsDirectory -Force -NoProgressBar -NoErrorMsg -ReturnObject -ErrorAction Stop
                                    $HashReturn['InvokeBGPython']['ProcessAction'] = 'Expanded_Archive:Successful'
                                }
                                Else
                                {
                                    Expand-Archive -LiteralPath $BGPythonArchive -DestinationPath $ToolsDirectory -Force -ErrorAction Stop
                                    $HashReturn['InvokeBGPython']['ProcessAction'] = 'Expanded_Archive:Successful'
                                }

                                #region Env Path Check for Python
                                    If
                                    (
                                        Test-Path -Path $BGPythonConfig -ErrorAction SilentlyContinue
                                    )
                                    {
                                        If
                                        (
                                            -Not $($env:Path | Select-String -SimpleMatch $BGPythonEnvPath)
                                        )
                                        {
                                            $env:Path = $('{0};{1};{2}' -f $BGPythonEnvPath, $BGPythonScriptPath, $env:Path)
                                        }

                                        $PythonEnvData = $(Get-Content -Path $('{0}\pyvenv.cfg' -f $BGPythonPath)) `
                                            -replace '^home.*$',"$('home = {0}' -f $BGPythonEnvPath)"
                                        $PythonEnvData | Out-File -FilePath $('{0}\pyvenv.cfg' -f $BGPythonPath) -Force -Encoding utf8
                                        $ConfirmPythonEnvPath = $(Get-Content -Path $('{0}\pyvenv.cfg' -f $BGPythonPath) | `
                                            Select-String -Pattern '^home.*$') -replace '^home = '

                                        If
                                        (
                                            $($env:Path | Select-String -SimpleMatch $BGPythonPath) -and $($ConfirmPythonEnvPath -eq $BGPythonEnvPath)
                                        )
                                        {
                                            If
                                            (
                                                -Not $($VerbosePreference -eq 'Continue')
                                            )
                                            {
                                                $Null = . $ToolsDirectory\BGPython\settings\BGSetup.ps1
                                            }
                                            Else
                                            {
                                                . $ToolsDirectory\BGPython\settings\BGSetup.ps1
                                            }
                                            $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Successful'
                                            $HashReturn['InvokeBGPython']['PythonCheck'] = $true
                                        }
                                        Else
                                        {
                                            $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Failed'
                                        }
                                    }
                                    Else
                                    {
                                        $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Failed'
                                    }
                                #endregion Env Path Check for Python
                            }
                            Catch
                            {
                                $HashReturn['InvokeBGPython']['ProcessAction'] = 'Expanded_Archive:Failed'
                            }
                        #endregion Expand Archive
                    }
                    Catch
                    {
                        $HashReturn['InvokeBGPython']['ProcessAction'] = 'Removed_Failed'
                    }
                }
                Else
                {
                    If
                    (
                        Test-Path -Path $BGPythonArchive -ErrorAction SilentlyContinue
                    )
                    {
                        #region Expand Archive
                            Try
                            {
                                If
                                (
                                    -Not $(Get-Command | Where-Object -FilterScript { $_.Name -eq 'Expand-Archive'  })
                                )
                                {
                                    Expand-ArchivePS2 -Path $BGPythonArchive -Destination $ToolsDirectory -Force -NoProgressBar -NoErrorMsg -ReturnObject -ErrorAction Stop
                                    $HashReturn['InvokeBGPython']['ProcessAction'] = 'Expanded_Archive:Successful'
                                }
                                Else
                                {
                                    Expand-Archive -LiteralPath $BGPythonArchive -DestinationPath $ToolsDirectory -Force -ErrorAction Stop
                                    $HashReturn['InvokeBGPython']['ProcessAction'] = 'Expanded_Archive:Successful'
                                }

                                #region Env Path Check for Python
                                    If
                                    (
                                        Test-Path -Path $BGPythonConfig -ErrorAction SilentlyContinue
                                    )
                                    {
                                        If
                                        (
                                            -Not $($env:Path | Select-String -SimpleMatch $BGPythonEnvPath)
                                        )
                                        {
                                            $env:Path = $('{0};{1};{2}' -f $BGPythonEnvPath, $BGPythonScriptPath, $env:Path)
                                        }

                                        $PythonEnvData = $(Get-Content -Path $('{0}\pyvenv.cfg' -f $BGPythonPath)) `
                                            -replace '^home.*$',"$('home = {0}' -f $BGPythonEnvPath)"
                                        $PythonEnvData | Out-File -FilePath $('{0}\pyvenv.cfg' -f $BGPythonPath) -Force -Encoding utf8
                                        $ConfirmPythonEnvPath = $(Get-Content -Path $('{0}\pyvenv.cfg' -f $BGPythonPath) | `
                                            Select-String -Pattern '^home.*$') -replace '^home = '

                                        If
                                        (
                                            $($env:Path | Select-String -SimpleMatch $BGPythonPath) -and $($ConfirmPythonEnvPath -eq $BGPythonEnvPath)
                                        )
                                        {
                                            If
                                            (
                                                -Not $($VerbosePreference -eq 'Continue')
                                            )
                                            {
                                                $Null = . $ToolsDirectory\BGPython\settings\BGSetup.ps1
                                            }
                                            Else
                                            {
                                                . $ToolsDirectory\BGPython\settings\BGSetup.ps1
                                            }
                                            $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Successful'
                                            $HashReturn['InvokeBGPython']['PythonCheck'] = $true
                                        }
                                        Else
                                        {
                                            $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Failed'
                                        }
                                    }
                                    Else
                                    {
                                        $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Failed'
                                    }
                                #endregion Env Path Check for Python
                            }
                            Catch
                            {
                                $HashReturn['InvokeBGPython']['ProcessAction'] = 'Expanded_Archive:Failed'
                            }
                        #endregion Expand Archive
                    }
                    Else
                    {
                        $HashReturn['InvokeBGPython']['ProcessAction'] = 'Expanded_Archive:Failed'
                    }
                }
                break
            }

            {$PYFile}
            {
                #region Env Path Check for Python
                    If
                    (
                        Test-Path -Path $BGPythonConfig -ErrorAction SilentlyContinue
                    )
                    {
                        If
                        (
                            -Not $($env:Path | Select-String -SimpleMatch $BGPythonEnvPath)
                        )
                        {
                            $env:Path = $('{0};{1};{2}' -f $BGPythonEnvPath, $BGPythonScriptPath, $env:Path)
                        }

                        $PythonEnvData = $(Get-Content -Path $('{0}\pyvenv.cfg' -f $BGPythonPath)) `
                            -replace '^home.*$',"$('home = {0}' -f $BGPythonEnvPath)"
                        $PythonEnvData | Out-File -FilePath $('{0}\pyvenv.cfg' -f $BGPythonPath) -Force -Encoding utf8
                        $ConfirmPythonEnvPath = $(Get-Content -Path $('{0}\pyvenv.cfg' -f $BGPythonPath) | `
                            Select-String -Pattern '^home.*$') -replace '^home = '

                        If
                        (
                            $($env:Path | Select-String -SimpleMatch $BGPythonPath) -and $($ConfirmPythonEnvPath -eq $BGPythonEnvPath)
                        )
                        {
                            If
                            (
                                -Not $($VerbosePreference -eq 'Continue')
                            )
                            {
                                $Null = . $ToolsDirectory\BGPython\settings\BGSetup.ps1
                            }
                            Else
                            {
                                . $ToolsDirectory\BGPython\settings\BGSetup.ps1
                            }
                            $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Successful'
                            $HashReturn['InvokeBGPython']['PythonCheck'] = $true

                            If
                            (
                                Test-Path -Path $PYFile -ErrorAction SilentlyContinue
                            )
                            {
                                    $PyReturn = & 'Python.exe' $PYFile
                                    If
                                    (
                                        $PyReturn
                                    )
                                    {
                                        $HashReturn['InvokeBGPython']['ProcessAction'] = $PyReturn
                                    }
                            }
                            Else
                            {
                                $HashReturn['InvokeBGPython']['ProcessAction'] = 'PyFile:NotFound'
                            }
                        }
                        Else
                        {
                            $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Failed'
                        }
                    }
                    Else
                    {
                        $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Failed'
                    }
                #endregion Env Path Check for Python
            }

            {$Console}
            {
                If
                (
                    Test-Path -Path $BGPythonConfig -ErrorAction SilentlyContinue
                )
                {
                    If
                    (
                        -Not $($env:Path | Select-String -SimpleMatch $BGPythonPath)
                    )
                    {
                        $PythonPath = $(Get-Content -Path $('{0}\pyvenv.cfg' -f $BGPythonPath) | Select-String -Pattern home) -replace '^home = '
                        $env:Path = $('{0};{1}' -f $PythonPath, $env:Path)
                    }

                    If
                    (
                        $env:Path | Select-String -SimpleMatch $BGPythonPath
                    )
                    {
                        $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Successful'
                        $HashReturn['InvokeBGPython']['PythonCheck'] = $true

                        Start-Process -FilePath 'Python.exe' -WorkingDirectory $BGPythonEnvPath
                    }
                    Else
                    {
                        $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Failed'
                    }
                }
                Else
                {
                    $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Failed'
                }
            }

            {$WinPyConsole}
            {
                If
                (
                    Test-Path -Path $BGPythonConfig -ErrorAction SilentlyContinue
                )
                {
                    If
                    (
                        -Not $($env:Path | Select-String -SimpleMatch $BGPythonPath)
                    )
                    {
                        $PythonPath = $(Get-Content -Path $('{0}\pyvenv.cfg' -f $BGPythonPath) | Select-String -Pattern home) -replace '^home = '
                        $env:Path = $('{0};{1}' -f $PythonPath, $env:Path)
                    }

                    If
                    (
                        $env:Path | Select-String -SimpleMatch $BGPythonPath
                    )
                    {
                        $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Successful'
                        $HashReturn['InvokeBGPython']['PythonCheck'] = $true

                        Start-Process -FilePath 'WinPython Command Prompt.exe' -WorkingDirectory $BGPythonPath
                    }
                    Else
                    {
                        $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Failed'
                    }
                }
                Else
                {
                    $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Failed'
                }
            }

            Default
            {
                #region Expand Archive
                    If
                    (
                        -Not $(Test-Path -Path $BGPythonConfig -ErrorAction SilentlyContinue)
                    )
                    {
                        Try
                        {
                            If
                            (
                                -Not $(Get-Command | Where-Object -FilterScript { $_.Name -eq 'Expand-Archive'  })
                            )
                            {
                                Expand-ArchivePS2 -Path $BGPythonArchive -Destination $ToolsDirectory -Force -NoProgressBar -NoErrorMsg -ReturnObject -ErrorAction Stop
                            }
                            Else
                            {
                                Expand-Archive -Path $BGPythonArchive -DestinationPath $ToolsDirectory -Force -ErrorAction Stop
                            }

                            $HashReturn['InvokeBGPython']['ProcessAction'] = 'Expanded_Archive:Successful'
                        }
                        Catch
                        {
                            $HashReturn['InvokeBGPython']['ProcessAction'] = 'Expanded_Archive:Failed'
                        }
                    }
                #endregion Expand Archive

                #region Env Path Check for Python
                    If
                    (
                        Test-Path -Path $BGPythonConfig -ErrorAction SilentlyContinue
                    )
                    {
                        If
                        (
                            -Not $($env:Path | Select-String -SimpleMatch $BGPythonEnvPath)
                        )
                        {
                            $env:Path = $('{0};{1};{2}' -f $BGPythonEnvPath, $BGPythonScriptPath, $env:Path)
                        }

                        $PythonEnvData = $(Get-Content -Path $('{0}\pyvenv.cfg' -f $BGPythonPath)) `
                            -replace '^home.*$',"$('home = {0}' -f $BGPythonEnvPath)"
                        $PythonEnvData | Out-File -FilePath $('{0}\pyvenv.cfg' -f $BGPythonPath) -Force -Encoding utf8
                        $ConfirmPythonEnvPath = $(Get-Content -Path $('{0}\pyvenv.cfg' -f $BGPythonPath) | `
                            Select-String -Pattern '^home.*$') -replace '^home = '

                        If
                        (
                            $($env:Path | Select-String -SimpleMatch $BGPythonPath) -and $($ConfirmPythonEnvPath -eq $BGPythonEnvPath)
                        )
                        {
                            If
                            (
                                -Not $($VerbosePreference -eq 'Continue')
                            )
                            {
                                $Null = . $ToolsDirectory\BGPython\settings\BGSetup.ps1
                            }
                            Else
                            {
                                . $ToolsDirectory\BGPython\settings\BGSetup.ps1
                            }
                            $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Successful'
                            $HashReturn['InvokeBGPython']['PythonCheck'] = $true
                        }
                        Else
                        {
                            $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Failed'
                        }
                    }
                    Else
                    {
                        $HashReturn['InvokeBGPython']['ProcessAction'] = 'Initialize:Failed'
                    }
                #endregion Env Path Check for Python
            }
        }
    #endregion Main

    #region Reset ProgressPreference
        $Global:ProgressPreference = $OrgProgressPreference
    #endregion Reset ProgressPreference

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['InvokeBGPython'].EndTime = $($EndTime).DateTime
        $HashReturn['InvokeBGPython'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            -Not $($VerbosePreference -eq 'Continue')
        )
        {
            #Add Hash Properties that are not needed without Verbose enabled.
            $null = $HashReturn['InvokeBGPython'].Remove('StartTime')
            $null = $HashReturn['InvokeBGPython'].Remove('ParameterSetResults')
            $null = $HashReturn['InvokeBGPython'].Remove('CachePath')
            $null = $HashReturn['InvokeBGPython'].Remove('EndTime')
            $null = $HashReturn['InvokeBGPython'].Remove('ElapsedTime')
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
                    Name = 'ProcessAction'
                    Expression = {$($HashReturn['InvokeBGPython']['ProcessAction'])}
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
#endregion Invoke-BluGeniePython (Function)