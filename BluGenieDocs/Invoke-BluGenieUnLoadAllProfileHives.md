# Invoke-BluGenieUnLoadAllProfileHives

## SYNOPSIS
Unload all known users profile hives

## SYNTAX
```
Invoke-BluGenieUnLoadAllProfileHives [[-ReturnObject]] [[-Walkthrough]] [<CommonParameters>]
```

## DESCRIPTION
Unload all known users profile hives

## EXAMPLES

### EXAMPLE 1
 ``` 
 Invoke-BluGenieUnLoadAllProfileHives
 ``` 
 ```yam 
 This will unload all none used registry hives
The returned data will be a Hash Table
 ``` 
 
### EXAMPLE 2
 ``` 
 Invoke-BluGenieUnLoadAllProfileHives -ReturnObject
 ``` 
 ```yam 
 This will unload all none used registry hives
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


