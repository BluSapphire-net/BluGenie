# Get-BluGenieADMachineInfo

## SYNOPSIS
Query Active Directory Machine Information (Without RSAT)

## SYNTAX
```
Get-BluGenieADMachineInfo [[-ReturnObject]] [[-Walkthrough]] [<CommonParameters>]
```

## DESCRIPTION
Query Active Directory Machine Information (Without RSAT)

## EXAMPLES

### EXAMPLE 1
 ``` 
 Get-BluGenieADMachineInfo
 ``` 
 ```yam 
 This will return machine specific information from AD and Group Policy
The returned data will be a Hash Table
 ``` 
 
### EXAMPLE 2
 ``` 
 Get-BluGenieADMachineInfo -ReturnObject
 ``` 
 ```yam 
 This will return machine specific information from AD and Group Policy
The returned data will be an Object
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


