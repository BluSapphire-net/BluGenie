 #region Get-BluGenieADGroupMembers (Function)
Function Get-BluGenieADGroupMembers
{
<#
    .SYNOPSIS
        Query Active Directory via LDAP without the need for RSAT to be installed.

    .DESCRIPTION
        Query Active Directory via LDAP without the need for RSAT to be installed.

    .PARAMETER GroupName
        Description: The name of the Group you are going to do a member lookup on
        Notes: This is Mandatory.  If this option is left blank the return is Null
        Alias: GN
        ValidateSet:

    .PARAMETER Domain
        Description: The name of the Domain in which you are looking for the Group and Member information
        Notes: The default domain name is pulled from the Registry.  If this option is not set or the domain
name is not found in the registry the return is Null
        Alias: DO
        ValidateSet:

    .PARAMETER FullDetails
        Description: Return a PSObject with the following values (Name, SAMAccountname, DisplayName, Description and the Path)
        Notes: The default return is a list of Names (ONLY)
        Alias: FD
        ValidateSet:

    .PARAMETER UseCache
        Description: Cache found objects to disk
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp
        Alias: UC
        ValidateSet:

    .PARAMETER CachePath
        Description: Path to store the Cache information
        Notes: By default the Cache location is %temp% with a BGSys_<GUID>.txt file name.
                    Example: C:\Users\ADMINI~1\AppData\Local\Temp\BGSys_46964-41870-29555-35418-93311.txt
        Alias: CP
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

    .PARAMETER OutYaml
        Description: Return detailed information in Yaml Format
        Notes: Only supported in Posh 3.0 and above
        Alias:
        ValidateSet:

    .PARAMETER FormatView
        Description: Automatically format the Return Object
        Notes: Yaml is only supported in Posh 3.0 and above
        Alias:
        ValidateSet: 'Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml'

    .EXAMPLE
        Command: $ConsoleSystems = Get-BGADGroupMembers -GroupName S_Wrk_Posh3PlusLabSystems -ReturnObject
        Description: Use this command to Query an AD Group and assign them to the BluGenie Console Systems variable
        Notes:

    .EXAMPLE
        Command: Get-BGADGroupMembers -GroupName S_Wrk_Posh3PlusLabSystems -ReturnObject
        Description: Use the command to display a list of computers from an AD Group
        Notes:

    .EXAMPLE
        Command: ADGM -GroupName S_Wrk_Posh3PlusLabSystems -UseCache
        Description: Use this Short-Hand Alias to create a text file with a list of computers from an AD Group
        Notes:

    .EXAMPLE
        Command: Get-BGADGroupMembers -GroupName S_Wrk_Posh3PlusLabSystems -UseCache -FullDetails
        Description: Use this command to create a csv file with a list of computers and their AD properties (Name,SAMAccountname,DisplayName,Description,Path)
        Notes:

    .EXAMPLE
        Command: Get-BGADGroupMembers -GroupName S_Wrk_Posh3PlusLabSystems -OutYaml -Verbose
        Description: Use this command to view a full detailed yaml report on the members of the AD Group and function details
        Notes:

    .EXAMPLE
        Command: Get-BGADGroupMembers -GroupName S_Wrk_Posh3PlusLabSystems -UseCache -CachePath .\Collections\S_Wrk_Posh3PlusLabSystems.txt
        Description: Use this command to save the AD Group members to a specific text file.
        Notes: By default the Cache location is %temp% with a BGSys_<GUID>.txt file name.

    .EXAMPLE
        Command: Get-BluGenieADGroupMembers -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieADGroupMembers -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BGADGroupMembers -OutUnEscapedJSON
        Description: Return a detailed function report in an UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BGADGroupMembers -OutYaml
        Description: Return a detailed function report in YAML format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BGADGroupMembers -ReturnObject
        Description: Return Output as a Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
                This parameter is also used with the FormatView

    .EXAMPLE
        Command: Get-BluGenieADGroupMembers -ReturnObject -FormatView Yaml
        Description: Output PSObject information in Yaml format
        Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
                Default is set to (None) and normal PSObject.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • [Original Author]
            o  Michael Arroyo
        • [Original Build Version]
            o  21.05.0601 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o
        • [Latest Build Version]
            o
        • [Comments]
            o
        • [PowerShell Compatibility]
            o  2,3,4,5.x
        • [Forked Project]
            o
        • [Links]
            o
        • [Dependencies]
            o  Invoke-BluGenieWalkThrough or Invoke-WalkThrough - interactive help menu system
            o  Get-BluGenieErrorAction or Get-ErrorAction - Round up any errors into a smiple, clean object
            o  New-BluGenieUID or New-UID - Create a New UID
            o  ConvertTo-Yaml - ConvertTo Yaml
            o  Clear-BlugenieMemory or Clear-Memory or CM - Free up any garbage collecting that Powershell is managing
            o  ConvertFrom-Yaml - Convert From Yaml
#>

#region Build Notes
<#
~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
    o 21.02.1201: • [Michael Arroyo] Function Template
    o 21.02.2401: • [Michael Arroyo] Posted
#>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Get-BGADGroupMembers','Get-BGADGM','ADGM')]
    #region Parameters
        Param
        (
            [Alias("GN")]
            [string]$GroupName,

            [Alias("DO")]
            [string]$Domain = $(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\History' -Name 'MachineDomain' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'MachineDomain'),

            [Alias("FD")]
            [Switch]$FullDetails,

            [Alias("UC")]
            [Switch]$UseCache,

            [Alias("CP")]
            [String]$CachePath = $('{0}\BGSys_{1}.txt' -f $env:temp, $(New-BluGenieUID)),

            [Alias('Help')]
            [Switch]$Walkthrough,

            [Switch]$ReturnObject,

            [Switch]$OutUnEscapedJSON,

            [Switch]$OutYaml,

            [ValidateSet('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')]
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
        $HashReturn['GetBluGenieADGroupMembers'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetBluGenieADGroupMembers'].StartTime = $($StartTime).DateTime
        $HashReturn['GetBluGenieADGroupMembers'].ParameterSetResults = @()
        $HashReturn['GetBluGenieADGroupMembers']['Items'] = @()
        $HashReturn['GetBluGenieADGroupMembers']['CachePath'] = $CachePath
        $HashReturn['GetBluGenieADGroupMembers']['Count'] = 0
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['GetBluGenieADGroupMembers'].ParameterSetResults += $PSBoundParameters
    #endregion Parameter Set Results

    #region Dynamic parameter update
        If
        (
            $PSVersionTable.PSVersion.Major -eq 2
        )
        {
            $IsPosh2 = $true
        }
        Else
        {
            $IsPosh2 = $false
        }

        Switch
        (
            $null
        )
        {
            {$FormatView -eq 'Yaml' -and $IsPosh2}
            {
                $FormatView -eq 'None'
            }

            {$FormatView -match 'JSON' -and $IsPosh2}
            {
                $FormatView -eq 'None'
            }

            {$FormatView -eq 'Yaml'}
            {
                $UseCache = $true
            }

            {$OutYaml -and $IsPosh2}
            {
                $OutYaml -eq $false
                $FormatView -eq 'None'
            }
        }
    #endregion Dynamic parameter update

    #region Internal Functions
        #region fGetADGroupObjectFromName (Function)
            function fGetADGroupObjectFromName([System.String]$sGroupName,[System.String]$sLDAPSearchRoot)
            {
                $oADRoot = New-Object System.DirectoryServices.DirectoryEntry($sLDAPSearchRoot)
                $sSearchStr ="(&(objectCategory=group)(name="+$sGroupName+"))"
                $oSearch=New-Object directoryservices.DirectorySearcher($oADRoot,$sSearchStr)
                $oFindResult=$oSearch.FindAll()

                if
                (
                    $oFindResult.Count -eq 1
                )
                {
                    return($oFindResult)
                }
                else
                {
                    return($false)
                }
            }
        #endregion fGetADGroupObjectFromName (Function)
    #endregion Internal Functions

    #region Main
        #region Query LDAP for Group Members
            $sSearchRoot = "LDAP://"+$domain+":3268"
            $oMemberList = @()
            $BuildCSVHeader = $false

            if
            (
                $oSearchResult=fGetADGroupObjectFromName $groupname $sSearchRoot
            )
            {
	            $oGroup=New-Object System.DirectoryServices.DirectoryEntry($oSearchResult.Path)
	            $oGroup.Member | ForEach-Object `
                    -Process `
                    {
		                $oUser=New-Object System.DirectoryServices.DirectoryEntry($sSearchRoot+"/"+$_)

                        If
                        (
                            $FullDetails
                        )
                        {
                            $oCurMemberList = New-Object PSObject -Property @{
                                    Name = $oUser | Select-Object -ExpandProperty Name
                                    SAMAccountname = $oUser | Select-Object -ExpandProperty sAMAccountname
		                            DisplayName = $oUser | Select-Object -ExpandProperty displayName
		                            Description = $oUser | Select-Object -ExpandProperty description
		                            Path = $oUser | Select-Object -ExpandProperty Path
                                }
                        }
                        Else
                        {
                            $oCurMemberList = $oUser.Name
                        }

                        If
                        (
                            $UseCache
                        )
                        {
                            
                            If
                            (
                                $FullDetails
                            )
                            {
                                If
                                (
                                    $BuildCSVHeader -eq $false
                                )
                                {
                                    '"Name","SAMAccountname","DisplayName","Description","Path"' | Out-File -FilePath $CachePath -Append -Force
                                    $BuildCSVHeader = $true
                                }

                                $('"{0}","{1}","{2}","{3}","{4}"' -f $oCurMemberList.Name,
                                                            $oCurMemberList.SAMAccountname,
                                                            $oCurMemberList.DisplayName,
                                                            $oCurMemberList.Description,
                                                            $oCurMemberList.Path) | Out-File $CachePath -Append -Force
                            }
                            Else
                            {
                                $oCurMemberList | Out-File $CachePath -Append -Force
                            }
                        }
                        
                        $oMemberList += $oCurMemberList
	                }
            }
            else
            {
	            Write-Warning ("Group "+$groupname+" not found at "+$domain)
            }
        #endregion Query LDAP for Group Members

        #region Update Hash Table
            If
            (
                $oMemberList
            )
            {
                $HashReturn['GetBluGenieADGroupMembers']['Items'] += $oMemberList
                $HashReturn['GetBluGenieADGroupMembers']['Count'] = $oMemberList.Count

                If
                (
                    $UseCache
                )
                {
                     Write-Host $('( {0} ) members saved to "{1}"' -f $GroupName, $CachePath) -ForegroundColor Green
                     Return
                }
            }
        #endregion Update Hash Table
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetBluGenieADGroupMembers'].EndTime = $($EndTime).DateTime
        $HashReturn['GetBluGenieADGroupMembers'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            -Not $($VerbosePreference -eq 'Continue')
        )
        {
            #Add Hash Properties that are not needed without Verbose enabled.
            $null = $HashReturn['GetBluGenieADGroupMembers'].Remove('StartTime')
            $null = $HashReturn['GetBluGenieADGroupMembers'].Remove('ParameterSetResults')
            $null = $HashReturn['GetBluGenieADGroupMembers'].Remove('CachePath')
            $null = $HashReturn['GetBluGenieADGroupMembers'].Remove('EndTime')
            $null = $HashReturn['GetBluGenieADGroupMembers'].Remove('ElapsedTime')
            $null = $HashReturn['GetBluGenieADGroupMembers'].Remove('Count')
        }

        If
        (
            $ClearGarbageCollecting
        )
        {
            $null = Clear-BlugenieMemory
        }

        #region Output Type
            $ResultSet = $oMemberList

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

                #region Yaml Output of Hash Information
                    { $OutYaml }
                    {
                        Return $($HashReturn | ConvertTo-Yaml)
                    }
                #endregion Yaml Output of Hash Information

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

                                #region Yaml
                                    'Yaml'
                                    {
                                        Return $($ResultSet | ConvertTo-Yaml)
                                    }
                                #endregion Yaml

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
#endregion Get-BluGenieADGroupMembers (Function)