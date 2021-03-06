# Set-BluGenieFirewallGPOStatus

## SYNOPSIS
Update the GPO assigned restrictions on the Windows Firewall (enable user updates / disable user updates)

## SYNTAX
```
Set-BluGenieFirewallGPOStatus [[-ServiceState] <String>] [[-Walkthrough]] [[-ReturnObject]] [[-OutUnEscapedJSON]] [<CommonParameters>]
```

## DESCRIPTION
Update the GPO assigned restrictions on the Windows Firewall (enable user updates / disable user updates)

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Set-BluGenieFirewallGPOStatus
 ``` 
 ```yam 
 Description: Remove the GPO assigned restrictions on the Firewall settings
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Set-BluGenieFirewallGPOStatus -ServiceState Remove
 ``` 
 ```yam 
 Description: Update the GPO assigned restrictions on the Firewall settings to whatever service state you set Remove
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Set-BluGenieFirewallGPOStatus -ServiceState Enable
 ``` 
 ```yam 
 Description: Update the GPO assigned restrictions on the Firewall settings to whatever service state you set Enable
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Set-BluGenieFirewallGPOStatus -ServiceState Disable
 ``` 
 ```yam 
 Description: Update the GPO assigned restrictions on the Firewall settings to whatever service state you set Disable
Notes:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Set-BluGenieFirewallGPOStatus -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Set-BluGenieFirewallGPOStatus -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Set-BluGenieFirewallGPOStatus -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Remove the GPO assigned restrictions on the Firewall settings and Return Output as UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: Set-BluGenieFirewallGPOStatus -ReturnObject
 ``` 
 ```yam 
 Description: Remove the GPO assigned restrictions on the Firewall settings and Return Output an Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 


## PARAMETERS

### ServiceState
 ```yam 
 -ServiceState <String>
    Description: Change the Service State to Enabled / Disabled / or Remove it all together 
    Notes: Managed Setting - HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsFirewall 
    Alias:
    ValidateSet: 'Remove','Enable','Disable'
    
    Required?                    false
    Position?                    1
    Default value                Remove
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
    Position?                    3
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
    Position?                    4
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
    Position?                    5
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


