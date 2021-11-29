#region Test-BluGenieIsFileLocked (Function)
Function Test-BluGenieIsFileLocked
{
<#
    .SYNOPSIS
        Test to see if a file locked by another process

    .DESCRIPTION
        Test to see if a file locked by another process.

        Note:  This will only return a [Bool]. If you are looking for mor details on what is locking the file run Get-BlueGenieLockingProcess or
                    Get-LockingProcess

    .PARAMETER Path
        Description: Path of the file being checked
        Notes:
        Alias: 'FullName','PSPath'
        ValidateSet:

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
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

    .EXAMPLE
        Command: Test-BluGenieIsFileLocked
        Description:
        Notes:

    .EXAMPLE
        Command: Test-BluGenieIsFileLocked
        Description:
        Notes:

    .EXAMPLE
        Command: Test-BluGenieIsFileLocked -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Test-BluGenieIsFileLocked -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Test-BluGenieIsFileLocked -OutUnEscapedJSON
        Description: <command_here> and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Test-BluGenieIsFileLocked -ReturnObject
        Description: <command_here> and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • Original Author           :
            o    Michael Arroyo
        • Original Build Version    :
            o    20.11.2801 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • Latest Author             :
            o   Michael Arroyo
        • Latest Build Version      :
            o   21.06.2301
        • Comments                  :
            o
        • PowerShell Compatibility  :
            o    2,3,4,5.x
        • Forked Project            :
            o
        • Links                     :
            o    https://mcpmag.com/articles/2018/07/10/check-for-locked-file-using-powershell.aspx
        • Dependencies              :
            o    Invoke-WalkThrough - will convert the static PowerShell help into an interactive menu system
            o    Get-ErrorAction - Get-ErrorAction will round up any errors into a simple object
            o    Invoke-BlueGenieWalkThrough - will convert the static PowerShell help into an interactive menu system
            o    Get-BluGenieErrorAction - Get-ErrorAction will round up any errors into a simple object
        • Build Version Details     :
            o 20.11.2801:   • [Michael Arroyo] Posted
            o 21.06.2301:   • [Michael Arroyo] Updated the function based on the PSScriptAnalyzerSettings configuration.
#>
    [cmdletbinding()]
    [Alias('Test-IsFileLocked','IsFileLocked')]
    #region Parameters
        Param
        (
            [parameter(Position=0,
                        Mandatory=$True,
                        ValueFromPipeline=$True,
                        ValueFromPipelineByPropertyName=$True)]
            [Alias('FullName','PSPath')]
            [string[]]$Path,

            [Alias('Help')]
            [Switch]$Walkthrough,

            [Switch]$ReturnObject = $true,

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
        $HashReturn['TestIsFileLocked'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['TestIsFileLocked'].StartTime = $($StartTime).DateTime
        $HashReturn['TestIsFileLocked'].ParameterSetResults = @()
        $HashReturn['TestIsFileLocked']['IsLocked'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['TestIsFileLocked'].ParameterSetResults += $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        $Path | ForEach-Object `
        -Process `
        {

            $Item = $_
            $LiterItemPath = $(Get-BluGenieLiteralPath -Path $Item -ErrorAction SilentlyContinue)
            If ([System.IO.File]::Exists($LiterItemPath))
            {
                Try
                {
                    $FileStream = [System.IO.File]::Open($LiterItemPath,'Open','Write')
                    $FileStream.Close()
                    $FileStream.Dispose()
                    $IsLocked = $False
                }
                Catch [System.UnauthorizedAccessException]
                {
                    $IsLocked = 'AccessDenied'
                }
                Catch
                {
                    $IsLocked = $True
                }
                $NewCustomObject = New-Object -TypeName psobject -Property @{
                    File = $LiterItemPath
                    IsLocked = $IsLocked
                    Exists = $True
                }
            }
            Else
            {
                $NewCustomObject = New-Object -TypeName psobject -Property @{
                    File = $LiterItemPath
                    IsLocked = $false
                    Exists = $False
                }
            }

            $HashReturn['TestIsFileLocked']['IsLocked'] += $NewCustomObject
            $NewCustomObject = $Null
        }
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['TestIsFileLocked'].EndTime = $($EndTime).DateTime
        $HashReturn['TestIsFileLocked'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
                                                            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        #region Output Type
            $ResultSet = $HashReturn['TestIsFileLocked']['IsLocked']

            switch
            (
                $Null
            )
            {
                #region Beatify the JSON return and not Escape any Characters
                    { $OutUnEscapedJSON }
                    {
                        Return $($HashReturn | ConvertTo-Json -Depth 10 | ForEach-Object -Process { [regex]::Unescape($_) })
                    }
                #endregion Beatify the JSON return and not Escape any Characters

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
                                        Try
                                        {
                                            $null = Get-Command -Name ConvertTo-Json -ErrorAction Stop
                                            Return $($ResultSet | ConvertTo-Json -Depth 10)
                                        }
                                        Catch
                                        {
                                        }
                                    }
                                #endregion JSON

                                #region OutUnEscapedJSON
                                    'OutUnEscapedJSON'
                                    {
                                        Try
                                        {
                                            $null = Get-Command -Name ConvertTo-Json -ErrorAction Stop
                                            Return $($ResultSet | ConvertTo-Json -Depth 10 | ForEach-Object `
                                                -Process `
                                                {
                                                    [regex]::Unescape($_)
                                                }
                                            )
                                        }
                                        Catch
                                        {
                                        }
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
#endregion Test-BluGenieIsFileLocked (Function)