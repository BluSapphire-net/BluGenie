# Get-BluGenieTrapData

## SYNOPSIS
Get-BluGenieTrapData will report back any captured BluGenie trap logs.  Functions as follows
    * List - Display a list of all the Blugenie Logs captured on the remote machine
    * Path - Specificy a path to query for Blugenie Logs (By defautl this is %SystemDrive%\Windows\Temp)
    * FileName - Specifically select which file you want to report on (By default the last file created is picked).  The file name can be picked using RegEx.
    * JobID - Specify which file you want to remote on using the Job ID (Be default this is the last log created with the Job ID specified.  You can have more then one log with the same Job ID)
    * Remove - Remove a Specific log file
    * RemoveAll - Remove BluGenie log files including the Debugging Log files
    * Overwrite - Return the current JSON Job data to look just like the Trapped Log data for easier reporting and parsing

## SYNTAX
```
Get-BluGenieTrapData [[-Path] <String>] [[-FileName] <String>] [-JobID <String>] [-List] [-Remove] [-RemoveAll] [-OverWrite] [-Walkthrough] 
[-ReturnObject] [-OutUnEscapedJSON] [-FormatView <String>] [<CommonParameters>]
```

## DESCRIPTION
Invoke-WalkThrough is Dynamic Help.  It will convert the static PowerShell help into an interactive menu system
    -Added with a few new tag descriptors for (Parameter and Examples).  This information will structure the help 
    information displayed and also help with bulding  the dynamic help menu

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Get-BluGenieTrapData -List
 ``` 
 ```yam 
 Description: List all BluGenie log files from the default location $ENV:SystemDrive\Windows\Temp
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Get-TrapData -path '\\win7sp1001\c$\Windows\Temp' -ReturnObject -List
 ``` 
 ```yam 
 Description: List all BluGenie log files from a remote systems log location.  Return on the Name, File Size, and LastWriteTime
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Get-BluGenieTrapData
 ``` 
 ```yam 
 Description: Return the last written log file from the default log location
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Get-BluGenieTrapData -path '\\win7sp1001\c$\Windows\Temp' -ReturnObject -Remove
 ``` 
 ```yam 
 Description: Return the last written log file data in an object format and, remove the file from disk
Notes:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Get-BluGenieTrapData -Remove -List
 ``` 
 ```yam 
 Description: Remove all items that are found
Notes:
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Get-BluGenieTrapData -RemoveAll -List
 ``` 
 ```yam 
 Description: Remove all items that are found
Notes:
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Get-BluGenieTrapData -path '\\win7sp1001\c$\Windows\Temp' -Remove
 ``` 
 ```yam 
 Description: Remove the file on disk after grabbing the trapped data
Notes:
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: Get-BluGenieTrapData -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 9
 ``` 
 Command: Get-BluGenieTrapData -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 10
 ``` 
 Command: Get-BluGenieTrapData -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: <command_here> and Return Output as UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 11
 ``` 
 Command: Get-BluGenieTrapData -ReturnObject
 ``` 
 ```yam 
 Description: <command_here> and Return Output an Object
Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
 ``` 


## PARAMETERS

### Path
 ```yam 
 -Path <String>
    Description:  Path to the BG*.log files.
    Notes: Default is set to $ENV:Systemdrive\Windows\Temp
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                $('{0}\Windows\Temp' -f $env:SystemDrive)
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### FileName
 ```yam 
 -FileName <String>
    Description:  Specify which file to pull
    Notes:  You can determine what log files are saved using the -List parameter
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    2
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### JobID
 ```yam 
 -JobID <String>
    Description:  Specify the Job ID
    Notes:  The last file created with the Job ID specified will be the information returned
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### List
 ```yam 
 -List [<SwitchParameter>]
    Description:  List all the BG*.log files
    Notes:  You can return just file File Names, LastWriteTime, and Size by using the -ReturnObject parameter
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Remove
 ```yam 
 -Remove [<SwitchParameter>]
    Description:  Remove the file specified or the last know log file found
    Notes:  
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### RemoveAll
 ```yam 
 -RemoveAll [<SwitchParameter>]
    Description:  Remove all BG*.log files
    Notes:  
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### OverWrite
 ```yam 
 -OverWrite [<SwitchParameter>]
    Description:  Flag used to return the Trapped data as the original return in BluGenie
    Notes:  
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
    
    Required?                    false
    Position?                    named
    Default value                None
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


