# Convert-BluGenieUserName2SID

## SYNOPSIS
Convert UserName to Security ID (SID)

## SYNTAX
```
Convert-BluGenieUserName2SID [[-UserName] <String>] [[-Walkthrough]] [<CommonParameters>]
```

## DESCRIPTION
Convert UserName to Security ID (SID)

## EXAMPLES

### EXAMPLE 1
 ``` 
 Convert-BluGenieUserName2SID -UserName Administrator
 ``` 
 ```yam 
 This will return Security ID (SID) for the user 'Administrator'
 ``` 


## PARAMETERS

### UserName
 ```yam 
 -UserName <String>
    UserName to be converted to Security ID (SID)
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    1
    Default value                
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


