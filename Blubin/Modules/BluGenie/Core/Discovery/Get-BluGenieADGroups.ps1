 #region Get-BluGenieADGroups (Function)
Function Get-BluGenieADGroups
{
<#
    .SYNOPSIS
        Query for Active Directory Groups via LDAP without the need for RSAT to be installed.

    .DESCRIPTION
        Query for Active Directory Groups via LDAP without the need for RSAT to be installed.

    .PARAMETER GroupName
        Description: The name of the Group you are looking for
        Notes: This is a regex managed pattern.  The default is (.*) for all Groups
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
        Notes: By default the Cache location is %temp%
        Alias: UC
        ValidateSet:

    .PARAMETER CachePath
        Description: Path to store the Cache information
        Notes: By default the Cache location is %temp% with a BG_ADGroups_<GUID>.txt file name.
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
        Command: Get-BGADGroups -ReturnObject
        Description: Use this command to Query AD for all Groups and return the instances as a PowerSehll object
        Notes:

    .EXAMPLE
        Command: Get-BGADGroups -ReturnObject -GroupName Administrator
        Description: Use this command to query AD for any group with a name that matches 'Administrator'
        Notes:  The GroupName property is filtered using RegEx

    .EXAMPLE
        Command: Get-BGADGroups -ReturnObject -UseCache
        Description: Use this command to save all found groups in AD to a file on disk
        Notes: The file is saved by default to $Env:temp with a prefix of BG_ADGroups_<GUID>

    .EXAMPLE
        Command: Get-BGADGroups -ReturnObject -UseCache -FormatView JSON -
        Description: Use this command to save the output to JSON format
        Notes: The default format is (CSV).  Options are JSON, YAML, and CSV

    .EXAMPLE
        Command: Get-BGADGroups -ReturnObject -UseCache -FormatView Yaml -CachePath C:\Temp -CacheFileName ADGroupInfo
        Description: Use this command to save the output as Yaml to a file located -> C:\Temp\ADGroupInfo.yaml
        Notes:     

    .EXAMPLE
        Command: Get-BGADGroups -ReturnObject -UseCache -FullDetails
        Description: Use this command to query the the full list of Group Object Properties
        Notes: The default is (name, distinguishedname, and path).  The full list of Properties are as follows
                o name
                o distinguishedname
                o path
                o objectcategory
                o usnchanged
                o grouptype
                o whencreated
                o samaccountname
                o description
                o instancetype
                o adspath
                o samaccounttype
                o objectsid
                o whenchanged
                o objectguid
                o member
                o cn
                o usncreated
                o admincount
                o iscriticalsystemobject
                o objectclass
                o systemflags
                o dscorepropagationdata

    .EXAMPLE
        Command: Get-BGADGroups -OutYaml -Verbose
        Description: Use this command to view a full detailed yaml report on AD Groups and function details
        Notes:

    .EXAMPLE
        Command: Get-BluGenieADGroups -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieADGroups -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BGADGroups -OutUnEscapedJSON
        Description: Return a detailed function report in an UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BGADGroups -OutYaml
        Description: Return a detailed function report in YAML format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BGADGroups -ReturnObject
        Description: Return Output as a Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
                This parameter is also used with the FormatView

    .EXAMPLE
        Command: Get-BGADGroups -ReturnObject -FormatView Yaml
        Description: Output PSObject information in Yaml format
        Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')
                Default is set to (None) and normal PSObject.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • [Original Author]
            o  Michael Arroyo
        • [Original Build Version]
            o  21.05.1401 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
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
    o 21.05.1401: • [Michael Arroyo] Posted
#>
#endregion Build Notes
    [cmdletbinding()]
    [Alias('Get-BGADGroups','Get-BGADG','ADG')]
    #region Parameters
        Param
        (
            [Alias("GN")]
            [string]$GroupName = '.*',

            [Alias("DO")]
            [string]$Domain = $(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\History' -Name 'MachineDomain' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'MachineDomain'),

            [Alias("FD")]
            [Switch]$FullDetails,

            [Alias("UC")]
            [Switch]$UseCache,

            [Alias("CP")]
            [String]$CachePath = $env:temp,

            [Alias("CFN")]
            [String]$CacheFileName = $('BG_ADGroups_{0}' -f $(New-BluGenieUID)),

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
        $HashReturn['GetBluGenieADGroups'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetBluGenieADGroups'].StartTime = $($StartTime).DateTime
        $HashReturn['GetBluGenieADGroups'].ParameterSetResults = @()
        $HashReturn['GetBluGenieADGroups']['Items'] = @()
        $HashReturn['GetBluGenieADGroups']['CachePath'] = $CachePath
        $HashReturn['GetBluGenieADGroups']['Count'] = 0
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['GetBluGenieADGroups'].ParameterSetResults += $PSBoundParameters
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
                $sSearchStr ="(&(objectCategory=group))"
                $oSearch=New-Object directoryservices.DirectorySearcher($oADRoot,$sSearchStr)
                $oFindResult=$oSearch.FindAll() | Where-Object -FilterScript { $_.Path -match $sGroupName }

                if
                (
                    $oFindResult.Count -gt 0
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

            if
            (
                $oSearchResult = fGetADGroupObjectFromName $groupname $sSearchRoot
            )
            {
	            $oSearchResult | ForEach-Object `
                    -Process `
                    {
                        $CurGroupObj = $_
                        $CurGroupPath = $_.Path
                        $CurGroupProps = $_.Properties
                        $CurGroupName = $CurGroupProps.Name

                        If
                        (
                            $FullDetails
                        )
                        {
                            $oCurMemberList = '' | Select-Object -Property @{
                                                                                Name = 'name'
                                                                                Expression = {$($CurGroupProps.name)}
                                                                            },
                                                                            @{
                                                                                Name = 'distinguishedname'
                                                                                Expression = {$CurGroupProps.distinguishedname}
                                                                            },
                                                                            @{
                                                                                Name = 'path'
                                                                                Expression = {$CurGroupPath}
                                                                            },
                                                                            @{
                                                                                Name = 'objectcategory'
                                                                                Expression = {$CurGroupProps.objectcategory}
                                                                            },
                                                                            @{
                                                                                Name = 'usnchanged'
                                                                                Expression = {$CurGroupProps.usnchanged}
                                                                            },
                                                                            @{
                                                                                Name = 'grouptype'
                                                                                Expression = {$CurGroupProps.grouptype}
                                                                            },
                                                                            @{
                                                                                Name = 'whencreated'
                                                                                Expression = {$CurGroupProps.whencreated}
                                                                            },
                                                                            @{
                                                                                Name = 'samaccountname'
                                                                                Expression = {$CurGroupProps.samaccountname}
                                                                            },
                                                                            @{
                                                                                Name = 'description'
                                                                                Expression = {$CurGroupProps.description}
                                                                            },
                                                                            @{
                                                                                Name = 'instancetype'
                                                                                Expression = {$CurGroupProps.instancetype}
                                                                            },
                                                                            @{
                                                                                Name = 'adspath'
                                                                                Expression = {$CurGroupProps.adspath}
                                                                            },
                                                                            @{
                                                                                Name = 'samaccounttype'
                                                                                Expression = {$CurGroupProps.samaccounttype}
                                                                            },
                                                                            @{
                                                                                Name = 'objectsid'
                                                                                Expression = {$CurGroupProps.objectsid}
                                                                            },
                                                                            @{
                                                                                Name = 'whenchanged'
                                                                                Expression = {$CurGroupProps.whenchanged}
                                                                            },
                                                                            @{
                                                                                Name = 'objectguid'
                                                                                Expression = {$CurGroupProps.objectguid}
                                                                            },
                                                                            @{
                                                                                Name = 'member'
                                                                                Expression = {$CurGroupProps.member}
                                                                            },
                                                                            @{
                                                                                Name = 'cn'
                                                                                Expression = {$CurGroupProps.cn}
                                                                            },
                                                                            @{
                                                                                Name = 'usncreated'
                                                                                Expression = {$CurGroupProps.usncreated}
                                                                            },
                                                                            @{
                                                                                Name = 'admincount'
                                                                                Expression = {$CurGroupProps.admincount}
                                                                            },
                                                                            @{
                                                                                Name = 'iscriticalsystemobject'
                                                                                Expression = {$CurGroupProps.iscriticalsystemobject}
                                                                            },
                                                                            @{
                                                                                Name = 'objectclass'
                                                                                Expression = {$CurGroupProps.objectclass}
                                                                            },
                                                                            @{
                                                                                Name = 'systemflags'
                                                                                Expression = {$CurGroupProps.systemflags}
                                                                            },
                                                                            @{
                                                                                Name = 'dscorepropagationdata'
                                                                                Expression = {$CurGroupProps.dscorepropagationdata}
                                                                            }
                        }
                        Else
                        {
                            $oCurMemberList = '' | Select-Object -Property @{
                                                                                Name = 'name'
                                                                                Expression = {$($CurGroupProps.name)}
                                                                            },
                                                                            @{
                                                                                Name = 'distinguishedname'
                                                                                Expression = {$CurGroupProps.distinguishedname}
                                                                            },
                                                                            @{
                                                                                Name = 'path'
                                                                                Expression = {$CurGroupPath}
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

        #region Cache Oject
            If
            (
                $UseCache -and $oMemberList
            )
            {
                Switch
                (
                    $FormatView
                )
                {
                    'JSON'
                    {
                        $UpdatedCachePath = $('{0}\{1}.JSON' -f $CachePath, $CacheFileName)
                        $oMemberList | ConvertTo-Json | Out-File -FilePath $UpdatedCachePath -Force
                        
                    }

                    'YAML'
                    {
                        $UpdatedCachePath = $('{0}\{1}.YAML' -f $CachePath, $CacheFileName)
                        $oMemberList | ConvertTo-Yaml | Out-File -FilePath $UpdatedCachePath -Force
                    }

                    Default
                    {
                        $UpdatedCachePath = $('{0}\{1}.CSV' -f $CachePath, $CacheFileName)
                        $oMemberList | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath $UpdatedCachePath -Force
                    }
                }
            }

            $HashReturn['GetBluGenieADGroups']['CachePath'] = $UpdatedCachePath
        #endregion Cache Oject

        #region Update Hash Table
            If
            (
                $oMemberList
            )
            {
                $HashReturn['GetBluGenieADGroups']['Items'] += $oMemberList
                $HashReturn['GetBluGenieADGroups']['Count'] = $oMemberList.Count
            }
        #endregion Update Hash Table
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetBluGenieADGroups'].EndTime = $($EndTime).DateTime
        $HashReturn['GetBluGenieADGroups'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        If
        (
            -Not $($VerbosePreference -eq 'Continue')
        )
        {
            #Add Hash Properties that are not needed without Verbose enabled.
            $null = $HashReturn['GetBluGenieADGroups'].Remove('StartTime')
            $null = $HashReturn['GetBluGenieADGroups'].Remove('ParameterSetResults')
            $null = $HashReturn['GetBluGenieADGroups'].Remove('CachePath')
            $null = $HashReturn['GetBluGenieADGroups'].Remove('EndTime')
            $null = $HashReturn['GetBluGenieADGroups'].Remove('ElapsedTime')
            $null = $HashReturn['GetBluGenieADGroups'].Remove('Count')
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
#endregion Get-BluGenieADGroups (Function)