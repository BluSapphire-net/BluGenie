# Set-BluGenieRemoteDesktopProcess

## SYNOPSIS
Enable or Disable Remote Desktop functionality

## SYNTAX
```
Set-BluGenieRemoteDesktopProcess [[-Value] <String>] [[-Walkthrough]] [[-ReturnObject]] [[-OutUnEscapedJSON]] [<CommonParameters>]
```

## DESCRIPTION
Enable or Disable Remote Desktop functionality
Managed Setting - HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server[fDenyTSConnections]

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Set-BluGenieRemoteDesktopProcess
 ``` 
 ```yam 
 Description: Enable Remote Desktop
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Set-BluGenieRemoteDesktopProcess -Value Enable
 ``` 
 ```yam 
 Description: Enable Remote Desktop [2]
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Set-BluGenieRemoteDesktopProcess -Value Disable
 ``` 
 ```yam 
 Description: Disable Remote Desktop
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Set-BluGenieRemoteDesktopProcess -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Set-BluGenieRemoteDesktopProcess -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Set-BluGenieRemoteDesktopProcess -Value Enable -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Enable Remote Desktop and Return Output as UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Set-BluGenieRemoteDesktopProcess -Value Enable -ReturnObject
 ``` 
 ```yam 
 Description: Enable Remote Desktop and Return Output an Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 


## PARAMETERS

### Value
 ```yam 
 -Value <String>
    Description: Option to enable or disable Terminal Services (RDP) 
    Notes:  
    Alias:
    ValidateSet: 'Enable','Disable'
    
    Required?                    false
    Position?                    1
    Default value                Enable
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
    Position?                    2
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ReturnObject
 ```yam 
 -ReturnObject [<SwitchParameter>]
    Description: Return information as an Object
    Notes: By default the data is returned as a Hash Table
    Alias: 
    ValidateSet:
    
    Required?                    false
    Position?                    3
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### OutUnEscapedJSON
 ```yam 
 -OutUnEscapedJSON [<SwitchParameter>]
    Description: Removed UnEsacped Char from the JSON information.
    Notes: This will beautify json and clean up the formatting.
    Alias: 
    ValidateSet:
    
    Required?                    false
    Position?                    4
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


