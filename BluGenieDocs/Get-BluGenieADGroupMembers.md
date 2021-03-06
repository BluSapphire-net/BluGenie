# Get-BluGenieADGroupMembers

## SYNOPSIS
Query Active Directory via LDAP without the need for RSAT to be installed.

## SYNTAX
```
Get-BluGenieADGroupMembers [[-GroupName] <String>] [[-Domain] <String>] [-FullDetails] [-UseCache] [[-CachePath] <String>] [-Walkthrough] 
[-ReturnObject] [-OutUnEscapedJSON] [-OutYaml] [[-FormatView] <String>] [<CommonParameters>]
```

## DESCRIPTION
Query Active Directory via LDAP without the need for RSAT to be installed.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: $ConsoleSystems = Get-BGADGroupMembers -GroupName S_Wrk_Posh3PlusLabSystems -ReturnObject
 ``` 
 ```yam 
 Description: Use this command to Query an AD Group and assign them to the BluGenie Console Systems variable
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Get-BGADGroupMembers -GroupName S_Wrk_Posh3PlusLabSystems -ReturnObject
 ``` 
 ```yam 
 Description: Use the command to display a list of computers from an AD Group
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: ADGM -GroupName S_Wrk_Posh3PlusLabSystems -UseCache
 ``` 
 ```yam 
 Description: Use this Short-Hand Alias to create a text file with a list of computers from an AD Group
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Get-BGADGroupMembers -GroupName S_Wrk_Posh3PlusLabSystems -UseCache -FullDetails
 ``` 
 ```yam 
 Description: Use this command to create a csv file with a list of computers and their AD properties (Name,SAMAccountname,DisplayName,Description,Path)
Notes:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Get-BGADGroupMembers -GroupName S_Wrk_Posh3PlusLabSystems -OutYaml -Verbose
 ``` 
 ```yam 
 Description: Use this command to view a full detailed yaml report on the members of the AD Group and function details
Notes:
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Get-BGADGroupMembers -GroupName S_Wrk_Posh3PlusLabSystems -UseCache -CachePath .\Collections\S_Wrk_Posh3PlusLabSystems.txt
 ``` 
 ```yam 
 Description: Use this command to save the AD Group members to a specific text file.
Notes: By default the Cache location is %temp% with a BGSys_<GUID>.txt file name.
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Get-BluGenieADGroupMembers -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: Get-BluGenieADGroupMembers -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 9
 ``` 
 Command: Get-BGADGroupMembers -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Return a detailed function report in an UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 10
 ``` 
 Command: Get-BGADGroupMembers -OutYaml
 ``` 
 ```yam 
 Description: Return a detailed function report in YAML format
Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 11
 ``` 
 Command: Get-BGADGroupMembers -ReturnObject
 ``` 
 ```yam 
 Description: Return Output as a Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
        This parameter is also used with the FormatView
 ``` 
 
### EXAMPLE 12
 ``` 
 Command: Get-BluGenieADGroupMembers -ReturnObject -FormatView Yaml
 ``` 
 ```yam 
 Description: Output PSObject information in Yaml format
Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
        Default is set to (None) and normal PSObject.
 ``` 


## PARAMETERS

### GroupName
 ```yam 
 -GroupName <String>
    Description: The name of the Group you are going to do a member lookup on
    Notes: This is Mandatory.  If this option is left blank the return is Null
    Alias: GN
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Domain
 ```yam 
 -Domain <String>
    Description: The name of the Domain in which you are looking for the Group and Member information
    Notes: The default domain name is pulled from the Registry.  If this option is not set or the domain
    name is not found in the registry the return is Null
    Alias: DO
    ValidateSet:
    
    Required?                    false
    Position?                    2
    Default value                $(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\History' -Name 
    'MachineDomain' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'MachineDomain')
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### FullDetails
 ```yam 
 -FullDetails [<SwitchParameter>]
    Description: Return a PSObject with the following values (Name, SAMAccountname, DisplayName, Description and the Path)
    Notes: The default return is a list of Names (ONLY)
    Alias: FD
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### UseCache
 ```yam 
 -UseCache [<SwitchParameter>]
    Description: Cache found objects to disk
    Notes: By default the Cache location is %SystemDrive%\Windows\Temp
    Alias: UC
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### CachePath
 ```yam 
 -CachePath <String>
    Description: Path to store the Cache information
    Notes: By default the Cache location is %temp% with a BGSys_<GUID>.txt file name.
                Example: C:\Users\ADMINI~1\AppData\Local\Temp\BGSys_46964-41870-29555-35418-93311.txt
    Alias: CP
    ValidateSet:
    
    Required?                    false
    Position?                    3
    Default value                $('{0}\BGSys_{1}.txt' -f $env:temp, $(New-BluGenieUID))
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
### OutYaml
 ```yam 
 -OutYaml [<SwitchParameter>]
    Description: Return detailed information in Yaml Format
    Notes: Only supported in Posh 3.0 and above
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
    Description: Automatically format the Return Object
    Notes: Yaml is only supported in Posh 3.0 and above
    Alias:
    ValidateSet: 'Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml'
    
    Required?                    false
    Position?                    4
    Default value                None
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


