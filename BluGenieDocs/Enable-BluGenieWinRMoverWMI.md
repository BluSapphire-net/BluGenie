# Enable-BluGenieWinRMoverWMI

## SYNOPSIS
Enable-BluGenieWinRMoverWMI will try and connect to a remote host and enable WinRM

## SYNTAX
```
Enable-BluGenieWinRMoverWMI [[-ComputerName] <String>] [-looptimer <Int32>] [-termloopcounter <Int32>] [-MaxConcurrentUsers <Int32>] 
[-MaxProcessesPerShell <Int32>] [-MaxMemoryPerShellMB <Int32>] [-MaxShellsPerUser <Int32>] [-MaxShellRunTime <Int32>] [-SetMaxValues] [-SetValues] 
[-ReturnDetails] [-Walkthrough] [-ReturnObject] [-OutUnEscapedJSON] [-FormatView <String>] [<CommonParameters>]
```

## DESCRIPTION
Enable-BluGenieWinRMoverWMI will try and connect to a remote host and enable WinRM.  The Service, Firewall, and Configuration will be enabled.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Enable-BluGenieWinRMoverWMI -ComputerName [Computer Name]
 ``` 
 ```yam 
 Description: This will enable WinRM over WMI
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Enable-BluGenieWinRMoverWMI -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
          Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Enable-BluGenieWinRMoverWMI -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
          Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Enable-BluGenieWinRMoverWMI -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Enable-BluGenieWinRMoverWMI and Return Output as UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Enable-BluGenieWinRMoverWMI -ReturnObject
 ``` 
 ```yam 
 Description: Enable-BluGenieWinRMoverWMI and Return Output an Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Enable-BluGenieWinRMoverWMI -ReturnObject -FormatView JSON
 ``` 
 ```yam 
 Description: Enable-BluGenieWinRMoverWMI and Return Object formatted in a JSON view
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Enable-BluGenieWinRMoverWMI -ReturnObject -FormatView Custom
 ``` 
 ```yam 
 Description: Enable-BluGenieWinRMoverWMI and Return Object formatted in a PSCustom view
Notes:  Format-Custom is designed to display views that are not just tables or just lists. You can use the views defined in the 
           *format.PS1XML files in the PowerShell directory, or you can create your own views in new PS1XML files and use the 
           Update-FormatData cmdlet to add them to PowerShell.
 ``` 


## PARAMETERS

### ComputerName
 ```yam 
 -ComputerName <String>
    Description: Computer name of the remote host
    Notes:  
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### looptimer
 ```yam 
 -looptimer <Int32>
    Description: How long to wait before processing another loop
    Notes:  Default 5 seconds
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                5
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### termloopcounter
 ```yam 
 -termloopcounter <Int32>
    Description: How many times the process should loop before exiting
    Notes:  Default 6 times
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                6
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### MaxConcurrentUsers
 ```yam 
 -MaxConcurrentUsers <Int32>
    Description: Set WMI value for MaxConcurrentUsers
    Notes:  Default 25
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                25
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### MaxProcessesPerShell
 ```yam 
 -MaxProcessesPerShell <Int32>
    Description: Set WMI value for MaxConcurrentUsers
    Notes:  Default 100
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                100
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### MaxMemoryPerShellMB
 ```yam 
 -MaxMemoryPerShellMB <Int32>
    Description: Set WMI value for MaxMemoryPerShellMB
    Notes:  Default 1024
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                1024
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### MaxShellsPerUser
 ```yam 
 -MaxShellsPerUser <Int32>
    Description: Set WMI value for MaxShellsPerUser
    Notes:  Default 30
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                30
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### MaxShellRunTime
 ```yam 
 -MaxShellRunTime <Int32>
    Description: Set WMI value for MaxShellRunTime
    Notes:  Default 2147483647 for PowerShell 3.0 and above
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                2147483647
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### SetMaxValues
 ```yam 
 -SetMaxValues [<SwitchParameter>]
    Description: Allow for WMI value to be set to the Max Values and overwrite any parameters given.
    Notes:  
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### SetValues
 ```yam 
 -SetValues [<SwitchParameter>]
    Description: Allow for WMI value to be set.
    Notes:  By default this is view only
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ReturnDetails
 ```yam 
 -ReturnDetails [<SwitchParameter>]
    Description: Gather more detailed information on WMI and PowerShell
    Notes:  By default the return is (True / False) for Enabled or not
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
### FormatView
 ```yam 
 -FormatView <String>
    Description: Select which format to return the object data in.
    Notes: Default value is set to (None).  This value is only valid when using the -ReturnObject parameter
    Alias:
    ValidateSet: 'Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV'
    
    Required?                    false
    Position?                    named
    Default value                Table
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


