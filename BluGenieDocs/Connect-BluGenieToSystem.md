# Connect-BluGenieToSystem

## SYNOPSIS
Connect-BluGenieToSystem will spawn a remote session into the computer you specify

## SYNTAX
```
Connect-BluGenieToSystem [[-ComputerName] <String[]>] [-Walkthrough] [-Force] [-CopyModules] [-SystemtModulePath] [<CommonParameters>]
```

## DESCRIPTION
Connect-BluGenieToSystem is a trouble shooting process to spawn a remote session into the computer(s) you specify.
You can also send the BluGemie Module, Service, and Tools to any of the folling remote system directories
    - $env:ProgramFiles\BluGenie (This is the Default Path)
    - $env:ProgramFiles\WindowsPowerShell\ModuleSource

Note:  When you copy the tools BluGenie will not Auto Load.  It was designed to force an Import

## EXAMPLES

### EXAMPLE 1
 ``` 
 Connect-BluGenieToSystem -ComputerName 10.20.136.52
 ``` 
 ```yam 
 This will try and resolve the IP to a Domain name, test to see if the system is online, and then spawn a remote session into the system
 ``` 
 
### EXAMPLE 2
 ``` 
 Connect-BluGenieToSystem -ComputerName TestPC05
 ``` 
 ```yam 
 This will test to see if the system is online, and then spawn a remote session into the system
 ``` 


## PARAMETERS

### ComputerName
 ```yam 
 -ComputerName <String[]>
    Description: Computer name or IP Address of the remote system.
    Notes: This can be an Array of systems.  All Systems will process in an asynchronous order and all connections will be minimized at start.
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
### Force
 ```yam 
 -Force [<SwitchParameter>]
    Description: Do not test the connect to the computer, just execute the connection process
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### CopyModules
 ```yam 
 -CopyModules [<SwitchParameter>]
    Description: Copy the BluGenie Module content to the remote host over WinRM.  This will not use SMB.
    Notes: Default path is $env:\ProgramFiles\BluGenie
    
            If the default path is set you can run Import-Module 'C:\Program Files\BluGenie' to load the module
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### SystemtModulePath
 ```yam 
 -SystemtModulePath [<SwitchParameter>]
    Description: When Copying the BluGenie Module content set the save path to the default Windows PowerShell Module directory
    Notes: Path is $env:\ProgramFiles\WindowsPowerShell\Modules\BluGenie.
    
            If this path is set you can run Import-Module BluGenie without having to set a Module path
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


