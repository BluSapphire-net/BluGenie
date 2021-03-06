# Invoke-PSipcalc

## SYNOPSIS
Provides detailed network information. Accepts CIDR notation and IP / subnet mask.
Inspired by the utility "ipcalc" on Linux.

Svendsen Tech.
Copyright (c) 2015, Joakim Svendsen
All rights reserved.

MIT license. http://www.opensource.org/licenses/MIT

## SYNTAX
```
Invoke-PSipcalc [-NetworkAddress] <String[]> [[-Contains] <String>] [-Enumerate] [<CommonParameters>]
```

## DESCRIPTION


## EXAMPLES

### 
 ``` 
 
 ``` 
 ```yam 
 
 ``` 


## PARAMETERS

### NetworkAddress
 ```yam 
 -NetworkAddress <String[]>
    CIDR notation network address, or using subnet mask. Examples: '192.168.0.1/24', '10.20.30.40/255.255.0.0'.
    
    Required?                    true
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Contains
 ```yam 
 -Contains <String>
    Causes PSipcalc to return a boolean value for whether the specified IP is in the specified network. Includes network address and broadcast 
    address.
    
    Required?                    false
    Position?                    2
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Enumerate
 ```yam 
 -Enumerate [<SwitchParameter>]
    Enumerates all IPs in subnet (potentially resource-expensive). Ignored if you use -Contains.
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


