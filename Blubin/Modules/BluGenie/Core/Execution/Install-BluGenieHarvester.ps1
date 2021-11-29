#region Install-BluGenieHarvester (Function)
    Function Install-BluGenieHarvester
    {
        <#
            .SYNOPSIS
                Install-BluGenieHarvester will copy and install the Windows Event Harvester (WinLogBeat)

            .DESCRIPTION
                Install-BluGenieHarvester will copy and install the Windows Event Harvester (WinLogBeat)

            .PARAMETER Source
                The Source path to the items to want to send
				
				The default is set to $ToolsDirectory\Blubin\WinlogBeat

                <Type>String<Type>

            .PARAMETER Destination
                The Destination path
				
				The default is set to 'C:\Program Files\WinlogBeat623'

                <Type>String<Type>

            .PARAMETER ForceCopy
                Forces the file or directory creation or overwrite

                <Type>SwitchParameter<Type>

            .PARAMETER Walkthrough
                An automated process to walk through the current function and all the parameters

                <Type>SwitchParameter<Type>

            .PARAMETER ReturnObject
                Return information as an Object.
                By default the data is returned as a Hash Table

                <Type>SwitchParameter<Type>

            .PARAMETER OutUnEscapedJSON
                Removed UnEsacped Char from the JSON Return.
                This will beautify json and clean up the formatting.

                <Type>SwitchParameter<Type>

            .PARAMETER ComputerName
                Remote computer name

                <Type>String<Type>
				
			.PARAMETER Install
                Install the Harvester (This is the default option, without being called)

                <Type>SwitchParameter<Type>
				
			.PARAMETER Uninstall
                Uninstall the Harvester

                <Type>SwitchParameter<Type>
				
			.PARAMETER Path
                The Install path and file name for the Harvester
				
				The default is set to 'C:\Program Files\WinlogBeat623\winlogbeat.exe'

                <Type>String<Type>
				
			.PARAMETER ForceInstall
                Overwrite the current installation and remove and reinstall the service.

                <Type>SwitchParameter<Type>

             .PARAMETER CopyOnly
                Copies the files to the remote system but, does not process an installation

                <Type>SwitchParameter<Type>

            .EXAMPLE
                Install-BluGenieHarvester

                This will copy the Harvester Source to the remote systems destination and install the the Harvester service.

            .EXAMPLE
                Install-BluGenieHarvester -ForceCopy -ForceInstall

                This will copy the Harvester Source to the remote systems destination and install the the Harvester service.
                If the files and service already exist the ForceCopy will overwrite the current files and the ForceInstall will
                remove and install the Harvester service.

            .EXAMPLE
                Install-BluGenieHarvester -Source C:\NewSource -Destination 'C:\Program Files\NewDest'

                This will copy the Harvester Source to the remote systems destination and install the the Harvester service.
                The Source and Destination can be changed.  The default values are below.

                Source:       $ToolsDirectory\Blubin\WinlogBeat
                Destination:  C:\Program Files\WinlogBeat623

            .EXAMPLE
                Install-BluGenieHarvester -Uninstall

                This will remove all the source files for the Harvester and uninstall the service.

            .EXAMPLE
                Install-BluGenieHarvester -ReturnObject

                This will copy the Harvester Source to the remote systems destination and install the the Harvester service
                and return just the Object content

                Note:  The default output is a HashTable

            .EXAMPLE
                Install-BluGenieHarvester -OutUnEscapedJSON

                This will copy the Harvester Source to the remote systems destination and install the the Harvester service
                and the return data will be in a beautified json format

            .OUTPUTS
                System.Collections.Hashtable

            .NOTES

                * Original Author           : Michael Arroyo
                * Original Build Version    : 1905.1001
                * Latest Author             : Michael Arroyo
                * Latest Build Version      : 1907.0201
                * Comments                  :
                * Dependencies              :
                                                ~
                * Build Version Details     :
                                                ~ 1905.1001: * [Michael Arroyo] Posted
                                                ~ 1907.0201: * [Michael Arroyo] Removed the Session Management process.  This is now done by the sub function Send-Item (Only).
                                                             * [Michael Arroyo] Updated the Source String to included all files.  This is no longer copying the directory.
                                                             * [Michael Arroyo] Updated copy command to use Send-Item
                                                             * [Michael Arroyo] Added Start, End, and Time Spane values to the returning JSON
                                                             * [Michael Arroyo] Added parameter CopyOnly.  This will copy the files specified but not process an install
                                                             * [Michael Arroyo] Added a process to allow for low level errors to be sent to the main log.  By default only script fault errors would be sent.
                                                             * [Michael Arroyo] Updated the installation process to use Start-Process
                                                             * [Michael Arroyo] Removed WorkDir variable and updated the Installtion settings
                                                ~ 1907.0501: * [Michael Arroyo] Added Path validation and reporting
                                                             * [Michael Arroyo] Updated the Path check process so if the path doesn't exits an error is processes and passed back to the main report.
        #>
        [Alias('Install-Harvester')]
        Param
        (
            [Parameter(Position = 0)]
            [String]$Source = $('{0}\Blubin\WinlogBeat\*.*' -f $ToolsDirectory),

            [Parameter(Position = 1)]
            [String]$Destination = $('{0}\WinlogBeat623' -f $env:ProgramFiles),

            [Parameter(Position = 2)]
            [Switch]$ForceCopy,

            [Parameter(Position = 3)]
            [Alias('Help')]
            [Switch]$Walkthrough,

            [Parameter(Position = 4)]
            [Switch]$ReturnObject,

            [Parameter(Position = 5)]
            [Switch]$OutUnEscapedJSON,

            [Parameter(Position = 6)]
            [String]$ComputerName,

            [Parameter(Position = 7)]
            [Switch]$Install,

            [Parameter(Position = 8)]
            [Switch]$Uninstall,

            [Parameter(Position = 9)]
            [String]$Path = $('{0}\WinlogBeat623\winlogbeat.exe' -f $env:ProgramFiles),

            [Parameter(Position = 10)]
            [Switch]$ForceInstall = $false,

            [Parameter(Position = 11)]
            [Switch]$CopyOnly
        )

        #region WalkThrough (Ver: 1905.2401)
            <#.NOTES
                
                * Original Author           : Michael Arroyo
                * Original Build Version    : 1902.0505
                * Latest Author             : Michael Arroyo
                * Latest Build Version      : 1905.2401
                * Comments                  : 
                * Dependencies              : 
                                                ~
                * Build Version Details     : 
                                                ~ 1902.0505: * [Michael Arroyo] Posted
                                                ~ 1904.0801: * [Michael Arroyo] Updated the error control for the entire process to support External Help (XML) files
                                                             * [Michael Arroyo] Updated the ** Parameters ** section to bypass the Help indicator to support External Help (XML) files
                                                             * [Michael Arroyo] Updated the ** Options ** section to bypass the Help indicator to support External Help (XML) files
                                                ~ 1905.1302: * [Michael Arroyo] Converted all Where-Object references to PowerShell 2
                                                ~ 1905.2401: * [Michael Arroyo] Updated syntax based on PSAnalyzer
            #>
                If
                (
                    $Walkthrough
                )
                {
                    #region WalkThrough Defined Variables
                        $Function = $($PSCmdlet.MyInvocation.InvocationName)
                        $CurHelp = $(Get-Help -Name $Function -ErrorAction SilentlyContinue)
                        $CurExamples = $CurHelp.examples
                        $CurParameters = $CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -NE 'Walkthrough' } | Select-Object -ExpandProperty Name
                        $CurSyntax = $CurHelp.syntax
                        $LeaveWalkThrough = $false
                    #endregion

                    #region Main Do Until
                        Do
                        {
                            #region Build Current Command
                                $Walk_Command = $('{0}' -f $Function)
                                $CurParameters | ForEach-Object `
                                -Process `
                                {
                                    $CurParameter = $_
                                    $CurValue = $(Get-Item -Path $('Variable:\{0}' -f $CurParameter) -ErrorAction SilentlyContinue).Value
                                    If
                                    (
                                        $CurValue
                                    )
                                    {
                                        Switch
                                        (
                                            $CurValue
                                        )
                                        {
                                            $true
                                            {
                                                $Walk_Command += $(' -{0}' -f $CurParameter)
                                            }
                                            $false
                                            {
                                                
                                            }
                                            Default
                                            {
                                                $Walk_Command += $(' -{0} "{1}"' -f $CurParameter, $CurValue)
                                            }
                                        }
                                    }
                                }
                            #endregion

                            #region Build Main Menu
                                #region Main Header
                                    Write-Host $("`n")
                                    Write-Host $('** Command Syntax **') -ForegroundColor Green
                                    Write-Host $('{0}' -f $($CurSyntax | Out-String).Trim()) -ForegroundColor Cyan

                                    Write-Host $("`n")
                                    Write-Host $('** Current Command **') -ForegroundColor Green
                                    Write-Host $('{0}' -f $Walk_Command) -ForegroundColor Cyan
                                    Write-Host $("`n")
	
									Write-Host $('** Parameters **') -ForegroundColor Green
									$CurParameters | ForEach-Object `
									-Process `
									{
										If
										(
											$_ -ne 'Help'
										)
										{
											Write-Host $('{0}: {1}' -f $_, $(Get-Item -Path Variable:\$_ -ErrorAction SilentlyContinue).Value) -ForegroundColor Cyan
										}
									}
									
									Write-Host $("`n")
						            Write-Host $('** Options **') -ForegroundColor Green
									$CurParameters | ForEach-Object `
									-Process `
									{
										If
										(
											$_ -ne 'Help'
										)
										{
											Write-Host $("Type '{0}' to update value" -f $_) -ForegroundColor Yellow
										}
									}
									Write-Host $("Type 'Help' to view the Description for each Parameter") -ForegroundColor Yellow
                                    Write-Host $("Type 'Examples' to view any Examples") -ForegroundColor Yellow
                                    Write-Host $("Type 'Run' to Run the above (Current Command)") -ForegroundColor Yellow
                                    Write-Host $("Type 'Exit' to Exit without running") -ForegroundColor Yellow

                                    Write-Host $("`n")
                                #endregion

                                #region Main Prompt
                                    $UpdateItem = Read-Host -Prompt 'Please make a selection'
                                #endregion

                                #region Main Switch for menu interaction
                                    switch ($UpdateItem)
                                    {
                                        #region Exit Main menu
                                            'Exit'
                                            {
                                                Return
                                            }
                                        #endregion

                                        #region Pull Parameter Type from the Static Help Parameter (If String)
                                            {
                                                Try
                                                {
                                                    $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'String'
                                                }
                                                Catch
                                                {
                                                    $null
                                                }
                                            }
                                            {
                                                Clear-Host
                                                $null = Remove-Variable -Name $UpdateItem -Force -ErrorAction SilentlyContinue
                                                $null = New-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $(Read-Host -Prompt $('Enter-{0}' -f $UpdateItem)) -Force -ErrorAction SilentlyContinue
                                            }
                                        #endregion

                                        #region Pull Parameter Type from the Static Help Parameter (If Int)
                                            {
                                                Try
                                                {
                                                    $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'Int'
                                                }
                                                Catch
                                                {
                                                    $null
                                                }
                                            }
                                            {
                                                Clear-Host
                                                $IntValue = $(Read-Host -Prompt $('Enter-{0}' -f $UpdateItem))
                                                Switch
                                                (
                                                    $IntValue
                                                )
                                                {
                                                    ''
                                                    {
                                                         $null = Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $null -Force -ErrorAction SilentlyContinue
                                                    }
                                                    {
                                                        $IntValue -match '^[\d\.]+$'
                                                    }
                                                    {
                                                        $null = Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $IntValue -Force -ErrorAction SilentlyContinue
                                                    }
                                                    Default
                                                    {
                                                        Clear-Host
                                                        Write-Host $('({0}) is not a valid [Int].  Please try again.' -f $IntValue) -ForegroundColor Red
                                                        Write-Host $("`n")
                                                        Pause
                                                    }
                                                }
                                            }
                                        #endregion

                                        #region Pull Parameter Type from the Static Help Parameter (If SwitchParameter)
                                            {
                                                Try
                                                {
                                                    $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'SwitchParameter'
                                                }
                                                Catch
                                                {
                                                    $null
                                                }
                                            }
                                            {
                                                Clear-Host
                                                If
                                                (
                                                    $(Get-Item -Path $('Variable:\{0}' -f $UpdateItem)).Value -eq $true
                                                )
                                                {
                                                    $CurToggle = $false
                                                }
                                                Else
                                                {
                                                    $CurToggle = $true
                                                }
                                                $null = Remove-Variable -Name $UpdateItem -Force -ErrorAction SilentlyContinue
                                                $null = New-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $CurToggle -Force
                                                $null = Remove-Variable -Name $CurToggle -Force -ErrorAction SilentlyContinue
                                            }
                                        #endregion

                                        #region Pull Parameter Type from the Static Help Parameter (If ValidateSet)
                                            {
                                                Try
                                                {
                                                    $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'ValidateSet'
                                                }
                                                Catch
                                                {
                                                    $null
                                                }
                                            }
                                            {
                                                $AllowedValues = $($($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem }) | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<ValidateSet\>')[1] -split ','
                                                Clear-Host

                                                Do
                                                {
                                                    Write-Host $('** Validation Set **') -ForegroundColor Green
                                                    $AllowedValues | ForEach-Object -Process { Write-Host $("Type '{0}' to update value" -f $_) -ForegroundColor Yellow}
                                                    Write-Host $("Type 'Back' to go back to the main menu") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Null' to remove the current value") -ForegroundColor Yellow

                                                    Write-Host $("`n")
                                                    $ValidateSetInput = $null
                                                    $ValidateSetInput = Read-Host -Prompt 'Please make a selection'

                                                    Switch
                                                    (
                                                        $ValidateSetInput
                                                    )
                                                    {
                                                        'Back'
                                                        {
                                                            $LeaveValidateSet = $true
                                                        }
                                                        'Null'
                                                        {
                                                            Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $null -ErrorAction SilentlyContinue
                                                            $LeaveValidateSet = $true
                                                        }
                                                        {
                                                            $AllowedValues -contains $ValidateSetInput
                                                        }
                                                        {
                                                            Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $ValidateSetInput -ErrorAction SilentlyContinue
                                                            $LeaveValidateSet = $true
                                                        }
                                                        Default
                                                        {
                                                            Clear-Host
                                                            Write-Host $('({0}) is not a valid option.  Please try again.' -f $ValidateSetInput) -ForegroundColor Red
                                                            Write-Host $("`n")
                                                            $LeaveValidateSet = $false
                                                        }
                                                    }
                                                }
                                                Until
                                                (
                                                    $LeaveValidateSet -eq $true
                                                )
                                            }
                                        #endregion

                                        #region Pull the Help information for each Parameter and Dynamically build the menu system
                                            'Help'
                                            {
                                                Clear-Host
                                                $LeaveHelpInput = $false

                                                Do
                                                {
                                                    Write-Host $('** Help Parameter Information **') -ForegroundColor Green
                                                    $CurParameters | ForEach-Object -Process { Write-Host $("Type '{0}' to view Help" -f $_) -ForegroundColor Yellow}
                                                    Write-Host $("Type 'All' to list all Parameters and Help Information") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Help' to view the General Help information") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Full' to view the Detailed Help information") -ForegroundColor Yellow
                                                    Write-Host $("Type 'ShowWin' to view the Detailed Help information in a Win-Form") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Back' to go back to the main menu") -ForegroundColor Yellow

                                                    Write-Host $("`n")
                                                    $HelpInput = $null
                                                    $HelpInput = Read-Host -Prompt 'Please make a selection'

                                                    Switch
                                                    (
                                                        $HelpInput
                                                    )
                                                    {
                                                        'Back'
                                                        {
                                                            $LeaveHelpInput = $true
                                                        }
                                                        {
                                                            $CurParameters -contains $HelpInput
                                                        }
                                                        {
                                                            $CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $HelpInput } | Out-String
                                                            Pause
                                                        }
                                                        'All'
                                                        {
                                                            $CurHelp.parameters.parameter | Out-String
                                                            Pause
                                                        }
                                                        'Help'
                                                        {
                                                            Get-Help -Name $Function | Out-String
                                                            Pause
                                                        }
                                                        'Full'
                                                        {
                                                            Get-Help -Name $Function -Full | Out-String
                                                            Pause
                                                        }
                                                        'ShowWin'
                                                        {
                                                            #Get-Help -Name $Function -ShowWindow  ##This was commented out for PS2 compatibility
                                                            Pause
                                                        }
                                                        Default
                                                        {
                                                            Clear-Host
                                                            Write-Host $('({0}) is not a valid option.  Please try again.' -f $HelpInput) -ForegroundColor Red
                                                            Write-Host $("`n")
                                                        }
                                                    }
                                                }
                                                Until
                                                (
                                                    $LeaveHelpInput -eq $true
                                                )
                                            }
                                        #endregion

                                        #region Pull the Examples information and Dynamically build the menu system
                                            'Examples'
                                            {
                                                Clear-Host
                                                $LeaveExampleInput = $false
                                                $CurExamplesList = $($CurHelp.examples.example | Select-Object -ExpandProperty Title) -replace ('-') -replace (' ') -replace ('EXAMPLE')

                                                Do
                                                {
                                                    Write-Host $('** Examples **') -ForegroundColor Green
                                                    $CurExamplesList | ForEach-Object -Process { Write-Host $("Type '{0}' to view Example{0}" -f $_) -ForegroundColor Yellow}
                                                    Write-Host $("Type 'All' to list all Examples") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Back' to go back to the main menu") -ForegroundColor Yellow

                                                    Write-Host $("`n")
                                                    $ExampleInput = $null
                                                    $ExampleInput = Read-Host -Prompt 'Please make a selection'

                                                    Switch
                                                    (
                                                        $ExampleInput
                                                    )
                                                    {
                                                        'Back'
                                                        {
                                                            $LeaveExampleInput = $true
                                                        }
                                                        {
                                                            $CurExamplesList -contains $ExampleInput
                                                        }
                                                        {
                                                            $CurHelp.examples.example | Where-Object -FilterScript { $_.Title -Match $('EXAMPLE\s{0}' -f $ExampleInput) }
                                                            Pause
                                                        }
                                                        'All'
                                                        {
                                                            $CurHelp.examples.example
                                                            Pause
                                                        }
                                                        Default
                                                        {
                                                            Clear-Host
                                                            Write-Host $('({0}) is not a valid option.  Please try again.' -f $ExampleInput) -ForegroundColor Red
                                                            Write-Host $("`n")
                                                        }
                                                    }
                                                }
                                                Until
                                                (
                                                    $LeaveExampleInput -eq $true
                                                )
                                            }
                                        #endregion

                                        #region Run the Current Command
                                            'Run'
                                            {
                                                #Exiting Switch and Running set Parameters
                                                $LeaveWalkThrough = $true
                                            }
                                        #endregion

                                        #region Default (Error Control)
                                            Default
                                            {
                                                Clear-Host
                                                Write-Host $('({0}) is not a valid option.  Please try again.' -f $UpdateItem) -ForegroundColor Red
                                                Write-Host $("`n")
                                                $LeaveWalkThrough = $false
                                                Pause
                                            }
                                        #endregion
                                    }
                                #endregion
                            #endregion
                        }
                        Until
                        (
                            $LeaveWalkThrough -eq $true
                        )
                    #endregion
                }
            #endregion

        #region Create Hash
            $HashReturn = @{ }
            $HashReturn.Harvester = @{ }
            $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn.Harvester.StartTime = $($StartTime).DateTime
        #endregion Create Hash

        #region Install Check
            If
            (
                $(-Not $Uninstall) -and $(-Not $CopyOnly)
            )
            {
                $Install = $true
            }
        #endregion Install Check

        #region Process Check
            $HashReturn.Harvester.Is64BitOperatingSystem = $([System.Environment]::Is64BitOperatingSystem)
            $HashReturn.Harvester.HarvesterSet = $Path
        #endregion Process Check

        #region Parameter Set Results
            $HashReturn.Harvester.ParameterSetResults = $PSBoundParameters
        #endregion Parameter Set Results

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
                    $HashReturn.Harvester.ParameterCheck = @{
                        'Parameter' = 'Source'
                        'Status'    = $false
                        'Error'     = $($Error.Exception | out-string).trim()
                    }
                    Break
                }
                {$Destination -eq $null}
                {
                    If
                    (
                        $Install
                    )
                    {
                        Write-Error -Message 'No Destination information specified' -ErrorAction SilentlyContinue
                        $HashReturn.Harvester.ParameterCheck = @{
                            'Parameter' = 'Destination'
                            'Status'    = $false
                            'Error'     = $($Error.Exception | out-string).trim()
                        }
                        Break
                    }
                }
            }

            if
            (
                $Error
            )
            {
                $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
                $HashReturn.Harvester.EndTime = $($($EndTime).DateTime)
                $HashReturn.Harvester.ElapsedTime = $($(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds)

                 #region Output
                    If
                    (
                        $ReturnObject
                    )
                    {
                        Return New-Object -TypeName PSObject -Property $($HashReturn.Harvester.ParameterCheck)
                    }
                    Else
                    {
                        If
                        (
                            -Not $OutUnEscapedJSON
                        )
                        {
                            Return $HashReturn
                        }
                        Else
                        {
                            Return $($HashReturn | ConvertTo-Json -Depth 10 | ForEach-Object `
                                -Process `
                                {
                                    [regex]::Unescape($_)
                                }
                            )
                        }
                    }
                #endregion Output
            }
        #endregion Parameter Check

        #region Copy Harvester
            If
            (
                $(-not $Install) -and $(-not $Uninstall)
            )
            {
                #region Build Copy Command
                    $ArrParamList = New-Object -TypeName PSObject -Property @{
                        'Source'      = $Source
                        'Destination' = $Destination
                        'Container'   = $false
                        'Recurse'     = $true
                        'Force'       = $ForceCopy
                        'ToSession'   = $true
                        'ComputerName'= $ComputerName
                    }

                    $NewCommand = $(Build-Command -Name 'Send-Item' -BoundParameters $ArrParamList -ErrorAction SilentlyContinue)

                    $HashReturn.Harvester.Command = $($NewCommand | Out-String) -replace ('Send\-Item\s','')
                #endregion Build Copy Command

                #region Process Copy Command
                    If
                    (
                        $NewCommand
                    )
                    {
                        $Error.Clear()
                        $null = Invoke-Command -ScriptBlock $NewCommand -ErrorAction SilentlyContinue

                        if
                        (
                            -Not $Error
                        )
                        {
                            $HashReturn.Harvester.Process = @{
                                'Status'    = $true
                                'Comment'   = $null
                                'Error'     = $null
                            }
                        }
                        else
                        {
                            $HashReturn.Harvester.Process = @{
                                'Status'    = $false
                                'Comment'   = $null
                                'Error'     = $($Error[0].Exception | out-string).trim()
                            }
                        }
                    }
                #endregion Process Copy Command
            }
        #endregion Copy Harvester

        #region Install Harvester
            If
            (
                $Install -and $(-not $Uninstall) -and $(-not $CopyOnly)
            )
            {
                #region Validate Path
                    $HashReturn.Harvester.ParameterSetResults += @{
                        'PathFound' = $(Test-Path -Path $Path -ErrorAction SilentlyContinue)
                    }
                #endregion Validate Path

                #region Install HashTable Header
                    $HashReturn.Harvester.Install = @{ 
                        Status = $false
                        Comment = 'Processing Install'
                        PathFound = $false
                        PreviouslyInstalled = $false
                        ForceInstall = $ForceInstall
                        Error = ''
                    }
                #endregion Install HashTable Header

                #region Harvester Check
                    If
                    (
                        $(Test-Path -Path $Path -ErrorAction SilentlyContinue)
                    )
                    {
                        $HashReturn.Harvester.Install.PathFound = $true

                        #region Harvester Install Check
                            If
                            (
                                $(Get-Service -Name winlogbeat -ErrorAction SilentlyContinue)
                            )
                            {
                                $HashReturn.Harvester.Install.PreviouslyInstalled = $true
                            }
                        #endregion Harvester Install Check

                        #region Harvester Install
                            If
                            (
                                $($HashReturn.Harvester.Install.PreviouslyInstalled)
                            )
                            {
                                If
                                (
                                    $ForceInstall
                                )
                                {
                                    $Error.Clear()
                                    $HarvesterService = Get-WmiObject -Class Win32_Service -Filter "name='winlogbeat'"
                                    $HarvesterService.StopService() | Out-Null -ErrorAction SilentlyContinue
                                    Start-Sleep -Seconds 2
                                    $HarvesterService.delete() | Out-Null -ErrorAction SilentlyContinue

                                    $null = New-Service -name Winlogbeat `
                                      -DisplayName Winlogbeat `
                                      -BinaryPathName "`"$Path`" -c `"$Destination\winlogbeat.yml`" -path.home `"$Destination`" -path.data `"$($env:ProgramData)\$($($Destination) | Split-Path -Leaf)`" -path.logs `"$($env:ProgramData)\$($($Destination) | Split-Path -Leaf)\logs`"" -ErrorAction SilentlyContinue
                                }
                            }
                            Else
                            {
                                $Error.Clear()
                                $null = New-Service -name Winlogbeat `
                                    -DisplayName Winlogbeat `
                                    -BinaryPathName "`"$Path`" -c `"$Destination\winlogbeat.yml`" -path.home `"$Destination`" -path.data `"$($env:ProgramData)\$($($Destination) | Split-Path -Leaf)`" -path.logs `"$($env:ProgramData)\$($($Destination) | Split-Path -Leaf)\logs`"" -ErrorAction SilentlyContinue
                            }
                        #endregion Harvester Install

                        #region Harvester Install ReCheck
                            If
                            (
                                $(Get-Service -Name winlogbeat)
                            )
                            {
                                $null = Start-Service -Name Winlogbeat
                                Start-Sleep -Seconds 2
                                $HashReturn.Harvester.Install.Status = $(Get-Service -Name winlogbeat -ErrorAction SilentlyContinue) | Select -Property `
                                    Name,
                                    @{Name='Status';Expression={$($_.Status | Out-String -ErrorAction SilentlyContinue).Trim()}},
                                    @{Name='StartType';Expression={$($_.StartType | Out-String -ErrorAction SilentlyContinue).Trim()}}
                            }
                        #endregion Harvester Install ReCheck

                        #region Harvester Error Check
                            If
                            (
                                $Error
                            )
                            {
                                $HashReturn.Harvester.Install.Error = $($Error.exception | Out-String).Trim()
                            }
                        #endregion Harvester Error Check
                    }
                    Else
                    {
                        $(Get-Item -Path $Path)
                    }
                #endregion Harvester Check
            }
        #endregion Install Harvester

        #region UnInstall Harvester
            If
            (
                $Uninstall -and $(-not $CopyOnly)
            )
            {
                #region Uninstall HashTable Header
                    $HashReturn.Harvester.Uninstall = @{ 
                        Status = $false
                        Comment = 'Processing Uninstall'
                        PathFound = $false
                        CurrentlyRunning = $false
                        Error = ''
                    }
                #endregion Uninstall HashTable Header

                #region Harvester Check
                    If
                    (
                        $(Test-Path -Path $Path -ErrorAction SilentlyContinue)
                    )
                    {
                        $HashReturn.Harvester.Uninstall.PathFound = $true

                        #region Harvester Uninstall Check
                            If
                            (
                                $(Get-Service -Name winlogbeat -ErrorAction SilentlyContinue)
                            )
                            {
                                $HashReturn.Harvester.Uninstall.CurrentlyRunning = $true
                            }
                        #endregion Harvester Uninstall Check

                        #region Harvester Uninstall
                            If
                            (
                                $($HashReturn.Harvester.Uninstall.CurrentlyRunning)
                            )
                            {
                                $Error.Clear()
                                $HarvesterService = Get-WmiObject -Class Win32_Service -Filter "name='winlogbeat'"
                                $HarvesterService.StopService() | Out-Null -ErrorAction SilentlyContinue
                                Start-Sleep -Seconds 2
                                $HarvesterService.delete() | Out-Null -ErrorAction SilentlyContinue

                                $null = Remove-Item -Path $Destination -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
                            }
                            Else
                            {
                                $Error.Clear()
                                $null = Remove-Item -Path $Destination -Force -Recurse -Confirm:$false -ErrorAction SilentlyContinue
                            }
                        #endregion Harvester Uninstall

                        #region Harvester Error Check
                            If
                            (
                                $Error
                            )
                            {
                                $HashReturn.Harvester.Uninstall.Error = $($Error.exception | Out-String).Trim()
                            }
                        #endregion Harvester Error Check

                        #region Harvester Uninstall ReCheck
                            If
                            (
                                -Not $(Get-Service -Name winlogbeat -ErrorAction SilentlyContinue)
                            )
                            {
                                $HashReturn.Harvester.Uninstall.Status = 'Uninstall Successful'
                            }
                        #endregion Harvester Uninstall ReCheck
                    }
                    ElseIf
                    (
                        $(Get-Service -Name winlogbeat -ErrorAction SilentlyContinue)
                    )
                    {
                        $HashReturn.Harvester.Uninstall.Installed = $true

                        #region Harvester Uninstall
                            $Error.Clear()
                            $HarvesterService = Get-WmiObject -Class Win32_Service -Filter "name='winlogbeat'"
                            $HarvesterService.StopService() | Out-Null -ErrorAction SilentlyContinue
                            Start-Sleep -Seconds 2
                            $HarvesterService.delete() | Out-Null -ErrorAction SilentlyContinue
                        #endregion Harvester Uninstall

                        #region Harvester Error Check
                            If
                            (
                                $Error
                            )
                            {
                                $HashReturn.Harvester.Uninstall.Error = $($Error.exception | Out-String).Trim()
                            }
                        #endregion Harvester Error Check

                        #region Harvester Uninstall ReCheck
                            If
                            (
                                -Not $(Get-Service -Name winlogbeat -ErrorAction SilentlyContinue)
                            )
                            {
                                $HashReturn.Harvester.Uninstall.Status = 'Uninstall Successful'
                            }
                            $Error.Clear()
                        #endregion Harvester Uninstall ReCheck
                    }
                    Else
                    {
                        $HashReturn.Harvester.Uninstall.Status = 'Not Installed'
                    }
                #endregion Harvester Check
            }
        #endregion UnInstall Harvester

        #region Output
            $Error.Clear()

            $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn.Harvester.EndTime = $($($EndTime).DateTime)
            $HashReturn.Harvester.ElapsedTime = $($(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds)

            If
            (
                $ReturnObject
            )
            {
                Return New-Object -TypeName PSObject -Property $($HashReturn.Harvester.Install)
            }
            Else
            {
                If
                (
                    -Not $OutUnEscapedJSON
                )
                {
                    Return $HashReturn
                }
                Else
                {
                    Return $($HashReturn | ConvertTo-Json -Depth 10 | ForEach-Object `
                        -Process `
                        {
                            [regex]::Unescape($_)
                        }
                    )
                }
            }
        #endregion Output
    }
#endregion Install-BluGenieHarvester (Function)