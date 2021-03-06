# Update-BluGenieSysinternals

## SYNOPSIS
Download and Update SysInternals tools

## SYNTAX
```
Update-BluGenieSysinternals [[-Source] <String>] [[-Destination] <String>] [[-BaseDir] <String>] [[-Algorithm] <String>] [-NoCleanUp] [-Walkthrough] 
[<CommonParameters>]
```

## DESCRIPTION
Download and Update SysInternals tools

## EXAMPLES

### EXAMPLE 1
 ``` 
 Update-BluGenieSysinternals
 ``` 
 ```yam 
 This will download the SysinternalsSuite.zip from the default Sysinternals live download area.
The file is downloaded to the default .\bin\x64\Tools directory
Once downloaded the file will be extracted to the same directory
 ``` 


## PARAMETERS

### Source
 ```yam 
 -Source <String>
    
    Required?                    false
    Position?                    1
    Default value                https://download.sysinternals.com/files/SysinternalsSuite.zip
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Destination
 ```yam 
 -Destination <String>
    Download Destination
    
    Default Value = '.\ScriptDirectory\Tools'
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    2
    Default value                $Global:ToolsDirectory
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### BaseDir
 ```yam 
 -BaseDir <String>
    Location to Extract to
    
    Default Value = '.\ScriptDirectory\Tools\'
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    3
    Default value                $Global:ToolsDirectory
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Algorithm
 ```yam 
 -Algorithm <String>
    <String> Specifies the cryptographic hash to use for computing the hash value of the contents of the specified file.
    The acceptable values for this parameter are:
    
    - SHA1
    - SHA256
    - SHA384
    - SHA512
    - MACTripleDES
    - MD5 = (Default)
    - RIPEMD160
    
    <Type>ValidateSet<Type>
    <ValidateSet>MACTripleDES,MD5,RIPEMD160,SHA1,SHA256,SHA384,SHA512<ValidateSet>
    
    Required?                    false
    Position?                    4
    Default value                MD5
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### NoCleanUp
 ```yam 
 -NoCleanUp [<SwitchParameter>]
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Walkthrough
 ```yam 
 -Walkthrough [<SwitchParameter>]
    An automated process to walk through the current function and all the parameters
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


