#Requires -Version 3
#region Invoke-BluGenieParallel (Function)
function Invoke-BluGenieParallel
{
    <#
    .SYNOPSIS
        Function to control parallel processing using runspaces

    .DESCRIPTION
        Function to control parallel processing using runspaces

            Note that each runspace will not have access to variables and commands loaded in your session or in other runspaces by default.
            This behaviour can be changed with parameters.

    .PARAMETER ScriptFile
        File to run against all input objects.  Must include parameter to take in the input object, or use $args.  Optionally, include parameter to take in parameter.  Example: C:\script.ps1

        <Type>String<Type>

    .PARAMETER ScriptBlock
        Scriptblock to run against all computers.

        You may use $Using:<Variable> language in PowerShell 3 and later.

            The parameter block is added for you, allowing behaviour similar to foreach-object:
                Refer to the input object as $_.
                Refer to the parameter parameter as $parameter

        <Type>String<Type>

    .PARAMETER InputObject
        Run script against these specified objects.

        <Type>String<Type>

    .PARAMETER Parameter
        This object is passed to every script block.  You can use it to pass information to the script block; for example, the path to a logging folder

            Reference this object as $parameter if using the scriptblock parameterset.

        <Type>String<Type>

    .PARAMETER ImportVariables
        If specified, get user session variables and add them to the initial session state

        <Type>SwitchParameter<Type>

    .PARAMETER ImportModules
        If specified, get loaded modules and pssnapins, add them to the initial session state

        <Type>SwitchParameter<Type>

    .PARAMETER ImportFunctions
        If specified, get loaded functions, and add them to the initial session state

        <Type>SwitchParameter<Type>

    .PARAMETER Throttle
        Maximum number of threads to run at a single time.

        <Type>Int<Type>

    .PARAMETER SleepTimer
        Milliseconds to sleep after checking for completed runspaces and in a few other spots.  I would not recommend dropping below 200 or increasing above 500

        <Type>Int<Type>

    .PARAMETER RunspaceTimeout
        Maximum time in seconds a single thread can run.  If execution of your code takes longer than this, it is disposed.  Default: 0 (seconds)

        WARNING:  Using this parameter requires that maxQueue be set to throttle (it will be by default) for accurate timing.  Details here:
        http://gallery.technet.microsoft.com/Run-Parallel-Parallel-377fd430

        <Type>Int<Type>

    .PARAMETER NoCloseOnTimeout
        Do not dispose of timed out tasks or attempt to close the runspace if threads have timed out. This will prevent the script from hanging in certain situations where threads become non-responsive, at the expense of leaking memory within the PowerShell host.

        <Type>Int<Type>

    .PARAMETER MaxQueue
        Maximum number of powershell instances to add to runspace pool.  If this is higher than $throttle, $timeout will be inaccurate

        If this is equal or less than throttle, there will be a performance impact

        The default value is $throttle times 3, if $runspaceTimeout is not specified
        The default value is $throttle, if $runspaceTimeout is specified

        <Type>Int<Type>

    .PARAMETER LogFile
        Path to a file where we can log results, including run time for each thread, whether it completes, completes with errors, or times out.

        <Type>String<Type>

    .PARAMETER AppendLog
        Append to existing log

        <Type>SwitchParameter<Type>

    .PARAMETER Quiet
        Disable progress bar

        <Type>SwitchParameter<Type>

    .PARAMETER Walkthrough
        An automated process to walk through the current function and all the parameters

        <Type>SwitchParameter<Type>

    .EXAMPLE
        Each example uses Test-ForPacs.ps1 which includes the following code:
            param($computer)

            if(test-connection $computer -count 1 -quiet -BufferSize 16){
                $object = [pscustomobject] @{
                    Computer=$computer;
                    Available=1;
                    Kodak=$(
                        if((test-path "\\$computer\c$\users\public\desktop\Kodak Direct View Pacs.url") -or (test-path "\\$computer\c$\documents and settings\all users\desktop\Kodak Direct View Pacs.url") ){"1"}else{"0"}
                    )
                }
            }
            else{
                $object = [pscustomobject] @{
                    Computer=$computer;
                    Available=0;
                    Kodak="NA"
                }
            }

            $object

    .EXAMPLE
        Invoke-BluGenieParallel -scriptfile C:\public\Test-ForPacs.ps1 -inputobject $(get-content C:\pcs.txt) -runspaceTimeout 10 -throttle 10

            Pulls list of PCs from C:\pcs.txt,
            Runs Test-ForPacs against each
            If any query takes longer than 10 seconds, it is disposed
            Only run 10 threads at a time

    .EXAMPLE
        Invoke-BluGenieParallel -scriptfile C:\public\Test-ForPacs.ps1 -inputobject c-is-ts-91, c-is-ts-95

            Runs against c-is-ts-91, c-is-ts-95 (-computername)
            Runs Test-ForPacs against each

    .EXAMPLE
        $stuff = [pscustomobject] @{
            ContentFile = "windows\system32\drivers\etc\hosts"
            Logfile = "C:\temp\log.txt"
        }

        $computers | Invoke-BluGenieParallel -parameter $stuff {
            $contentFile = join-path "\\$_\c$" $parameter.contentfile
            Get-Content $contentFile |
                set-content $parameter.logfile
        }

        This example uses the parameter argument.  This parameter is a single object.  To pass multiple items into the script block, we create a custom object (using a PowerShell v3 language) with properties we want to pass in.

        Inside the script block, $parameter is used to reference this parameter object.  This example sets a content file, gets content from that file, and sets it to a predefined log file.

    .EXAMPLE
        $test = 5
        1..2 | Invoke-BluGenieParallel -ImportVariables {$_ * $test}

        Add variables from the current session to the session state.  Without -ImportVariables $Test would not be accessible

    .EXAMPLE
        $test = 5
        1..2 | Invoke-BluGenieParallel {$_ * $Using:test}

        Reference a variable from the current session with the $Using:<Variable> syntax.  Requires PowerShell 3 or later. Note that -ImportVariables parameter is no longer necessary.

    .FUNCTIONALITY
        PowerShell Language

    .NOTES
        Credit to Boe Prox for the base runspace code and $Using implementation
            http://learn-powershell.net/2012/05/10/speedy-network-information-query-using-powershell/
            http://gallery.technet.microsoft.com/scriptcenter/Speedy-Network-Information-5b1406fb#content
            https://github.com/proxb/PoshRSJob/

        Credit to T Bryce Yehl for the Quiet and NoCloseOnTimeout implementations

        Credit to Sergei Vorobev for the many ideas and contributions that have improved functionality, reliability, and ease of use
                
                * Original Author           : 
                * Original Build Version    : 
                * Latest Author             : Michael Arroyo
                * Latest Build Version      : 20.05.2101
                * Comments                  : 
                * Dependencies              : 
                                                ~
                * Build Version Details     : 
                                                ~ 1902.1401: * [Michael Arroyo] Posted
                                                ~ 1909.2301: * [Michael Arroyo] Updated the JSON return job, per node, to be managed in a specific diretory (InProgress, Completed, and CompletedWithErrors)
                                                                    * InProgress           - Default directory.  Each node will get a specific .JSON file created as the parent identifier to show where the process is currently running.
                                                                    * Completed            - If the Job for that host is successful the identifer will be updated with the return data and moved to the completed directory
                                                                    * CompletedWithErrors  - If the Job for that host has completed but with errors, the identifer will be updated with the return data and moved to the CompletedWithErrors directory
                                                                    * OutOfMemory          - Default directory.  Each node will get a specific .JSON file created as the parent identifier to show where the process is currently running.
                                                                    * TimedOut             - If the Job for that host is successful the identifer will be updated with the return data and moved to the completed directory
												~ 1909.2301: * [Michael Arroyo] Updated the Error capture event to report more detailed error information to the .CSV Log
												~ 20.05.2101:• [Michael Arroyo] Updated function requirements to Posh 3

    .LINK
        https://github.com/RamblingCookieMonster/Invoke-BluGenieParallel
    #>
    
    [cmdletbinding(DefaultParameterSetName='ScriptBlock')]
    [Alias('Invoke-Parallel')]
    Param
    (
        [Parameter(Position=0,
                   ParameterSetName='ScriptBlock')]
        [scriptblock]$ScriptBlock,

        [Parameter(ParameterSetName='ScriptFile')]
        [ValidateScript({Test-Path $_ -pathtype leaf})]
        $ScriptFile,

        [Parameter(ValueFromPipeline=$true)]
        [Alias('CN','__Server','IPAddress','Server','ComputerName')]
        [PSObject]$InputObject,

        [PSObject]$Parameter,

        [switch]$ImportVariables,

        [switch]$ImportModules,

        [switch]$ImportFunctions,

        [int]$Throttle = 50,

        [int]$SleepTimer = 200,

        [int]$RunspaceTimeout = 0,

        [switch]$NoCloseOnTimeout = $false,

        [int]$MaxQueue,

        [validatescript({Test-Path (Split-Path $_ -parent)})]

        [switch] $AppendLog = $false,

        [string]$LogFile,

        [switch]$Quiet = $false,

        [Alias('Help')]
        [Switch]$Walkthrough
    )
    begin
    {
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

        #region Parameter Check
            Switch
            (
                $null
            )
            {
                {$InputObject -eq $null}
                {
                    $Error.Clear()
                    Write-Error -Message '-InputObject cannot be empty.  Please try again...' -ErrorAction SilentlyContinue
                    Write-Host $('{0}' -f $($Error.exception | Out-String).Trim())
                    $Leave = $true
                    Return
                }
                {$InputObject -eq ''}
                {
                    $Error.Clear()
                    Write-Error -Message '-InputObject cannot be empty.  Please try again...' -ErrorAction SilentlyContinue
                    Write-Host $('{0}' -f $($Error.exception | Out-String).Trim())
                    $Leave = $true
                    Return
                }
            }
        #endregion Parameter Check

        #No max queue specified?  Estimate one.
        #We use the script scope to resolve an odd PowerShell 2 issue where MaxQueue isn't seen later in the function
        if
        (
            -not $PSBoundParameters.ContainsKey('MaxQueue')
        )
        {
            if
            (
                $RunspaceTimeout -ne 0
            )
            {
                $script:MaxQueue = $Throttle
            }
            else
            {
                $script:MaxQueue = $Throttle * 3
            }
        }
        else
        {
            $script:MaxQueue = $MaxQueue
        }
        
        $ProcessID = $PID

        Write-Host $("`n`n* Job Settings" -f $(New-TimeStamp -ErrorAction SilentlyContinue)) -ForegroundColor Green
        #Write-Verbose "Throttle: '$throttle' SleepTimer '$sleepTimer' runSpaceTimeout '$runspaceTimeout' maxQueue '$maxQueue' logFile '$logFile'"
        Write-Host $("~ ThreadCount: {0}" -f $throttle) -ForegroundColor Yellow
        Write-Host $("~ SleepTimer: {0} MS" -f $sleepTimer) -ForegroundColor Yellow
        Write-Host $("~ JobTimeout: {0} MIN" -f $($runspaceTimeout / 60)) -ForegroundColor Yellow
        Write-Host $("~ MaxQueue: {0}" -f $maxQueue) -ForegroundColor Yellow
        Write-Host $("~ PID: {0}" -f $ProcessID) -ForegroundColor Yellow
        
        If
        (
            $BGMemory -is [int]
        )
        {
            $Global:MaxmemoryMB = $($BGMemory * 1kb)
        }
        
        Write-Host $("~ MaxMemoryMB: {0}" -f $Global:MaxmemoryMB) -ForegroundColor Yellow
        Write-Host $("~ LogFile: {0}" -f $logFile) -ForegroundColor Yellow
        Write-Host $("`n* Starting Jobs - {0}" -f $(New-TimeStamp -ErrorAction SilentlyContinue)) -ForegroundColor Green
        
        #If they want to import variables or modules, create a clean runspace, get loaded items, use those to exclude items
        if
        (
            $ImportVariables -or $ImportModules -or $ImportFunctions
        )
        {
            $StandardUserEnv = [powershell]::Create().addscript(
            {
                #Get modules, snapins, functions in this clean runspace
                $Modules = Get-Module | Select-Object -ExpandProperty Name
                $Snapins = Get-PSSnapin | Select-Object -ExpandProperty Name
                $Functions = Get-ChildItem function:\ | Select-Object -ExpandProperty Name

                #Get variables in this clean runspace
                #Called last to get vars like $? into session
                $Variables = Get-Variable | Select-Object -ExpandProperty Name

                #Return a hashtable where we can access each.
                @{
                    Variables   = $Variables
                    Modules     = $Modules
                    Snapins     = $Snapins
                    Functions   = $Functions
                }
            }
            ).invoke()[0]

            if
            (
                $ImportVariables
            )
            {
                #Exclude common parameters, bound parameters, and automatic variables
                Function _temp
                {
                    [cmdletbinding(SupportsShouldProcess=$True)]
                    
                    param()
                }

                $VariablesToExclude = @( (Get-Command _temp | Select-Object -ExpandProperty parameters).Keys + $PSBoundParameters.Keys + $StandardUserEnv.Variables )
                Write-Verbose "Excluding variables $( ($VariablesToExclude | Sort-Object ) -join ", ")"

                # we don't use 'Get-Variable -Exclude', because it uses regexps.
                # One of the veriables that we pass is '$?'.
                # There could be other variables with such problems.
                # Scope 2 required if we move to a real module
                $UserVariables = @( Get-Variable | Where-Object { -not ($VariablesToExclude -contains $_.Name) } )
                Write-Verbose "Found variables to import: $( ($UserVariables | Select-Object -expandproperty Name | Sort-Object ) -join ", " | Out-String).`n"
            }

            if
            (
                $ImportModules
            )
            {
                $UserModules = @( Get-Module | Where-Object {$StandardUserEnv.Modules -notcontains $_.Name -and (Test-Path $_.Path -ErrorAction SilentlyContinue)} | Select-Object -ExpandProperty Path )
                $UserSnapins = @( Get-PSSnapin | Select-Object -ExpandProperty Name | Where-Object {$StandardUserEnv.Snapins -notcontains $_ } )
            }

            if
            (
                $ImportFunctions
            )
            {
                $UserFunctions = @( Get-ChildItem function:\ | Where-Object { $StandardUserEnv.Functions -notcontains $_.Name } )
            }
        }

        #region functions
            Function Get-RunspaceData 
            {
                param
                (
                    [switch]$Wait
                )

                #loop through runspaces
                #if $wait is specified, keep looping until all complete

                #Setup Console so that no runspace output gets captured to the screen

				If 
                (
                    $Console
                )
                {
                    [console]::ForegroundColor = "black"
                    $saveY = [console]::CursorTop
                    $saveX = [console]::CursorLeft
                    $WaitChar = '|'
                }

                Do 
                {
                    #set more to false for tracking completion
                    $more = $false

                    #Progress bar if we have inputobject count (bound parameter)
                    if
                    (
                        -not $Quiet
                    )
                    {
                        Write-Progress  -Activity "Running Query" -Status "Starting threads"`
                            -CurrentOperation "$startedCount threads defined - $totalCount input objects - $script:completedCount input objects processed"`
                            -PercentComplete $( Try { $script:completedCount / $totalCount * 100 } Catch {0} )
                    }

                    #run through each runspace.
                    Foreach
                    (
                        $runspace in $runspaces
                    )
                    {
                        #get the duration - inaccurate
                        $currentdate = Get-Date
                        $runtime = $currentdate - $runspace.startTime
                        $runMin = [math]::Round( $runtime.totalminutes ,2 )

                        #set up log object
                        $log = "" | Select-Object Date, Action, Runtime, Status, Details
                        $log.Action = "Removing:'$($runspace.object)'"
                        $log.Date = $currentdate
                        $log.Runtime = "$runMin minutes"

                        #region Object in Queue
                            $LogFilePath = Split-Path -Path $LogFile -Parent
                            $CompletedPath = $('{0}\Completed' -f $LogFilePath)
                            #$CompletedWithErrorsPath = $('{0}\CompletedWithErrors' -f $LogFilePath)
                            #$OutOfMemoryPath = $('{0}\OutOfMemory' -f $LogFilePath)
                            $InProgressPath = $('{0}\InProgress' -f $LogFilePath)
                            #$TimedOutPath = $('{0}\TimedOut' -f $LogFilePath)
                            $TagName = $($log.Action -split ':')[1] -replace "'"
                            
                            $CompletedWithErrorsPath = $('{0}\Completed' -f $LogFilePath)
                            $OutOfMemoryPath = $('{0}\Completed' -f $LogFilePath)
                            $TimedOutPath = $('{0}\Completed' -f $LogFilePath)
                        #endregion Object in Queue

                        #If runspace completed, end invoke, dispose, recycle, counter++
                        If
                        (
                            $runspace.Runspace.isCompleted
                        )
                        {
                            $script:completedCount++

                            #check if there were errors
                            if
                            (
                                $runspace.powershell.Streams.Error.Count -gt 0
                            )
                            {
                                #set the logging info and move the file to completed
                                $log.status = "CompletedWithErrors"
                                Write-Verbose ($log | ConvertTo-Csv -Delimiter ";" -NoTypeInformation)[1]
                                If
                                (
                                    $Console
                                )
                                {
                                    [console]::setcursorposition($saveX,$saveY)
                                }
                                Write-Host $("~ {0}" -f $($log | ConvertTo-Csv -Delimiter ";" -NoTypeInformation)[1]) -ForegroundColor White
                                $saveY += 1
            
                                foreach
                                (
                                    $ErrorRecord in $runspace.powershell.Streams.Error
                                )
                                {
                                    Write-Error -ErrorRecord $ErrorRecord
									
									$ErrorReturn = [pscustomobject]@{
										'Action' 		= ''
										'StackTrace' 	= ''
										'Line'			= ''
										'Error' 		= ''
									}
									
									switch
									(
										$null
									)
									{
										{ $ErrorRecord.exception }
										{
											$ErrorReturn.Error = $($ErrorRecord.exception | Out-String).trim() -replace '\n'
										}
										
										{ $ErrorRecord.ScriptStackTrace }
										{
											$ErrorReturn.StackTrace = $($ErrorRecord.ScriptStackTrace -replace '^(.*)?,.*:\s(line\s\d?)','$1,$2' -split '\n') | Select-Object -First 1
										}
										
										{ $ErrorRecord.CategoryInfo.Activity }
										{
											$ErrorReturn.Action = $ErrorRecord.CategoryInfo.Activity
										}
										
										{ $ErrorRecord.InvocationInfo.Line }
										{
											$ErrorReturn.Line = $($ErrorRecord.InvocationInfo.Line).Trim()
										}
									}
									
                                    $ErrObj = [PSCustomObject]@{
                                        Date = $currentdate
                                        Action = "ErrorMsg:'$($runspace.object)'"
                                        Runtime = "$runMin minutes"
                                        Status = 'Error'
                                        Details = $($($ErrorReturn | ConvertTo-Csv -NoTypeInformation)[1] | Out-String) -replace '\n' -replace '\s+',' '
                                    }
									
									#$ErrObj.Details | Out-File c:\Source\ErrorDetails.log -Append

                                    #report on Error messages
                                    $($ErrObj | ConvertTo-Csv -Delimiter ';' -NoTypeInformation)[1] -replace '\"+','"' | out-file $LogFile -append
                                }

                                #region Move System Object in Queue
                                    If
                                    (
                                        $ErrObj.Details -match 'Out of memory'
                                    )
                                    {
                                        $log | ConvertTo-Json -Depth 10 -Compress | Out-File -FilePath $('{0}\{1}.JSON' -f $InProgressPath, $TagName) -Append -Encoding utf8
                                        #Start-Sleep -Milliseconds 500
                                        $null = Move-Item -Path $('{0}\{1}.JSON' -f $InProgressPath, $TagName) -Destination $('{0}\{1}.JSON' -f $OutOfMemoryPath, $TagName) -Force -ErrorAction SilentlyContinue
                                    }
                                    ElseIf
                                    (
                                        $ErrOb
                                    )
                                    {

                                    }
                                    Else
                                    {
                                        $null = Move-Item -Path $('{0}\{1}.JSON' -f $InProgressPath, $TagName) -Destination $('{0}\{1}.JSON' -f $CompletedWithErrorsPath, $TagName) -Force -ErrorAction SilentlyContinue
                                    }
                                #endregion Move System Object in Queue
                            }
                            else
                            {
                                #add logging details and cleanup
                                $log.status = "Completed"
                                Write-Verbose ($log | ConvertTo-Csv -Delimiter ";" -NoTypeInformation)[1]
                                If
                                (
                                    $Console
                                )
                                {
                                    [console]::setcursorposition($saveX,$saveY)
                                }
                                Write-Host $("~ {0}" -f $($log | ConvertTo-Csv -Delimiter ";" -NoTypeInformation)[1]) -ForegroundColor White
                                $saveY += 1

                                #region Move System Object in Queue
                                    $null = Move-Item -Path $('{0}\{1}.JSON' -f $InProgressPath, $TagName) -Destination $('{0}\{1}.JSON' -f $CompletedPath, $TagName) -Force -ErrorAction SilentlyContinue
                                #endregion Move System Object in Queue
                            }

                            #everything is logged, clean up the runspace
                            $runspace.powershell.EndInvoke($runspace.Runspace)
                            $runspace.powershell.dispose()
                            $runspace.Runspace = $null
                            $runspace.powershell = $null
                            [gc]::Collect()
                        }

                        #If runtime exceeds max, dispose the runspace
                        ElseIf 
                        (
                            $runspaceTimeout -ne 0 -and $runtime.totalseconds -gt $runspaceTimeout
                        )
                        {
                            $script:completedCount++
                            $timedOutTasks = $true

                            #add logging details and cleanup
                            $log.status = "TimedOut"
                            Write-Verbose ($log | ConvertTo-Csv -Delimiter ";" -NoTypeInformation)[1]
                            If
                            (
                                $Console
                            )
                            {
                                [console]::setcursorposition($saveX,$saveY)
                            }
                            Write-Host $("~ {0}" -f $($log | ConvertTo-Csv -Delimiter ";" -NoTypeInformation)[1]) -ForegroundColor White
                            $saveY += 1
                            
                            #region Move System Object in Queue
                                $log | ConvertTo-Json -Depth 10 -Compress | Out-File -FilePath $('{0}\{1}.JSON' -f $InProgressPath, $TagName) -Append -Encoding utf8
                                #Start-Sleep -Milliseconds 500
                                $null = Move-Item -Path $('{0}\{1}.JSON' -f $InProgressPath, $TagName) -Destination $('{0}\{1}.JSON' -f $TimedOutPath, $TagName) -Force -ErrorAction SilentlyContinue
                            #endregion Move System Object in Queue

                            Write-Error "Runspace timed out at $($runtime.totalseconds) seconds for the object:`n$($runspace.object | out-string)"

                            #Depending on how it hangs, we could still get stuck here as dispose calls a synchronous method on the powershell instance
                            if
                            (
                                -Not $noCloseOnTimeout
                            )
                            {
                                $runspace.powershell.dispose()
                                [gc]::Collect()
                            }

                            $runspace.Runspace = $null
                            $runspace.powershell = $null
                            $completedCount++
                        }

                        #If runspace isn't null set more to true
                        ElseIf
                        (
                            $runspace.Runspace -ne $null
                        )
                        {
                            $log = $null
                            $more = $true

                            if
                            (
                                $Wait
                            )
                            {
                                Switch
                                (
                                    $WaitChar
                                )
                                {
                                    '|'
                                    {
                                        If
                                        (
                                            $Console
                                        )
                                        {
                                            [console]::setcursorposition($saveX,$saveY)
                                        }
                                        Write-Host '|' -ForegroundColor White -NoNewline
                                        $WaitChar = '/'
                                    }
                                    '/'
                                    {
                                        If
                                        (
                                            $Console
                                        )
                                        {
                                            [console]::setcursorposition($saveX,$saveY)
                                        }
                                        Write-Host '/' -ForegroundColor White -NoNewline
                                        $WaitChar = '-'
                                    }
                                    '-'
                                    {
                                        If
                                        (
                                            $Console
                                        )
                                        {
                                            [console]::setcursorposition($saveX,$saveY)
                                        }
                                        Write-Host '-' -ForegroundColor White -NoNewline
                                        $WaitChar = '\'
                                    }
                                    '\'
                                    {
                                        If
                                        (
                                            $Console
                                        )
                                        {
                                            [console]::setcursorposition($saveX,$saveY)
                                        }
                                        Write-Host '\' -ForegroundColor White -NoNewline
                                        $WaitChar = '|'
                                    }
                                }
                            }
                        }

                        #log the results if a log file was indicated
                        if
                        (
                            $logFile -and $log
                        )
                        {
                            $($log | ConvertTo-Csv -Delimiter ";" -NoTypeInformation)[1] | out-file $LogFile -append
                        }
                    }

                    #Clean out unused runspace jobs
                    $temphash = $runspaces.clone()
                    $temphash | Where-Object { $_.runspace -eq $Null } | ForEach-Object `
                    -Process `
                    {
                        $Runspaces.remove($_)
                        
                    }
                    
                    $runspace = $null
                    $temphash = $null
                    $log = $null
                    $ErrorRecord = $null
                    $ErrOb = $null
                    [gc]::Collect()

                    #sleep for a bit if we will loop again
                    if
                    (
                        $Wait
                    )
                    {
                        Start-Sleep -milliseconds $SleepTimer
                    }

                #Loop again only if -wait parameter and there are more runspaces to process
                }
                while
                (
                    $more -and $Wait
                )

                If
                (
                    $Console
                )
                {
                    [console]::ForegroundColor = "white"
                }
                
                [gc]::Collect()

            #End of runspace function
            }
        #endregion functions

        #region Init

            if
            (
                $PSCmdlet.ParameterSetName -eq 'ScriptFile'
            )
            {
                $ScriptBlock = [scriptblock]::Create( $(Get-Content $ScriptFile | out-string) )
            }
            elseif
            (
                $PSCmdlet.ParameterSetName -eq 'ScriptBlock'
            )
            {
                #Start building parameter names for the param block
                [string[]]$ParamsToAdd = '$_'
                if
                (
                    $PSBoundParameters.ContainsKey('Parameter')
                )
                {
                    $ParamsToAdd += '$Parameter'
                }

                $UsingVariableData = $Null

                # This code enables $Using support through the AST.
                # This is entirely from  Boe Prox, and his https://github.com/proxb/PoshRSJob module; all credit to Boe!

                if
                (
                    $PSVersionTable.PSVersion.Major -gt 2
                )
                {
                    #Extract using references
                    $UsingVariables = $ScriptBlock.ast.FindAll({$args[0] -is [Management.Automation.Language.UsingExpressionAst]},$True)

                    If
                    (
                        $UsingVariables
                    )
                    {
                        $List = New-Object 'System.Collections.Generic.List`1[System.Management.Automation.Language.VariableExpressionAst]'
                        ForEach
                        (
                            $Ast in $UsingVariables
                        )
                        {
                            [void]$list.Add($Ast.SubExpression)
                        }

                        $UsingVar = $UsingVariables | Group-Object -Property SubExpression | ForEach-Object `
                        -Process `
                        {
                            $_.Group | Select-Object -First 1
                        }

                        #Extract the name, value, and create replacements for each
                        $UsingVariableData = ForEach
                        (
                            $Var in $UsingVar
                        )
                        {
                            try
                            {
                                $Value = Get-Variable -Name $Var.SubExpression.VariablePath.UserPath -ErrorAction Stop
                                [pscustomobject]@{
                                    Name = $Var.SubExpression.Extent.Text
                                    Value = $Value.Value
                                    NewName = ('$__using_{0}' -f $Var.SubExpression.VariablePath.UserPath)
                                    NewVarName = ('__using_{0}' -f $Var.SubExpression.VariablePath.UserPath)
                                }
                            }
                            catch
                            {
                                Write-Error "$($Var.SubExpression.Extent.Text) is not a valid Using: variable!"
                            }
                        }
                        $ParamsToAdd += $UsingVariableData | Select-Object -ExpandProperty NewName -Unique

                        $NewParams = $UsingVariableData.NewName -join ', '
                        $Tuple = [Tuple]::Create($list, $NewParams)
                        $bindingFlags = [Reflection.BindingFlags]"Default,NonPublic,Instance"
                        $GetWithInputHandlingForInvokeCommandImpl = ($ScriptBlock.ast.gettype().GetMethod('GetWithInputHandlingForInvokeCommandImpl',$bindingFlags))

                        $StringScriptBlock = $GetWithInputHandlingForInvokeCommandImpl.Invoke($ScriptBlock.ast,@($Tuple))

                        $ScriptBlock = [scriptblock]::Create($StringScriptBlock)

                        Write-Verbose $StringScriptBlock
                    }
                }

                $ScriptBlock = $ExecutionContext.InvokeCommand.NewScriptBlock("param($($ParamsToAdd -Join ", "))`r`n" + $Scriptblock.ToString())
            }
            else
            {
                Throw "Must provide ScriptBlock or ScriptFile"; Break
            }

            Write-Debug "`$ScriptBlock: $($ScriptBlock | Out-String)"
            Write-Verbose "Creating runspace pool and session states"
            Write-Host $("~ {0}" -f 'Creating runspace pool and session states')

            #If specified, add variables and modules/snapins to session state
            $sessionstate = [initialsessionstate]::CreateDefault()
            if
            (
                $ImportVariables -and $UserVariables.count -gt 0
            )
            {
                foreach
                (
                    $Variable in $UserVariables
                )
                {
                    $sessionstate.Variables.Add((New-Object -TypeName System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList $Variable.Name, $Variable.Value, $null) )
                }
            }
            if
            (
                $ImportModules
            )
            {
                if
                (
                    $UserModules.count -gt 0
                )
                {
                    foreach
                    (
                        $ModulePath in $UserModules
                    )
                    {
                        $sessionstate.ImportPSModule($ModulePath)
                    }
                }
                if
                (
                    $UserSnapins.count -gt 0
                )
                {
                    foreach
                    (
                        $PSSnapin in $UserSnapins
                    )
                    {
                        [void]$sessionstate.ImportPSSnapIn($PSSnapin, [ref]$null)
                    }
                }
            }
            if
            (
                $ImportFunctions -and $UserFunctions.count -gt 0
            )
            {
                foreach
                (
                    $FunctionDef in $UserFunctions
                )
                {
                    $sessionstate.Commands.Add((New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry -ArgumentList $FunctionDef.Name,$FunctionDef.ScriptBlock))
                }
            }

            #Create runspace pool
            $runspacepool = [runspacefactory]::CreateRunspacePool(1, $Throttle, $sessionstate, $Host)
            $runspacepool.Open()

            Write-Verbose "Creating empty collection to hold runspace jobs"
            Write-Host $("~ {0}" -f 'Creating empty collection to hold runspace jobs')
            $Script:runspaces = New-Object System.Collections.ArrayList

            #If inputObject is bound get a total count and set bound to true
            $bound = $PSBoundParameters.keys -contains "InputObject"
            if
            (
                -not $bound
            )
            {
                [Collections.ArrayList]$allObjects = @()
            }

            #Set up log file if specified
            if
            (
                $LogFile -and (-not (Test-Path $LogFile) -or $AppendLog -eq $false)
            )
            {
                $null = New-Item -ItemType file -Path $logFile -Force
                ("" | Select-Object -Property Date, Action, Runtime, Status, Details | ConvertTo-Csv -NoTypeInformation -Delimiter ";")[0] | Out-File $LogFile
            }

            #write initial log entry
            $log = "" | Select-Object -Property Date, Action, Runtime, Status, Details
            $log.Date = Get-Date
            $log.Action = "Batch processing started"
            $log.Runtime = $null
            $log.Status = "Started"
            $log.Details = $null
            if
            (
                $logFile
            )
            {
                ($log | convertto-csv -Delimiter ";" -NoTypeInformation)[1] | Out-File $LogFile -Append
            }
            $timedOutTasks = $false
        #endregion INIT
    }
    process
    {
        #add piped objects to all objects or set all objects to bound input object parameter
        if
        (
            $Leave
        )
        {
            Return
        }

        if
        (
            $bound
        )
        {
            $allObjects = $InputObject
        }
        else
        {
            [void]$allObjects.add( $InputObject )
        }
    }
    end
    {
        if
        (
            $Leave
        )
        {
            Return
        }

        #Use Try/Finally to catch Ctrl+C and clean up.
        try 
        {
            #counts for progress
            $totalCount = $allObjects.count
            $script:completedCount = 0
            $startedCount = 0
            foreach
            (
                $object in $allObjects
            )
            {
                #region add scripts to runspace pool
                    #Create the powershell instance, set verbose if needed, supply the scriptblock and parameters
                    $powershell = [powershell]::Create()

                    if
                    (
                        $VerbosePreference -eq 'Continue'
                    )
                    {
                        [void]$PowerShell.AddScript({$VerbosePreference = 'Continue'})
                    }

                    [void]$PowerShell.AddScript($ScriptBlock).AddArgument($object)

                    if
                    (
                        $parameter
                    )
                    {
                        [void]$PowerShell.AddArgument($parameter)
                    }

                    # $Using support from Boe Prox
                    if
                    (
                        $UsingVariableData
                    )
                    {
                        Foreach
                        (
                            $UsingVariable in $UsingVariableData
                        )
                        {
                            Write-Verbose "Adding $($UsingVariable.Name) with value: $($UsingVariable.Value)"
                            Write-Host $("~ Adding {0} with value: {1}" -f $($UsingVariable.Name),$($UsingVariable.Value))
                            [void]$PowerShell.AddArgument($UsingVariable.Value)
                        }
                    }

                    #Add the runspace into the powershell instance
                    $powershell.RunspacePool = $runspacepool

                    #Create a temporary collection for each runspace
                    $temp = "" | Select-Object PowerShell, StartTime, object, Runspace
                    $temp.PowerShell = $powershell
                    $temp.StartTime = Get-Date
                    $temp.object = $object

                    #Save the handle output when calling BeginInvoke() that will be used later to end the runspace
                    If
                    (
                        $MaxmemoryMB
                    )
                    {
                        while
                        (
                            $($($(Get-Process -id $ProcessID | Select-Object -ExpandProperty WorkingSet) / 1kb) -ge $MaxmemoryMB)
                        )
                        {
                            Start-Sleep -Seconds 10
                            Get-RunspaceData
                        }
                    }
                    
                    $temp.Runspace = $powershell.BeginInvoke()
                    $startedCount++

                    #Add the temp tracking info to $runspaces collection
                    Write-Verbose ( "Adding {0} to collection at {1}" -f $temp.object, $temp.starttime.tostring() )
                    Write-Host $("~ Adding {0} to collection at {1}" -f $temp.object, $temp.starttime.tostring())
                    $null = $runspaces.Add($temp)
                    
                    $temp = $null
                    $powershell = $null
                    
                    #loop through existing runspaces one time
                    Get-RunspaceData
                    
                    #If we have more running than max queue (used to control timeout accuracy)
                    #Script scope resolves odd PowerShell 2 issue
                    $firstRun = $true
                    while
                    (
                        $runspaces.count -ge $Script:MaxQueue
                    )
                    {
                        #give verbose output
                        if
                        (
                            $firstRun
                        )
                        {
                            Write-Verbose "$($runspaces.count) items running - exceeded $Script:MaxQueue limit."
                        }
                        $firstRun = $false

                        #run get-runspace data and sleep for a short while
                        Get-RunspaceData
                        Start-Sleep -Milliseconds $sleepTimer
                    }
                #endregion add scripts to runspace pool
            }
            Write-Verbose ( "Finish processing the remaining runspace jobs: {0}" -f ( @($runspaces | Where-Object {$_.Runspace -ne $Null}).Count) )
            Write-Host $("~ Finish processing the remaining runspace jobs: {0}" -f ( @($runspaces | Where-Object {$_.Runspace -ne $Null}).Count))

            Get-RunspaceData -wait
            
            if
            (
                -not $quiet
            )
            {
                Write-Progress -Activity "Running Query" -Status "Completed Jobs" -Completed
            }
        }
        finally
        {
            #Close the runspace pool, unless we specified no close on timeout and something timed out
            if
            (
                ($timedOutTasks -eq $false) -or ( ($timedOutTasks -eq $true) -and ($noCloseOnTimeout -eq $false) )
            )
            {
                Write-Verbose "Closing the runspace pool"
                Write-Host $("~ {0}" -f 'Closing the runspace pool')
                $runspacepool.close()
            }
            #collect garbage
            [gc]::Collect()
            
            if
            (
                $Quiet
            )
            {
                Write-Host $("* Completed Jobs - {0} `n" -f $(New-TimeStamp -ErrorAction SilentlyContinue)) -ForegroundColor Green
            }
        }
    }
}
#endregion Invoke-BluGenieParallel (Function)