# Set-BluGenieScriptCredentials

## SYNOPSIS
Set Credentials at the command line

## SYNTAX
```
Set-BluGenieScriptCredentials [-SetUser] <String> [-SetPass] <String> [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Set Credentials without using Get-Credentials and being prompted for a password

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: $Creds = Set-BluGenieScriptCredentials -UserName 'Guest' -Password 'Password!'
 ``` 
 ```yam 
 Description: Use this command to Set Credentials and save that information to a variable called $Creds
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: $Creds = Set-ScriptCredentials -UserName 'TestDomain\Guest' -Password 'Password!'
 ``` 
 ```yam 
 Description: Use this command to Set Domain Credentials and save that information to a variable called $Creds
Notes: This command uses the Alias command name
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: $Creds = Set-ScriptCredentials -UserName 'TestDomain\Guest' -Password 'Password!'
 ``` 
 ```yam 
 $Creds.ShowPassword()Description: Use this command to show an already saved Cred Password
Notes: This is a known PowerShell method which will expose the current password.  This is not a secure method for managing Passwords.
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Set-BluGenieScriptCredentials -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Set-BluGenieScriptCredentials -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 


## PARAMETERS

### SetUser
 ```yam 
 -SetUser <String>
    Description: User Name for the Current Credentials
    Notes: You can set a domain by using "Domain_Name\UserName"
    Alias: 'UserName','Usr'
    ValidateSet:
    
    Required?                    true
    Position?                    1
    Default value                
    Accept pipeline input?       true (ByPropertyName)
    Accept wildcard characters?  false
 ``` 
### SetPass
 ```yam 
 -SetPass <String>
    Description: Password for the Current Credentials
    Notes:
    Alias: 'Password','Pw'
    ValidateSet:
    
    Required?                    true
    Position?                    2
    Default value                
    Accept pipeline input?       true (ByPropertyName)
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


