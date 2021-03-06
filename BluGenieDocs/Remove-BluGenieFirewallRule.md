# Remove-BluGenieFirewallRule

## SYNOPSIS
Remove Windows Firewall Rule(s)

## SYNTAX
```
Remove-BluGenieFirewallRule [[-RuleName] <String[]>] [[-Walkthrough]] [[-ReturnObject]] [[-OutUnEscapedJSON]] [<CommonParameters>]
```

## DESCRIPTION
Remove Windows Firewall Rule(s)

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Remove-BluGenieFirewallRule -RulePath 'BGAgent_445_Inbound_TCP'
 ``` 
 ```yam 
 Description: Remove the BGAgent_445_Inbound_TCP rules from the Windows Firewall Rule list.
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Remove-BluGenieFirewallRule -RulePath 'BGAgent_445_Inbound_TCP,BGAgent_445_Inbound_UDP'
 ``` 
 ```yam 
 Description: Remove the BGAgent_445_Inbound_TCP and BGAgent_445_Inbound_UDP rules from the Windows Firewall Rule list.
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Remove-BluGenieFirewallRule -RuleName '^BGAgent.*'
 ``` 
 ```yam 
 Description: Remove the BGAgent_445_Inbound_TCP and BGAgent_445_Inbound_UDP rules from the Windows Firewall Rule list.
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Remove-BluGenieFirewallRule -Help
 ``` 
 ```yam 
 Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
Notes: Snippet to add to your script function (Read the #region WalkThrough (Dynamic Help)) as part of this script.  Make sure to add both the snippet and the parameter to your function.
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Remove-BluGenieFirewallRule -WalkThrough
 ``` 
 ```yam 
 Description: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
Notes: Snippet to add to your script function (Read the #region WalkThrough (Dynamic Help)) as part of this script.  Make sure to add both the snippet and the parameter to your function.
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Remove-BluGenieFirewallRule -RulePath 'BGAgent_445_Inbound_TCP' -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Remove the BGAgent_445_Inbound_TCP rules from the Windows Firewall Rule list and return an UnEsacped JSON formated report.
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Remove-BluGenieFirewallRule -RulePath 'BGAgent_445_Inbound_TCP' -ReturnObject
 ``` 
 ```yam 
 Description: This will remove the BGAgent_445_Inbound_TCP rules from the Windows Firewall Rule list and return an Object with the returning results
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 


## PARAMETERS

### RuleName
 ```yam 
 -RuleName <String[]>
    Description: The name(s) of the firewall rule you would like to remove 
    Notes:  
    Alias:
    ValidateSet:
    
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
    Position?                    4
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
    Position?                    5
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


