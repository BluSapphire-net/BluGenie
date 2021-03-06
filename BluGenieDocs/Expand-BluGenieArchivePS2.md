# Expand-BluGenieArchivePS2

## SYNOPSIS
Expand-BluGenieArchivePS2 Extracts files from a specified archive (zipped) file.

## SYNTAX
```
Expand-BluGenieArchivePS2 [[-Path] <String>] [[-Destination] <String>] [[-NoProgressBar]] [[-Force]] [[-ProgressOnly]] [[-NoErrorMsg]] 
[[-Walkthrough]] [[-ReturnObject]] [[-OutUnEscapedJSON]] [<CommonParameters>]
```

## DESCRIPTION
Expand-BluGenieArchivePS2 is a PowerShell 2.0 version of Expand-Archive which extracts files from a specified archive (zipped) file.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Expand-BluGenieArchivePS2 -Path C:\Source\SysinternalsSuite.zip -Destination C:\Source\SysinternalsSuite
 ``` 
 ```yam 
 This will extact the zip files contents to the destination directory.  If the directory doesn't exist it will be created on the fly.
~ By default this will not overwrite any files 
~ A progress bar is displayed showing the current activities, including what file is currently being extracted.
 ``` 
 
### EXAMPLE 2
 ``` 
 Expand-BluGenieArchivePS2 -Path C:\Source\SysinternalsSuite.zip -Destination C:\Source\SysinternalsSuite -ProgressOnly
 ``` 
 ```yam 
 This will extact the zip files contents to the destination directory.  If the directory doesn't exist it will be created on the fly.
~ By default this will not overwrite any files 
~ A progress bar is displayed showing the current activities.  However all file names are hidden from view.  Only the overall progress is shown.
 ``` 
 
### EXAMPLE 3
 ``` 
 Expand-BluGenieArchivePS2 -Path C:\Source\SysinternalsSuite.zip -Destination C:\Source\SysinternalsSuite -NoProgressBar -NoErrorMsg -Force
 ``` 
 ```yam 
 This will extact the zip files contents to the destination directory.  If the directory doesn't exist it will be created on the fly.
~ All extracted content with the same name as the destination direcotry content will be overwritten 
~ All progress information including error messages will be hidden
 ``` 
 
### EXAMPLE 4
 ``` 
 Expand-BluGenieArchivePS2 -Path C:\Source\SysinternalsSuite.zip -Destination C:\Source\SysinternalsSuite -NoProgressBar -NoErrorMsg -Force -ReturnObject
 ``` 
 ```yam 
 This will extact the zip files contents to the destination directory.  If the directory doesn't exist it will be created on the fly.
~ All extracted content with the same name as the destination direcotry content will be overwritten 
~ All progress information including error messages will be hidden
~ The Return data will be in an Object format.  $true / $false
 ``` 
 
### EXAMPLE 5
 ``` 
 Expand-BluGenieArchivePS2 -Path C:\Source\SysinternalsSuite.zip -Destination C:\Source\SysinternalsSuite -NoProgressBar -NoErrorMsg -Force -OutUnEscapedJSON
 ``` 
 ```yam 
 This will extact the zip files contents to the destination directory.  If the directory doesn't exist it will be created on the fly.
~ All extracted content with the same name as the destination direcotry content will be overwritten 
~ All progress information including error messages will be hidden
~ The Return data will be in a beautified json format
 ``` 


## PARAMETERS

### Path
 ```yam 
 -Path <String>
    The .Zip file source path
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    2
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Destination
 ```yam 
 -Destination <String>
    The Destination path
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    3
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### NoProgressBar
 ```yam 
 -NoProgressBar [<SwitchParameter>]
    Do not show an active progress bar
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    4
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Force
 ```yam 
 -Force [<SwitchParameter>]
    Forces the file overwrite
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    5
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ProgressOnly
 ```yam 
 -ProgressOnly [<SwitchParameter>]
    Only show the progress bar, do not show the extracted content.
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    6
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### NoErrorMsg
 ```yam 
 -NoErrorMsg [<SwitchParameter>]
    Do not show any pop up error messages to the screen
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    7
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
    Position?                    8
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
    Position?                    9
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
    Position?                    10
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


