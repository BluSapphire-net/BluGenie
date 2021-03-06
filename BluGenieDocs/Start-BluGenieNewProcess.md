# Start-BluGenieNewProcess

## SYNOPSIS
Start-BluGenieNewProcess is similar to Start-Process but can capture all Standard Output

## SYNTAX
```
Start-BluGenieNewProcess [[-FileName] <String>] [[-Arguments] <String>] [[-WorkingDirectory] <String>] [-Walkthrough] [-ReturnObject] 
[-OutUnEscapedJSON] [<CommonParameters>]
```

## DESCRIPTION
Start-BluGenieNewProcess is similar to Start-Process but can capture all Standard Output while keeping the screen hidden

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Start-BluGenieNewProcess ping.exe 'localhost'
 ``` 
 ```yam 
 Description: Start a process and capture the Standard Output using the default parameter position
Notes: 
- Sample Output -
FileName         : ping.exe                                                 
Arguments        : localhost                                                
WorkingDirectory :                                                          
StdOut           :                                                          
                  Pinging Computer1 [::1] with 32 bytes of data:
                  Reply from ::1: time<1ms                                 
                  Reply from ::1: time<1ms                                 
                  Reply from ::1: time<1ms                                 
                  Reply from ::1: time<1ms                                 
                                                                           
                  Ping statistics for ::1:                                 
                      Packets: Sent = 4, Received = 4, Lost = 0 (0% loss), 
                  Approximate round trip times in milli-seconds:           
                      Minimum = 0ms, Maximum = 0ms, Average = 0ms
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Start-BluGenieNewProcess -FileName 'ping.exe' -Arguments 'localhost' | Select-Object -ExpandProperty StdOut
 ``` 
 ```yam 
 Description: Start a process and only capture the Standard Output
Notes:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Start-BluGenieNewProcess -FileName 'ping.exe' -Arguments 'localhost'
 ``` 
 ```yam 
 Description: Start a process and capture the Standard Output using the parameter names
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Start-BluGenieNewProcess -FileName 'ping.exe' -Arguments 'localhost' -WorkingDirectory 'C:\Windows\System32'
 ``` 
 ```yam 
 Description: Start a process from a specfic Working Directory
Notes:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Start-BluGenieNewProcess -FileName 'ping.exe' -Arguments 'localhost' -ReturnObject:$false
 ``` 
 ```yam 
 Description: Start a process and capture the Standard Output and Return Output as a Hash Table
Notes:
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Start-BluGenieNewProcess -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Start-BluGenieNewProcess -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: Start-BluGenieNewProcess -FileName 'ping.exe' -Arguments 'localhost' -OutUnEscapedJSON
 ``` 
 ```yam 
 Description: Start a process and capture the Standard Output and Return Output as UnEscaped JSON format
Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.
 ``` 
 
### EXAMPLE 9
 ``` 
 Command: Start-BluGenieNewProcess -FileName 'ping.exe' -Arguments 'localhost' -ReturnObject
 ``` 
 ```yam 
 Description: Start a process and capture the Standard Output and Return Output an Object
Notes:  The ReturnObject is used to return a PowerShell Object.  This is the default
 ``` 


## PARAMETERS

### FileName
 ```yam 
 -FileName <String>
    Description: The Path and Filename of the process
    Notes:  
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Arguments
 ```yam 
 -Arguments <String>
    Description: Process arguments
    Notes:  
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    2
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### WorkingDirectory
 ```yam 
 -WorkingDirectory <String>
    Description: Working direcotry for the started process
    Notes:  
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    3
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
    Default value                True
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


