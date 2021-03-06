# Get-BluGenieLiteralPath

## SYNOPSIS
Get-BluGenieLiteralPath will convert System Variable defined paths to a Literal Path

## SYNTAX
```
Get-BluGenieLiteralPath [[-Path] <String>] [[-Walkthrough]] [<CommonParameters>]
```

## DESCRIPTION
Get-BluGenieLiteralPath will convert System Variable defined paths to a Literal Path

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Get-BluGenieLiteralPath -Path '%SystemDrive%\Users\%Username%'
 ``` 
 ```yam 
 Description: Return a literal path of ( C:\Users\Administrator )
Notes:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Get-BluGenieLiteralPath -Help
 ``` 
 ```yam 
 Description: Call Help Information
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Get-BluGenieLiteralPath -WalkThrough
 ``` 
 ```yam 
 Description: Call Help Information [2]
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter
 ``` 


## PARAMETERS

### Path
 ```yam 
 -Path <String>
    Description: Specifies the path to convert or validate
    Notes:  
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    2
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
    Position?                    3
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


