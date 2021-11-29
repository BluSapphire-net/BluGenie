#region Invoke-BluGenieSQLLQuery (Function)
Function Invoke-BluGenieSQLLQuery
{
<#
    .SYNOPSIS
        Invoke-BluGenieSQLLQuery is a shim function to ( Invoke-SqliteQuery ) which helps manage SQL queries and gives us a correctly
formatted return for BluGenie reporting

    .DESCRIPTION
        Invoke-BluGenieSQLLQuery is a shim function to ( Invoke-SqliteQuery ) which helps manage SQL queries and gives us a correctly
formatted return for BluGenie reporting

    .PARAMETER DBName
        Description: Database Name (Without extention)
        Notes: The default name is set to 'BluGenie'
        Alias:
        ValidateSet:

    .PARAMETER DBPath
        Description: Path to either Save or Update the Database
        Notes: The default path is $('{0}\BluGenie' -f $env:ProgramFiles)  Example: C:\Program Files\BluGenie
        Alias:
        ValidateSet:

    .PARAMETER QueryString
        Description: SQL String to query for specific data from the SQlite Database
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER File
        Description: Full file path to a file housing a SQL Query string
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .PARAMETER UseCache
        Description: Cache found objects to disk.  This is to not over tax Memory resources with found artifacts
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp
        Alias:
        ValidateSet:

    .PARAMETER RemoveCache
        Description: Remove Cache data on completion
        Notes: Cache information is removed right before the data is returned to the calling process
        Alias:
        ValidateSet:

    .PARAMETER CachePath
        Description: Path to store the Cache information
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp
        Alias:
        ValidateSet:

    .PARAMETER ClearGarbageCollecting
        Description: Garbage Collection in Powershell to Speed up Scripts and help lower memory consumption
        Notes: This is enabled by default.  To disable use -ClearGarbageCollecting:$False
        Alias:
        ValidateSet:

    .PARAMETER ReturnObject
        Description: Return information as an Object
        Notes: By default the data is returned as a Hash Table
        Alias:
        ValidateSet:

    .PARAMETER OutUnEscapedJSON
        Description: Remove UnEsacped Char from the JSON information.
        Notes: This will beautify json and clean up the formatting.
        Alias:
        ValidateSet:

    .PARAMETER FormatView
        Description: Automatically format the Return Object
        Notes: Yaml is only supported in Posh 3.0 and above
        Alias:
        ValidateSet: 'Table', 'Custom', 'CustomModified', 'None', 'JSON', 'OutUnEscapedJSON', 'CSV'

    .EXAMPLE
        Command: Invoke-BGSQLLQuery -QueryString "SELECT
    FullName,
    Hash
FROM
    BGChildItemList
WHERE
    Hash = 'd4d2883b821d5e95805336234a50c7e8'"
        Description: Return Fullname, and Hash information for a specific item that matches the requested Hash
        Notes:

    .EXAMPLE
        Command: Invoke-BGSQLLQuery -File .\Tools\Blubin\Modules\BluGenie\Configs\SQL\grabhash.sql
        Description: Query the Sqlite Database using a Query from a file
        Notes:

    .EXAMPLE
        Command: Invoke-BluGenieSQLLQuery -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Invoke-BluGenieSQLLQuery -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Invoke-BGSQLLQuery -File .\Tools\Blubin\Modules\BluGenie\Configs\SQL\grabhash.sql -OutUnEscapedJSON
        Description: Return a detailed function report in an UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Invoke-BGSQLLQuery -File .\Tools\Blubin\Modules\BluGenie\Configs\SQL\grabhash.sql -OutYaml
        Description: Return a detailed function report in YAML format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Invoke-BGSQLLQuery -File .\Tools\Blubin\Modules\BluGenie\Configs\SQL\grabhash.sql -ReturnObject
        Description: Return Output as a Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
                This parameter is also used with the ForMat

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • [Original Author]
            o    Michael Arroyo
        • [Original Build Version]
            o    21.01.0401 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o
        • [Latest Build Version]
            o
        • [Comments]
            o
        • [PowerShell Compatibility]
            o    2,3,4,5.x
        • [Forked Project]
            o
        • [Links]
            o
        • [Dependencies]
            o    Invoke-BluGenieWalkThrough or Invoke-WalkThrough - interactive help menu system
            o    Clear-BlugenieMemory or Clear-Memory or CM - Free up any garbage collecting that Powershell is managing
#>

#region Build Notes
    <#
        • [Build Version Details]
            o 21.01.0401: * [Michael Arroyo] Function Template
                          * [Michael Arroyo] Posted
    #>
#endregion Build Notes

    [cmdletbinding()]
    [Alias('Invoke-SQLLQuery', 'Invoke-BGSQLLQuery', 'SQLLQ')]
    #region Parameters
        Param
        (
            [Parameter(Position = 0)]
            [String[]]$QueryString,

            [String]$File,

            [String]$DBName = 'BluGenie',

            [String]$DBPath = $('{0}\BluGenie' -f $env:ProgramFiles),

            [Switch]$ClearGarbageCollecting,

            [Alias('Help')]
            [Switch]$Walkthrough,

            [Switch]$ReturnObject,

            [Switch]$OutUnEscapedJSON,

            [ValidateSet('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV')]
            [string]$FormatView = 'None'
        )
    #endregion Parameters

    #region WalkThrough (Dynamic Help)
        If
        (
            $Walkthrough
        )
        {
            If
            (
                $($PSCmdlet.MyInvocation.InvocationName)
            )
            {
                $Function = $($PSCmdlet.MyInvocation.InvocationName)
            }
            Else
            {
                If
                (
                    $Host.Name -match 'ISE'
                )
                {
                    $Function = $(Split-Path -Path $psISE.CurrentFile.FullPath -Leaf) -replace '((?:.[^.\r\n]*){1})$'
                }
            }

            If
            (
                Test-Path -Path Function:\Invoke-BluGenieWalkThrough
            )
            {
                If
                (
                    $Function -eq 'Invoke-BluGenieWalkThrough'
                )
                {
                    #Disable Invoke-BluGenieWalkThrough looping
                    Invoke-Command -ScriptBlock { Invoke-BluGenieWalkThrough -Name $Function -RemoveRun }
                    Return
                }
                Else
                {
                    Invoke-Command -ScriptBlock { Invoke-BluGenieWalkThrough -Name $Function }
                    Return
                }
            }
            Else
            {
                Get-Help -Name $Function -Full
                Return
            }
        }
    #endregion WalkThrough (Dynamic Help)

    #region Create Return hash
        $HashReturn = @{}
        $HashReturn['BGSQLLQuery'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['BGSQLLQuery']['Items'] = @()
        $HashReturn['BGSQLLQuery']['Comment'] = @()
        If
        (
            $VerbosePreference -eq 'Continue'
        )
        {
            $HashReturn['BGSQLLQuery'].StartTime = $($StartTime).DateTime
            $HashReturn['BGSQLLQuery']['Query'] = @()
            $HashReturn['BGSQLLQuery']['ParameterSetResults'] = @()
        }
    #endregion Create Return hash

    #region Parameter Set Results
        If
        (
            $VerbosePreference -eq 'Continue'
        )
        {
            $HashReturn['BGSQLLQuery']['ParameterSetResults'] = $PSBoundParameters
        }
    #endregion Parameter Set Results

    #region Build Data Table Hash Table
        #region Create Hash Table
            $HSqlite = @{}
        #endregion Create Hash Table

        #region Set Database Full Path
            $HSqlite.DBPath = $DBPath
            $HSqlite.DBName = $DBName
            $HSqlite.Database = Join-Path -Path $($HSqlite.DBPath) -ChildPath $('{0}.SQLite' -f $($HSqlite.DBName))
        #endregion Set Database Full Path
    #endregion Build Data Table Hash Table

    #region Main
        $Error.Clear()

        If
        (
            $QueryString
        )
        {
            Try
            {
                $HashReturn['BGSQLLQuery']['Items'] += Invoke-SqliteQuery -DataSource $($HSqlite.Database) -Query "$QueryString"
            }
            Catch
            {
                $HashReturn['BGSQLLQuery']['Comment'] += $error
            }
        }
        else
        {
            Try
            {
                $HashReturn['BGSQLLQuery']['Items'] += Invoke-SqliteQuery -DataSource $($HSqlite.Database) -InputFile $File
            }
            Catch
            {
                $HashReturn['BGSQLLQuery']['Comment'] += $error
            }
        }
    #endregion Main

    #region Output
        If
        (
            $VerbosePreference -eq 'Continue'
        )
        {
            $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn['BGSQLLQuery'].EndTime = $($EndTime).DateTime
            $HashReturn['BGSQLLQuery'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
                | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds
        }

        If
        (
            $ClearGarbageCollecting
        )
        {
            $null = Clear-BlugenieMemory
        }

        #region Output Type
            $ResultSet = $HashReturn['BGSQLLQuery']['Items']

            switch
            (
                $Null
            )
            {
                #region Beautify the JSON return and not Escape any Characters
                    { $OutUnEscapedJSON }
                    {
                        Return $($HashReturn | ConvertTo-Json -Depth 10 | ForEach-Object -Process { [regex]::Unescape($_) })
                    }
                #endregion Beautify the JSON return and not Escape any Characters

                #region Return a PowerShell Object
                    { $ReturnObject }
                    {
                            #region Switch FormatView
                            switch
                            (
                                $FormatView
                            )
                            {
                                #region Table
                                    'Table'
                                    {
                                        Return $($ResultSet | Format-Table -AutoSize -Wrap)
                                    }
                                #endregion Table

                                #region CSV
                                    'CSV'
                                    {
                                        Return $($ResultSet | ConvertTo-Csv -NoTypeInformation)
                                    }
                                #endregion CSV

                                #region CustomModified
                                    'CustomModified'
                                    {
                                        Return $($ResultSet | Format-Custom | Out-String) -replace '}\s\s','},' `
                                        -replace '\sclass\s.*\s'
                                    }
                                #endregion CustomModified

                                #region Custom
                                    'Custom'
                                    {
                                        Return $($ResultSet | Format-Custom)
                                    }
                                #endregion Custom

                                #region JSON
                                    'JSON'
                                    {
                                        Return $($ResultSet | ConvertTo-Json -Depth 10)
                                    }
                                #endregion JSON

                                #region OutUnEscapedJSON
                                    'OutUnEscapedJSON'
                                    {
                                        Return $($ResultSet | ConvertTo-Json -Depth 10 | ForEach-Object `
                                            -Process `
                                            {
                                                [regex]::Unescape($_)
                                            }
                                        )
                                    }
                                #endregion OutUnEscapedJSON

                                #region Default
                                    Default
                                    {
                                        Return $ResultSet
                                    }
                                #endregion Default
                            }
                        #endregion Switch Statement RegEx
                    }
                #endregion Return a PowerShell Object

                #region Default
                    Default
                    {
                        Return $HashReturn
                    }
                #endregion Default
            }
        #endregion Output Type
    #endregion Output
}
#endregion Invoke-BluGenieSQLLQuery (Function)