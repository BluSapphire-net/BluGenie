# New-BluGenieSessionInfo

## SYNOPSIS
New-BluGenieSessionInfo will query a Current Session Environment varialbe and build Posh variables back into new PSSession Runspaces

## SYNTAX
```
New-BluGenieSessionInfo [[-EnvVarName] <String>] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
New-BluGenieSessionInfo will query a Current Session Environment varialbe and build Posh variables back into new PSSession Runspaces

## EXAMPLES

### EXAMPLE 1
 ``` 
 
 ``` 
 ```yam 
 Description:
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 
 ``` 
 ```yam 
 Description:
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: New-BluGenieSessionInfo -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: New-BluGenieSessionInfo -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 


## PARAMETERS

### EnvVarName
 ```yam 
 -EnvVarName <String>
    Description: Name of the Current Systems Envinroment Variable
    Notes: The default is 'BGSessionInfo'
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                BGSessionInfo
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Walkthrough
 ```yam 
 -Walkthrough [<SwitchParameter>]
    Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
    Notes:  
    Alias: Help
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


