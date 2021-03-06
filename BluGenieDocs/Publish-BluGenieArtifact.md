# Publish-BluGenieArtifact

## SYNOPSIS
Manage Artifact data from a JSON/YAML file to query local and remote systems for a specfic Indicator of compromise or IOC

## SYNTAX
```
Publish-BluGenieArtifact [[-Artifact] <String>] [-Import] [[-Export] <String>] [-Remove] [-Review] [[-ExportType] <String>] [-Walkthrough] 
[<CommonParameters>]
```

## DESCRIPTION
Import, Export, and Review Artifact data from a JSON/YAML file.
Artifacts are contructed logic to query local and remote systems for a specfic Indicator of compromise or IOC

IOC is a forensic term that refers to the evidence on a device that points out to a security breach. The data
of IOC is gathered after a suspicious incident, security event or unexpected call-outs from the network.

## EXAMPLES

### EXAMPLE 1
 ``` 
 
 ``` 
 ```yam 
 Description: Use this commadn to set the Artifact and get it ready for importing or review
Notes: This option uses the default cmdlet name
 ``` 
 
### EXAMPLE 2
 ``` 
 Command: Publish-BGArtifact -Artifact .
 ``` 
 ```yam 
 Description: Use this command to quickly bring up the file select dialog to manually select the Artifact to import
Notes: This option uses the Short-Hand cmdlet name
 ``` 
 
### EXAMPLE 3
 ``` 
 Command: BGArtifact -Review
 ``` 
 ```yam 
 Description: Use this command to show any issues with the currently selected Artifact.
Notes: This option uses the BG Alias name
 ``` 
 
### EXAMPLE 4
 ``` 
 Command: BGArtifact -Artifact .\Artifacts\TestPack.YAML -Review
 ``` 
 ```yam 
 Description: Use this command to Select the Artifact and to process a Review on it with a single command
Notes:
 ``` 
 
### EXAMPLE 5
 ``` 
 Command: BGArtifact -Import
 ``` 
 ```yam 
 Description: Use this command to import and utilize an Artifact
Notes: If an Artifact was not previsouly set, a file select dialog will be displayed to manually select the Artifact to import
 ``` 
 
### EXAMPLE 6
 ``` 
 Command: BGArtifact -Artifact .\Artifacts\TestPack.YAML -Import
 ``` 
 ```yam 
 Description: Use this command to Select and Import an Artifact to process
Notes:
 ``` 
 
### EXAMPLE 7
 ``` 
 Command: BGArtifact -ExportType 'JSON' -Export .\QueryOpenPorts
 ``` 
 ```yam 
 Description: Use this command to export an Artifact to a JSON formated file.
Notes: Items will be saved in the .\Artifacts\ Directory
 ``` 
 
### EXAMPLE 8
 ``` 
 Command: BGArtifact -Export .\QueryOpenPorts
 ``` 
 ```yam 
 Description: Use this command to export an Artifact to a YAML formated file.
Notes: YAML is the default export format.  Items will be saved in the .\Artifacts\ Directory
 ``` 
 
### EXAMPLE 9
 ``` 
 Command: BGArtifact -Help
 ``` 
 ```yam 
 Description: Use this command to provide you with an interactive help system to show more examples and commands
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
        Get-Help will be called with the -Full parameter
 ``` 
 
### EXAMPLE 10
 ``` 
 Command: BGArtifact -WalkThrough
 ``` 
 ```yam 
 Description: Use this command to provide you with an interactive help system to show more examples and commands
Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
        Get-Help will be called with the -Full parameter
 ``` 


## PARAMETERS

### Artifact
 ```yam 
 -Artifact <String>
    
    Required?                    false
    Position?                    1
    Default value                $global:ConsoleJSONJob
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Import
 ```yam 
 -Import [<SwitchParameter>]
    Description: Import a JSON/YAML Artifact to use to query local and remote systems for a specfic IOC
    Notes:
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Export
 ```yam 
 -Export <String>
    Description: Export the BluGenie Console settings into a JSON/YAML Artifact
    Notes: YAML is the default export type.  If you want to change it set -Exporttype 'JSON'
    Alias:
    ValidateSet: 'YAML','JSON'
    
    Required?                    false
    Position?                    2
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Remove
 ```yam 
 -Remove [<SwitchParameter>]
    Description: Remove the currently selected Artifact
    Notes: If there is no Artifact selected and you run the -Import parameter you will be given a file dialog to choose an Artifact
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Review
 ```yam 
 -Review [<SwitchParameter>]
    Description: Review a JSON/YAML Artifact without overwritting any predefined Artifact settings
    Notes:  In the BluGenie Conole you can manually update the Artifact settings even while reviewing another Artifact
    Alias:
    ValidateSet:
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ExportType
 ```yam 
 -ExportType <String>
    Description: Select what Artifact format to export to.
    Notes:  The default is 'YAML'
    Alias:
    ValidateSet: 'YAML','JSON'
    
    Required?                    false
    Position?                    3
    Default value                YAML
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
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


