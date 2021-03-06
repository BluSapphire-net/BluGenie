# Out-DataTable

## SYNOPSIS
Creates a DataTable for an object

## SYNTAX
```
Out-DataTable [-InputObject] <PSObject[]> [-NonNullable <String[]>] [<CommonParameters>]
```

## DESCRIPTION
Creates a DataTable based on an object's properties.

## EXAMPLES

### EXAMPLE 1
 ``` 
 $dt = Get-psdrive | Out-DataTable
 ``` 
 ```yam 
 # This example creates a DataTable from the properties of Get-psdrive and assigns output to $dt variable
 ``` 
 
### EXAMPLE 2
 ``` 
 Get-Process | Select Name, CPU | Out-DataTable | Invoke-SQLBulkCopy -ServerInstance $SQLInstance -Database $Database -Table $SQLTable -force -verbose
 ``` 
 ```yam 
 # Get a list of processes and their CPU, create a datatable, bulk import that data
 ``` 


## PARAMETERS

### InputObject
 ```yam 
 -InputObject <PSObject[]>
    One or more objects to convert into a DataTable
    
    Required?                    true
    Position?                    1
    Default value                
    Accept pipeline input?       true (ByValue)
    Accept wildcard characters?  false
 ``` 
### NonNullable
 ```yam 
 -NonNullable <String[]>
    A list of columns to set disable AllowDBNull on
    
    Required?                    false
    Position?                    named
    Default value                @()
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


