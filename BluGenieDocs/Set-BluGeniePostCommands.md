# Set-BluGeniePostCommands

## SYNOPSIS
Set-BluGeniePostCommands is an add-on to manage the Post Command list in the BluGenie Console

## SYNTAX
```
Set-BluGeniePostCommands [[-Add] <String[]>] [[-Remove] <String[]>] [[-RemoveIndex] <Int32[]>] [-RemoveAll] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Set-BluGeniePostCommands is an add-on to manage the Post Command list in the BluGenie Console

Post Commands can be BluGenie Functions or any command Posh can run.
    Note: Post Command section will run in synchronous order
            Post Commands run after all the Parallel Commands have finished

o 1st   - Command section will run in synchronous order
o 2nd   - Parallel Command section will run all items at the same time.
        - Parallel Commands run after all Commands in the Command section finish
o 3rd   - Post Command section will run in synchronous order
        - Post Commands run after all the Parallel Commands have finished

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Set-BluGeniePostCommands
 ``` 
 ```yam 
 Description: This will give you a list of identified Post Commands
Notes:
OutType:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Set-BluGeniePostCommands 'Get-SystemInfo'
 ``` 
 ```yam 
 Description: This will add the specified Command to the Post Command list
Notes:
OutType:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Set-BluGeniePostCommands -Add 'Get-SystemInfo','Invoke-Netstat','Get-ProcessList'
 ``` 
 ```yam 
 Description: This will add all of the specified Commands to the Post Command list
Notes:
OutType:
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: Set-BluGeniePostCommands -Remove '^G'
 ``` 
 ```yam 
 Description: The -Remove command excepts (RegEx).  This will remove all items with a ( G ) as the first character
Notes:
OutType:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: Set-BluGeniePostCommands -Remove 'Get-SystemInfo'
 ``` 
 ```yam 
 Description: The -Remove command excepts (RegEx).  This will remove all items with 'Get-SystemInfo' in the name
Notes:
OutType:
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: Set-BluGeniePostCommands -Remove '^Get-SystemInfo$','^Get-ProcessList$'
 ``` 
 ```yam 
 Description: The -Remove command excepts (RegEx).  This will remove all items with that have an exact match of the Post Command
name
Notes:
OutType:
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: Set-BluGeniePostCommands -RemoveAll
 ``` 
 ```yam 
 Description: This will remove all items from the Post Command List
Notes:
OutType:
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: Set-BluGeniePostCommands -RemoveIndex 1
 ``` 
 ```yam 
 Description: This will remove the first item in the Command list
Notes:
OutType:
 ``` 
 
### EXAMPLE 9
 ``` 
 Command: Set-BluGeniePostCommands -RemoveIndex 1,10,12,15
 ``` 
 ```yam 
 Description: This will remove all the items from the Command list that have the specified index value.
Notes: To get the Index value you can run ( Set-BluGeniePostCommands ).  This will show the Post Command list and the index
values.
OutType:
 ``` 


## PARAMETERS

### Add
 ```yam 
 -Add <String[]>
    Description: Add items to the list
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Remove
 ```yam 
 -Remove <String[]>
    Description: Remove items from the list
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    2
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### RemoveIndex
 ```yam 
 -RemoveIndex <Int32[]>
    Description: Remove items from the list using the index value
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    3
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### RemoveAll
 ```yam 
 -RemoveAll [<SwitchParameter>]
    Description: Remove all items from the list
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
    Description: An automated process to walk through the current function and all the parameters
    Notes:
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


