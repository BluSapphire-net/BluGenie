#region Invoke-BluGenieProcess (Function)
    Function Invoke-BluGenieProcess
    {
            <#
                .SYNOPSIS
                    Invoke-BluGenieProcess will kick off the multi threaded job management engine

                .DESCRIPTION
                    Invoke-BluGenieProcess will kick off the multi threaded job management engine

                .PARAMETER System
                    Computer Name or IP Address of the System you want to manage

                    <Type>String<Type>

                .PARAMETER Range
                    IP Address Range of the Systems you want to manage

                    <Type>String<Type>

                .PARAMETER Command
                    The Commands you would like to execute on the remote computer

                    <Type>String<Type>

                .PARAMETER JobID
                    The Job Identifier

                    <Type>String<Type>

                .PARAMETER ThreadCount
                    How many remote systems do you want to control at once.
                    The default is ( 50 )

                    <Type>Int<Type>

                .PARAMETER Walkthrough
                    An automated process to walk through the current function and all the parameters

                    <Type>SwitchParameter<Type>

                .PARAMETER Trap
                    Trap the return data in the Windows Event Log

                    <Type>SwitchParameter<Type>

                .PARAMETER ServiceJob
                    Convert the job into a Service Job

                    <Type>SwitchParameter<Type>

                .PARAMETER JobTimeout
                    How long a remote systems connection can stay open before it is automatically closed.
                    The default is ( 120 min )

                    Note:  If a job has reached it's timeout value, the session is closed and no data is captured unless you use the -Trap parameter.
                            The -Trap parameter will log all the data on the remote host's <System> Drive.

                    <Type>Int<Type>

                .EXAMPLE
                    Invoke-BluGenieProcess -System 'Computer1' -Command 'Get-SystemInfo' -JobID '12345'

                    This will run the command (Get-SystemInfo) on the remote system "Computer1".  All data will be logged in a directory with the assigned JOBID as the name.

                .EXAMPLE
                    Invoke-BluGenieProcess -Range 10.10.1.50-10.10.1.250 -Command 'Get-SystemInfo'

                    This will run the command (Get-SystemInfo) on all systems in the IP range of [10.10.1.50 -> 250].  All data will be logged in a directory with the assigned Date and Time.

                .EXAMPLE
                    Invoke-BluGenieProcess -System 'Computer1' -Command 'Get-SystemInfo' -Trap

                    This will run the command (Get-SystemInfo) on the remote system "Computer1".  The job data will also be trapped and logged on the remote hosts Event log.

                    Event Log Details:
                        LogName = Application
                        Source  = BluGenie
                        Type    = Information
                        ID      = 7114

                .EXAMPLE
                    Run -System 'Computer1' -Command 'Get-SystemInfo' -JobTimeout 5

                    This will run the command (Get-SystemInfo) on the remote system "Computer1".
                    The job has a timed session of 5 minutes.  After that the session will be automatically closed.

                    Note:  If a job has reached it's timeout value, the session is closed and no data is captured unless you use the -Trap parameter.
                            The -Trap parameter will log all the data on the remote host's <System> Drive.

                .OUTPUTS


                .NOTES

                    * Original Author           : Michael Arroyo
                    * Original Build Version    : 1905.0518
                    * Latest Author             : Michael Arroyo
                    * Latest Build Version      : 21.02.0101
                    * Comments                  :
                    * Dependencies              :
                                                    ~
                    * Build Version Details     :
                        ~ 1902.1401:* [Michael Arroyo] Posted
                        ~ 1902.1801:* [Michael Arroyo] Updated the Source path to a new link.  The old link was invalid.
                        ~ 1905.0518:* [Michael Arroyo] Add Expand-Archive command for PowerShell 2,3,and,4
                                    * [Michael Arroyo] Update all Where-Object references to PowerShell 2
                                    * [Michael Arroyo] Added the Dynamic Help Function (Ver: 1905.1302)
                        ~ 1908.0201:* [Michael Arroyo] Added the Parallel and Post variables so they can be passed to the remote agent.
                        ~ 1908.2001:* [Michael Arroyo] Added the ( Trap ) parameter to capture job data to the remote hosts event log
                        ~ 1909.2001:* [Michael Arroyo] Updated control over the Timeout from Minutes to Seconds.  The default parameter excepts
                                                        seconds only and I wanted to leave it that way but make it easier to manage from the
                                                        command line.
                        ~ 1909.2001:* [Michael Arroyo] Updated the JSON return job, per node, to be managed in a specific diretory (InProgress,
                                                            Completed, and CompletedWithErrors)
                                        * InProgress - Default directory.  Each node will get a specific .JSON file
                                            created as the parent identifier to show where the process is currently running.
                                        * Completed - If the Job for that host is successful the identifer will be
                                            updated with the return data and moved to the completed directory
                                        * CompletedWithErrors  - If the Job for that host has completed but with errors, the
                                            identifer will be updated with the return data and moved to the CompletedWithErrors
                                            directory
                        ~ 1909.2301:* [Michael Arroyo] Updated the JSON return job, per node, to be managed in a specific diretory - Added two
                                                            new directories (OutOfMemory, and TimedOut)
                                        * OutOfMemory - Default directory.  Each node will get a specific .JSON file
                                            created as the parent identifier to show where the process is currently running.
                                        * TimedOut - If the Job for that host is successful the identifer will be
                                            updated with the return data and moved to the completed directory
                        ~ 2002.2401:* [Michael Arroyo] Consolidated the OutPut Directories by removing
                                        * CompletedWithErrors
                                        * OutOfMemory
                                        * TimedOut
                        ~ 2005.1801:* [Michael Arroyo] Removed the JSoNJob parameter.  This options is no longer
                                                            controlled by this function.
                        ~ 21.02.0101* [Michael Arroyo] Added Parameter ServiceJob
            #>
            [CmdletBinding(DefaultParameterSetName='Default',
                            SupportsShouldProcess=$true,
                            PositionalBinding=$true)]
            [Alias('Run','Invoke-Process')]
            Param
            (
            [Parameter(ValueFromPipeline=$true,
                        ValueFromPipelineByPropertyName=$true,
                        Position=0,
                        ParameterSetName='Default')]
            [Alias('CN','__Server','IPAddress','Server','Computer','Name','ComputerName')]
            [String[]]$System = $(
                If
                (
                    -Not $global:ConsoleSystems
                )
                {
                    [System.Collections.ArrayList]$global:ConsoleSystems = @()
                }

                Return $global:ConsoleSystems
            ),

            [Parameter(ParameterSetName='Range')]
            [String[]]$Range = $(
                If
                (
                    -Not $global:ConsoleRange
                )
                {
                    [System.Collections.ArrayList]$global:ConsoleRange = @()
                }

                Return $global:ConsoleRange
            ),

            [Parameter(Position=1,
                        ParameterSetName='Range')]
            [Parameter(ParameterSetName='Default')]
            [String[]]$Command = $(
                If
                (
                    -Not $global:ConsoleCommands
                )
                {
                    [System.Collections.ArrayList]$global:ConsoleCommands = @()
                }

                Return $global:ConsoleCommands
            ),

            [Parameter(Position=2,
                        ParameterSetName='Range')]
            [Parameter(ParameterSetName='Default')]
            [String]$JobID = $(
                If
                (
                    -Not $global:ConsoleJobID
                )
                {
                    [String]$global:ConsoleJobID = ''
                }

                Return $global:ConsoleJobID
            ),

            [Parameter(ParameterSetName='Range')]
            [Parameter(ParameterSetName='Default')]
            [int]$ThreadCount = $(
                If
                (
                    -Not $global:ConsoleThreadCount
                )
                {
                    [Int]$global:ConsoleThreadCount = 50
                }

                Return $global:ConsoleThreadCount
            ),

            [Parameter(ParameterSetName='Range')]
            [Parameter(ParameterSetName='Default')]
            [Alias('Help')]
            [Switch]$Walkthrough,

            [Parameter(ParameterSetName='Range')]
            [Parameter(ParameterSetName='Default')]
            [Switch]$Trap = $(
                If
                (
                    -Not $global:ConsoleTrap
                )
                {
                    [Switch]$global:ConsoleTrap = $false
                }

                Return $global:ConsoleTrap
            ),

            [Parameter(ParameterSetName='Range')]
            [Parameter(ParameterSetName='Default')]
            [Int]$JobTimeout = $(
                If
                (
                    -Not $global:ConsoleJobTimeout
                )
                {
                    [Int]$global:ConsoleJobTimeout = 120
                }

                Return $global:ConsoleJobTimeout
            )
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
                                                                Get-Help -Name $Function -ShowWindow
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

        #region Variables
            If
            (
                $global:ConsoleParallelCommands
            )
            {
                $InvokeParallelCommands = $global:ConsoleParallelCommands
            }

            If
            (
                $global:ConsolePostCommands
            )
            {
                $InvokePostCommands = $global:ConsolePostCommands
            }

            If
            (
                -Not $JobID
            )
            {
                $JobID = $('{0}.{1}{2}' -f $(Get-Date -f MM.dd.yyyy),$(Get-Date -UFormat %R).Replace(':','.'),$(Get-Date -f .ss))
            }
        #endregion Variables

        #region Function Variables

            $CurScriptBlock = $SendScriptBlock
            $JobTranscriptsDir = $(Join-Path -Path $TranscriptsDir -ChildPath $JobID)

        #endregion

        #region Create New Job ID directory

            Try
            {
                $null = New-Item -Path $JobTranscriptsDir -Force -ItemType Directory -ErrorAction Stop
                $null = New-Item -Path $('{0}\Completed' -f $JobTranscriptsDir) -Force -ItemType Directory -ErrorAction Stop
                #$null = New-Item -Path $('{0}\CompletedWithErrors' -f $JobTranscriptsDir) -Force -ItemType Directory -ErrorAction Stop
                $null = New-Item -Path $('{0}\InProgress' -f $JobTranscriptsDir) -Force -ItemType Directory -ErrorAction Stop
                #$null = New-Item -Path $('{0}\OutOfMemory' -f $JobTranscriptsDir) -Force -ItemType Directory -ErrorAction Stop
                #$null = New-Item -Path $('{0}\TimedOut' -f $JobTranscriptsDir) -Force -ItemType Directory -ErrorAction Stop
                $TranscriptsFile | Select-Object -Property @{ Name='Path';Expression={$_}} | ConvertTo-Json | Out-File -FilePath `
                    $('{0}\TransID.log' -f $JobTranscriptsDir) -Force -ErrorAction Stop
            }
            Catch
            {
                #Write-host "Error creating Job ID Directory - Update code to support this"
                $null
            }

        #endregion

        #region Manage Range of IP Address
            If
            (
                $Range
            )
            {
                $Range | ForEach-Object `
                -Process `
                {
                    $CurRange = $_
                    $ipStart,$ipEnd = $CurRange.Split('-')
                    $System += $(Get-IPrange -start $ipStart -end $ipEnd) | Select-Object -Unique
                }
            }
        #endregion

        #region System variable Check

            If #Check on this code.......
            (
                -Not $System
            )
            {
                $System = Read-host -Prompt 'Hostname or IPAddress'
            }

        #endregion

        #region Process Task
        If
        (
            $System
        )
        {
            $ParamArgs = @{}
            $ParamArgs.ScriptDirectory = $ScriptDirectory
            $ParamArgs.TranscriptsDir = $TranscriptsDir
            $ParamArgs.ToolsDirectory = $ToolsDirectory
            $ParamArgs.JobIDDir = $JobTranscriptsDir
            $ParamArgs.command = $Command
            $ParamArgs.ToolsConfig =  $ToolsConfig.CopyTools
            $ParamArgs.RemoteWSManConfig = $ToolsConfig.RemoteWSManConfig

            $ParamArgs.remoteparallelcommands = New-Object -TypeName System.Collections.ArrayList

            If
            (
                $InvokeParallelCommands
            )
            {
                $InvokeParallelCommands | ForEach-Object `
                -Process `
                {
                    $null = $ParamArgs.remoteparallelcommands.Add($_)
                }
            }

            $ParamArgs.remotepostcommands = $InvokePostCommands
            $ParamArgs.JSONJob = $JSONJob
            $ParamArgs.JobID = $JobID
            $ParamArgs.BGAgentFunctions = $BGAgent
            $ParamArgs.Trap = $Trap

            If
            (
                #$host.name -match 'ISE'
                $global:BGDebugger
            )
            {
                $ParamArgs.Debug = $true
            }
            Else
            {
                $ParamArgs.Debug = $false
            }

            $ParamArgs.BGRemoveMods = $BGRemoveMods
            $ParamArgs.BGUpdateMods = $BGUpdateMods
            $ParamArgs.BGServiceJob = $BGServiceJob
            If
            (
                $BGServiceJob
            )
            {
                $ParamArgs.BGServiceJobFile = Get-BluGenieSettings | ConvertFrom-Json | Select-Object -Property * -ExcludeProperty 'systems','range','cores','memory','nosetres','noexit','nobanner','threadcount','priority' | ConvertTo-Json -Compress
            }

            $Global:CurLogFile = $('{0}\{1}.csv' -f $JobTranscriptsDir,$JobID)
            $Global:CurLogDirectory = $(Split-Path -Path $CurLogFile -Parent -ErrorAction SilentlyContinue)

            # *** Remove Comment to export the Parameters to the local file system for review ***
            #$ParamArgs | Out-File -FilePath C:\LocalParams.txt -Force

            $System | ForEach-Object `
            -Process `
            {
                $CurSystemTag = $_
                $Null = New-Item -Path $('{0}\InProgress\{1}.JSON' -f $JobTranscriptsDir, $CurSystemTag) -ItemType File -Force -ErrorAction SilentlyContinue
            }

            $ConvertTimout2Min = $JobTimeout * 60
            Invoke-Parallel -ScriptBlock $InvokeScriptBlock -parameter $ParamArgs -InputObject $System -LogFile $('{0}\{1}.csv' -f $JobTranscriptsDir,$JobID) -ImportFunctions -Quiet -Throttle $ThreadCount -RunspaceTimeout $ConvertTimout2Min
            #$MyReturn
        }
        #endregion
    }
#endregion Invoke-BluGenieProcess (Function)