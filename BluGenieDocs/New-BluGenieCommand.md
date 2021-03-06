# New-BluGenieCommand

## SYNOPSIS
New-BluGenieCommand will take a list of arguments and build out a command line string for [ScriptBlock] execution

## SYNTAX
```
New-BluGenieCommand [[-Name] <String>] [[-BoundParameters] <Object>] [[-Walkthrough]] [<CommonParameters>]
```

## DESCRIPTION
New-BluGenieCommand will take a list of arguments and build out a command line string for [ScriptBlock] execution

The advantage of this script is to take arguments from the parent functions $PSBoundParameters and use them to execute nested cmdlets

## EXAMPLES

### EXAMPLE 1
 ``` 
 $Source = "$ScriptDirectory\Tools\SysinternalsSuite"
 ``` 
 ```yam 
 $Destination = "C:\Source"
$Container = $true
$Recurse = $false
$Force = $false

$ArrParamList = [PSCustomObject]@{
    'Path' = $Source
    'Destination' = $Destination
    'Filter' = $Filter
    'Container' = $Container
    'Include' = $Include
    'Exclude' = $Exclude
    'Recurse' = $Recurse
    'Force' = $Force
}

New-BluGenieCommand -Name 'Copy-Item' -BoundParameters $ArrParamList -ErrorAction SilentlyContinue

$NewCommand.Invoke()

This will dynamically build out the Copy-Item string from the variables defined (normally $PSBoundParameters from the parent script)
and invoke the command.
 ``` 


## PARAMETERS

### Name
 ```yam 
 -Name <String>
    The name of the command [cmdlet] you're building the string for.
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### BoundParameters
 ```yam 
 -BoundParameters <Object>
    [PSCustomObject] with all the parameters needed to build the new cmdlet / command
    
    <Type>String<Type>
    
    Required?                    false
    Position?                    2
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Walkthrough
 ```yam 
 -Walkthrough [<SwitchParameter>]
    An automated process to walk through the current function and all the parameters
    
    <Type>SwitchParameter<Type>
    
    Required?                    false
    Position?                    3
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


