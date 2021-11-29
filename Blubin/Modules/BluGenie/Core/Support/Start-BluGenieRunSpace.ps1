#region Start-BluGenieRunSpace (Function)
function Start-BluGenieRunSpace
{
    <#
        .SYNOPSIS 
            Start-BluGenieRunSpace will run a list of commands or scriptblocks in parallel

        .DESCRIPTION
            Start-BluGenieRunSpace will run a list of commands or scriptblocks in parallel

        .PARAMETER maxThreads
            Set the Max Threads to run in parallel

            The default is set to ( 0 / Zero ).  If left to ( 0 / Zero ) the maxThreads count will be set to ( The total command count )

            <Type>Int<Type>

        .PARAMETER maxJobs
            Set the Max Jobs to run manage in a queue

            The default is set to ( 0 / Zero ).  If left to ( 0 / Zero ) the maxJobs count will be set to ( 20 + maxThreads )

            <Type>Int<Type>

        .PARAMETER slotTimer
            Number of Milliseconds for slot-free-waiting

            The default is set to ( 50 ).

            <Type>Int<Type>

        .PARAMETER sleepTimer
            Number of Milliseconds for loop-waiting

            The default is set to ( 500 ).

            <Type>Int<Type>

        .PARAMETER processJobsInterval
            Process completed jobs every x number of items

            The default is set to ( 5 ).

            <Type>Int<Type>

        .PARAMETER HelpMessage
            Display message status

            - Quiet    = Silent / No status messages
            - Verbose  = Show every action
            - Headers  = Only show major event progress

            The default value is ( Verbose )

            <Type>ValidateSet<Type>
            <ValidateSet>Quiet,Verbose,Headers<ValidateSet>

        .PARAMETER Commands
            A list of commands or ScriptBlocks to action in a seperate PowerShell RunSpace

            <Type>String<Type>

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

        .EXAMPLE
            

        .OUTPUTS
                TypeName: System.Collections.Hashtable

        .NOTES
        
            * Original Author           : Michael Arroyo
            * Original Build Version    : 1907.2601
            * Latest Author             : Michael Arroyo
            * Latest Build Version      : 20.07.0601
            * Comments                  : 
            * Dependencies              : 
                                            ~
            * Build Version Details     : 
                ~ 1907.2601: * [Michael Arroyo] Posted
                ~ 1907.2901: * [Michael Arroyo] Added the Command to the Job results
                             * [Michael Arroyo] Updated JobData to only show Results data no other internally captured job data
                             * [Michael Arroyo] Updated the return data from an object to a hashtable based on an error 'The specified wildcard 
                                                    pattern is not valid'
                             * [Michael Arroyo] Added property management to the RunSpace pool.  The pool is being generated so fast the 
                                                    properties are not all in a settled state.
                ~ 1908.0601: * [Michael Arroyo] Updated the process to create a new PowerShell instance
                             * [Michael Arroyo] Added a process to remove any hung Job Data.  This was causing the session to freeze.
                             * [Michael Arroyo] Updated the internal function ( Process-FinishedJobs ).  Added a new data capture variable.
                             * [Michael Arroyo] Updated Job manager to double check job count
                             * [Michael Arroyo] Updated the entire process to support a single job.  Previously it was only working with 
                                                    multiple commands.
                ~ 1910.1001: * [Michael Arroyo] Upated reference objects for RunSpace to Fully Qualified names.  PS2 and PS3 didnt like the 
                                                    shorten names.
                ~ 20.07.0601:* [Michael Arroyo] Added Alias injection into the new Runspace.  This will fix any issues while calling the old
                                                    Blugenie commands as well as providing a clone of the parent PowerShell Env.
    #>
    [Alias('Start-RunSpace')]
    param
    (
        [parameter(HelpMessage="Number of parallel threads")]
        [int]$maxThreads = 0,

        [parameter(HelpMessage="Number of jobs to be queued")]
        [int]$maxJobs = 0,

        [parameter(HelpMessage="Number of ms for slot-free-waiting")]
        [int]$slotTimer = 50,

        [parameter(HelpMessage="Number of ms for loop-waiting")]
        [int]$sleepTimer = 500,

        [parameter(HelpMessage="Process completed jobs every x number of items")]
        [int]$processJobsInterval = 5,

        [parameter(HelpMessage='List of commands for each job')]
        [String[]]$commands,

        [parameter(HelpMessage='Display Message Status')]
        [ValidateSet('Quiet', 'Verbose', 'Headers')]
        [String]$StatusMessage = 'Verbose',

        [Parameter(Position=6)]
        [Alias('Help')]
        [Switch]$Walkthrough,

        [Parameter(Position=9)]
        [Switch]$ReturnObject,

        [Parameter(Position = 10)]
        [Switch]$OutUnEscapedJSON
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
                Test-Path -Path Function:\Invoke-WalkThrough -ErrorAction SilentlyContinue
            )
            {
                If
                (
                    $Function -eq 'Invoke-WalkThrough'
                )
                {
                    #Disable Invoke-WalkThrough looping
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

    #region Functions
        #region New-RunSpaceSession (Function)
            Function New-RunSpaceSession
            {
                $CurSessionState = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
                
                If
                (
                    $CurSessionState.psobject.Properties | Where-Object -FilterScript { $_.'Name' -eq 'ExecutionPolicy' }
                )
                {
                    $CurSessionState.ExecutionPolicy = 'ByPass'
                }
                Else
                {
                    Start-Sleep -Seconds 2
                    If
                    (
                        $CurSessionState.psobject.Properties | Where-Object -FilterScript { $_.'Name' -eq 'ExecutionPolicy' }
                    )
                    {
                        $CurSessionState.ExecutionPolicy = 'ByPass'
                    }
                }
                
                Return $CurSessionState
            }
        #endregion New-RunSpaceSession (Function)

        #region Get-CurrentSessionFunctions (Function)
            Function Get-CurrentSessionFunctions
            {
                Return $(Get-ChildItem -Path Function:\ | Where-Object -FilterScript { $_.'Source' -NotMatch '^Microsoft|^ISE' } | Select-Object -ExpandProperty Name)
            }
        #endregion Get-CurrentSessionFunctions (Function)

        #region Get-RunSpaceSessionFunctions (Function)
            Function Get-RunSpaceSessionFunctions
            {
                Param
                (
                    $RunSpace
                )

                    $CurSessionInfo = [powershell]::Create().addscript(
                    {
                        #$Modules = Get-Module | Select-Object -ExpandProperty Name
                        #$Snapins = Get-PSSnapin | Select-Object -ExpandProperty Name
                        Get-ChildItem function:\ | Select-Object -ExpandProperty Name
                        #$Variables = Get-Variable | Select-Object -ExpandProperty Name
                    }
                    ).invoke()

                    Return $CurSessionInfo
            }
        #endregion Get-RunSpaceSessionFunctions (Function)

        #region Get-SessionFunctionList (Function)
            Function Get-SessionFunctionList
            {
                Param
                (
                )

                Compare-Object -ReferenceObject $(Get-CurrentSessionFunctions) -DifferenceObject $(Get-RunSpaceSessionFunctions) | Where-Object -FilterScript { $_.'SideIndicator' -eq '<=' } | Select-Object -ExpandProperty InputObject
            }
        #endregion Get-SessionFunctionList (Function)

        #region Get-CurrentSessionVariables (Function)
            Function Get-CurrentSessionVariables
            {
                Return $(Get-ChildItem -Path Variable:\ | Select-Object -ExpandProperty Name)
            }
        #endregion Get-CurrentSessionVariables (Function)

        #region Get-RunSpaceSessionVariables (Function)
            Function Get-RunSpaceSessionVariables
            {
                Param
                (
                )

                    $CurSessionInfo = [powershell]::Create().addscript(
                    {
                        #Get-Module | Select-Object -ExpandProperty Name
                        #Get-PSSnapin | Select-Object -ExpandProperty Name
                        #Get-ChildItem function:\ | Select-Object -ExpandProperty Name
                        Get-Variable | Select-Object -ExpandProperty Name
                    }
                    ).invoke()

                    Return $CurSessionInfo
            }
        #endregion Get-RunSpaceSessionVariables (Function)

        #region Get-SessionVariableList (Function)
            Function Get-SessionVariableList
            {
                Param
                (
                )

                Compare-Object -ReferenceObject $(Get-CurrentSessionVariables) -DifferenceObject $(Get-RunSpaceSessionVariables -Runspace $Runspace) | Where-Object -FilterScript { $_.'SideIndicator' -eq '<=' } | Select-Object -ExpandProperty InputObject
            }
        #endregion Get-SessionVariableList (Function)

        #region Update-RunSpaceSessionFunctions (Function)
            Function Update-RunSpaceSessionFunctions
            {
                Param
                (
                    [Parameter(Position=0)]
                    $Runspace,

                    [Parameter(Position=1)]
                    [String[]]$FunctionName
                )

                $ArrFunctionList = @()
                $CurCommands = $RunSpace.Commands | Select-Object -ExpandProperty Name

                $FunctionName | ForEach-Object `
                -Process `
                {
                    $CurFunction = $_
                    $Error.Clear()

                    Try
                    {
                        If
                        (
                            -Not $($CurCommands -contains $CurFunction)
                        )
                        {
                            $CurDefinitionFunction = Get-Content -Path $('Function:\{0}' -f $CurFunction) -ErrorAction Stop
                            $CurSessionStateFunction = New-Object System.Management.Automation.Runspaces.SessionStateFunctionEntry -ArgumentList $CurFunction, $CurDefinitionFunction
                            $Runspace.Commands.Add($CurSessionStateFunction)
                            $ArrFunctionList += New-Object -TypeName PSObject -Property @{
                                Function = $CurFunction
                                AddedToSession = $true
                                Comment = $null
                            }
                        }
                        Else
                        {
                            $ArrFunctionList += New-Object -TypeName PSObject -Property @{
                                Function = $CurFunction
                                AddedToSession = $false
                                Comment = 'already added to session'
                            }
                        }              
                    }
                    Catch
                    {
                        $ArrFunctionList += New-Object -TypeName PSObject -Property @{
                            Function = $CurFunction
                            AddedToSession = $false
                            Comment = $Error[0].ToString()
                        }
                    }
                }

                Return  $ArrFunctionList
            }
        #endregion Update-RunSpaceSessionFunctions (Function)

        #region Update-RunSpaceSessionVariables (Function)
            Function Update-RunSpaceSessionVariables
            {
                Param
                (
                    [Parameter(Position=0)]
                    $Runspace,

                    [Parameter(Position=1)]
                    [String[]]$VariableName
                )

                $ArrVariableList = @()
                $CurVariables = $RunSpace.Variables | Select-Object -ExpandProperty Name

                $VariableName | ForEach-Object `
                -Process `
                {
                    $CurVariable = $_
                    $Error.Clear()

                    Try
                    {
                        If
                        (
                            -Not $($CurVariables -contains $CurVariable)
                        )
                        {
                            $CurVariableInfo = Get-Item -Path $('Variable:\{0}' -f $CurVariable) -ErrorAction Stop
                            $CurSessionStateVariable = New-Object System.Management.Automation.Runspaces.SessionStateVariableEntry($($CurVariableInfo.Name), $($CurVariableInfo.Value), $null)
                            $Runspace.Variables.Add($CurSessionStateVariable)
                            $ArrVariableList += New-Object -TypeName PSObject -Property @{
                                Variable = $CurVariable
                                AddedToSession = $true
                                Comment = $null
                            }
                        }
                        Else
                        {
                                $ArrVariableList += New-Object -TypeName PSObject -Property @{
                                Variable = $CurVariable
                                AddedToSession = $false
                                Comment = 'already added to session'
                            }
                        }              
                    }
                    Catch
                    {
                        $ArrVariableList += New-Object -TypeName PSObject -Property @{
                                Variable = $CurVariable
                            AddedToSession = $false
                            Comment = $Error[0].ToString()
                        }
                    }
                }

                Return  $ArrVariableList
            }
        #endregion Update-RunSpaceSessionVariables (Function)

        #region Update-RunSpaceSessionAliases (Function)
            Function Update-RunSpaceSessionAliases
            {
                Param
                (
                    [Parameter(Position=0)]
                    $Runspace,

                    [Parameter(Position=1)]
                    [String[]]$AliasName
                )

                $ArrAliasList = @()
                $CurCommands = $RunSpace.Commands | Select-Object -ExpandProperty Name

                $AliasName | ForEach-Object `
                -Process `
                {
                    $CurAlias = $_
                    $Error.Clear()

                    Try
                    {
                        If
                        (
                            -Not $($CurCommands -contains $CurAlias)
                        )
                        {
                            $CurDefinitionAlias = Get-Item -Path $('Alias:\{0}' -f $CurAlias) -ErrorAction Stop | Select-Object -Property Definition
                            If
                            (
                                $CurDefinitionAlias.Definition.length -gt 0
                            )
                            {
                                $CurSessionStateAlias = New-Object System.Management.Automation.Runspaces.SessionStateAliasEntry -ArgumentList $CurAlias, $($CurDefinitionAlias | Select-Object -ExpandProperty Definition)
                                $Runspace.Commands.Add($CurSessionStateAlias)
                                
                                $ArrAliasList += New-Object -TypeName PSObject -Property @{
                                    Function = $CurAlias
                                    AddedToSession = $true
                                    Comment = $null
                                }
                            }
                            Else
                            {
                                $ArrAliasList += New-Object -TypeName PSObject -Property @{
                                    Function = $CurAlias
                                    AddedToSession = $false
                                    Comment = 'No Definition Found'
                                }
                            }
                            
                        }
                        Else
                        {
                            $ArrAliasList += New-Object -TypeName PSObject -Property @{
                                Function = $CurAlias
                                AddedToSession = $false
                                Comment = 'already added to session'
                            }
                        }              
                    }
                    Catch
                    {
                        $ArrAliasList += New-Object -TypeName PSObject -Property @{
                            Function = $CurAlias
                            AddedToSession = $false
                            Comment = $Error[0].ToString()
                        }
                    }
                }

                Return  $ArrAliasList
            }
        #endregion Update-RunSpaceSessionAliases (Function)

        #region write-log (Function) 
            function write-log
            {
                param
                (
                    [string]$action,
                    [string]$color = "Cyan",
                    [string]$status = " .. ",
                    [switch]$onlyToFile = $false,
                    [switch]$outputToFile = $true
                )

                $timestamp = $('D.{0}.T.{1}' -f $(get-date -Format "yyyy.MM.dd"), $(get-date -Format "hh.mm.ss.fff"))

                if
                (
                    -not $silent -and -not $onlyToFile
                )
                {
                    if
                    (
                        $status
                    )
                    {
                        $statusColor = "white"
                        Switch
                        (
                            $status
                        )
                        {
                            "OK"
                            {
                                $status = " OK "
                                $statusColor = "green"
                            }

                            "FAIL"
                            {
                                $statusColor = "YELLOW"
                            }

    
                        }

                        write-host "[" -NoNewline -ForegroundColor white
                        write-host $timestamp -NoNewline -ForegroundColor White
                        write-host "] " -NoNewline -ForegroundColor white

                        write-host "[" -NoNewline -ForegroundColor white
                        write-host $status -NoNewline -ForegroundColor $statusColor
                        write-host "] " -NoNewline -ForegroundColor white

                    }
                    Write-Host -ForegroundColor $color "$action"
                }

                if
                (
                    $outputToFile
                )
                {
                    $mtx = New-Object System.Threading.Mutex($false, "LogfileMutex")
                    [void]$mtx.WaitOne()
                    Add-Content $logfile -Value "[$timestamp][$status] $action"
                    $mtx.ReleaseMutex()
                }
            }
        #endregion write-log (Function) 

        #region Create-RunspacePool (Function)
            Function Create-RunspacePool
            {
                Param
                (
                    [Parameter(Position=0)]
                    $Runspace,

                    [Parameter(Position=1)]
                    [Int]$maxThreads = 10
                )

                $RunspacePool = [runspacefactory]::CreateRunspacePool(
                    1, #Min Runspaces
                    $maxThreads, #Max Runspaces
                    $Runspace, # our defined session state
                    $host #PowerShell host
                )
                Return $RunspacePool
            }
        #endregion Create-RunspacePool (Function)

        #region New-StopWatch (Function)
            Function New-StopWatch
            {
                Param
                (
                )

                Return $( [system.diagnostics.stopwatch]::StartNew() )
            }
        #endregion New-StopWatch (Function)

        #region Get-JobStats (Function)
            function Get-JobStats{
                param(
                    $max,
                    $maxJobs
                )
                $running = @($jobs).Count
                $finished = $max - $running
                $reallyRunning = @($jobs | Where-Object {
                    # really import line here.  check result first !
                    if($_.Result){
                        -not $_.Result.IsCompleted
                    }else{
                        $false
                    }
                }).Count

                $percent = if($max -gt 0){
                    [int]($finished/$max*100)
                }else{
                    100
                }

                Return $(
                    New-Object -TypeName PSObject -Property @{
                        running = $running
                        open = $reallyRunning
                        finished = $finished
                        percent = $percent
                        hasFreeSlot = ($reallyRunning -lt $maxJobs)
                        isFinished = (-not $running)
                    }
                )
            }
        #endregion Get-JobStats (Function)

        #region Process-FinishedJobs (Function)
            function Process-FinishedJobs{
                Param
                (
                )

                # handle finished jobs
                Switch
                (
                    $StatusMessage
                )
                {
                    'Quiet'
                    {
                        break
                    }
                    'Headers'
                    {
                        break
                    }
                    default
                    {
                        write-log -action 'Processing completed jobs...' -color white -outputToFile:$false
                    }
                }

                ForEach
                (
                    $jobresult in @($jobs | Where-Object -FilterScript {$_.Result.IsCompleted})
                )
                {
                    $jobID = $jobresult.jobID
                    $jobCommand = $jobresult.command

                    if
                    (
                        $jobresult.job.Streams.Error.Count -gt 0
                    )
                    {
                        Switch
                        (
                            $StatusMessage
                        )
                        {
                            'Quiet'
                            {
                                break
                            }
                            'Headers'
                            {
                                write-log -action $('Job ID {0} - Completed with Errors...' -f $jobID) -color red -outputToFile:$false
                                break
                            }
                            default
                            {
                                write-log -action $('Job ID {0} - Completed with Errors...' -f $jobID) -color red -outputToFile:$false
                            }
                        }

                        $ErrorArray = New-Object -TypeName System.Collections.ArrayList

                        foreach
                        (
                            $ErrorRecord in $jobresult.job.Streams.Error
                        )
                        {
                            Write-Error -ErrorRecord $ErrorRecord
                            $ErrObj = New-Object -TypeName PSObject -Property @{
                                Date = $($(Get-Date).DateTime)
                                Status = 'Error'
                                Details = $ErrorRecord.tostring()
                                JobID = $jobID
                                Command = $jobCommand
                            }

                            #report on Error messages
                            Switch
                            (
                                $StatusMessage
                            )
                            {
                                'Quiet'
                                {
                                    break
                                }
                                'Headers'
                                {
                                    break
                                }
                                default
                                {
                                    $ErrObj | ForEach-Object `
                                    -Process `
                                    { 
                                        write-log -action $_ -color red -outputToFile:$false
                                    }
                                }
                            }
                            
                            $null = $ErrorArray.Add($ErrObj)
                        }

                        $jobOutput = $jobresult.Job.EndInvoke($jobresult.Result)
    
                        $results.$('Job{0}' -f $jobID) = New-Object -TypeName PSObject -Property @{
                            Results = $jobOutput
                            Command = $jobCommand
                        }
                        $results.$('ErrorJob{0}' -f $jobID) = $ErrorArray

                        Switch
                        (
                            $StatusMessage
                        )
                        {
                            'Quiet'
                            {
                                break
                            }
                            'Headers'
                            {
                                break
                            }
                            default
                            {
                                write-log -action $('Logging - Job{0}"'-f $jobID) -color white -outputToFile:$false
                            }
                        }
                        
                        $null = Remove-Item -Path Variable:\JobOutput -Force -ErrorAction SilentlyContinue
                    }
                    else
                    {
                        # we get the job result by triggering endinvoke on the jobhandle
                        $jobOutput = $jobresult.Job.EndInvoke($jobresult.Result)
    
                        $results.$('Job{0}' -f $jobID) = New-Object -TypeName PSObject -Property @{
                            Results = $jobOutput
                            Command = $jobCommand
                        }

                        Switch
                        (
                            $StatusMessage
                        )
                        {
                            'Quiet'
                            {
                                break
                            }
                            'Headers'
                            {
                                break
                            }
                            default
                            {
                                write-log -action $('Logging - Job{0}"'-f $jobID) -color white -outputToFile:$false
                            }
                        }

                        If
                        (
                            $JobOutput
                        )
                        {
                            Try
                            {
                                $null = Remove-Item -Path Variable:\JobOutput -Force -ErrorAction Stop
                            }
                            Catch
                            {
                                If
                                (
                                    $($error.Count -gt 0)
                                )
                                {
                                    $Error.RemoveAt(0)
                                }
                            }
                        }
                    }
    
                    # kill the job, adding room for new jobs
                    $jobresult.Job.Dispose()
                    $jobresult.Job = $Null
                    $jobresult.Result = $Null
                    $jobs.remove($jobresult)
                }
            }
        #endregion Process-FinishedJobs (Function)
    #endregion Functions

    #region Processes
        #region StartTime Tracker
            $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        #endregion StartTime Tracker

        #region Update MaxThreads and MaxJobs if not defined.
            if
            (
                $maxThreads -eq 0
            )
            {
                $maxThreads = $commands.Count
            }

            if
            (
                $maxJobs -eq 0
            )
            {
                $maxJobs = $($maxThreads + 20)
            }
        #endregion Update MaxThreads to Command Count if not defined.

        #region Build-RunSpacePool (Process)
            $mainstopwatch = New-StopWatch
            Switch
            (
                $StatusMessage
            )
            {
                'Quiet'
                {
                    break
                }
                'Headers'
                {
                    write-log ("Starting...") -status "TIME" -color Yellow -outputToFile:$false
                    write-log ("Preparing RunSpacePool") -color yellow -status "START" -outputToFile:$false
                    break
                }
                default
                {
                    write-log ("Starting...") -status "TIME" -color Yellow -outputToFile:$false
                    write-log ("Preparing RunSpacePool") -color yellow -status "START" -outputToFile:$false
                }
            }
            
            $RunSpacePoolStopWatch = New-StopWatch

            $iss = New-RunSpaceSession
            Switch
            (
                $StatusMessage
            )
            {
                'Quiet'
                {
                    break
                }
                'Headers'
                {
                    write-log ("New Session Created") -outputToFile:$false
                    break
                }
                default
                {
                    write-log ("New Session Created") -outputToFile:$false
                }
            }

            If
            (
                $iss
            )
            {
                Switch
                (
                    $StatusMessage
                )
                {
                    'Quiet'
                    {
                        break
                    }
                    'Headers'
                    {
                        write-log ("Addeding Current Session Functions to RunSpace") -outputToFile:$false
                        break
                    }
                    default
                    {
                        write-log ("Addeding Current Session Functions to RunSpace") -outputToFile:$false
                    }
                }
                
                Start-Sleep -Seconds 2
                $RSFunctions = Update-RunSpaceSessionFunctions -Runspace $iss -FunctionName $(Get-SessionFunctionList -FormatView None | Select-Object -ExpandProperty Name)
                $RSFunctions | ForEach-Object `
                -Process `
                {
                    $CurItem = $_
                    Switch
                    (
                        $StatusMessage
                    )
                    {
                        'Quiet'
                        {
                            break
                        }
                        'Headers'
                        {
                            break
                        }
                        default
                        {
                            write-log ('{0}' -f $CurItem) -color white -outputToFile:$false
                        }
                    }
                }
                
                Switch
                (
                    $StatusMessage
                )
                {
                    'Quiet'
                    {
                        break
                    }
                    'Headers'
                    {
                        write-log ("Addeding Current Session Variables to RunSpace") -outputToFile:$false
                        break
                    }
                    default
                    {
                        write-log ("Addeding Current Session Variables to RunSpace") -outputToFile:$false
                    }
                }
                
                Start-Sleep -Seconds 2
                $RSVariables = Update-RunSpaceSessionVariables -Runspace $iss -VariableName $(Get-SessionVariableList -FormatView None | Select-Object -ExpandProperty Name)
                $RSVariables | ForEach-Object `
                -Process `
                {
                    $CurItem = $_
                    Switch
                    (
                        $StatusMessage
                    )
                    {
                        'Quiet'
                        {
                            break
                        }
                        'Headers'
                        {
                            break
                        }
                        default
                        {
                            write-log ('{0}' -f $CurItem) -color white -outputToFile:$false
                        }
                    }
                }

                Switch
                (
                    $StatusMessage
                )
                {
                    'Quiet'
                    {
                        break
                    }
                    'Headers'
                    {
                        write-log ("Addeding Current Session Aliases to RunSpace") -outputToFile:$false
                        break
                    }
                    default
                    {
                        write-log ("Addeding Current Session Aliases to RunSpace") -outputToFile:$false
                    }
                }

                Start-Sleep -Seconds 2
                $RSAliases = Update-RunSpaceSessionAliases -Runspace $iss -AliasName $(Get-BluGenieSessionAliasList -FormatView None | Select-Object -ExpandProperty Name)
                $RSAliases | ForEach-Object `
                -Process `
                {
                    $CurItem = $_
                    Switch
                    (
                        $StatusMessage
                    )
                    {
                        'Quiet'
                        {
                            break
                        }
                        'Headers'
                        {
                            break
                        }
                        default
                        {
                            write-log ('{0}' -f $CurItem) -color white -outputToFile:$false
                        }
                    }
                }
            }

            $RunSpacePool = Create-RunspacePool -Runspace $iss -maxThreads $maxThreads
            $RunSpacePool.Open()

            if
            (
                $RunSpacePool
            )
            {
                Switch
                (
                    $StatusMessage
                )
                {
                    'Quiet'
                    {
                        break
                    }
                    'Headers'
                    {
                        write-log ("RunSpace Pool set to ( {0} ) threads" -f $maxThreads) -outputToFile:$false
                        write-log ("Runspace is prepared - Script ran for {0}" -f $RunSpacePoolStopWatch.Elapsed.toString()) -color yellow -status "STOP" -outputToFile:$false
                        write-log ("Total Session Elapsed Time {0}" -f $mainstopwatch.Elapsed.toString()) -color yellow -status "TIME" -outputToFile:$false
                        break
                    }
                    default
                    {
                        write-log ("RunSpace Pool set to ( {0} ) threads" -f $maxThreads) -outputToFile:$false
                        write-log ("Runspace is prepared - Script ran for {0}" -f $RunSpacePoolStopWatch.Elapsed.toString()) -color yellow -status "STOP" -outputToFile:$false
                        write-log ("Total Session Elapsed Time {0}" -f $mainstopwatch.Elapsed.toString()) -color yellow -status "TIME" -outputToFile:$false
                    }
                }
            }

            $null = Remove-Item -Path Variable:\RunSpacePoolStopWatch -Force -ErrorAction SilentlyContinue
        #endregion Build-RunSpacePool (Process)

        #region Build Jobs list to maintain the running jobs
            [System.Collections.ArrayList]$jobs = @()
        #endregion Build Jobs list to maintain the running jobs

        #region Setup results HashTable
            $results = @{}
        #endregion Setup results HashTable

        #region Process Threads
            $ProcessStopWatch = New-StopWatch
            
            Switch
            (
                $StatusMessage
            )
            {
                'Quiet'
                {
                    break
                }
                'Headers'
                {
                    write-log ("Processing Threads") -status "START" -color yellow -outputToFile:$false
                    break
                }
                default
                {
                    write-log ("Processing Threads") -status "START" -color yellow -outputToFile:$false
                }
            }

            #progress counters
            $i = 0
            $processJobsCounter = 0

            Switch
            (
                $StatusMessage
            )
            {
                'Quiet'
                {
                    break
                }
                'Headers'
                {
                    write-log -action $('Adding jobs with max {0} threads' -f  $maxThreads) -outputToFile:$false
                    break
                }
                default
                {
                    write-log -action $('Adding jobs with max {0} threads' -f  $maxThreads) -outputToFile:$false
                }
            }

            #For each command process a new job
            $commands | ForEach-Object `
            -Process `
            {
                $CurCommand = $_

                #region visualize progress
                    $i++
                    $jobstats = Get-JobStats -max $maxThreads -maxJobs $maxJobs
                    Switch
                    (
                        $StatusMessage
                    )
                    {
                        'Quiet'
                        {
                            break
                        }
                        'Headers'
                        {
                            break
                        }
                        default
                        {
                            write-log -action $("Running {0} jobs | Adding {1}/{2}" -f $jobstats.open,$i,$maxThreads) -color white -outputToFile:$false
                            write-log -action $('Job Percent Added: {0}' -f $(($i/$maxThreads).tostring("P"))) -color white -outputToFile:$false
                        }
                    }
                #endregion visualize progress

                #region Wait for a slot to become available
                    While
                    (
                        -not $jobstats.hasFreeSlot
                    )
                    {
                        Start-Sleep -Milliseconds $slotTimer
                        $jobstats = Get-JobStats -max $maxThreads -maxJobs $maxJobs
                    }
                #endregion Wait for a slot to become available

                #region Invoke job (parallel)
                    # Create a new job
                    #$Job = [System.Management.Automation.PowerShell]::Create()
                    $Job = [powershell]::Create()
                
                    # Add commands or scriptblock to the new Powershell session
                    $null = $Job.AddScript($CurCommand)

                    # Add Parameters to the new Powershell session
                    #[void]$Job.AddParameter()

                    # Add the defined RunspacePool
                    $Job.RunspacePool = $RunspacePool

                    # Add custom metadata - add as many as you want - can be a hash-table
                    $oJob = New-Object PSObject -Property @{
                        job = $Job
                        result = $Job.BeginInvoke()
                        jobID = $i
                        jobErrors = $null
                        command = $CurCommand
                    }
                    $null = $jobs.Add($oJob)
                #endregion Invoke job (parallel)

                #region process finished jobs while adding jobs
                    $processJobsCounter++
                    if
                    (
                        $processJobsCounter -ge $processJobsInterval
                    )
                    {
                        Process-FinishedJobs
                        #reset counter
                        $processJobsCounter = 0
                    }
                #endregion process finished jobs while adding jobs

                #region process final remaining finished jobs
                    Process-FinishedJobs
                #endregion process final remaining finished jobs

                #region clean up
                    $null = Remove-Item Variable:\job -Force -ErrorAction SilentlyContinue
                #endregion clean up
            }
        #endregion Process Threads

        #region Process any remaining jobs
            $jobstats = Get-JobStats -max $maxThreads -maxJobs $maxJobs

            While
            (
                -not $jobstats.isFinished
            )
            {

                Process-FinishedJobs

                Start-Sleep -Milliseconds $sleepTimer
                $jobstats = Get-JobStats -max $maxThreads -maxJobs $maxJobs
            }

            Switch
            (
                $StatusMessage
            )
            {
                'Quiet'
                {
                    break
                }
                'Headers'
                {
                    write-log ("Completed Processing Jobs... - Script ran for {0}" -f $ProcessStopWatch.Elapsed.toString()) -color yellow -status "STOP" -outputToFile:$false
                    write-log ("Total Session Elapsed Time {0}" -f $mainstopwatch.Elapsed.toString()) -color yellow -status "TIME" -outputToFile:$false
                    break
                }
                default
                {
                    write-log ("Completed Processing Jobs... - Script ran for {0}" -f $ProcessStopWatch.Elapsed.toString()) -color yellow -status "STOP" -outputToFile:$false
                    write-log ("Total Session Elapsed Time {0}" -f $mainstopwatch.Elapsed.toString()) -color yellow -status "TIME" -outputToFile:$false
                }
            }
            $null = Remove-Item -Path Variable:\ProcessStopWatch -Force -ErrorAction SilentlyContinue
        #endregion Process any remaining jobs

        #region Finalize
            $FinalizeStopWatch = New-StopWatch

            Switch
            (
                $StatusMessage
            )
            {
                'Quiet'
                {
                    break
                }
                'Headers'
                {
                    write-log ("Finalizing...") -color yellow -status "START" -outputToFile:$false
                    break
                }
                default
                {
                    write-log ("Finalizing...") -color yellow -status "START" -outputToFile:$false
                }
            }

            #region Create JobData Report Hashtable
                $JobData = New-Object -TypeName System.Collections.ArrayList
            #endregion Create JobData Report Hashtable
            
            #region Stop Tracking and Report Data
                $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
                $null = $JobData.Add(@{StartTime = $($StartTime).DateTime})
                $null = $JobData.Add(@{EndTime = $($EndTime).DateTime})
                $null = $JobData.Add(@{ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds})
            #endregion Stop Tracking and Report Data

            #region Add Jobs to the Job Data HashTable
                $results | Select-Object -ExpandProperty Keys | Where-Object -FilterScript { $_ -match '^Job\d+'} | ForEach-Object `
                -Process `
                {
                    $CurJobKey = $_
                    $JobData += $($results.Item("$CurJobKey").Results)
                }
            #endregion Add Jobs to the Job Data HashTable

            #region Add Error Tracking to the Job Data HashTable
                $ErrorTracker = New-Object -TypeName System.Collections.ArrayList

                $results | Select-Object -ExpandProperty Keys | Where-Object -FilterScript { $_ -match '^ErrorJob\d+'} | ForEach-Object `
                -Process `
                {
                    $CurErrorJobKey = $_

                    $results.Item("$CurErrorJobKey") | ForEach-Object `
                    -Process `
                    {
                        $null = $ErrorTracker.Add($_)    
                    }
                }

                $JobData += $(@{Errors = $ErrorTracker})
            #endregion Add Error Tracking to the Job Data HashTable

        #endregion Finalize

        #region Cleanup
            $RunspacePool.Close()
            $RunspacePool.Dispose()

            If
            (
                $iss
            )
            {
                $null = Remove-Item -Path 'Variable:\iss' -ErrorAction SilentlyContinue -Force
            }

            If
            (
                $RunSpacePool
            )
            {
                $null = Remove-Item -Path 'Variable:\RunSpacePool' -ErrorAction SilentlyContinue -Force
            }
            
        #endregion Cleanup

        #region End 
            $mainstopwatch.stop()
            Switch
            (
                $StatusMessage
            )
            {
                'Quiet'
                {
                    break
                }
                'Headers'
                {
                    write-log ("Finalizing Complete ... - Script ran for {0}" -f $FinalizeStopWatch.Elapsed.toString()) -color yellow -status "STOP" -outputToFile:$false
                    write-log ("Total Session Elapsed Time {0}" -f $mainstopwatch.Elapsed.toString()) -color yellow -status "TIME" -outputToFile:$false
                    break
                }
                default
                {
                    write-log ("Finalizing Complete ... - Script ran for {0}" -f $FinalizeStopWatch.Elapsed.toString()) -color yellow -status "STOP" -outputToFile:$false
                    write-log ("Total Session Elapsed Time {0}" -f $mainstopwatch.Elapsed.toString()) -color yellow -status "TIME" -outputToFile:$false
                }
            }
        #endregion End

        #region Output
            If
            (
                $ReturnObject
            )
            {
                $JobData
            }
            Else
            {
                If
                (
                    -Not $OutUnEscapedJSON
                )
                {
                    Return @{
                        AllJobResults = $results
                        JobData = $JobData
                    }
                }
                Else
                {
                    Return $($JobData | ConvertTo-Json -Depth 10 | ForEach-Object -Process { [regex]::Unescape($_) })
                }
            }
        #endregion Output
    #endregion Processes
}
#endregion Start-BluGenieRunSpace (Function)