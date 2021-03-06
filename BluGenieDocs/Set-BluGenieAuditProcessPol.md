# Set-BluGenieAuditProcessPol

## SYNOPSIS
Enable or Disable Audit Process Tracking

## SYNTAX
```
Set-BluGenieAuditProcessPol [[-ReturnObject]] [[-Status] <String>] [[-ViewOnly]] [[-Walkthrough]] [<CommonParameters>]
```

## DESCRIPTION
Enable or Disable Audit Process Tracking

## EXAMPLES

### EXAMPLE 1
 ``` 
 Set-BluGenieAuditProcessPol
 ``` 
 ```yam 
 This will enable Auditing for Process Creation and Process Exits
The returned data will be a Hash Table
 ``` 
 
### EXAMPLE 2
 ``` 
 Set-BluGenieAuditProcessPol -ViewOnly
 ``` 
 ```yam 
 This will display the current status of the Audit policy for Process Tracking.
Note:  This will not change any settings.
 ``` 
 
### EXAMPLE 3
 ``` 
 Set-BluGenieAuditProcessPol -ReturnObject
 ``` 
 ```yam 
 This will enable Auditing for Process Creation and Process Exits

The returned data will be an Object
 ``` 
 
### EXAMPLE 4
 ``` 
 Set-BluGenieAuditProcessPol -Status Disable
 ``` 
 ```yam 
 This will disable Auditing for Process Creation and Process Exits
 ``` 


## PARAMETERS

### ReturnObject
 ```yam 
 -ReturnObject [<SwitchParameter>]
    Return information as an Object.
    By default the data is returned as a Hash Table
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    1
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Status
 ```yam 
 -Status <String>
    Set the Prefetch process status.
    The acceptable values for this parameter are:
    
    - Enable = (Default) : Enable Audit Process Tracking
    - Disable            : Disable Audit Process Tracking
    
    If no value is specified, or if the parameter is omitted, the default value is (Enable).
    
    <Type>ValidateSet<Type>
    <ValidateSet>Enable,Disable<ValidateSet>
    
    Required?                    false
    Position?                    2
    Default value                Enable
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ViewOnly
 ```yam 
 -ViewOnly [<SwitchParameter>]
    View the current settings only.  Do not process an update.
    By default the data is returned as a Hash Table
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    3
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Walkthrough
 ```yam 
 -Walkthrough [<SwitchParameter>]
    
    Required?                    false
    Position?                    4
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


