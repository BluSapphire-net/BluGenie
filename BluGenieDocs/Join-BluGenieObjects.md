# Join-BluGenieObjects

## SYNOPSIS
Combine 2 Object into 1 Super Object

## SYNTAX
```
Join-BluGenieObjects [-Object1] <Object> [-Object2] <Object> [<CommonParameters>]
```

## DESCRIPTION
Combine 2 Object into 1 Super Object

## EXAMPLES

### EXAMPLE 1
 ``` 
 $SuperObject = Join-BluGenieObjects -Object1 $FirstObject -Object2 $SecondObject
 ``` 
 ```yam 
 This will create a new object called $SuperObject and both Object1 and Object2 are now combined into it
 ``` 


## PARAMETERS

### Object1
 ```yam 
 -Object1 <Object>
    The Source for the first Object
    
    <Type>String<Type>
    
    Required?                    true
    Position?                    2
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Object2
 ```yam 
 -Object2 <Object>
    The Source for the second Object
    
    <Type>String<Type>
    
    Required?                    true
    Position?                    3
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


