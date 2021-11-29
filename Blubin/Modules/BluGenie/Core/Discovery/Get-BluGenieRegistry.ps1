#region Get-BluGenieRegistry (Function)
Function Get-BluGenieRegistry
{
<#
    .SYNOPSIS
        Searches the registry for a specified text pattern.

    .DESCRIPTION
        Searches the registry for a specified text pattern. Supports searching for any combination of key names, value names, and/or value data. 
		The text pattern is a case-insensitive regular expression.

    .PARAMETER StartKey
        Description: Starts searching at the specified key. 
        Notes: The key name uses the following format:

                HKEY_LOCAL_MACHINE\
                HKEY_CURRENT_USER\
                HKEY_USERS\
                HKEY_CLASSES_ROOT\
        Alias: Path
        ValidateSet:  

    .PARAMETER Pattern
        Description: Searches for the specified regular expression pattern. The pattern is not case-sensitive.
        Notes:  
        Alias:
        ValidateSet:
		
	.PARAMETER ExcludePattern
        Description: Used in conjuction with -Pattern.  Reparse found items from pattern with an Exclude pattern
        Notes:  This cannot be used on it's own and cannot be used with -NotMatch.
        Alias:
        ValidateSet:
		
	.PARAMETER MatchKey
        Description: Matches registry key names.
        Notes: Default option is MatchData
        Alias:
        ValidateSet: 
		
	.PARAMETER MatchValueName
        Description: Matches registry value names.
        Notes: Default option is MatchData
        Alias: MatchValue
        ValidateSet: 
		
	.PARAMETER MatchData
        Description: Matches registry value data.
        Notes: This option is default
        Alias:
        ValidateSet: 
		
	.PARAMETER RootKeyOnly
        Description: If Selected the Query will only parse the root of the Search Key given.  No sub keys will be queried.
        Notes: 
        Alias:
        ValidateSet: 
		
	.PARAMETER Remove
        Description: Removes any matching patterns found in the registry.
        Notes: 
        Alias:
        ValidateSet: 
		
	.PARAMETER NotMatch
        Description: Not Matching or Exclude pattern queries
        Notes: 
        Alias:
        ValidateSet: 
		
	.PARAMETER ExactMatch
        Description: The Match type is equal or exact to the Pattern string
        Notes: 
        Alias:
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
		
    .PARAMETER FormatView
		Description: Select which format to return the object data in.
		Notes: Default value is set to (None).  This value is only valid when using the -ReturnObject parameter
		Alias:
		ValidateSet: 'Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV'

	.EXAMPLE
	    Command: Get-BluGenieRegistry -StartKey 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -MatchKey -RootKeyOnly
        Description: Query Keys Only, Process the Root with No Sub Keys, Using the StartKey Param, Using the Short Hand Hive name
        Notes: 
		
	.EXAMPLE
	    Command: Get-BluGenieRegistry -StartKey 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -MatchKey -RootKeyOnly -Pattern 'run'
        Description: Specify a specific pattern to search for, Query Keys Only, Process the Root with No Sub Keys
        Notes: 
		
	.EXAMPLE
	    Command: Get-BluGenieRegistry -StartKey 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -MatchKey -RootKeyOnly -Pattern 'run' -ExcludePattern 'once'
        Description: Specify a specific pattern to search for while using an Exclude pattern, Query Keys Only, Process the Root with No Sub Keys
        Notes: 
		
	.EXAMPLE
	    Command: Get-BluGenieRegistry -StartKey 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -MatchKey -RootKeyOnly -Pattern 'run' -ExcludePattern 'once'  -ReturnObject
        Description: Return Data as an Object
        Notes: 

	.EXAMPLE
	    Command: Get-BluGenieRegistry -StartKey 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion' -MatchKey -RootKeyOnly -Pattern 'run' -ExcludePattern 'once'  -ReturnObject -FormatView csv
        Description: Return Data as an Object, Reformat the Object as CSV,JSON,CustomObject,UnEscapedJSON.
        Notes: 

	.EXAMPLE
	    Command: Get-BluGenieRegistry -Path 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion' -MatchKey -RootKeyOnly
        Description: Query Keys Only, Process the Root with No Sub Keys, Using the Path Param, Using the Long Name Hive Name
        Notes: 

	.EXAMPLE
	    Command: Get-BluGenieRegistry -Path 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths'
        Description: Query Value Names (Default), Process Sub Keys, Using the Long Name Hive Name
        Notes: 

	.EXAMPLE
	    Command: Get-BluGenieRegistry -Path 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths' -MatchKey -Pattern 'Write' -Remove
        Description: Query Key Names, Process Sub Keys, Using the Long Name Hive Name, Remove Keys Found
        Notes: 

	.EXAMPLE
	    Command: Get-BluGenieRegistry -Path 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths' -MatchData -Pattern 'Word' -Remove
        Description: Query Data Values, Process Sub Keys, Using the Long Name Hive Name, Remove ValueNames Found
        Notes: 

	.EXAMPLE
	    Command: Get-BluGenieRegistry -Path 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -MatchValueName -Pattern '(?=.*Auto)(?=.*Logon)' -ExcludePattern 'Sid|Count'
        Description: RegEx Search Pattern and Exclude Pattern
        Notes: 

	.EXAMPLE
	    Command: Get-BluGenieRegistry -Path 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' -OutUnEscapedJSON -MatchValueName -Pattern '(?=.*Auto)(?=.*Logon)' -ExcludePattern 'Sid|Count'
        Description: RegEx Search Pattern and Exclude Pattern, Output UnEscaped JSON
        Notes: 

    .EXAMPLE
	    Command: Get-BluGenieRegistry -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
               Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieRegistry -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
               Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieRegistry -OutUnEscapedJSON
        Description: Get-BluGenieRegistry and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Get-BluGenieRegistry -ReturnObject
        Description: Get-BluGenieRegistry and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
		
	.EXAMPLE
	    Command: Get-BluGenieRegistry -ReturnObject -FormatView JSON
        Description: Get-BluGenieRegistry and Return Object formatted in a JSON view
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
		
	.EXAMPLE
	    Command: Get-BluGenieRegistry -ReturnObject -FormatView Custom
        Description: Get-BluGenieRegistry and Return Object formatted in a PSCustom view
        Notes:  Format-Custom is designed to display views that are not just tables or just lists. You can use the views defined in the 
                *format.PS1XML files in the PowerShell directory, or you can create your own views in new PS1XML files and use the 
                Update-FormatData cmdlet to add them to PowerShell.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • Original Author           : Michael Arroyo
        • Original Build Version    : 1811.1401
        • Latest Author             : Michael Arroyo
        • Latest Build Version      : 2004.2001
        • Comments                  :
        • PowerShell Compatibility  : 2,3,4,5.x
        • Forked Project            : 
        • Link                      : 
            o 
        • Dependencies              :
            o Invoke-WalkThrough - is an interactive help menu system
            o Get-ErrorAction - will round up any errors into a simple object
        • Build Version Details     :
			o 1811.1401:  [Michael Arroyo] Posted
            o 1812.0201:  [Michael Arroyo] Updated the Help information
            o 1812.0601:  [Micahel Arroyo] Rewrote the entire process to support a faster query process and use RegEx to search for Keys, Data, 
												and Values
            o 1902.0601:  [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information
                          [Michael Arroyo] Removed the overall function structure Begin{}Process{}End{}.  This was causing issues when trying to
						 						exit on error
            o 1902.0801:  [Michael Arroyo] Added the .PARAMETER Remove value in the help
            o 1904.1501:  [Michael Arroyo] Added a default value to StartKey 'HKEY_LOCAL_MACHINE\SOFTWARE'
                          [Michael Arroyo] Added a default value to Pattern '^(?s:.)*'
                          [Michael Arroyo] Added the ReturnObject Switch to return an Object instead of a HashTable
                          [Michael Arroyo] Added the NotMatch Switch to allow for an exclusion query
                          [Michael Arroyo] Updated the WalkThrough Function to Support External Help .XML Files (Version 1904.0801)
                          [Michael Arroyo] Removed the StartKey and Pattern parameter check
            o 1904.2401:  [Michael Arroyo] Added the -NotMatch help header.  It was missing, but the function was working fine.
                          [Michael Arroyo] Added the -ExactMatch help header.  It was missing, but the functino was working fine.
            o 1906.0301:  [Michael Arroyo] Updated the Walktrough Function to version 1905.2401
                          [Michael Arroyo] Updated the failed flag.  The process will no longer exit early.
            o 1906.0303:  [Michael Arroyo] Updated the Search function to the new script standards.  This fixed some searches coming back (Null)
                          [Michael Arroyo] Added parameter OutUnEscapedJSON to beautify the JSON Return data into a cleaner format
                          [Michael Arroyo] Removed parameter MaximumMatches, No longer needed
                          [Michael Arroyo] Added parameter RootKeyOnly.  This option will search only the search path.  It will not query sub 
						 						keys.
                          [Michael Arroyo] Removed parameter ComputerName.  No longer needed
                          [Michael Arroyo] Added a total number of keys found to the return results
                          [Michael Arroyo] Updated the Array to be static.  This will speed up longer queries so the array doesn't get rebuilt 
						 						each time, which is a default behavior for Powershell.
            o 2004.2001:  [Michael Arroyo] Updated the parameter value ( MatchValue ) to ( MatchValueName ).  Conform to the real registry
                                                value name
                          [Michael Arroyo] Updated the data return value name ( Value ) to ( ValueName ).  Conform to the real registry
                                                value name
                          [Michael Arroyo] Added the Alias ( MatchValue ) to ( MatchValueName ) so older function calls still work
                          [Michael Arroyo] Added the Alias ( Path ) to ( StartKey ) to make the command cleaner and still support the older calls
                          [Michael Arroyo] Added type information for each data value returned
                          [Michael Arroyo] Updated the StartKey search to run a cleaner -Match RegEx pattern
                          [Michael Arroyo] Added Get-ErrorAction to all subfunction for error management
                          [Michael Arroyo] Upated the Output to always return some data, previsouly it was set to return nothing if the key 
                                                didn't exist
                          [Michael Arroyo] Removed all Throw errors and errors are now being managed by Get-ErrorAction
                          [Michael Arroyo] Added a Hive key check.  If the key doesn't exist the registry is not queried
                          [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                          [Michael Arroyo] Updated the Hash Information to follow the new function standards
                          [Michael Arroyo] Added more detailed information to the Return data
                          [Michael Arroyo] Updated the Code to the '145' column width standard
                          [Michael Arroyo] Added the -ExcludePattern parameter which is used in conjuction with -Pattern.  It will allow you 
                                                to reparse found items based on the given pattern and then exclude any instances you no longer 
                                                want.
                          [Michael Arroyo] Updated the Binary data to be consolidated.  This compresses the binary data value.
                          [Michael Arroyo] Added a Test path process to the StartKey/Path value.
                          [Michael Arroyo] Updated the ( Remove ) process to search for the new type indentifier to help idenify how to remove
                                                the Key or ValueName registry data
                                                    
#>
    [cmdletbinding()]
    [Alias('Get-Registry')]
	#region Parameters
    Param
    (
        [Alias('Path')]
		[Parameter(Position=0)]
        [String]$StartKey = 'HKEY_LOCAL_MACHINE\SOFTWARE',

        [Parameter(Position=1)]
        [string]$Pattern = '^(?s:.)*',
		
		[Parameter(Position=2)]
        [string]$ExcludePattern = '',

        [Switch]$MatchKey,
        
        [Alias('MatchValue')]
        [Switch]$MatchValueName,

        [Switch]$MatchData,

        [Switch]$RootKeyOnly,

        [Switch]$NotMatch,
		
		[Switch]$ExactMatch,

        [Switch]$Remove,

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
                Test-Path -Path Function:\Invoke-WalkThrough -ErrorAction SilentlyContinue
            )
            {
                If
                (
                    $Function -eq 'Invoke-WalkThrough'
                )
                {
                    #Disable Invoke-WalkThrough looping
                    Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function -RemoveRun }
                    Return
                }
                Else
                {
                    Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function }
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
        $HashReturn['Registry'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['Registry'].StartTime = $($StartTime).DateTime
        $HashReturn['Registry'].Comments = @()
		$HashReturn['Registry'].Query = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['Registry'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
		#region Setup Registry Hives for PSProvider
		    switch
            (
                $null
            )
            {
                #region Check for 'HKCR' PSDrive Provider
                    {-Not $(Test-Path -Path 'HKCR:\')}
                    {
                        New-PSDrive -PSProvider Registry -Root HKEY_CLASSES_ROOT -Name HKCR -ErrorAction SilentlyContinue | Out-Null
                    }
                #endregion Check for 'HKCR' PSDrive Provider
                
                #region Check for 'HKU' PSDrive Provider
                    {-Not $(Test-Path -Path 'HKU:\')}
                    {
                        New-PSDrive -PSProvider Registry -Root HKEY_USERS -Name HKU -ErrorAction SilentlyContinue | Out-Null
                    }
                #endregion Check for 'HKU' PSDrive Provider
                
                #region Check for 'HKLM' PSDrive Provider
                    {-Not $(Test-Path -Path 'HKLM:\')}
                    {
                        New-PSDrive -PSProvider Registry -Root HKEY_LOCAL_MACHINE -Name HKLM -ErrorAction SilentlyContinue | Out-Null
                    }
                #endregion Check for 'HKLM' PSDrive Provider
            }            
        #endregion Setup Registry Hives for PSProvider
		
		#region Throw an error if -StartKey is not valid
	        If
	        (
	            -Not $StartKey
	        )
	        {
				Write-Error -Message "-StartKey parameter is not valid" -ErrorAction SilentlyContinue
				$HashReturn['Registry'].Comments += $(Get-ErrorAction -Clear)
	        }
	    #endregion Throw an error if -StartKey is not valid
		
		#region Throw an error if -Pattern is not valid
            If
            (
                $Pattern -eq $null
            )
            {
				Write-Error -Message "-Pattern parameter is not valid" -ErrorAction SilentlyContinue
				$HashReturn['Registry'].Comments += $(Get-ErrorAction -Clear)
            }
        #endregion Throw an error if -Pattern is not valid
		
		#region You must specify at least one matching criteria
            if
            (
                -not ($MatchKey -or $MatchValueName -or $MatchData)
            )
            {
                $MatchData = $true
            }
        #endregion You must specify at least one matching criteria
		
		#region These two hash tables speed up lookup of key names and hive types
            $HiveNameToHive = @{
                "HKCR"               = [Microsoft.Win32.RegistryHive] "ClassesRoot";
                "HKEY_CLASSES_ROOT"  = [Microsoft.Win32.RegistryHive] "ClassesRoot";
                "HKCU"               = [Microsoft.Win32.RegistryHive] "CurrentUser";
                "HKEY_CURRENT_USER"  = [Microsoft.Win32.RegistryHive] "CurrentUser";
                "HKLM"               = [Microsoft.Win32.RegistryHive] "LocalMachine";
                "HKEY_LOCAL_MACHINE" = [Microsoft.Win32.RegistryHive] "LocalMachine";
                "HKU"                = [Microsoft.Win32.RegistryHive] "Users";
                "HKEY_USERS"         = [Microsoft.Win32.RegistryHive] "Users";
            }

            $HiveToHiveName = @{
                [Microsoft.Win32.RegistryHive] "ClassesRoot"  = "HKCR";
                [Microsoft.Win32.RegistryHive] "CurrentUser"  = "HKCU";
                [Microsoft.Win32.RegistryHive] "LocalMachine" = "HKLM";
                [Microsoft.Win32.RegistryHive] "Users"        = "HKU";
            }
        #endregion These two hash tables speed up lookup of key names and hive types
		
		#region Search for 'hive:\startkey'; ':' and starting key optional
            $null = $StartKey -match "(?<HiveName>[^:\\]+):?\\?(?<StartPath>.+)?"
			If
			(
				$matches.HiveName
			)
			{
				$HiveName = $matches.HiveName
                $StartPath = $matches.StartPath
			}

            if
            (
                -not $HiveNameToHive.ContainsKey($HiveName)
            )
            {
				Write-Error -Message $('Invalid registry path: {0}' -f $StartKey) -ErrorAction SilentlyContinue
				$HashReturn['Registry'].Comments += $(Get-ErrorAction -Clear)
            }
            else
            {
                $Hive = $HiveNameToHive[$HiveName]
                $HiveName = $HiveToHiveName[$Hive]
            }
        #endregion
		
		#region Recursive function that searches the registry
            function search-registrykey
            {
                Param
                (
                    $rootKey,
                    
                    $keyPath
                )

                #region Build Return Array
                    $ArrRegInf = New-Object -TypeName System.Collections.ArrayList
                #endregion Build Return Array

                #region Write error and return if unable to open the key path as read-only
                    try
                    {
                        $Error.Clear()
                        $subKey = $rootKey.OpenSubKey($keyPath)
                        Write-Verbose $('Key Found = {0}' -f $Keypath)
                    }
                    catch
                    {
                        $message = $Error.Exception.Message
                        Write-Error "$message - $HiveName\$keyPath" -Category ObjectNotFound
                        $HashReturn['Registry'].Comments += $(Get-ErrorAction -Clear)
                        return
                    }
                #endregion Write error and return if unable to open the key path as read-only

                #region Search for value and/or data
                    if
                    (
                        $MatchValueName -or $MatchData
                    )
                    {
                        If
                        (
                            $($subKey | Select-Object -ExpandProperty ValueCount) -gt 0
                        )
                        {
                            $subKey.GetValueNames() | ForEach-Object `
                            -Process `
                            {
                                $valueName = $_
                                $valueData = $subKey.GetValue($valueName)
                                $valueType = $($subKey.GetValueKind($valueName) | Out-String).trim()
                                
                                If
                                (
                                    $valueType -eq 'Binary'
                                )
                                {
                                    $valueData = $($valueData -join ',')
                                }
                                #region Name and Data Query
                                    Switch
                                    (
                                        $null
                                    )
                                    {
                                        #region NotMatch Name and Data Query
                                            {$NotMatch -eq $true}
                                            {
												If
												(
													$MatchValueName
												)
												{
	                                                if
	                                                (
	                                                    $valueName -notmatch $Pattern
	                                                )
	                                                {
	                                                	$Null = $ArrRegInf.Add(
	                                                        $(
	                                                            New-Object -TypeName PSObject -Property @{
	                                                                "ComputerName" = $('{0}' -f $computerName)
	                                                                "Key" = $('{0}:\{1}' -f $HiveName, $keyPath)
	                                                                "ValueName" = $('{0}' -f $valueName)
	                                                                "Data" = $valueData
                                                                    "Type" = $('{0}' -f $valueType)
                                                                    "Removed" = $false
	                                                            }
	                                                        )
	                                                    )
	                                                }
												}
												Else
												{
													if
	                                                (
	                                                    $valueData -notmatch $Pattern
	                                                )
	                                                {
	                                                    $Null = $ArrRegInf.Add(
	                                                        $(
	                                                            New-Object -TypeName PSObject -Property @{
	                                                                "ComputerName" = $('{0}' -f $computerName)
	                                                                "Key" = $('{0}:\{1}' -f $HiveName, $keyPath)
	                                                                "ValueName" = $('{0}' -f $valueName)
	                                                                "Data" = $valueData
                                                                    "Type" = $('{0}' -f $valueType)
                                                                    "Removed" = $false
	                                                            }
	                                                        )
	                                                    )
	                                                }
												}
                                                Break
                                            }
                                        #endregion NotMatch Name and Data Query

                                        #region Equals Name and Data Query
                                            {$ExactMatch -eq $true}
                                            {
												If
												(
													$MatchValueName
												)
												{
	                                                if
	                                                (
	                                                    $valueName -eq $Pattern
	                                                )
	                                                {
	                                                    $Null = $ArrRegInf.Add(
	                                                        $(
	                                                            New-Object -TypeName PSObject -Property @{
	                                                                "ComputerName" = $('{0}' -f $computerName)
	                                                                "Key" = $('{0}:\{1}' -f $HiveName, $keyPath)
	                                                                "ValueName" = $('{0}' -f $valueName)
	                                                                "Data" = $valueData
                                                                    "Type" = $('{0}' -f $valueType)
                                                                    "Removed" = $false
	                                                            }
	                                                        )
	                                                    )
	                                                
	                                                }
												}
												Else
												{
													if
	                                                (
	                                                    $valueData -eq $Pattern
	                                                )
	                                                {
	                                                    $Null = $ArrRegInf.Add(
	                                                        $(
	                                                            New-Object -TypeName PSObject -Property @{
	                                                                "ComputerName" = $('{0}' -f $computerName)
	                                                                "Key" = $('{0}:\{1}' -f $HiveName, $keyPath)
	                                                                "ValueName" = $('{0}' -f $valueName)
	                                                                "Data" = $valueData
                                                                    "Type" = $('{0}' -f $valueType)
                                                                    "Removed" = $false
	                                                            }
	                                                        )
	                                                    )
	                                                
	                                                }
												}
                                                Break
                                            }
                                        #endregion Equals Name and Data Query
										
										#region Match and Then Not Match Name and Data Query
                                            {$ExcludePattern}
                                            {
												If
												(
													$MatchValueName
												)
												{
	                                                if
	                                                (
	                                                    $valueName -match $Pattern
	                                                )
	                                                {
	                                                    if
		                                                (
		                                                    $valueName -notmatch $ExcludePattern
		                                                )
		                                                {
		                                                    $Null = $ArrRegInf.Add(
		                                                        $(
		                                                            New-Object -TypeName PSObject -Property @{
		                                                                "ComputerName" = $('{0}' -f $computerName)
    	                                                                "Key" = $('{0}:\{1}' -f $HiveName, $keyPath)
    	                                                                "ValueName" = $('{0}' -f $valueName)
    	                                                                "Data" = $valueData
                                                                        "Type" = $('{0}' -f $valueType)
                                                                        "Removed" = $false
		                                                            }
		                                                        )
		                                                    )
		                                                }
	                                                }
												}
												Else
												{
													if
	                                                (
	                                                    $valueData -match $Pattern
	                                                )
	                                                {
	                                                    if
		                                                (
		                                                    $valueData -notmatch $ExcludePattern
		                                                )
		                                                {
		                                                    $Null = $ArrRegInf.Add(
		                                                        $(
		                                                            New-Object -TypeName PSObject -Property @{
		                                                                "ComputerName" = $('{0}' -f $computerName)
    	                                                                "Key" = $('{0}:\{1}' -f $HiveName, $keyPath)
    	                                                                "ValueName" = $('{0}' -f $valueName)
    	                                                                "Data" = $valueData
                                                                        "Type" = $('{0}' -f $valueType)
                                                                        "Removed" = $false
		                                                            }
		                                                        )
		                                                    )
		                                                }
	                                                }
												}
                                                Break
                                            }
                                        #endregion Match and Then Not Match Name and Data Query

                                        #region Default/Match Name and Data Query
                                            Default
                                            {
												If
												(
													$MatchValueName
												)
												{
	                                                if
	                                                (
	                                                    $valueName -match $Pattern
	                                                )
	                                                {
	                                                    $Null = $ArrRegInf.Add(
	                                                        $(        
	                                                            New-Object -TypeName PSObject -Property @{
	                                                                "ComputerName" = $('{0}' -f $computerName)
	                                                                "Key" = $('{0}:\{1}' -f $HiveName, $keyPath)
	                                                                "ValueName" = $('{0}' -f $valueName)
	                                                                "Data" = $valueData
                                                                    "Type" = $('{0}' -f $valueType)
                                                                    "Removed" = $false
	                                                            }
	                                                        )
	                                                    )
	                                                }
												}
												Else
												{
													if
	                                                (
	                                                    $valueData -match $Pattern
	                                                )
	                                                {
	                                                    $Null = $ArrRegInf.Add(
	                                                        $(        
	                                                            New-Object -TypeName PSObject -Property @{
	                                                                "ComputerName" = $('{0}' -f $computerName)
	                                                                "Key" = $('{0}:\{1}' -f $HiveName, $keyPath)
	                                                                "ValueName" = $('{0}' -f $valueName)
	                                                                "Data" = $valueData
                                                                    "Type" = $('{0}' -f $valueType)
                                                                    "Removed" = $false
	                                                            }
	                                                        )
	                                                    )
	                                                }
												}
                                            }
                                        #endregion Default Name and Data Query
                                    }
                                #endregion Name and Data Query
                            }
                        }
                    }
                #endregion Search for value and/or data

                #region Iterate and recurse through subkeys
                    If
                    (
                        $($subKey | Select-Object -ExpandProperty SubKeyCount) -gt 0
                    )
                    {
                        $subKey.GetSubKeyNames() | ForEach-Object `
                        -Process `
                        {
                            $keyName = $_
                        
                            #region Build Sub Key path
                                if
                                (
                                    $keyPath -eq ""
                                )
                                {
                                    $subkeyPath = $keyName
                                }
                                else
                                {
                                    $subkeyPath = $keyPath + "\" + $keyName
                                }
                            #endregion Build Sub Key path

                            If
                            (
                                $MatchKey
                            )
                            {
                                #region Key Path Query
                                    Switch
                                    (
                                        $null
                                    )
                                    {
                                        #region NotMatch Key Path Query
                                            {$NotMatch -eq $true}
                                            {
                                                if
                                                (
                                                    $keyName -notmatch $Pattern
                                                )
                                                {
                                                    $Null = $ArrRegInf.Add(
                                                        $(
                                                            New-Object -TypeName PSObject -Property @{
                                                                "ComputerName" = $('{0}' -f $computerName)
                                                                "Key" = $('{0}:\{1}' -f $HiveName, $subkeyPath)
                                                                "ValueName" = ''
                                                                "Data" = ''
                                                                "Type" = 'Key'
                                                                "Removed" = $false
                                                            }
                                                        )
                                                    )
                                                }
                                                Break
                                            }
                                        #endregion NotMatch Key Path Query

                                        #region Equals Key Path Query
                                            {$ExactMatch -eq $true}
                                            {
                                                if
                                                (
                                                    $keyName -eq $Pattern
                                                )
                                                {
                                                    $Null = $ArrRegInf.Add(
                                                        $(
                                                            New-Object -TypeName PSObject -Property @{
                                                                "ComputerName" = $('{0}' -f $computerName)
                                                                "Key" = $('{0}:\{1}' -f $HiveName, $subkeyPath)
                                                                "ValueName" = ''
                                                                "Data" = ''
                                                                "Type" = 'Key'
                                                                "Removed" = $false
                                                            }
                                                        )
                                                    )
                                                }
                                                Break
                                            }
                                        #endregion Equals Key Path Query
										
										#region Match and Then Not Match Key Path Query
                                            {$ExcludePattern}
                                            {
                                                if
                                                (
                                                    $keyName -match $Pattern
                                                )
                                                {
                                                    if
	                                                (
	                                                    $keyName -notmatch $ExcludePattern
	                                                )
	                                                {
	                                                    $Null = $ArrRegInf.Add(
	                                                        $(
	                                                            New-Object -TypeName PSObject -Property @{
	                                                                "ComputerName" = $('{0}' -f $computerName)
                                                                    "Key" = $('{0}:\{1}' -f $HiveName, $subkeyPath)
                                                                    "ValueName" = ''
                                                                    "Data" = ''
                                                                    "Type" = 'Key'
                                                                    "Removed" = $false
	                                                            }
	                                                        )
	                                                    )
	                                                }
                                                }
                                                Break
                                            }
                                        #endregion Match and Then Not Match Key Path Query

                                        #region Default/Match Key Path Query
                                            Default
                                            {
                                                if
                                                (
                                                    $keyName -match $Pattern
                                                )
                                                {
                                                    $Null = $ArrRegInf.Add(
                                                        $(
                                                            New-Object -TypeName PSObject -Property @{
                                                                "ComputerName" = $('{0}' -f $computerName)
                                                                "Key" = $('{0}:\{1}' -f $HiveName, $subkeyPath)
                                                                "ValueName" = ''
                                                                "Data" = ''
                                                                "Type" = 'Key'
                                                                "Removed" = $false
                                                            }
                                                        )
                                                    )
                                                }
                                            }
                                        #endregion Default/Match Key Path Query
                                    }
                                #endregion Key Path Query
                            }
                                
                            #region Process New Sub Key
                                If
                                (
                                    -Not $RootKeyOnly
                                )
                                {
                                    search-registrykey $rootKey $subkeyPath
                                }
                            #endregion Process New Sub Key
                        
                        }
                    }
                #endregion Iterate and recurse through subkeys

                #region Close opened subkey
                    If
                    (
                        $subKey
                    )
                    {
                        Try
                        {
                            $subKey.Close()
                        }
                        Catch
                        {
                            $null
                        }
                    }
                #endregion Close opened subkey

                #region Output
                    Return $ArrRegInf
                #endregion Output
            }
        #endregion Recursive function that searches the registry
		
		#region Core function opens the registry on a computer and initiates searching
			If
			(
				$Hive
			)
			{
				#region Connect to registry 
	                Try
	                {   
	                    $Error.Clear()
	                    If
	                    (
	                        $Hive -eq 'CurrentUser'
	                    )
	                    {
	                        $Hive = $HiveNameToHive['HKU']
	                        $HiveName = $HiveToHiveName[$Hive]
	                    }

	                    [String]$ComputerName = $ENV:COMPUTERNAME
	                    $rootKey = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($Hive, $ComputerName)
	                }
	                catch
	                {
	                    $HashReturn['Registry'].Comments += $(Get-ErrorAction -Clear)
	                }
	            #endregion Connect to registry

	            #region Start Query 
	                If
	                (
	                    $rootKey
	                )
	                {
	                    #region Update Hive information and Start Query
	                        If
	                        (
	                            $($Hive -eq 'Users')
	                        )
	                        {
	                            $CurRegUserList = Get-LoadedRegHives -ReturnObject -ErrorAction SilentlyContinue | Select-Object `
                                    -ExpandProperty UserName
	                            $CurRegUserList | ForEach-Object `
	                            -Process `
	                            {
	                                $NewStartPath = $('{0}\{1}' -f $_,$StartPath)
                                    $PreCheckPath = $('{0}:\{1}' -f $($HiveNameToHive.Keys | Where-Object -FilterScript { $HiveNameToHive["$_"] -eq $Hive} | Where-Object -FilterScript { $_ -notmatch '_' }), $NewStartPath)
                                    
                                    Try
                                    {
                                        $Null = Get-Item -Path $PreCheckPath -ErrorAction Stop
                                        $HashReturn.Registry.Query += search-registrykey -rootKey $rootKey -keyPath $NewStartPath
                                    }
                                    Catch
                                    {
                                        $HashReturn['Registry'].Comments += $(Get-ErrorAction -Clear)
                                    }
	                            }
	                        }
	                        Else
	                        {
                                $PreCheckPath = $('{0}:\{1}' -f $($HiveNameToHive.Keys | Where-Object -FilterScript { $HiveNameToHive["$_"] -eq $Hive} | Where-Object -FilterScript { $_ -notmatch '_' }), $StartPath)
                                Try
                                {
                                    $Null = Get-Item -Path $PreCheckPath -ErrorAction Stop                           
                                    $HashReturn.Registry.Query += search-registrykey -rootKey $rootKey -keyPath $StartPath
	                            }
                                Catch
                                {
                                    $HashReturn['Registry'].Comments += $(Get-ErrorAction -Clear)
                                }
                            }
	                    #endregion Update Hive information and Start Query

	                    #region Close Connection
	                        $rootKey.Close()
	                    #endregion Close Connection
	                }
	            #endregion Start Query 
			}
			Else
			{
				$HashReturn['Registry'].Comments += $(Get-ErrorAction -Clear)
			}
            
        #endregion Core function opens the registry on a computer and initiates searching
		
		#region Flag if Query was successful
            If
            (
                $($HashReturn.Registry.Query | Measure-Object | Select-Object -ExpandProperty Count) -gt 0
            )
            {
                $HashReturn.Registry.DataPull = @{
                    status = $true
                }
            }
            Else
            {
                $HashReturn.Registry.DataPull = @{
                    status = $false
                }
				
				$HashReturn['Registry'].Comments += $(Get-ErrorAction -Clear)
            }
        #endregion Flag if Query was successful
		
		#region Set Total Items Found
            $HashReturn.Registry.Total = $($HashReturn.Registry.Query | Measure-Object | Select-Object -ExpandProperty Count)
        #endregion Set Total Items Found
		
		#region Delete Registry Keys, Value, and Data
            If
            (
                $Remove
            )
            {
                $HashReturn.Registry.Query | ForEach-Object `
                -Process `
                {
                    $CurRegObj = $_
                    $CurRegPath = $CurRegObj.Key -split ("\\",2)

                    If
                    (
                        $CurRegObj.Type -ne 'Key'
                    )
                    {
                        Try
                        {
                            Remove-ItemProperty -Path $($CurRegObj.Key) -Name $($CurRegObj.ValueName) -Force `
                                -ErrorAction Stop | Out-Null
                            $CurRegObj.Removed = $true
                        }
                        Catch
                        {
							$HashReturn['Registry'].Comments += $(Get-ErrorAction -Clear)
                        }
                    }
                    Else
                    {
                        Try
                        {
                            Remove-Item -Path $($CurRegObj.Key) -Force -Recurse -ErrorAction Stop | Out-Null
                            $CurRegObj.Removed = $true
                        }
                        Catch
                        {
							$HashReturn['Registry'].Comments += $(Get-ErrorAction -Clear)
                        }
                    }
                }
            }
        #endregion Delete Registry Keys, Value, and Data
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['Registry'].EndTime = $($EndTime).DateTime
        $HashReturn['Registry'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | 
                                                     Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

		#region Output Type
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
						#region Update the Object being returned
							$CurReturnObject = $HashReturn.Registry.Query
						#endregion Update the Object being returned
					
						#region Switch FormatView
	                        switch 
                            (
                                $FormatView
                            )
	                        {
		                        #region Table
			                        'Table'
			                        {
				                        Return $($CurReturnObject | Format-Table -AutoSize -Wrap)
			                        }
		                        #endregion Table

                                #region CSV
			                        'CSV'
			                        {
				                        Return $($CurReturnObject | ConvertTo-Csv -NoTypeInformation)
			                        }
		                        #endregion CSV

                                #region CustomModified
			                        'CustomModified'
			                        {
				                        Return $($CurReturnObject | Format-Custom | Out-String) -replace '}\s\s','},' `
                                        -replace '\sclass\s.*\s'
			                        }
		                        #endregion CustomModified

                                #region Custom
			                        'Custom'
			                        {
				                        Return $($CurReturnObject | Format-Custom)
			                        }
		                        #endregion Custom

                                #region JSON
			                        'JSON'
			                        {
                                        Try
                                        {
                                            $null = Get-Command -Name ConvertTo-Json -ErrorAction Stop
                                            Return $($CurReturnObject | ConvertTo-Json -Depth 10)
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
                                            Return $($CurReturnObject | ConvertTo-Json -Depth 10 | ForEach-Object `
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
			                            Return $CurReturnObject
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
#endregion Get-BluGenieRegistry (Function)