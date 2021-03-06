# Write-BluGenieVerboseMsg

## SYNOPSIS
Write-BluGenieVerboseMsg is used to display Time Stamped, Verbose Messages to the screen

## SYNTAX
```
Write-BluGenieVerboseMsg [[-Message] <String>] [-Color <String>] [-Status <String>] [-CheckFlag <String>] [-ClearTimers] [-Walkthrough] 
[<CommonParameters>]
```

## DESCRIPTION
Write-BluGenieVerboseMsg is used to display Time Stamped, Verbose Messages to the screen

You can view overall progress, elapsed time from one message to the next, change color and even check for an existing flag before displaying the 
message.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: $null = Write-BluGenieVerboseMsg -ClearTimers
 ``` 
 ```yam 
 Description: Clear global tracking time stamps
Notes: If you don't pass it to $null you will get a $true/$false when the process has ran
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Write-BluGenieVerboseMsg -Message "Starting" -Color 'Yellow' -Status 'StartTimer' -CheckFlag MyVerboseParam
 ``` 
 ```yam 
 Description: Setup the 1st overall message and timestamp with a message in Yellow, only if MyVerboseParam variable either (Exists or is $true)
Notes: If -CheckFlag is used the variable name (not the variable - no dollar sign) needs to be set.  If the variable is true or exists the message will show, 
          if the variable is either false or doesn't exists the message will not show
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Write-BluGenieVerboseMsg -Msg "Running a Sub Task" -Color 'Cyan' -Status 'StartTask'
 ``` 
 ```yam 
 Description: Start a new timestamp track, with a message in Cyan
Notes:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Write-BluGenieVerboseMsg -Msg "Just another message" -Color 'White' -Status '....'
 ``` 
 ```yam 
 Description: Send a generic message in White, elasped time is based on the last StartTask Timestamp
Notes:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Write-BluGenieVerboseMsg -Msg "Just another message 2" -Color 'White' -Status '....'
 ``` 
 ```yam 
 Description: Send a 2nd generic message in White, elasped time is based on the last StartTask Timestamp
Notes:
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Write-BluGenieVerboseMsg -Message "Stopping Sub Task" -Color 'Yellow' -Status 'StopTask'
 ``` 
 ```yam 
 Description: Stop and Reset the timestamp block, and display a message in Yellow
Notes:
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Write-BluGenieVerboseMsg -Msg "Stopping" -Color 'Yellow' -Status 'StopTimer' -CheckFlag MyVerboseParam
 ``` 
 ```yam 
 Description: Stop and Reset the timestamp block, remove all global time stamps, and display a message in Yellow, only if MyVerboseParam variable either (Exists or is $true)
Notes: If -CheckFlag is used the variable name (not the variable - no dollar sign) needs to be set.  If the variable is true or exists the message will show, 
          if the variable is either false or doesn't exists the message will not show
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: Write-BluGenieVerboseMsg -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 9
 ``` 
 Command: Write-BluGenieVerboseMsg -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 


## PARAMETERS

### Message
 ```yam 
 -Message <String>
    Description: Message to display
    Notes:  
    Alias: Msg
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       true (ByValue)
    Accept wildcard characters?  false
 ``` 
### Color
 ```yam 
 -Color <String>
    Description: Select the Color of the output
    Notes: Default value is ( White )
    Alias: 
    ValidateSet: 'Black','Blue','Cyan','DarkBlue','DarkCyan','DarkGray','DarkGreen','DarkMagenta','DarkRed','DarkYellow','Gray','Green','Magenta','Re
    d','White','Yellow'
    
    Required?                    false
    Position?                    named
    Default value                White
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Status
 ```yam 
 -Status <String>
    Description: Set the type of Message 
    Notes: The elapsed time from one message to another depends on what Status type you select. The default value is '....' for generic, continued 
    messaging 
    Alias:
    ValidateSet: 'StopTimer','StartTimer','....','StartTask','StopTask'
    
    Required?                    false
    Position?                    named
    Default value                ....
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### CheckFlag
 ```yam 
 -CheckFlag <String>
    Description: CheckFlag will allow you to check to see if another variable is either True/False or Exists/Not Exists.
    Notes: This will allow you to show messages based on another set action.
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ClearTimers
 ```yam 
 -ClearTimers [<SwitchParameter>]
    Description: Clear the global tracking time stamps 
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


