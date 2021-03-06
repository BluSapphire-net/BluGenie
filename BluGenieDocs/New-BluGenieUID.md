# New-BluGenieUID

## SYNOPSIS
Create a New UID

## SYNTAX
```
New-BluGenieUID [[-NumPerSet] <Int32>] [[-NumOfSets] <Int32>] [[-Delimiter] <String>] [[-Walkthrough]] [<CommonParameters>]
```

## DESCRIPTION
Create a New UID

You can specify any delimter, how many char per set, and how many sets

- Sample Output -

* 086
* 1-3-8
* 80.46
* 4_6_1_6
* 6366*8083*1176*1972
* 85221-93304-78886-45563-09558

## EXAMPLES

### EXAMPLE 1
 ``` 
 New-BluGenieUID
 ``` 
 ```yam 
 This will output a random UID based on the default settings
5 Chars per set, with 5 Sets of Chars, and the delimiter is ( - )

54555-13241-72594-03233-72927
 ``` 
 
### EXAMPLE 2
 ``` 
 New-BluGenieUID -NumbPerSet 2 -NumbOfSets 4 -Delimiter '.'
 ``` 
 ```yam 
 This will output a random UID based on the default settings
2 Chars per set, with 4 Sets of Chars, and the delimiter is ( . )

61.01.26.89
 ``` 


## PARAMETERS

### NumPerSet
 ```yam 
 -NumPerSet <Int32>
    Option = "1"    - 1 Char Per Set    #
    Option = "2"    - 2 Char's Per Set  ##
    Option = "3"    - 3 Char's Per Set  ###
    Option = "4"    - 4 Char's Per Set  ####
    Option = "5"    - 5 Char's Per Set  #####
    
    <Type>ValidateSet<Type>
    <ValidateSet>1,2,3,4,5<ValidateSet>
    
    Required?                    false
    Position?                    1
    Default value                5
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### NumOfSets
 ```yam 
 -NumOfSets <Int32>
    Option = "1"    - 1 Set    *
    Option = "2"    - 2 Sets   *-*
    Option = "3"    - 3 Sets   *-*-*
    Option = "4"    - 4 Sets   *-*-*-*
    Option = "5"    - 5 Sets   *-*-*-*-*
    
    <Type>ValidateSet<Type>
    <ValidateSet>1,2,3,4,5<ValidateSet>
    
    Required?                    false
    Position?                    2
    Default value                5
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Delimiter
 ```yam 
 -Delimiter <String>
    Delimiter used to seperate each char set
    
    Default = '-'
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    3
    Default value                -
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


