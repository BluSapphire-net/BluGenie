# Update-BluGenieFirewallProfileStatus

## SYNOPSIS
Enable or Disable the Window Firewall Profile(s) *Not the Service*

## SYNTAX
```
Update-BluGenieFirewallProfileStatus [[-ProfileType] <String>] [[-Status] <String>] [-ReportOnly] [-Walkthrough] [-ReturnObject] [-OutUnEscapedJSON] 
[<CommonParameters>]
```

## DESCRIPTION
Enable or Disable the Window Firewall Profile(s) *Not the Service*

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Update-BluGenieFirewallProfileStatus
 ``` 
 ```yam 
 Description: Set the [ DOMAIN | PRIVATE | PUBLIC ] Windows Firewall Profiles to enabled / on
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Update-BluGenieFirewallProfileStatus -ProfileType PRIVATE -Status DISABLE
 ``` 
 ```yam 
 Description: Set the Windows Firewall Profile "PRIVATE" to disabled
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Update-BluGenieFirewallProfileStatus -ProfileType DOMAIN -Status ENABLE
 ``` 
 ```yam 
 Description: Set the Windows Firewall Profile "DOMAIN" to Enabled
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Update-BluGenieFirewallProfileStatus -Status DISABLE
 ``` 
 ```yam 
 Description: Set the [ DOMAIN | PRIVATE | PUBLIC ] Windows Firewall Profiles to disabled / off
Notes:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Update-BluGenieFirewallProfileStatus -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Update-BluGenieFirewallProfileStatus -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Update-BluGenieFirewallProfileStatus -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Set the [ DOMAIN | PRIVATE | PUBLIC ] Windows Firewall Profiles to enabled / on and Return Output as UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: Update-BluGenieFirewallProfileStatus -ReturnObject
 ``` 
 ```yam 
 Description: Set the [ DOMAIN | PRIVATE | PUBLIC ] Windows Firewall Profiles to enabled / on and Return Output an Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 


## PARAMETERS

### ProfileType
 ```yam 
 -ProfileType <String>
    Description:  Select which profile to update
    Notes: 
            - DOMAIN
            - PRIVATE
            - PUBLIC
            - DOMAIN+PRIVATE+PUBLIC - (Default Selection)
    Alias:
    ValidateSet: 'DOMAIN','PRIVATE','PUBLIC','DOMAIN+PRIVATE+PUBLIC'
    
    Required?                    false
    Position?                    2
    Default value                DOMAIN+PRIVATE+PUBLIC
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Status
 ```yam 
 -Status <String>
    Description: Option to enable or disable the Firewall Profile  
    Notes:  - ENABLE - (Default Selection)
            - DISABLE
    Alias:
    ValidateSet: 'ENABLE','DISABLE'
    
    Required?                    false
    Position?                    3
    Default value                ENABLE
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ReportOnly
 ```yam 
 -ReportOnly [<SwitchParameter>]
    
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


