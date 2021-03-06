# Invoke-BluGenieParallel

## SYNOPSIS
Function to control parallel processing using runspaces

## SYNTAX
```
Invoke-BluGenieParallel [[-ScriptBlock] <ScriptBlock>] [-InputObject <PSObject>] [-Parameter <PSObject>] [-ImportVariables] [-ImportModules] 
[-ImportFunctions] [-Throttle <Int32>] [-SleepTimer <Int32>] [-RunspaceTimeout <Int32>] [-NoCloseOnTimeout] [-MaxQueue <Int32>] [-AppendLog] 
[-LogFile <String>] [-Quiet] [-Walkthrough] [<CommonParameters>]

Invoke-BluGenieParallel [-ScriptFile <Object>] [-InputObject <PSObject>] [-Parameter <PSObject>] [-ImportVariables] [-ImportModules] 
[-ImportFunctions] [-Throttle <Int32>] [-SleepTimer <Int32>] [-RunspaceTimeout <Int32>] [-NoCloseOnTimeout] [-MaxQueue <Int32>] [-AppendLog] 
[-LogFile <String>] [-Quiet] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Function to control parallel processing using runspaces

    Note that each runspace will not have access to variables and commands loaded in your session or in other runspaces by default.
    This behaviour can be changed with parameters.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Each example uses Test-ForPacs.ps1 which includes the following code:
 ``` 
 ```yam 
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
 ``` 
 
### EXAMPLE 2
 ``` 
 Invoke-BluGenieParallel -scriptfile C:\public\Test-ForPacs.ps1 -inputobject $(get-content C:\pcs.txt) -runspaceTimeout 10 -throttle 10
 ``` 
 ```yam 
 Pulls list of PCs from C:\pcs.txt,
    Runs Test-ForPacs against each
    If any query takes longer than 10 seconds, it is disposed
    Only run 10 threads at a time
 ``` 
 
### EXAMPLE 3
 ``` 
 Invoke-BluGenieParallel -scriptfile C:\public\Test-ForPacs.ps1 -inputobject c-is-ts-91, c-is-ts-95
 ``` 
 ```yam 
 Runs against c-is-ts-91, c-is-ts-95 (-computername)
    Runs Test-ForPacs against each
 ``` 
 
### EXAMPLE 4
 ``` 
 $stuff = [pscustomobject] @{
 ``` 
 ```yam 
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
 ``` 
 
### EXAMPLE 5
 ``` 
 $test = 5
 ``` 
 ```yam 
 1..2 | Invoke-BluGenieParallel -ImportVariables {$_ * $test}

Add variables from the current session to the session state.  Without -ImportVariables $Test would not be accessible
 ``` 
 
### EXAMPLE 6
 ``` 
 $test = 5
 ``` 
 ```yam 
 1..2 | Invoke-BluGenieParallel {$_ * $Using:test}

Reference a variable from the current session with the $Using:<Variable> syntax.  Requires PowerShell 3 or later. Note that -ImportVariables parameter is no longer necessary.
 ``` 


## PARAMETERS

### ScriptBlock
 ```yam 
 -ScriptBlock <ScriptBlock>
    Scriptblock to run against all computers.
    
    You may use $Using:<Variable> language in PowerShell 3 and later.
    
        The parameter block is added for you, allowing behaviour similar to foreach-object:
            Refer to the input object as $_.
            Refer to the parameter parameter as $parameter
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ScriptFile
 ```yam 
 -ScriptFile <Object>
    File to run against all input objects.  Must include parameter to take in the input object, or use $args.  Optionally, include parameter to take 
    in parameter.  Example: C:\script.ps1
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### InputObject
 ```yam 
 -InputObject <PSObject>
    Run script against these specified objects.
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       true (ByValue)
    Accept wildcard characters?  false
 ``` 
### Parameter
 ```yam 
 -Parameter <PSObject>
    This object is passed to every script block.  You can use it to pass information to the script block; for example, the path to a logging folder
    
        Reference this object as $parameter if using the scriptblock parameterset.
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ImportVariables
 ```yam 
 -ImportVariables [<SwitchParameter>]
    If specified, get user session variables and add them to the initial session state
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ImportModules
 ```yam 
 -ImportModules [<SwitchParameter>]
    If specified, get loaded modules and pssnapins, add them to the initial session state
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ImportFunctions
 ```yam 
 -ImportFunctions [<SwitchParameter>]
    If specified, get loaded functions, and add them to the initial session state
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Throttle
 ```yam 
 -Throttle <Int32>
    Maximum number of threads to run at a single time.
    
    <Type>Int<Type>
    
    Required?                    false
    Position?                    named
    Default value                50
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### SleepTimer
 ```yam 
 -SleepTimer <Int32>
    Milliseconds to sleep after checking for completed runspaces and in a few other spots.  I would not recommend dropping below 200 or increasing 
    above 500
    
    <Type>Int<Type>
    
    Required?                    false
    Position?                    named
    Default value                200
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### RunspaceTimeout
 ```yam 
 -RunspaceTimeout <Int32>
    Maximum time in seconds a single thread can run.  If execution of your code takes longer than this, it is disposed.  Default: 0 (seconds)
    
    WARNING:  Using this parameter requires that maxQueue be set to throttle (it will be by default) for accurate timing.  Details here:
    http://gallery.technet.microsoft.com/Run-Parallel-Parallel-377fd430
    
    <Type>Int<Type>
    
    Required?                    false
    Position?                    named
    Default value                0
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### NoCloseOnTimeout
 ```yam 
 -NoCloseOnTimeout [<SwitchParameter>]
    Do not dispose of timed out tasks or attempt to close the runspace if threads have timed out. This will prevent the script from hanging in 
    certain situations where threads become non-responsive, at the expense of leaking memory within the PowerShell host.
    
    <Type>Int<Type>
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### MaxQueue
 ```yam 
 -MaxQueue <Int32>
    Maximum number of powershell instances to add to runspace pool.  If this is higher than $throttle, $timeout will be inaccurate
    
    If this is equal or less than throttle, there will be a performance impact
    
    The default value is $throttle times 3, if $runspaceTimeout is not specified
    The default value is $throttle, if $runspaceTimeout is specified
    
    <Type>Int<Type>
    
    Required?                    false
    Position?                    named
    Default value                0
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### AppendLog
 ```yam 
 -AppendLog [<SwitchParameter>]
    Append to existing log
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### LogFile
 ```yam 
 -LogFile <String>
    Path to a file where we can log results, including run time for each thread, whether it completes, completes with errors, or times out.
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Quiet
 ```yam 
 -Quiet [<SwitchParameter>]
    Disable progress bar
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Walkthrough
 ```yam 
 -Walkthrough [<SwitchParameter>]
    An automated process to walk through the current function and all the parameters
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


