# Invoke-BluGenieProcess

## SYNOPSIS
Invoke-BluGenieProcess will kick off the multi threaded job management engine

## SYNTAX
```
Invoke-BluGenieProcess [[-System] <String[]>] [-Command <String[]>] [-JobID <String>] [-ThreadCount <Int32>] [-Walkthrough] [-Trap] [-JobTimeout 
<Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]

Invoke-BluGenieProcess [-Range <String[]>] [[-Command] <String[]>] [[-JobID] <String>] [-ThreadCount <Int32>] [-Walkthrough] [-Trap] [-JobTimeout 
<Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Invoke-BluGenieProcess will kick off the multi threaded job management engine

## EXAMPLES

### EXAMPLE 1
 ``` 
 Invoke-BluGenieProcess -System 'Computer1' -Command 'Get-SystemInfo' -JobID '12345'
 ``` 
 ```yam 
 This will run the command (Get-SystemInfo) on the remote system "Computer1".  All data will be logged in a directory with the assigned JOBID as the name.
 ``` 
 
### EXAMPLE 2
 ``` 
 Invoke-BluGenieProcess -Range 10.10.1.50-10.10.1.250 -Command 'Get-SystemInfo'
 ``` 
 ```yam 
 This will run the command (Get-SystemInfo) on all systems in the IP range of [10.10.1.50 -> 250].  All data will be logged in a directory with the assigned Date and Time.
 ``` 
 
### EXAMPLE 3
 ``` 
 Invoke-BluGenieProcess -System 'Computer1' -Command 'Get-SystemInfo' -Trap
 ``` 
 ```yam 
 This will run the command (Get-SystemInfo) on the remote system "Computer1".  The job data will also be trapped and logged on the remote hosts Event log.

Event Log Details:
    LogName = Application
    Source  = BluGenie
    Type    = Information
    ID      = 7114
 ``` 
 
### EXAMPLE 4
 ``` 
 Run -System 'Computer1' -Command 'Get-SystemInfo' -JobTimeout 5
 ``` 
 ```yam 
 This will run the command (Get-SystemInfo) on the remote system "Computer1".
The job has a timed session of 5 minutes.  After that the session will be automatically closed.

Note:  If a job has reached it's timeout value, the session is closed and no data is captured unless you use the -Trap parameter.
        The -Trap parameter will log all the data on the remote host's <System> Drive.
 ``` 


## PARAMETERS

### System
 ```yam 
 -System <String[]>
    Computer Name or IP Address of the System you want to manage
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    1
    Default value                $(
                    If
                    (
                        -Not $global:ConsoleSystems
                    )
                    {
                        [System.Collections.ArrayList]$global:ConsoleSystems = @()
                    }
    
                    Return $global:ConsoleSystems
                )
    Accept pipeline input?       true (ByValue, ByPropertyName)
    Accept wildcard characters?  false
 ``` 
### Range
 ```yam 
 -Range <String[]>
    IP Address Range of the Systems you want to manage
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    named
    Default value                $(
                    If
                    (
                        -Not $global:ConsoleRange
                    )
                    {
                        [System.Collections.ArrayList]$global:ConsoleRange = @()
                    }
    
                    Return $global:ConsoleRange
                )
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Command
 ```yam 
 -Command <String[]>
    The Commands you would like to execute on the remote computer
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    named
    Default value                $(
                    If
                    (
                        -Not $global:ConsoleCommands
                    )
                    {
                        [System.Collections.ArrayList]$global:ConsoleCommands = @()
                    }
    
                    Return $global:ConsoleCommands
                )
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### JobID
 ```yam 
 -JobID <String>
    The Job Identifier
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    named
    Default value                $(
                    If
                    (
                        -Not $global:ConsoleJobID
                    )
                    {
                        [String]$global:ConsoleJobID = ''
                    }
    
                    Return $global:ConsoleJobID
                )
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ThreadCount
 ```yam 
 -ThreadCount <Int32>
    How many remote systems do you want to control at once.
    The default is ( 50 )
    
    <Type>Int<Type>
    
    Required?                    false
    Position?                    named
    Default value                $(
                    If
                    (
                        -Not $global:ConsoleThreadCount
                    )
                    {
                        [Int]$global:ConsoleThreadCount = 50
                    }
    
                    Return $global:ConsoleThreadCount
                )
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
### Trap
 ```yam 
 -Trap [<SwitchParameter>]
    Trap the return data in the Windows Event Log
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    named
    Default value                $(
                    If
                    (
                        -Not $global:ConsoleTrap
                    )
                    {
                        [Switch]$global:ConsoleTrap = $false
                    }
    
                    Return $global:ConsoleTrap
                )
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### JobTimeout
 ```yam 
 -JobTimeout <Int32>
    How long a remote systems connection can stay open before it is automatically closed.
    The default is ( 120 min )
    
    Note:  If a job has reached it's timeout value, the session is closed and no data is captured unless you use the -Trap parameter.
            The -Trap parameter will log all the data on the remote host's <System> Drive.
    
    <Type>Int<Type>
    
    Required?                    false
    Position?                    named
    Default value                $(
                    If
                    (
                        -Not $global:ConsoleJobTimeout
                    )
                    {
                        [Int]$global:ConsoleJobTimeout = 120
                    }
    
                    Return $global:ConsoleJobTimeout
                )
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### WhatIf
 ```yam 
 -WhatIf [<SwitchParameter>]
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Confirm
 ```yam 
 -Confirm [<SwitchParameter>]
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


