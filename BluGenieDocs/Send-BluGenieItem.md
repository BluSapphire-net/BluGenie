# Send-BluGenieItem

## SYNOPSIS
Send-BluGenieItem will copy files and folders to a new location.

## SYNTAX
```
Send-BluGenieItem [[-Source] <String[]>] [[-Destination] <String>] [-RelativePath <String>] [-Container] [-Force] [-Filter <String>] [-Include 
<String>] [-Exclude <String>] [-Recurse] [-FromSession] [-ToSession] [-ComputerName <String>] [-ShowProgress] [-ClearGarbageCollecting] 
[-Walkthrough] [-ReturnObject] [-OutUnEscapedJSON] [-OutYaml] [-FormatView <String>] [<CommonParameters>]
```

## DESCRIPTION
Send-BluGenieItem will copy files and folders to a new location.  Copying items can be over SMB and WinRM.  You can also copy items from a remote 
machine.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Send-BluGenieItem
 ``` 
 ```yam 
 This will output a Parameter Check validation error.
If the
    * Source
    * Destination
    * ComputerName (if -ToSession is used)
    * ComputerName (if -FromSession is used)
values are empty the command will Return an error
 ``` 
 
### EXAMPLE 2
 ``` 
 Send-BluGenieItem -Source C:\Source\git.exe -Destination '\\computer1\c$\Source' -Force
 ``` 
 ```yam 
 This will copy a file from the local machine to the destination computers UNC Share over SMB and force the file copy if the file already exists.
 ``` 
 
### EXAMPLE 3
 ``` 
 Send-BluGenieItem -Source C:\Source\*.* -Destination C:\Source -Force -ToSession -ComputerName computer1
 ``` 
 ```yam 
 This will copy file(s) from the local machine to the destination computer over WinRM and force the file copy if the file already exists.
 ``` 
 
### EXAMPLE 4
 ``` 
 Send-BluGenieItem -Source C:\Source\*.* -Destination C:\Source -ToSession -ComputerName computer1 -Recurse
 ``` 
 ```yam 
 This will copy file(s) and sub-directories from the local machine to the destination computer over WinRM
 ``` 
 
### EXAMPLE 5
 ``` 
 Send-BluGenieItem -Source C:\Source\*.* -Destination C:\Source -ToSession -ComputerName computer1 -Recurse -Exclude *.log
 ``` 
 ```yam 
 This will copy file(s) and sub-directories from the local machine to the destination computer over WinRM excluding all *.log files.
 ``` 
 
### EXAMPLE 6
 ``` 
 Send-BluGenieItem -Source C:\Source\ErrorDetails.log -Destination C:\Source\computer1 -FromSession -ComputerName computer1 -Force
 ``` 
 ```yam 
 This will copy ErrorDetails.log from the local remote machine to the local computer over WinRM.
If the destination path doesn't exist the directory will be created on the fly.
 ``` 
 
### EXAMPLE 7
 ``` 
 Send-BluGenieItem -Source C:\Source\*.* -Destination C:\Source -Force -ToSession -ComputerName computer1  -ReturnObject
 ``` 
 ```yam 
 This will copy file(s) from the local machine to the destination computer over WinRM and force the file copy if the file already exists
and return just the Object content

Note:  The default output is a HashTable
 ``` 
 
### EXAMPLE 8
 ``` 
 Send-BluGenieItem -Source C:\Source\*.* -Destination C:\Source -Force -ToSession -ComputerName computer1 -OutUnEscapedJSON
 ``` 
 ```yam 
 This will copy file(s) from the local machine to the destination computer over WinRM and force the file copy if the file already exists
and the return data will be in a beautified json format
 ``` 


## PARAMETERS

### Source
 ```yam 
 -Source <String[]>
    Description: The Source path to the items to want to send
    Notes:  This can be one or more files.  If your using ToSession or FromSession a sinle connection will be set to run all copies
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Destination
 ```yam 
 -Destination <String>
    Description: The Destination path
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    2
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### RelativePath
 ```yam 
 -RelativePath <String>
    Description: RelativePath is a string path that will be placed by the Destination path while keeping the entire directory tree
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Container
 ```yam 
 -Container [<SwitchParameter>]
    Description: Sets the Copy to a directory instead of a file
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Force
 ```yam 
 -Force [<SwitchParameter>]
    Description: Forces the file or directory creation or overwrite
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Filter
 ```yam 
 -Filter <String>
    Description: Filter what files you would like to Send to the destination
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Include
 ```yam 
 -Include <String>
    Description: Include what files you would like to Send to the destination
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Exclude
 ```yam 
 -Exclude <String>
    Description: Exclude what files you don't want to Send to the destination
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Recurse
 ```yam 
 -Recurse [<SwitchParameter>]
    Description: Recurse through subdirectories
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### FromSession
 ```yam 
 -FromSession [<SwitchParameter>]
    Description: Copy from a remote session over WinRM
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ToSession
 ```yam 
 -ToSession [<SwitchParameter>]
    Description: Copy to a remote session over WinRM
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ComputerName
 ```yam 
 -ComputerName <String>
    Description: Remote computer name
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ShowProgress
 ```yam 
 -ShowProgress [<SwitchParameter>]
    Description: Show Progress Bar when copying data
    Notes: Disabled by default
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ClearGarbageCollecting
 ```yam 
 -ClearGarbageCollecting [<SwitchParameter>]
    Description: Garbage Collection in Powershell to Speed up Scripts and help lower memory consumption
    Notes: This is enabled by default.  To disable use -ClearGarbageCollecting:$False
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
    Position?                    named
    Default value                None
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


