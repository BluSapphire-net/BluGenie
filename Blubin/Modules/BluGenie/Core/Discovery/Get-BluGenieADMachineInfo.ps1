#region Get-BluGenieADMachineInfo (Function)
    function Get-BluGenieADMachineInfo
    {
    <#
        .SYNOPSIS
            Query Active Directory Machine Information (Without RSAT)

        .DESCRIPTION
            Query Active Directory Machine Information (Without RSAT)

        .PARAMETER ReturnObject
            Return information as an Object.
            By default the data is returned as a Hash Table

            <Type>SwitchParameter<Type>

        .EXAMPLE
            Get-BluGenieADMachineInfo

            This will return machine specific information from AD and Group Policy
            The returned data will be a Hash Table

        .EXAMPLE
            Get-BluGenieADMachineInfo -ReturnObject

            This will return machine specific information from AD and Group Policy
            The returned data will be an Object

        .OUTPUTS
            TypeName: System.Collections.Hashtable

        .NOTES

            * Original Author           : Michael Arroyo
            * Original Build Version    : 1903.1501
            * Latest Author             : Michael Arroyo
            * Latest Build Version      : 1903.2101
            * Comments                  :
            * Dependencies              :
                                            ~
            * Build Version Details     :
                                            ~ 1903.1501: * [Michael Arroyo] Posted
                                            ~ 1903.1601: * [Michael Arroyo] Pulling Data from AD using .NET [ADSI]
                                                            * [Michael Arroyo] Removed functions for System.DirectoryServices.Protocols
                                                            * [Michael Arroyo] Check for pre-existing AD Info if running remotly.  You cannot run this type of code normally as it tries to double hop to the LDAP Server.
                                                            * [Michael Arroyo] Removed the Add to Object section and added a Key / Value pair in an array based on the new LDAP collections object
                                            ~ 1903.2101: * [Michael Arroyo] Added a process to pass Active Directory data from the main console to the remote machine
                                                            * [Michael Arroyo] Moved the AD data parsing code to an area that will only process if the process is ran manually.  Not from the console.  The console is now doing this step.
                                                            * [Michael Arroyo] Added more error control around data being sent from the console

    #>
        [Alias('Get-ADMachineInfo')]
        Param
        (
            [Parameter(Position=0)]
            [Switch]$ReturnObject,

            [Parameter(Position=3)]
            [Alias('Help')]
            [Switch]$Walkthrough
        )

        #region WalkThrough (Ver: 1905.2401)
            <#.NOTES
                
                * Original Author           : Michael Arroyo
                * Original Build Version    : 1902.0505
                * Latest Author             : Michael Arroyo
                * Latest Build Version      : 1905.2401
                * Comments                  : 
                * Dependencies              : 
                                                ~
                * Build Version Details     : 
                                                ~ 1902.0505: * [Michael Arroyo] Posted
                                                ~ 1904.0801: * [Michael Arroyo] Updated the error control for the entire process to support External Help (XML) files
                                                             * [Michael Arroyo] Updated the ** Parameters ** section to bypass the Help indicator to support External Help (XML) files
                                                             * [Michael Arroyo] Updated the ** Options ** section to bypass the Help indicator to support External Help (XML) files
                                                ~ 1905.1302: * [Michael Arroyo] Converted all Where-Object references to PowerShell 2
                                                ~ 1905.2401: * [Michael Arroyo] Updated syntax based on PSAnalyzer
            #>
                If
                (
                    $Walkthrough
                )
                {
                    #region WalkThrough Defined Variables
                        $Function = $($PSCmdlet.MyInvocation.InvocationName)
                        $CurHelp = $(Get-Help -Name $Function -ErrorAction SilentlyContinue)
                        $CurExamples = $CurHelp.examples
                        $CurParameters = $CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -NE 'Walkthrough' } | Select-Object -ExpandProperty Name
                        $CurSyntax = $CurHelp.syntax
                        $LeaveWalkThrough = $false
                    #endregion

                    #region Main Do Until
                        Do
                        {
                            #region Build Current Command
                                $Walk_Command = $('{0}' -f $Function)
                                $CurParameters | ForEach-Object `
                                -Process `
                                {
                                    $CurParameter = $_
                                    $CurValue = $(Get-Item -Path $('Variable:\{0}' -f $CurParameter) -ErrorAction SilentlyContinue).Value
                                    If
                                    (
                                        $CurValue
                                    )
                                    {
                                        Switch
                                        (
                                            $CurValue
                                        )
                                        {
                                            $true
                                            {
                                                $Walk_Command += $(' -{0}' -f $CurParameter)
                                            }
                                            $false
                                            {
                                                
                                            }
                                            Default
                                            {
                                                $Walk_Command += $(' -{0} "{1}"' -f $CurParameter, $CurValue)
                                            }
                                        }
                                    }
                                }
                            #endregion

                            #region Build Main Menu
                                #region Main Header
                                    Write-Host $("`n")
                                    Write-Host $('** Command Syntax **') -ForegroundColor Green
                                    Write-Host $('{0}' -f $($CurSyntax | Out-String).Trim()) -ForegroundColor Cyan

                                    Write-Host $("`n")
                                    Write-Host $('** Current Command **') -ForegroundColor Green
                                    Write-Host $('{0}' -f $Walk_Command) -ForegroundColor Cyan
                                    Write-Host $("`n")
	
									Write-Host $('** Parameters **') -ForegroundColor Green
									$CurParameters | ForEach-Object `
									-Process `
									{
										If
										(
											$_ -ne 'Help'
										)
										{
											Write-Host $('{0}: {1}' -f $_, $(Get-Item -Path Variable:\$_ -ErrorAction SilentlyContinue).Value) -ForegroundColor Cyan
										}
									}
									
									Write-Host $("`n")
						            Write-Host $('** Options **') -ForegroundColor Green
									$CurParameters | ForEach-Object `
									-Process `
									{
										If
										(
											$_ -ne 'Help'
										)
										{
											Write-Host $("Type '{0}' to update value" -f $_) -ForegroundColor Yellow
										}
									}
									Write-Host $("Type 'Help' to view the Description for each Parameter") -ForegroundColor Yellow
                                    Write-Host $("Type 'Examples' to view any Examples") -ForegroundColor Yellow
                                    Write-Host $("Type 'Run' to Run the above (Current Command)") -ForegroundColor Yellow
                                    Write-Host $("Type 'Exit' to Exit without running") -ForegroundColor Yellow

                                    Write-Host $("`n")
                                #endregion

                                #region Main Prompt
                                    $UpdateItem = Read-Host -Prompt 'Please make a selection'
                                #endregion

                                #region Main Switch for menu interaction
                                    switch ($UpdateItem)
                                    {
                                        #region Exit Main menu
                                            'Exit'
                                            {
                                                Return
                                            }
                                        #endregion

                                        #region Pull Parameter Type from the Static Help Parameter (If String)
                                            {
                                                Try
                                                {
                                                    $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'String'
                                                }
                                                Catch
                                                {
                                                    $null
                                                }
                                            }
                                            {
                                                Clear-Host
                                                $null = Remove-Variable -Name $UpdateItem -Force -ErrorAction SilentlyContinue
                                                $null = New-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $(Read-Host -Prompt $('Enter-{0}' -f $UpdateItem)) -Force -ErrorAction SilentlyContinue
                                            }
                                        #endregion

                                        #region Pull Parameter Type from the Static Help Parameter (If Int)
                                            {
                                                Try
                                                {
                                                    $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'Int'
                                                }
                                                Catch
                                                {
                                                    $null
                                                }
                                            }
                                            {
                                                Clear-Host
                                                $IntValue = $(Read-Host -Prompt $('Enter-{0}' -f $UpdateItem))
                                                Switch
                                                (
                                                    $IntValue
                                                )
                                                {
                                                    ''
                                                    {
                                                         $null = Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $null -Force -ErrorAction SilentlyContinue
                                                    }
                                                    {
                                                        $IntValue -match '^[\d\.]+$'
                                                    }
                                                    {
                                                        $null = Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $IntValue -Force -ErrorAction SilentlyContinue
                                                    }
                                                    Default
                                                    {
                                                        Clear-Host
                                                        Write-Host $('({0}) is not a valid [Int].  Please try again.' -f $IntValue) -ForegroundColor Red
                                                        Write-Host $("`n")
                                                        Pause
                                                    }
                                                }
                                            }
                                        #endregion

                                        #region Pull Parameter Type from the Static Help Parameter (If SwitchParameter)
                                            {
                                                Try
                                                {
                                                    $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'SwitchParameter'
                                                }
                                                Catch
                                                {
                                                    $null
                                                }
                                            }
                                            {
                                                Clear-Host
                                                If
                                                (
                                                    $(Get-Item -Path $('Variable:\{0}' -f $UpdateItem)).Value -eq $true
                                                )
                                                {
                                                    $CurToggle = $false
                                                }
                                                Else
                                                {
                                                    $CurToggle = $true
                                                }
                                                $null = Remove-Variable -Name $UpdateItem -Force -ErrorAction SilentlyContinue
                                                $null = New-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $CurToggle -Force
                                                $null = Remove-Variable -Name $CurToggle -Force -ErrorAction SilentlyContinue
                                            }
                                        #endregion

                                        #region Pull Parameter Type from the Static Help Parameter (If ValidateSet)
                                            {
                                                Try
                                                {
                                                    $($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem } | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<Type\>')[1] -eq 'ValidateSet'
                                                }
                                                Catch
                                                {
                                                    $null
                                                }
                                            }
                                            {
                                                $AllowedValues = $($($($CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $UpdateItem }) | Select-Object -ExpandProperty Description | Select-Object -ExpandProperty Text) -split '\<ValidateSet\>')[1] -split ','
                                                Clear-Host

                                                Do
                                                {
                                                    Write-Host $('** Validation Set **') -ForegroundColor Green
                                                    $AllowedValues | ForEach-Object -Process { Write-Host $("Type '{0}' to update value" -f $_) -ForegroundColor Yellow}
                                                    Write-Host $("Type 'Back' to go back to the main menu") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Null' to remove the current value") -ForegroundColor Yellow

                                                    Write-Host $("`n")
                                                    $ValidateSetInput = $null
                                                    $ValidateSetInput = Read-Host -Prompt 'Please make a selection'

                                                    Switch
                                                    (
                                                        $ValidateSetInput
                                                    )
                                                    {
                                                        'Back'
                                                        {
                                                            $LeaveValidateSet = $true
                                                        }
                                                        'Null'
                                                        {
                                                            Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $null -ErrorAction SilentlyContinue
                                                            $LeaveValidateSet = $true
                                                        }
                                                        {
                                                            $AllowedValues -contains $ValidateSetInput
                                                        }
                                                        {
                                                            Set-Item -Path $('Variable:\{0}' -f $UpdateItem) -Value $ValidateSetInput -ErrorAction SilentlyContinue
                                                            $LeaveValidateSet = $true
                                                        }
                                                        Default
                                                        {
                                                            Clear-Host
                                                            Write-Host $('({0}) is not a valid option.  Please try again.' -f $ValidateSetInput) -ForegroundColor Red
                                                            Write-Host $("`n")
                                                            $LeaveValidateSet = $false
                                                        }
                                                    }
                                                }
                                                Until
                                                (
                                                    $LeaveValidateSet -eq $true
                                                )
                                            }
                                        #endregion

                                        #region Pull the Help information for each Parameter and Dynamically build the menu system
                                            'Help'
                                            {
                                                Clear-Host
                                                $LeaveHelpInput = $false

                                                Do
                                                {
                                                    Write-Host $('** Help Parameter Information **') -ForegroundColor Green
                                                    $CurParameters | ForEach-Object -Process { Write-Host $("Type '{0}' to view Help" -f $_) -ForegroundColor Yellow}
                                                    Write-Host $("Type 'All' to list all Parameters and Help Information") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Help' to view the General Help information") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Full' to view the Detailed Help information") -ForegroundColor Yellow
                                                    Write-Host $("Type 'ShowWin' to view the Detailed Help information in a Win-Form") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Back' to go back to the main menu") -ForegroundColor Yellow

                                                    Write-Host $("`n")
                                                    $HelpInput = $null
                                                    $HelpInput = Read-Host -Prompt 'Please make a selection'

                                                    Switch
                                                    (
                                                        $HelpInput
                                                    )
                                                    {
                                                        'Back'
                                                        {
                                                            $LeaveHelpInput = $true
                                                        }
                                                        {
                                                            $CurParameters -contains $HelpInput
                                                        }
                                                        {
                                                            $CurHelp.parameters.parameter | Where-Object -FilterScript { $_.Name -eq $HelpInput } | Out-String
                                                            Pause
                                                        }
                                                        'All'
                                                        {
                                                            $CurHelp.parameters.parameter | Out-String
                                                            Pause
                                                        }
                                                        'Help'
                                                        {
                                                            Get-Help -Name $Function | Out-String
                                                            Pause
                                                        }
                                                        'Full'
                                                        {
                                                            Get-Help -Name $Function -Full | Out-String
                                                            Pause
                                                        }
                                                        'ShowWin'
                                                        {
                                                            #Get-Help -Name $Function -ShowWindow  ##This was commented out for PS2 compatibility
                                                            Pause
                                                        }
                                                        Default
                                                        {
                                                            Clear-Host
                                                            Write-Host $('({0}) is not a valid option.  Please try again.' -f $HelpInput) -ForegroundColor Red
                                                            Write-Host $("`n")
                                                        }
                                                    }
                                                }
                                                Until
                                                (
                                                    $LeaveHelpInput -eq $true
                                                )
                                            }
                                        #endregion

                                        #region Pull the Examples information and Dynamically build the menu system
                                            'Examples'
                                            {
                                                Clear-Host
                                                $LeaveExampleInput = $false
                                                $CurExamplesList = $($CurHelp.examples.example | Select-Object -ExpandProperty Title) -replace ('-') -replace (' ') -replace ('EXAMPLE')

                                                Do
                                                {
                                                    Write-Host $('** Examples **') -ForegroundColor Green
                                                    $CurExamplesList | ForEach-Object -Process { Write-Host $("Type '{0}' to view Example{0}" -f $_) -ForegroundColor Yellow}
                                                    Write-Host $("Type 'All' to list all Examples") -ForegroundColor Yellow
                                                    Write-Host $("Type 'Back' to go back to the main menu") -ForegroundColor Yellow

                                                    Write-Host $("`n")
                                                    $ExampleInput = $null
                                                    $ExampleInput = Read-Host -Prompt 'Please make a selection'

                                                    Switch
                                                    (
                                                        $ExampleInput
                                                    )
                                                    {
                                                        'Back'
                                                        {
                                                            $LeaveExampleInput = $true
                                                        }
                                                        {
                                                            $CurExamplesList -contains $ExampleInput
                                                        }
                                                        {
                                                            $CurHelp.examples.example | Where-Object -FilterScript { $_.Title -Match $('EXAMPLE\s{0}' -f $ExampleInput) }
                                                            Pause
                                                        }
                                                        'All'
                                                        {
                                                            $CurHelp.examples.example
                                                            Pause
                                                        }
                                                        Default
                                                        {
                                                            Clear-Host
                                                            Write-Host $('({0}) is not a valid option.  Please try again.' -f $ExampleInput) -ForegroundColor Red
                                                            Write-Host $("`n")
                                                        }
                                                    }
                                                }
                                                Until
                                                (
                                                    $LeaveExampleInput -eq $true
                                                )
                                            }
                                        #endregion

                                        #region Run the Current Command
                                            'Run'
                                            {
                                                #Exiting Switch and Running set Parameters
                                                $LeaveWalkThrough = $true
                                            }
                                        #endregion

                                        #region Default (Error Control)
                                            Default
                                            {
                                                Clear-Host
                                                Write-Host $('({0}) is not a valid option.  Please try again.' -f $UpdateItem) -ForegroundColor Red
                                                Write-Host $("`n")
                                                $LeaveWalkThrough = $false
                                                Pause
                                            }
                                        #endregion
                                    }
                                #endregion
                            #endregion
                        }
                        Until
                        (
                            $LeaveWalkThrough -eq $true
                        )
                    #endregion
                }
            #endregion

        #region Create Hash
            $HashReturn = @{}
            $HashReturn.ADMachineInfo = @{}
        #endregion

        #region Setup Registry Hives for PSProvider
            $null = New-PSDrive -PSProvider Registry -Root HKEY_CLASSES_ROOT -Name HKCR -ErrorAction SilentlyContinue
            $null = New-PSDrive -PSProvider Registry -Root HKEY_USERS -Name HKU -ErrorAction SilentlyContinue
            $null = New-PSDrive -PSProvider Registry -Root HKEY_LOCAL_MACHINE -Name HKLM -ErrorAction SilentlyContinue
        #endregion

        #region Internal Functions
            #region ConvertTo-Date Function
                Function ConvertTo-Date {
                    Param (
                        $accountExpires
                    )

                    process {
                        $lngValue = $accountExpires
                        if(($lngValue -eq 0) -or ($lngValue -gt [DateTime]::MaxValue.Ticks)) {
                            $AcctExpires = "Never"
                        } else {
                            $Date = [DateTime]$lngValue
                            $AcctExpires = $Date.AddYears(1600).ToLocalTime()
                        }
                        $AcctExpires
                    }
                }
            #endregion

            #region Convert-UTCtoLocal Function
                function Convert-UTCtoLocal
                {
                    param(
                    [String] $UTCTime
                    )

                    $strCurrentTimeZone = (Get-WmiObject win32_timezone).StandardName
                    $TZ = [TimeZoneInfo]::FindSystemTimeZoneById($strCurrentTimeZone)
                    $LocalTime = [TimeZoneInfo]::ConvertTimeFromUtc($UTCTime, $TZ)

                    Return $LocalTime
                }
            #endregion
        #endregion

        #region Query LDAP Connection Information from Registry
            $Error.Clear()
            $MachineDomain = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\History' -Name 'MachineDomain' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'MachineDomain'
            $DistinguishedName = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine' -Name 'Distinguished-Name' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'Distinguished-Name'
            $SystemBaseName = $DistinguishedName -split (',',2) | Select-Object -Skip 1 -First 1
        #endregion

        #region Error Check LDAP Connection Information
            If
            (
                $MachineDomain -and  $DistinguishedName -and $SystemBaseName
            )
            {
                $HashReturn.ADMachineInfo.LDAPRegInfo = @{
                    'Status' = $true
                    'Comment' = New-Object -TypeName PSObject -Property @{'MachineDomain' = $MachineDomain
                                                    'DistinguishedName' = $DistinguishedName
                                                    'SystemBaseName' = $SystemBaseName}
                    'TimeStamp' = $(New-TimeStamp -ErrorAction SilentlyContinue)
                    'Error' = ''
                }
            }
            Else
            {
                $HashReturn.ADMachineInfo.LDAPRegInfo = @{
                    'Status' = $false
                    'Comment' = New-Object -TypeName PSObject -Property @{'MachineDomain' = $MachineDomain
                                                    'DistinguishedName' = $DistinguishedName
                                                    'SystemBaseName' = $SystemBaseName}
                    'TimeStamp' = $(New-TimeStamp -ErrorAction SilentlyContinue)
                    'Error' = $Error.Exception
                }

                Return $HashReturn
            }
        #endregion

        #region Query LDAP Object
            $Error.Clear()
            If
            (
                $Global:BGADInfo
            )
            {
                $LDAPInfo = $Global:BGADInfo
                $QueryFrom = 'Console'
            }
            Else
            {
                #region Create LDAP connection and search for instance
                    $ADSISearcher = [ADSISearcher]$('(&(cn={0})(objectClass=computer))' -f $env:COMPUTERNAME)
                    $ADSISearcher.SearchRoot = [ADSI]"LDAP://$SystemBaseName"
                    $LDAPInfo = $ADSISearcher.FindOne().Properties
                    $QueryFrom = $env:COMPUTERNAME
                #endregion

                #region Update LDAP Object
                    $LDAPInfo.Add('accountexpiresdate',@($(ConvertTo-Date -accountExpires $($LDAPInfo.accountexpires) -ErrorAction SilentlyContinue | Out-String).trim()))
                    $LDAPInfo.Add('badpasswordtimedate',@($(ConvertTo-Date -accountExpires $($LDAPInfo.badpasswordtime) -ErrorAction SilentlyContinue | Out-String).trim()))
                    $LDAPInfo.Add('lastlogondate',@($(Get-Date -Date $([datetime]::FromFileTime($($LDAPInfo.lastlogon))) -Format "MM/dd/yyyy hh:mm:ss tt" -ErrorAction SilentlyContinue | Out-String).trim()))
                    $LDAPInfo.Add('lastlogontimestampdate',@($(Get-Date -Date $([datetime]::FromFileTime($($LDAPInfo.lastlogontimestamp))) -Format "MM/dd/yyyy hh:mm:ss tt" -ErrorAction SilentlyContinue | Out-String).trim()))
                    $LDAPInfo.Add('pwdlastsetdate',@($(Get-Date -Date $([datetime]::FromFileTime($($LDAPInfo.pwdlastset))) -Format "MM/dd/yyyy hh:mm:ss tt" -ErrorAction SilentlyContinue | Out-String).trim()))
                    $LDAPInfo.Add('whencreateddate',@($(Get-Date -Date $($LDAPInfo.whencreated) -Format "MM/dd/yyyy hh:mm:ss tt" -ErrorAction SilentlyContinue | Out-String).trim()))
                    $LDAPInfo.Add('whenchangeddate',@($(Get-Date -Date $($LDAPInfo.whenchanged) -Format "MM/dd/yyyy hh:mm:ss tt" -ErrorAction SilentlyContinue | Out-String).trim()))
                #endregion
            }
        #endregion

        #region Error Check Query LDAP Object
            If
            (
                $LDAPInfo
            )
            {
                $HashReturn.ADMachineInfo.LDAPObjectResults = @{
                    'Status' = $true
                    'Comment' = New-Object -TypeName PSObject -Property @{'Object' = $($LDAPInfo.distinguishedname)
                                                    'Fitler' = $($ADSISearcher.Filter)
                                                    'SearchRoot' = $($($ADSISearcher.SearchRoot | Out-String).Trim())
                                                    'QueryStartedFrom' = $QueryFrom
                                                    }
                    'TimeStamp' = $(New-TimeStamp -ErrorAction SilentlyContinue)
                    'Error' = ''
                }
            }
            Else
            {
                $HashReturn.ADMachineInfo.LDAPObjectResults = @{
                    'Status' = $false
                    'Comment' = New-Object -TypeName PSObject -Property @{'Object' = $($LDAPInfo.distinguishedname)
                                                    'Fitler' = $($ADSISearcher.Filter)
                                                    'SearchRoot' = $($($ADSISearcher.SearchRoot | Out-String).Trim())
                                                    'QueryStartedFrom' = $QueryFrom
                                                    }
                    'TimeStamp' = $(New-TimeStamp -ErrorAction SilentlyContinue)
                    'Error' = $Error.Exception
                }

                Return $HashReturn
            }
        #endregion

        #region Update Return Hash with LDAP Info
            $HashReturn.ADMachineInfo.ADMachineInfo = $LDAPInfo
        #endregion

        #region Query Group Member List
            $Error.Clear()
            $ArrGroupMembers = @()

            $(Get-Item -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\GroupMembership') |
                Select-Object -ExpandProperty Property | Where-Object -FilterScript { $_ -match '^Group'} | ForEach-Object `
                -Process `
                {
                    $CurGroup = $_
                    $CurSID = $(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\GroupMembership' -Name $CurGroup -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $CurGroup)

                    If
                    (
                        $CurSID -eq 'S-1-16-16384'
                    )
                    {
                        $CurGroupName = 'System Mandatory Level'
                    }
                    Else
                    {
                        $CurGroupNameChk = Convert-SID2UserName -SID $CurSID -ErrorAction SilentlyContinue

                        If
                        (
                            $CurGroupNameChk -notmatch '^Oops'
                        )
                        {
                            $CurGroupName = $CurGroupNameChk
                        }
                        Else
                        {
                            $CurGroupName = $CurSID
                        }
                    }

                    $ArrGroupMembers += New-Object -TypeName PSObject -Property @{
                        'SID' = $CurSID
                        'GroupMemberShip' = $CurGroupName
                        'GroupID' = $_
                    }
                }

                $HashReturn.ADMachineInfo.GroupMembersOf = $ArrGroupMembers
        #endregion

        #region Error Check Query Group Member
            If
            (
                $ArrGroupMembers
            )
            {
                $HashReturn.ADMachineInfo.GroupMemberListResults = @{
                    'Status' = $true
                    'Comment' = ''
                    'TimeStamp' = $(New-TimeStamp -ErrorAction SilentlyContinue)
                    'Error' = ''
                }
            }
            Else
            {
                $HashReturn.ADMachineInfo.GroupMemberListResults = @{
                    'Status' = $false
                    'Comment' = ''
                    'TimeStamp' = $(New-TimeStamp -ErrorAction SilentlyContinue)
                    'Error' = $Error.Exception
                }
            }
        #endregion

        #region Query GPO List
            $Error.Clear()
            $ArrGPOList = @()

            $(Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\GPO-List') | Select-Object -ExpandProperty PSChildName | ForEach-Object `
                -Process `
                {
                    $CurGroupList = $_
                    $CurGroupListName = $(Get-ItemProperty -Path $('HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\GPO-List\{0}' -f $CurGroupList) -Name 'DisplayName' -ErrorAction SilentlyContinue | Select-Object -ExpandProperty 'DisplayName')

                    $ArrGPOList += New-Object -TypeName PSObject -Property @{
                        'DisplayName' = $CurGroupListName
                        'GroupID' = $_
                    }
                }

                $HashReturn.ADMachineInfo.GPOList = $ArrGPOList
        #endregion

        #region Error Check Query Group Member
            If
            (
                $ArrGPOList
            )
            {
                $HashReturn.ADMachineInfo.GPOListResults = @{
                    'Status' = $true
                    'Comment' = ''
                    'TimeStamp' = $(New-TimeStamp -ErrorAction SilentlyContinue)
                    'Error' = ''
                }
            }
            Else
            {
                $HashReturn.ADMachineInfo.GPOListResults = @{
                    'Status' = $false
                    'Comment' = ''
                    'TimeStamp' = $(New-TimeStamp -ErrorAction SilentlyContinue)
                    'Error' = $Error.Exception
                }
            }
        #endregion

        #region Output
            If
            (
                $ReturnObject
            )
            {
                Return $(New-Object -TypeName PSObject -Property @{
                    'ADInfo' = $LDAPInfo
                    'MembersOf' = $ArrGroupMembers
                    'GPOList' = $ArrGPOList
                })
            }
            Else
            {
                Return $HashReturn
            }
        #endregion
    }
#endregion Get-BluGenieADMachineInfo (Function)