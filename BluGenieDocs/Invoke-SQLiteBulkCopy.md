# Invoke-SQLiteBulkCopy

## SYNOPSIS
Use a SQLite transaction to quickly insert data

## SYNTAX
```
Invoke-SQLiteBulkCopy [-DataTable] <DataTable> [-DataSource] <String> [-Table] <String> [[-ConflictClause] <String>] [-NotifyAfter <Int32>] [-Force] 
[-QueryTimeout <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]

Invoke-SQLiteBulkCopy [-DataTable] <DataTable> [-SQLiteConnection] <SQLiteConnection> [-Table] <String> [[-ConflictClause] <String>] [-NotifyAfter 
<Int32>] [-Force] [-QueryTimeout <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Use a SQLite transaction to quickly insert data.  If we run into any errors, we roll back the transaction.

The data source is not limited to SQL Server; any data source can be used, as long as the data can be loaded to a DataTable instance or read with a 
IDataReader instance.

## EXAMPLES

### EXAMPLE 1
 ``` 
 #
 ``` 
 ```yam 
 #Create a table
    Invoke-SqliteQuery -DataSource "C:\Names.SQLite" -Query "CREATE TABLE NAMES (
        fullname VARCHAR(20) PRIMARY KEY,
        surname TEXT,
        givenname TEXT,
        BirthDate DATETIME)" 

#Build up some fake data to bulk insert, convert it to a datatable
    $DataTable = 1..10000 | %{
        [pscustomobject]@{
            fullname = "Name $_"
            surname = "Name"
            givenname = "$_"
            BirthDate = (Get-Date).Adddays(-$_)
        }
    } | Out-DataTable

#Copy the data in within a single transaction (SQLite is faster this way)
    Invoke-SQLiteBulkCopy -DataTable $DataTable -DataSource $Database -Table Names -NotifyAfter 1000 -ConflictClause Ignore -Verbose
 ``` 


## PARAMETERS

### DataTable
 ```yam 
 -DataTable <DataTable>
    
    Required?                    true
    Position?                    1
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### DataSource
 ```yam 
 -DataSource <String>
    Path to one ore more SQLite data sources to query
    
    Required?                    true
    Position?                    2
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### SQLiteConnection
 ```yam 
 -SQLiteConnection <SQLiteConnection>
    An existing SQLiteConnection to use.  We do not close this connection upon completed query.
    
    Required?                    true
    Position?                    2
    Default value                
    Accept pipeline input?       true (ByPropertyName)
    Accept wildcard characters?  false
 ``` 
### Table
 ```yam 
 -Table <String>
    
    Required?                    true
    Position?                    3
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### ConflictClause
 ```yam 
 -ConflictClause <String>
    The conflict clause to use in case a conflict occurs during insert. Valid values: Rollback, Abort, Fail, Ignore, Replace
    
    See https://www.sqlite.org/lang_conflict.html for more details
    
    Required?                    false
    Position?                    4
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### NotifyAfter
 ```yam 
 -NotifyAfter <Int32>
    The number of rows to fire the notification event after transferring.  0 means don't notify.  Notifications hit the verbose stream (use -verbose 
    to see them)
    
    Required?                    false
    Position?                    named
    Default value                0
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Force
 ```yam 
 -Force [<SwitchParameter>]
    If specified, skip the confirm prompt
    
    Required?                    false
    Position?                    named
    Default value                False
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### QueryTimeout
 ```yam 
 -QueryTimeout <Int32>
    Specifies the number of seconds before the queries time out.
    
    Required?                    false
    Position?                    named
    Default value                600
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### WhatIf
 ```yam 
 -WhatIf [<SwitchParameter>]
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ``` 
### Confirm
 ```yam 
 -Confirm [<SwitchParameter>]
    
    Required?                    false
    Position?                    named
    Default value                
    Accept pipeline input?       false
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


