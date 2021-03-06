# Set-BluGenieCores

## SYNOPSIS
Set-BluGenieCores is an add-on to control how many Cores to use while in the BluGenie Console

## SYNTAX
```
Set-BluGenieCores [[-Cores] <Object[]>] [-Walkthrough] [<CommonParameters>]
```

## DESCRIPTION
Set-BluGenieCores is an add-on to control how many Cores to use while in the BluGenie Console

Select the amount of cores you want this job to use.  Default is (ALL).
Core information is pulled from the ($env:NUMBER_OF_PROCESSORS) variable.

## EXAMPLES

### EXAMPLE 1
 ``` 
 Command: Set-BluGenieCores
 ``` 
 ```yam 
 Description: This will set the Core to use to (ALL)
Notes:
Output:
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Set-BluGenieCores -Cores 2
 ``` 
 ```yam 
 Description :This will set the Core to use to 2
Notes:
Output:
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: Set-BluGenieCores 2,3,4
 ``` 
 ```yam 
 Description: This will set the Core to use to 2,3,4 while using Position 0 in the parameter index
Notes:
Output:
 ``` 


## PARAMETERS

### Cores
 ```yam 
 -Cores <Object[]>
    Description: Select the amount of cores you want this job to use.
    Notes: Default is (ALL)
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    1
    Default value                
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


