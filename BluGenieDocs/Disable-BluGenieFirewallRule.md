# Disable-BluGenieFirewallRule

## SYNOPSIS
Disable Firewall Rule(s) without removing them

## SYNTAX
```
Disable-BluGenieFirewallRule [[-RuleName] <String[]>] [[-Walkthrough]] [[-ReturnObject]] [[-OutUnEscapedJSON]] [<CommonParameters>]
```

## DESCRIPTION
Disable Firewall Rule(s) without removing them

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Disable-BluGenieFirewallRule -Name 'Agent_445_Inbound_TCP,Agent_445_Inbound_UDP'
 ``` 
 ```yam 
 Description: This will disable the specific Windows Firewall Rule(s)
Notes: Firewall rules are set as a sinlge line separated by a comma, set as an array is supported as well
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Disable-BluGenieFirewallRule -Name 'Agent_445_Inbound_TCP','Agent_445_Inbound_UDP'
 ``` 
 ```yam 
 Description: This will disable the specific Windows Firewall Rule(s)
Notes: Firewall rules are set as an array, single line separated by a comma is supported as well
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Disable-BluGenieFirewallRule -Help
 ``` 
 ```yam 
 Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Disable-BluGenieFirewallRule -WalkThrough
 ``` 
 ```yam 
 Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
Notes:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Disable-BluGenieFirewallRule -Name 'Agent_445_Inbound_TCP','Agent_445_Inbound_UDP' -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: This will disable the specific Windows Firewall Rule(s) and display output in JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Disable-BluGenieFirewallRule -Name 'Agent_445_Inbound_TCP','Agent_445_Inbound_UDP' -ReturnObject
 ``` 
 ```yam 
 Description: This will disable the specific Windows Firewall Rule(s) and display output as PowerShell Objects
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 


## PARAMETERS

### RuleName
 ```yam 
 -RuleName <String[]>
    
    Required?                    false
    Position?                    1
    Default value                
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
    Position?                    2
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
    Position?                    2
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


