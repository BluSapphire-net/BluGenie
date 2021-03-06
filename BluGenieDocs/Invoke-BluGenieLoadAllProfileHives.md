# Invoke-BluGenieLoadAllProfileHives

## SYNOPSIS
Load all known users profile hives

## SYNTAX
```
Invoke-BluGenieLoadAllProfileHives [[-ReturnObject]] [[-Walkthrough]] [<CommonParameters>]
```

## DESCRIPTION
Load all known users profile hives.  Load all profile NTUSER.DAT from %SystemDrive%\Users

## EXAMPLES

### EXAMPLE 1
 ``` 
 Invoke-BluGenieLoadAllProfileHives
 ``` 
 ```yam 
 This will load all profile NTUSER.DAT from %SystemDrive%\Users
The returned data will be a Hash Table
 ``` 
 
### EXAMPLE 2
 ``` 
 Invoke-BluGenieLoadAllProfileHives -ReturnObject
 ``` 
 ```yam 
 This will load all profile NTUSER.DAT from %SystemDrive%\Users
The returned data will be an Object
 ``` 


## PARAMETERS

### ReturnObject
 ```yam 
 -ReturnObject [<SwitchParameter>]
    Return information as an Object.
    By default the data is returned as a Hash Table
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    1
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Walkthrough
 ```yam 
 -Walkthrough [<SwitchParameter>]
    
    Required?                    false
    Position?                    2
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


