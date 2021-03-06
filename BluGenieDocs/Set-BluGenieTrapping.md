# Set-BluGenieTrapping

## SYNOPSIS
Set-BluGenieTrapping is an add-on to control Remote Host log trapping in the BluGenie Console

## SYNTAX
```
Set-BluGenieTrapping [-SetTrue] [-SetFalse] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Set-BluGenieTrapping is an add-on to control Remote Host log trapping in the BluGenie Console.

Trap information is captured to both a file and the Event Log.
    o FilePath = <$env:SystemDrive>\Windows\Temp\BG<$JobID>-<$PID>-<10_Digit_GUID>.log
    o Event Info:
        ~ EventLogName = 'Application'
        ~ Source = 'BluGenie'
        ~ EntryType = 'Information'
        ~ EventID = 7114
    o Data captured using Posh 2
        ~ Data will be logged using ConvertTo-Xml -as String
    o Data captured using Posh 3 and Above
        ~ Data will be logged using ConvertTo-JSON

Information Trapped:
    o JobID
    o Hostname
    o Commands
    o ParallelCommands
    o PostCommands
    o FullDumpPath

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Set-BluGenieTrapping
 ``` 
 ```yam 
 Description: This will toggle the Trap indicator from (True to False) or (False to True)
Notes:
Output:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Set-BluGenieTrapping -SetTrue
 ``` 
 ```yam 
 Description: This will set the Trap indicator to True
Notes:
Output:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Set-BluGenieTrapping -SetFalse
 ``` 
 ```yam 
 Description: This will set the Trap indicator to False
Notes:
Output:
 ``` 


## PARAMETERS

### SetTrue
 ```yam 
 -SetTrue [<SwitchParameter>]
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### SetFalse
 ```yam 
 -SetFalse [<SwitchParameter>]
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Walkthrough
 ```yam 
 -Walkthrough [<SwitchParameter>]
    Description: An automated process to walk through the current function and all the parameters
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


