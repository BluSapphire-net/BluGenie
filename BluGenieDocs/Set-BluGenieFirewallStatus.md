# Set-BluGenieFirewallStatus

## SYNOPSIS
Update the Firewall Oubound or Inbound status

## SYNTAX
```
Set-BluGenieFirewallStatus [[-ProfileType] <String>] [[-OutBound] <String>] [[-InBound] <String>] [[-Walkthrough]] [[-ReturnObject]] 
[[-OutUnEscapedJSON]] [<CommonParameters>]
```

## DESCRIPTION
Update the Firewall Oubound or Inbound status

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Set-BluGenieFirewallStatus
 ``` 
 ```yam 
 Description: Set Inbound and Outbound for [DOMAIN | PRIVATE | PUBLIC] to the Windows default setting
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Set-BluGenieFirewallStatus -ProfileType DOMAIN -Outbound Block -Inbound Block
 ``` 
 ```yam 
 Description: Set Inbound and Outbound for the DOMAIN profile to Block
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Set-BluGenieFirewallStatus -ProfileType PRIVATE -Outbound Block -Inbound Allow
 ``` 
 ```yam 
 Description: Set Inbound to Allow and Outbound to Block for the PRIVATE Windows Firewall Profile
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Set-BluGenieFirewallStatus -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Set-BluGenieFirewallStatus -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Set-BluGenieFirewallStatus -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Set Inbound and Outbound for [DOMAIN | PRIVATE | PUBLIC] to the Windows default setting and Return Output as UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Set-BluGenieFirewallStatus -ReturnObject
 ``` 
 ```yam 
 Description: Set Inbound and Outbound for [DOMAIN | PRIVATE | PUBLIC] to the Windows default setting and Return Output an Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 


## PARAMETERS

### ProfileType
 ```yam 
 -ProfileType <String>
    Description:  Select which profile you would like to update
    Notes:  
            - DOMAIN
            - PRIVATE
            - PUBLIC
            - DOMAIN+PRIVATE+PUBLIC - (Default Selection)
    Alias:
    ValidateSet: 'DOMAIN','PRIVATE','PUBLIC','DOMAIN+PRIVATE+PUBLIC'
    
    Required?                    false
    Position?                    1
    Default value                DOMAIN+PRIVATE+PUBLIC
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### OutBound
 ```yam 
 -OutBound <String>
    Description: Select the Firewall Management State per profile 
    Notes:  
            - Block
            - Allow
            - Default - (Default Selection)
    Alias:
    ValidateSet: 'Block','Allow','Default'
    
    Required?                    false
    Position?                    2
    Default value                Default
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### InBound
 ```yam 
 -InBound <String>
    Description: Select the Firewall Management State per profile 
    Notes: 
            - Block
            - Allow
            - Default - (Default Selection) 
    Alias:
    ValidateSet: 'Block','Allow','Default'
    
    Required?                    false
    Position?                    3
    Default value                Default
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
    Position?                    4
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
    Position?                    5
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
    Position?                    6
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


