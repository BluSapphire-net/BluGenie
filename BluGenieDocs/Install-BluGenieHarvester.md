# Install-BluGenieHarvester

## SYNOPSIS
Install-BluGenieHarvester will copy and install the Windows Event Harvester (WinLogBeat)

## SYNTAX
```
Install-BluGenieHarvester [[-Source] <String>] [[-Destination] <String>] [[-ForceCopy]] [[-Walkthrough]] [[-ReturnObject]] [[-OutUnEscapedJSON]] 
[[-ComputerName] <String>] [[-Install]] [[-Uninstall]] [[-Path] <String>] [[-ForceInstall]] [[-CopyOnly]] [<CommonParameters>]
```

## DESCRIPTION
Install-BluGenieHarvester will copy and install the Windows Event Harvester (WinLogBeat)

## EXAMPLES

### EXAMPLE 1
 ``` 
 Install-BluGenieHarvester
 ``` 
 ```yam 
 This will copy the Harvester Source to the remote systems destination and install the the Harvester service.
 ``` 
 
### EXAMPLE 2
 ``` 
 Install-BluGenieHarvester -ForceCopy -ForceInstall
 ``` 
 ```yam 
 This will copy the Harvester Source to the remote systems destination and install the the Harvester service.
If the files and service already exist the ForceCopy will overwrite the current files and the ForceInstall will
remove and install the Harvester service.
 ``` 
 
### EXAMPLE 3
 ``` 
 Install-BluGenieHarvester -Source C:\NewSource -Destination 'C:\Program Files\NewDest'
 ``` 
 ```yam 
 This will copy the Harvester Source to the remote systems destination and install the the Harvester service.
The Source and Destination can be changed.  The default values are below.

Source:       $ToolsDirectory\Blubin\WinlogBeat
Destination:  C:\Program Files\WinlogBeat623
 ``` 
 
### EXAMPLE 4
 ``` 
 Install-BluGenieHarvester -Uninstall
 ``` 
 ```yam 
 This will remove all the source files for the Harvester and uninstall the service.
 ``` 
 
### EXAMPLE 5
 ``` 
 Install-BluGenieHarvester -ReturnObject
 ``` 
 ```yam 
 This will copy the Harvester Source to the remote systems destination and install the the Harvester service
and return just the Object content

Note:  The default output is a HashTable
 ``` 
 
### EXAMPLE 6
 ``` 
 Install-BluGenieHarvester -OutUnEscapedJSON
 ``` 
 ```yam 
 This will copy the Harvester Source to the remote systems destination and install the the Harvester service
and the return data will be in a beautified json format
 ``` 


## PARAMETERS

### Source
 ```yam 
 -Source <String>
    The Source path to the items to want to send
    
    The default is set to $ToolsDirectory\Blubin\WinlogBeat
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    1
    Default value                $('{0}\Blubin\WinlogBeat\*.*' -f $ToolsDirectory)
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Destination
 ```yam 
 -Destination <String>
    The Destination path
    
    The default is set to 'C:\Program Files\WinlogBeat623'
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    2
    Default value                $('{0}\WinlogBeat623' -f $env:ProgramFiles)
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ForceCopy
 ```yam 
 -ForceCopy [<SwitchParameter>]
    Forces the file or directory creation or overwrite
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    3
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
    Position?                    4
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ReturnObject
 ```yam 
 -ReturnObject [<SwitchParameter>]
    Return information as an Object.
    By default the data is returned as a Hash Table
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    5
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### OutUnEscapedJSON
 ```yam 
 -OutUnEscapedJSON [<SwitchParameter>]
    Removed UnEsacped Char from the JSON Return.
    This will beautify json and clean up the formatting.
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    6
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ComputerName
 ```yam 
 -ComputerName <String>
    Remote computer name
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    7
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Install
 ```yam 
 -Install [<SwitchParameter>]
    Install the Harvester (This is the default option, without being called)
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    8
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Uninstall
 ```yam 
 -Uninstall [<SwitchParameter>]
    Uninstall the Harvester
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    9
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Path
 ```yam 
 -Path <String>
    The Install path and file name for the Harvester
    
    The default is set to 'C:\Program Files\WinlogBeat623\winlogbeat.exe'
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    10
    Default value                $('{0}\WinlogBeat623\winlogbeat.exe' -f $env:ProgramFiles)
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ForceInstall
 ```yam 
 -ForceInstall [<SwitchParameter>]
    Overwrite the current installation and remove and reinstall the service.
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    11
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### CopyOnly
 ```yam 
 -CopyOnly [<SwitchParameter>]
    Copies the files to the remote system but, does not process an installation
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    12
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


