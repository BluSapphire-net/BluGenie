#region Connect-BluGenieToSystem (Function)
    function Connect-BluGenieToSystem
    {
    <#
        .SYNOPSIS
            Connect-BluGenieToSystem will spawn a remote session into the computer you specify

        .DESCRIPTION
            Connect-BluGenieToSystem is a trouble shooting process to spawn a remote session into the computer(s) you specify.
            You can also send the BluGemie Module, Service, and Tools to any of the folling remote system directories
                - $env:ProgramFiles\BluGenie (This is the Default Path)
                - $env:ProgramFiles\WindowsPowerShell\ModuleSource

            Note:  When you copy the tools BluGenie will not Auto Load.  It was designed to force an Import


        .PARAMETER ComputerName
            Description: Computer name or IP Address of the remote system.
            Notes: This can be an Array of systems.  All Systems will process in an asynchronous order and all connections will be minimized at start.
            Alias:
            ValidateSet:

        .PARAMETER Walkthrough
            Description: An automated process to walk through the current function and all the parameters
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER Force
            Description: Do not test the connect to the computer, just execute the connection process
            Notes:
            Alias:
            ValidateSet:

        .PARAMETER CopyModules
            Description: Copy the BluGenie Module content to the remote host over WinRM.  This will not use SMB.
            Notes: Default path is $env:\ProgramFiles\BluGenie

                    If the default path is set you can run Import-Module 'C:\Program Files\BluGenie' to load the module
            Alias:
            ValidateSet:

        .PARAMETER SystemtModulePath
            Description: When Copying the BluGenie Module content set the save path to the default Windows PowerShell Module directory
            Notes: Path is $env:\ProgramFiles\WindowsPowerShell\Modules\BluGenie.

                    If this path is set you can run Import-Module BluGenie without having to set a Module path
            Alias:
            ValidateSet:

        .EXAMPLE
            Connect-BluGenieToSystem -ComputerName 10.20.136.52

            This will try and resolve the IP to a Domain name, test to see if the system is online, and then spawn a remote session into the system

        .EXAMPLE
            Connect-BluGenieToSystem -ComputerName TestPC05

            This will test to see if the system is online, and then spawn a remote session into the system

        .OUTPUTS
            None

        .NOTES

            * Original Author           : Michael Arroyo
            * Original Build Version    : 1907.1501
            * Latest Author             : Michael Arroyo
            * Latest Build Version      : 21.04.1401
            * Comments                  :
            * Dependencies              :
                o  Invoke-BluGenieWalkThrough or Invoke-WalkThrough - interactive help menu system
                o  Get-BluGenieErrorAction or Get-ErrorAction - Round up any errors into a smiple, clean object
                o  New-BluGenieUID or New-UID - Create a New UID
    #>

    #region Build Notes
        <#
        ~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
            ~ 1907.1501:* [Michael Arroyo] Posted
            ~ 1907.1601:* [Michael Arroyo] Added the -Force switch to bypass (the OS info, the Result Info,
                                                and the Resolved Info) checks
            ~ 21.04.1401* [Michael Arroyo] Updated the Description with more function detail
                        * [Michael Arroyo] Updated The ComputerName parameter to support multiple computers
                        * [Michael Arroyo] Added the missing parameter help header for (Force).
                        * [Michael Arroyo] Added a new parameter called (CopyModules).  This copies the BluGenie Module content to the remote
                                            host over WinRM without starting a Job.
                        * [Michael Arroyo] Added a new parameter called (SystemtModulePath).  When Copying the BluGenie Module content, set the
                                            save path to the default Windows PowerShell Module directory
                                            o Notes: Path is $env:\ProgramFiles\WindowsPowerShell\Modules\BluGenie.
                        * [Michael Arroyo] Fixed the Help information region. Moved the (Build Version Details) from main help.
                                            There is a Char limit and PSHelp could not read all the information correctly which also created
                                            issues using the (WalkThrough) parameter as well.
                        * [Michael Arroyo] Updated this function / script based on the new Linter (PSScriptAnalyzerSettings)
                        * [Michael Arroyo] Added a new Alias called (Connect-BGToSystem)

        #>
    #endregion Build Notes
        [Alias('Connect-ToSystem','Connect','Connect-BGToSystem')]
        Param
        (
            [Parameter(Position = 0)]
            [string[]]$ComputerName,

            [Alias('Help')]
            [Switch]$Walkthrough,

            [Switch]$Force,

            [Switch]$CopyModules,

            [Switch]$SystemtModulePath
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

        #region Copy BluGenie Modules before connecting to the remote session
            If
            (
                $SystemtModulePath
            )
            {
                $CopyModules = $true
            }

            If
            (
                $CopyModules
            )
            {
                #region Query Module Source
                    $ModuleSource = @()

                    Get-Childitem -Path $BluGenieModulePath -File -Recurse | Select-Object -Property FullName | ForEach-Object `
                        -Process `
                        {
                            If
                            (
                                $ToolsConfig.ExcludedCopyFiles.Name.Count -eq 1
                            )
                            {
                                If
                                (
                                    $_  -Notmatch $($ToolsConfig.ExcludedCopyFiles.Name).Replace('\','\\')
                                )
                                {
                                    $ModuleSource += $_.FullName
                                }
                            }
                            Else
                            {
                                If
                                (
                                    $_  -Notmatch $($ToolsConfig.ExcludedCopyFiles.Name -Join '|').Replace('\','\\')
                                )
                                {
                                    $ModuleSource += $_.FullName
                                }
                            }
                        }
                #endregion Query Module Source

                #region Start Copy
                    If
                    (
                        $SystemtModulePath
                    )
                    {
                        $CopyDest = $('{0}\WindowsPowerShell\Modules\' -f $Env:ProgramFiles)
                    }
                    Else
                    {
                        $CopyDest = $('{0}\BluGenie\Modules\' -f $Env:ProgramFiles)
                    }

                    $ComputerName | ForEach-Object `
                        -Process `
                        {
                            $System = Resolve-BgDnsName -ComputerName $_ -ErrorAction SilentlyContinue

                            Write-BluGenieVerboseMsg -Message $('Copying Tools to ({0})' -f $System.ComputerName) -Color 'Yellow' `
                                -Status 'StartTimer'

                            $null = Send-BluGenieItem -Source $ModuleSource `
                                -Destination  $CopyDest `
                                -RelativePath $($BluGenieModulePath) -ToSession -ComputerName $System.ComputerName `
                                -Force -ErrorAction SilentlyContinue

                            Write-BluGenieVerboseMsg -Message $('Process Completed for ({0})' -f $System.ComputerName) -Color 'Yellow' `
                                -Status 'StopTimer'

                            #region Test Connection and Connect
                                If
                                (
                                    $Force
                                )
                                {
                                    Start-Process -FilePath $('{0}\Windows\system32\cmd.exe' -f $env:SystemDrive) -ArgumentList $('/c start {0}\Windows\system32\WindowsPowerShell\v1.0\PowerShell.exe -NoExit -WindowStyle Minimized -Command "Enter-PSSession -ComputerName {1}"' -f $env:SystemDrive, $system.ComputerName) -WindowStyle Minimized
                                }
                                ElseIf
                                (
                                    $($System.OS -eq 'Windows') -and $($System.Resolved -eq $true) -and $($system.Results -eq 'Up')
                                )
                                {
                                    Start-Process -FilePath $('{0}\Windows\system32\cmd.exe' -f $env:SystemDrive) -ArgumentList $('/c start {0}\Windows\system32\WindowsPowerShell\v1.0\PowerShell.exe -NoExit -WindowStyle Minimized -Command "Enter-PSSession -ComputerName {1}"' -f $env:SystemDrive, $system.ComputerName) -WindowStyle Minimized
                                }
                                Else
                                {
                                    $System | Add-Member -MemberType NoteProperty -Name 'Error' -Value 'Could not connect to system'
                                    Write-Host $System
                                }
                            #endregion Test Connection and Connect
                        }
                #endregion Start Copy
            }
            Else
            {
                $ComputerName | ForEach-Object `
                -Process `
                {
                    $System = Resolve-BgDnsName -ComputerName $_ -ErrorAction SilentlyContinue

                    #region Test Connection and Connect
                        If
                        (
                            $Force
                        )
                        {
                            Start-Process -FilePath $('{0}\Windows\system32\cmd.exe' -f $env:SystemDrive) -ArgumentList $('/c start {0}\Windows\system32\WindowsPowerShell\v1.0\PowerShell.exe -NoExit -WindowStyle Minimized -Command "Enter-PSSession -ComputerName {1}"' -f $env:SystemDrive, $system.ComputerName) -WindowStyle Minimized
                        }
                        ElseIf
                        (
                            $($System.OS -eq 'Windows') -and $($System.Resolved -eq $true) -and $($system.Results -eq 'Up')
                        )
                        {
                            Start-Process -FilePath $('{0}\Windows\system32\cmd.exe' -f $env:SystemDrive) -ArgumentList $('/c start {0}\Windows\system32\WindowsPowerShell\v1.0\PowerShell.exe -NoExit -WindowStyle Minimized -Command "Enter-PSSession -ComputerName {1}"' -f $env:SystemDrive, $system.ComputerName) -WindowStyle Minimized
                        }
                        Else
                        {
                            $System | Add-Member -MemberType NoteProperty -Name 'Error' -Value 'Could not connect to system'
                            Write-Host $System
                        }
                    #endregion Test Connection and Connect
                }
            }
        #endregion Copy BluGenie Modules before connecting to the remote session
    }
#endregion Connect-BluGenieToSystem (Function)