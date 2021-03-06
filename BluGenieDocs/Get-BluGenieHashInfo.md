# Get-BluGenieHashInfo

## SYNOPSIS
Get-BluGenieHashInfo is a PowerShell Version 2 port of Get-FileHash

## SYNTAX
```
Get-BluGenieHashInfo [[-Path] <String[]>] [[-Algorithm] <String>] [[-Walkthrough]] [[-ReturnObject]] [[-OutUnEscapedJSON]] [-FormatView <String>] 
[<CommonParameters>]
```

## DESCRIPTION
Specifies the path to a file to hash. Wildcard characters are permitted.

Note:  If more than 1 path is specified the return will output a list of items including the Paths and Hash information of each file.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Get-BluGenieHashInfo -Path C:\Windows\Notepad.exe
 ``` 
 ```yam 
 Description: This will return the (MD5) hash value for C:\Windows\Notepad.exe
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Get-BluGenieHashInfo -Path C:\Windows\Note* -Algorithm SHA256
 ``` 
 ```yam 
 Description: This will return the (SHA256) hash value for C:\Windows\Notepad.exe
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Get-BluGenieHashInfo -Path '%Windir%\notepad.exe'
 ``` 
 ```yam 
 Description:  This will convert the path to the literal path and return the (MD5) hash value for C:\Windows\Notepad.exe
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Get-BluGenieHashInfo -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Get-BluGenieHashInfo -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Get-BluGenieHashInfo -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Get-BluGenieHashInfo and Return Output as UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Get-BluGenieHashInfo -ReturnObject
 ``` 
 ```yam 
 Description: Get-BluGenieHashInfo and Return Output an Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: Get-BluGenieHashInfo -ReturnObject -FormatView Custom
 ``` 
 ```yam 
 Description: Get-BluGenieHashInfo and Return Object formatted in a PSCustom view
Notes:  Format-Custom is designed to display views that are not just tables or just lists. You can use the views defined in the
        *format.PS1XML files in the PowerShell directory, or you can create your own views in new PS1XML files and use the
        Update-FormatData cmdlet to add them to PowerShell.
 ``` 


## PARAMETERS

### Path
 ```yam 
 -Path <String[]>
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Algorithm
 ```yam 
 -Algorithm <String>
    Description:  Specifies the cryptographic hash to use for computing the hash value of the contents of the specified file.
    Notes:  The acceptable values for this parameter are:
    
                - SHA1
                - SHA256
                - SHA384
                - SHA512
                - MACTripleDES
                - MD5 = (Default)
                - RIPEMD160
    
            If no value is specified, or if the parameter is omitted, the default value is (MD5)
    Alias:
    ValidateSet: 'MACTripleDES','MD5','RIPEMD160','SHA1','SHA256','SHA384','SHA512'
    
    Required?                    false
    Position?                    2
    Default value                MD5
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


