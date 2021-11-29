#region Get-BluGenieMRUActivityView (Function)
    function Get-BluGenieMRUActivityView
    {
    <#
        .SYNOPSIS
            Query MRU Activity

        .DESCRIPTION
            Query MRU Activity.  Pull all known MRU information from the following location.

            'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU'
            'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRULegacy'
            'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\FirstFolder'
            'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU'
            'HKEY_CURRENT_USER\Software\IvoSoft\ClassicStartMenu\MRU'
            'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs'

        .PARAMETER ReturnObject
            Return information as an Object.
            By default the data is returned as a Hash Table

            <Type>SwitchParameter<Type>

        .EXAMPLE
            Get-BluGenieMRUActivityView

            This will return all MRU Information for the following locations.

            'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU'
            'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRULegacy'
            'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\FirstFolder'
            'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU'
            'HKEY_CURRENT_USER\Software\IvoSoft\ClassicStartMenu\MRU'
            'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs'

        .EXAMPLE
            Invoke-LoadAllProfileHives -ReturnObject

            This will return all MRU Information.
            The returned data will be an Object

        .OUTPUTS
            TypeName: System.Collections.Hashtable

        .NOTES

            * Original Author           : Michael Arroyo
            * Original Build Version    : 1903.1101
            * Latest Author             : Michael Arroyo
            * Latest Build Version      : 1903.1101
            * Comments                  :
            * Dependencies              :
                                            ~
            * Build Version Details     :
                                            ~ 1903.1101: * [Michael Arroyo] Posted
    #>
        [Alias('Get-MRUActivityView')]
        Param
        (
            [Parameter(Position=0)]
            [Switch]$ReturnObject,

            [Parameter(Position=1)]
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

        #region Create Return hash
            $HashReturn = @{}
            $HashReturn.MRUActivityView = @{}
        #endregion

        #region Array MRU List
            $ArrMRUList = @(
                #'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU|Sub',
                #'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSaveMRU|Sub',
                'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRU|Root',
                'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\LastVisitedPidlMRULegacy|Root',
                'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\FirstFolder|Root',
                'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU|Root',
                'HKEY_CURRENT_USER\Software\IvoSoft\ClassicStartMenu\MRU|Root',
                'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs|Root',
                'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs|Sub'
            )
        #endregion

        #region Create Object from ArrMRUList
            $ObjMRUList = @()

            $ArrMRUList | ForEach-Object `
            -Process `
            {
                $CurMRUList = $_
                $ObjMRUList += $CurMRUList | ConvertFrom-Csv -Delimiter '|' -Header 'Key','SearchType'
            }
        #endregion

        #region Create Parent List Array
            $ArrParentList = @()
        #endregion

        #region Setup Registry Hives for PSProvider
            $null = New-PSDrive -PSProvider Registry -Root HKEY_CLASSES_ROOT -Name HKCR -ErrorAction SilentlyContinue
            $null = New-PSDrive -PSProvider Registry -Root HKEY_USERS -Name HKU -ErrorAction SilentlyContinue
            $null = New-PSDrive -PSProvider Registry -Root HKEY_LOCAL_MACHINE -Name HKLM -ErrorAction SilentlyContinue
        #endregion

        #region Internal Functions
            #region Function Decrypt Binary
                Function DecryptRegBinary
                {
                    Param
                    (
                        $Value
                    )

                    $decoded_value = ([Text.Encoding]::Unicode.GetString($Value))
                    Return $($decoded_value -replace '[^\u0000-\u007F]+', '' | Out-String)
                }

            #endregion
        #endregion

        #region Parent Array
            $ArrAllValues = @()
        #endregion

        #region Foreach Key
            $ObjMRUList | ForEach-Object `
            -Process `
            {
                $CurObjMRUItem = $_

                #region Rebuild Registry Key for Query
                    $ArrMRUKeys = @()

                    Switch
                    (
                        $CurObjMRUItem.Key
                    )
                    {
                        {$_ -match '^HKEY_LOCAL_MACHINE'}
                        {
                            $CurKey = $_ -replace ('^HKEY_LOCAL_MACHINE','HKLM:')
                            $ArrMRUKeys += New-Object -TypeName PSObject -Property @{
                                    'PSPath' = $CurKey
                                    'RegPrefix' = 'HKEY_LOCAL_MACHINE'
                            }
                        }
                        {$_ -match '^HKEY_CLASSES_ROOT'}
                        {
                            $CurKey = $_ -replace ('^HKEY_CLASSES_ROOT','HKCR:')
                            $ArrMRUKeys += New-Object -TypeName PSObject -Property @{
                                    'PSPath' = $CurKey
                                    'RegPrefix' = 'HKEY_CLASSES_ROOT'
                            }
                        }
                        {$_ -match '^HKEY_CURRENT_USER'}
                        {
                            $CurKey = $_ -replace ('^HKEY_CURRENT_USER','')
                            $AllUserHives = $(Get-LoadedRegHives -ReturnObject | Select-Object -ExpandProperty UserHive) -replace ('^HKEY_USERS','HKU:')
                            $AllUserHives | ForEach-Object `
                            -Process `
                            {
                                $ArrUser = $_
                                $ArrMRUKeys += New-Object -TypeName PSObject -Property @{
                                    'PSPath' = $('{0}{1}' -f $ArrUser,$CurKey)
                                    'RegPrefix' = 'HKEY_USERS'
                                }
                            }
                        }
                    }
                #endregion

                #region Query and Convert Values
                    $ArrMRUKeyValues = @()

                    Switch
                    (
                        $CurObjMRUItem.SearchType
                    )
                    {
                        'Root'
                        {
                            $ArrMRUKeys | ForEach-Object `
                            -Process `
                            {
                                #region Build Common Values
                                    $CurArrMRU = $_
                                    $CurArrMRUKey = $CurArrMRU.PSPath
                                    $CurArrMRUPre = $CurArrMRU.RegPrefix

                                    If
                                    (
                                        $CurArrMRUKey -match '^HKU\:'
                                    )
                                    {
                                        $CurArrMRUUser = $CurArrMRUKey -replace ('^HKU\:\\','') -split ('\\',2) | Select-Object -First 1

                                        If
                                        (
                                            $CurArrMRUUser -match '^S-1'
                                        )
                                        {
                                            $CurArrMRUFullName = Convert-SID2UserName -SID $CurArrMRUUser -ErrorAction SilentlyContinue

                                            If
                                            (
                                                $CurArrMRUFullName -match '^oops'
                                            )
                                            {
                                                $CurArrMRUFullName = ''
                                            }
                                        }
                                        Else
                                        {
                                            $CurArrMRUFullName = $CurArrMRUUser
                                        }
                                    }
                                    Else
                                    {
                                        $CurArrMRUUser = ''
                                        $CurArrMRUFullName = ''
                                    }

                                    $CurArrMRUKeyIdentifer = $CurArrMRUKey | Split-Path -leaf
                                #endregion

                                #region Pull Reg Values
                                    If
                                    (
                                        $(Get-ItemProperty -Path $CurArrMRUKey -Name 'MRUListEx' -ErrorAction SilentlyContinue)
                                    )
                                    {
                                        $CurArrMRUKeyPropList = $(Get-ItemProperty -Path $CurArrMRUKey -ErrorAction SilentlyContinue).psobject.properties | Where-Object -FilterScript { $_.'TypeNameOfValue' -eq 'System.Byte[]' } | Select-Object -Property Value
                                    }
                                    Else
                                    {
                                        $CurArrMRUKeyPropList = $(Get-ItemProperty -Path $CurArrMRUKey -ErrorAction SilentlyContinue).psobject.properties |
                                        Where-Object -FilterScript { $_.'Name' -NotLike 'MRUList' }|
                                        Where-Object -FilterScript { $_.'Name' -NotLike 'PSChildName' }|
                                        Where-Object -FilterScript { $_.'Name' -NotLike 'PSDrive' }|
                                        Where-Object -FilterScript { $_.'Name' -NotLike 'PSParentPath' }|
                                        Where-Object -FilterScript { $_.'Name' -NotLike 'PSPath' }|
                                        Where-Object -FilterScript { $_.'Name' -NotLike 'PSProvider' }|
                                        Where-Object -FilterScript { $_.'TypeNameOfValue' -eq 'System.String' }| Select-Object -Property Value
                                    }
                                #endregion

                                #region Parse Reg Values
                                    If
                                    (
                                        $CurArrMRUKeyPropList
                                    )
                                    {
                                        $CurArrMRUKeyPropList | ForEach-Object `
                                        -Process `
                                        {
                                            $CurMRUKeyPropList = $_.Value

                                            If
                                            (
                                                $CurMRUKeyPropList.GetType().Name -eq 'String'
                                            )
                                            {
                                                $CurConvertedString = $CurMRUKeyPropList
                                                $CurConvertedType = 'String'
                                            }
                                            Else
                                            {
                                                $CurConvertedString = $(DecryptRegBinary -Value $CurMRUKeyPropList).trim()
                                                $CurConvertedType = 'Binary'
                                            }


                                            $ArrMRUKeyValues += New-Object -TypeName PSObject -Property @{
                                                'RegPath' = $($CurArrMRUKey.Replace($($CurArrMRUKey | Split-Path -Qualifier),$CurArrMRU.RegPrefix))
                                                'User' = $CurArrMRUUser
                                                'FullUserName' = $CurArrMRUFullName
                                                'KeyIdentifier' = $CurArrMRUKeyIdentifer
                                                'Value' = $CurConvertedString
                                                'OriginalType' = $CurConvertedType
                                            }
                                        }
                                    }
                                #endregion
                            }
                        }
                        'Sub'
                        {
                            $ArrMRUKeys | ForEach-Object `
                            -Process `
                            {
                                #region Build Common Values
                                    $CurArrMRU = $_
                                    $CurArrMRUKey = $CurArrMRU.PSPath
                                    $CurArrMRUPre = $CurArrMRU.RegPrefix

                                    If
                                    (
                                        $CurArrMRUKey -match '^HKU\:'
                                    )
                                    {
                                        $CurArrMRUUser = $CurArrMRUKey -replace ('^HKU\:\\','') -split ('\\',2) | Select-Object -First 1

                                        If
                                        (
                                            $CurArrMRUUser -match '^S-1'
                                        )
                                        {
                                            $CurArrMRUFullName = Convert-SID2UserName -SID $CurArrMRUUser -ErrorAction SilentlyContinue

                                            If
                                            (
                                                $CurArrMRUFullName -match '^oops'
                                            )
                                            {
                                                $CurArrMRUFullName = ''
                                            }
                                        }
                                        Else
                                        {
                                            $CurArrMRUFullName = $CurArrMRUUser
                                        }
                                    }
                                    Else
                                    {
                                        $CurArrMRUUser = ''
                                        $CurArrMRUFullName = ''
                                    }

                                    $CurArrMRUKeyIdentifer = $CurArrMRUKey | Split-Path -leaf
                                #endregion


                                #region Pull Reg Values
                                    $CurArrMRUKeyPropList = Get-ChildItem -Path $CurArrMRUKey -ErrorAction SilentlyContinue | ForEach-Object `
                                                            -Process `
                                                            {
                                                                $($_ | Get-ItemProperty).psobject.properties | Where-Object -FilterScript { $_.'TypeNameOfValue' -eq 'System.Byte[]' } | Select-Object -Property Value
                                                            }
                                #endregion

                                #region Parse Reg Values
                                    If
                                    (
                                        $CurArrMRUKeyPropList
                                    )
                                    {
                                        $CurArrMRUKeyPropList | ForEach-Object `
                                        -Process `
                                        {
                                            $CurMRUKeyPropList = $_.Value

                                            If
                                            (
                                                $CurMRUKeyPropList.GetType().Name -eq 'String'
                                            )
                                            {
                                                $CurConvertedString = $CurMRUKeyPropList
                                                $CurConvertedType = 'String'
                                            }
                                            Else
                                            {
                                                $CurConvertedString = $(DecryptRegBinary -Value $CurMRUKeyPropList).trim()
                                                $CurConvertedType = 'Binary'
                                            }


                                            $ArrMRUKeyValues += New-Object -TypeName PSObject -Property @{
                                                'RegPath' = $($CurArrMRUKey.Replace($($CurArrMRUKey | Split-Path -Qualifier),$CurArrMRU.RegPrefix))
                                                'User' = $CurArrMRUUser
                                                'FullUserName' = $CurArrMRUFullName
                                                'KeyIdentifier' = $CurArrMRUKeyIdentifer
                                                'Value' = $CurConvertedString
                                                'OriginalType' = $CurConvertedType
                                            }
                                        }
                                    }
                                #endregion

                            }
                        }
                    }
                #endregion

                #region Report back values
                    $ArrAllValues += $ArrMRUKeyValues
                #endregion
            }
        #endregion

        #region Check Loaded Profiles
            If
            (
                $ArrAllValues
            )
            {
                $HashReturn.MRUActivityView = @{
                    status = $true
                    comment = ""
                    timestamp =  $(New-TimeStamp)
                }
            }
            Else
            {
                $HashReturn.MRUActivityView = @{
                    status = $false
                    comment = ""
                    timestamp =  $(New-TimeStamp)
                }

                Return $HashReturn
            }
        #endregion

        #region Parse All Values for File Information
            If
            (
                $ArrAllValues
            )
            {
                $ArrAllValues | ForEach-Object `
                -Process `
                {
                    $CurAllValue = $_

                    If
                    (
                        $CurAllValue.OriginalType -eq 'String'
                    )
                    {
                        If
                        (
                            $($CurAllValue.Value -split '^*\.(.{1,3}\s)' | Select-Object -Skip 1 -First 1)
                        )
                        {
                            $CurAllValueName = $('{0}.{1}' -f $($CurAllValue.Value -split '^*\.(.{1,3}\s)' | Select-Object -First 1),$($CurAllValue.Value -split '^*\.(.{1,3}\s)' | Select-Object -Skip 1 -First 1) -replace ' ','')
                            $_ | Add-Member -MemberType NoteProperty -Name 'Name' -Value $CurAllValueName -Force
                        }
                        Else
                        {
                            $CurAllValueName = $('{0}.{1}' -f $($CurAllValue.Value -split '^*\.(.{1,3})' | Select-Object -First 1),$($CurAllValue.Value -split '^*\.(.{1,3})' | Select-Object -Skip 1 -First 1) -replace ' ','')
                            $_ | Add-Member -MemberType NoteProperty -Name 'Name' -Value $CurAllValueName -Force
                        }
                    }
                    Else
                    {
                        $CurAllValueName = $CurAllValue.Value -split ([char]0,2) | Select-Object -First 1
                        $_ | Add-Member -MemberType NoteProperty -Name 'Name' -Value $CurAllValueName -Force

                        $_ | Add-Member -MemberType NoteProperty -Name 'Value' -Value $($($CurAllValue.Value | Out-String) -replace '[\u0000-\u0020]+', ' ') -Force
                    }
                }
            }
        #endregion

        #region Output
            $OutPutInfo = $ArrAllValues | Where-Object -FilterScript { $_.Value -ne $([char]0) -and $_.Value -ne $([char]1) -and $_.Value -ne $([char]1) -and $_.Value -ne $([char]28) -and $_.Value -ne $null -and $_.Value -ne '' -and $_.Value -ne ' '}

            If
            (
                $ReturnObject
            )
            {
                Return $OutPutInfo
            }
            Else
            {
                $HashReturn.MRUActivityView.MRUs = $OutPutInfo
                $HashReturn.MRUActivityView.MRUsTotal = $($OutPutInfo.Count)

                Return $HashReturn
            }
        #endregion
    }
#endregion Get-BluGenieMRUActivityView (Function)