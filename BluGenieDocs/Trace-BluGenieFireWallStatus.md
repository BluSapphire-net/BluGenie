# Trace-BluGenieFireWallStatus

## SYNOPSIS
Trace-BluGenieFireWallStatus will track and revert the Windows Firewall Service and Profile settings

## SYNTAX
```
Trace-BluGenieFireWallStatus [[-ProfileType] <String>] [-Revert] [-SnapShot] [-Force] [-Walkthrough] [-ReturnObject] [-OutUnEscapedJSON] 
[<CommonParameters>]
```

## DESCRIPTION
Trace-BluGenieFireWallStatus will track and revert the Windows Firewall Service and Profile settings

PARAMETER ProfileType
Description:  Select which profile to update
Notes: 
        - DOMAIN
        - PRIVATE
        - PUBLIC
        - DOMAIN+PRIVATE+PUBLIC - (Default Selection)
Alias:
ValidateSet: 'DOMAIN','PRIVATE','PUBLIC','DOMAIN+PRIVATE+PUBLIC'

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Trace-BluGenieFireWallStatus
 ``` 
 ```yam 
 Description: Track and backup the Firewall Service and Profile configuration
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Trace-BluGenieFireWallStatus -Force
 ``` 
 ```yam 
 Description: Force the backup of the Firewall Service and Profile configuration even if the information is already there.
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Trace-BluGenieFireWallStatus -Revert
 ``` 
 ```yam 
 Description: Revert the Firewall Service and Profile configuration back to what was saved in the registry
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Trace-BluGenieFireWallStatus -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Trace-BluGenieFireWallStatus -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Trace-BluGenieFireWallStatus -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: <command_here> and Return Output as UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Trace-BluGenieFireWallStatus -ReturnObject
 ``` 
 ```yam 
 Description: <command_here> and Return Output an Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 


## PARAMETERS

### ProfileType
 ```yam 
 -ProfileType <String>
    
    Required?                    false
    Position?                    2
    Default value                DOMAIN+PRIVATE+PUBLIC
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Revert
 ```yam 
 -Revert [<SwitchParameter>]
    Description: Revert the tracked changes that are found in the Registry 
    Notes: Information is saved in the registry under 'HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\GetFireWallStatus' 
    Alias: 
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### SnapShot
 ```yam 
 -SnapShot [<SwitchParameter>]
    Description: Take a SnapShot of the Firewall Service and Profile settings and save them in the registry
    Notes: Information is saved in the registry under 'HKEY_LOCAL_MACHINE\SOFTWARE\BluGenie\GetFireWallStatus' 
    Snapshot is also enabled by default.
    Alias: 
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                True
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Force
 ```yam 
 -Force [<SwitchParameter>]
    Description: Force the snapshot information to over write any previously saved information in the registry
    Notes: 
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
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
### ReturnObject
 ```yam 
 -ReturnObject [<SwitchParameter>]
    Description: Return information as an Object
    Notes: By default the data is returned as a Hash Table
    Alias: 
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### OutUnEscapedJSON
 ```yam 
 -OutUnEscapedJSON [<SwitchParameter>]
    Description: Remove UnEsacped Char from the JSON information.
    Notes: This will beautify json and clean up the formatting.
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


