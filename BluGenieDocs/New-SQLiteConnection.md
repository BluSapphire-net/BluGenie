# New-SQLiteConnection

## SYNOPSIS
Creates a SQLiteConnection to a SQLite data source

## SYNTAX
```
New-SQLiteConnection [-DataSource] <String[]> [[-Password] <SecureString>] [[-ReadOnly]] [[-Open] <Boolean>] [<CommonParameters>]
```

## DESCRIPTION
Creates a SQLiteConnection to a SQLite data source

## EXAMPLES

### EXAMPLE 1
 ``` 
 $Connection = New-SQLiteConnection -DataSource C:\NAMES.SQLite
 ``` 
 ```yam 
 Invoke-SQLiteQuery -SQLiteConnection $Connection -query $Query

# Connect to C:\NAMES.SQLite, invoke a query against it
 ``` 
 
### EXAMPLE 2
 ``` 
 $Connection = New-SQLiteConnection -DataSource :MEMORY:
 ``` 
 ```yam 
 Invoke-SqliteQuery -SQLiteConnection $Connection -Query "CREATE TABLE OrdersToNames (OrderID INT PRIMARY KEY, fullname TEXT);"
Invoke-SqliteQuery -SQLiteConnection $Connection -Query "INSERT INTO OrdersToNames (OrderID, fullname) VALUES (1,'Cookie Monster');"
Invoke-SqliteQuery -SQLiteConnection $Connection -Query "PRAGMA STATS"

# Create a connection to a SQLite data source in memory
# Create a table in the memory based datasource, verify it exists with PRAGMA STATS

$Connection.Close()
$Connection.Open()
Invoke-SqliteQuery -SQLiteConnection $Connection -Query "PRAGMA STATS"

#Close the connection, open it back up, verify that the ephemeral data no longer exists
 ``` 


## PARAMETERS

### DataSource
 ```yam 
 -DataSource <String[]>
    SQLite Data Source to connect to.
    
    Required?                    true
    Position?                    1
    Default value                
    Accept pipeline input?       true (ByValue, ByPropertyName)
    Accept wildcard characters?  false
 ``` 
### Password
 ```yam 
 -Password <SecureString>
    Specifies A Secure String password to use in the SQLite connection string.
            
    SECURITY NOTE: If you use the -Debug switch, the connectionstring including plain text password will be sent to the debug stream.
    
    Required?                    false
    Position?                    3
    Default value                
    Accept pipeline input?       true (ByPropertyName)
    Accept wildcard characters?  false
 ``` 
### ReadOnly
 ```yam 
 -ReadOnly [<SwitchParameter>]
    If specified, open SQLite data source as read only
    
    Required?                    false
    Position?                    4
    Default value                False
    Accept pipeline input?       true (ByPropertyName)
    Accept wildcard characters?  false
 ``` 
### Open
 ```yam 
 -Open <Boolean>
    We open the connection by default.  You can use this parameter to create a connection without opening it.
    
    Required?                    false
    Position?                    5
    Default value                True
    Accept pipeline input?       true (ByPropertyName)
    Accept wildcard characters?  false
 ```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).


