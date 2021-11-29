#region Get-BluGenieRegSnapshot (Function)
    function Get-BluGenieRegSnapshot
    {
    <#
        .SYNOPSIS
            Get-BluGenieRegSnapshot takes a snapshot of the Registry

        .DESCRIPTION
            Get-BluGenieRegSnapshot takes a snapshot of the Registry

            .PARAMETER Path
            The path to the parent registry key

            <Type>String<Type>

        .PARAMETER Walkthrough
            An automated process to walk through the current function and all the parameters

            <Type>SwitchParameter<Type>

        .PARAMETER ReturnObject
            Return information as an Object.
            By default the data is returned as a Hash Table

            <Type>SwitchParameter<Type>

        .PARAMETER LeaveFile
            Do not remove snapshot file.
            By default the data is saved has a GUID in the users temp directory

            <Type>SwitchParameter<Type>

        .PARAMETER OutUnEscapedJSON
            Removed UnEsacped Char from the JSON Return.
            This will beautify json and clean up the formatting.

            <Type>SwitchParameter<Type>

        .EXAMPLE
            Get-BluGenieRegSnapshot -Path 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa'

            This will take a Registry Snapshot of the path 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa'
            and return a Hash Table with all the information

        .EXAMPLE
            Get-BluGenieRegSnapshot -Path 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa' -ReturnObject

            This will take a Registry Snapshot of the path 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa'
            and return just the Object content

        .EXAMPLE
            Get-BluGenieRegSnapshot -Path 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa' -LeaveFile

            This will take a Registry Snapshot of the path 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa'

            The temp snapshot file will be removed from the users temp directory.  The file is saved with a guid value

        .EXAMPLE
            Get-BluGenieRegSnapshot -Path 'HKEY_CURRENT_USER\Software\7-Zip'

            Any values that match HKEY_CURRENT_USER will be convert to HKU keys and all loaded registry hives will be enumerated and
            parsed.  A Registry Snapshot of the path will be taken for each loaded hive that has the key path.

        .EXAMPLE
            Get-BluGenieRegSnapshot -Path 'HKEY_CURRENT_USER\Software\7-Zip' -OutUnEscapedJSON

            Any values that match HKEY_CURRENT_USER will be convert to HKU keys and all loaded registry hives will be enumerated and
            parsed.  A Registry Snapshot of the path will be taken for each loaded hive that has the key path.

            The return will be a beautified json format

        .OUTPUTS
            System.Collections.Hashtable

        .NOTES

            * Original Author           : Michael Arroyo
            * Original Build Version    : 1904.1501
            * Latest Author             :
            * Latest Build Version      :
            * Comments                  :
            * Dependencies              :
                                            ~
            * Build Version Details     :
                                            ~ 1904.1501: * [Michael Arroyo] Posted
    #>
        [Alias('Get-RegSnapshot')]
        Param
        (
            [Parameter(Position=0)]
            [String]$Path,

            [Parameter(Position=1)]
            [Alias('Help')]
            [Switch]$Walkthrough,

            [Parameter(Position=2)]
            [Switch]$ReturnObject,

            [Parameter(Position=3)]
            [Switch]$LeaveFile,

            [Parameter(Position=4)]
            [Switch]$OutUnEscapedJSON
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
            $HashReturn.RegistrySnapshot = @{}
        #endregion

        #region Parameter Set Results
            $HashReturn.RegistrySnapshot.ParameterSetResults = @{
                Path = $Path
                ReturnObject = $ReturnObject
                LeaveFile = $LeaveFile
            }
        #endregion

        #region Path Check
            If
            (
                -Not $Path
            )
            {
                Return
            }
        #endregion

        #region Tool Check
            $Error.Clear()
            $RegTool = $('{0}\System32\Reg.exe' -f $env:windir)

            If
            (
                -Not $(Get-Item -Path $RegTool -ErrorAction SilentlyContinue)
            )
            {
                $HashReturn.RegistrySnapshot.ToolCheck = @{
                    'Status' = $false
                    'Comment' = 'Could not find file.'
                    'TimeStamp' = $(New-TimeStamp)
                    'Error' = $Error.exception.ToString()
                }

                Return $HashReturn
            }
            Else
            {
                $HashReturn.RegistrySnapshot.ToolCheck = @{
                    'Status' = $true
                    'Comment' = $null
                    'TimeStamp' = $(New-TimeStamp)
                    'Error' = $null
                }
            }
        #endregion

        #region IsHKCU Check
            If
            (
                $Path -Match 'HKEY_CURRENT_USER'
            )
            {
                $HashReturn.RegistrySnapshot.IsHKCUResults = @{
                    'Status' = $true
                    'Comment' = $null
                    'TimeStamp' = $(New-TimeStamp)
                    'Error' = $null
                }
            }
            Else
            {
                $HashReturn.RegistrySnapshot.IsHKCUResults = @{
                    'Status' = $false
                    'Comment' = $null
                    'TimeStamp' = $(New-TimeStamp)
                    'Error' = $null
                }
            }
        #endregion

        #region Export Reg Snapshot
            $Error.Clear()
            If
            (
                $($HashReturn.RegistrySnapshot.IsHKCUResults.Status -eq $false)
            )
            {
                $SnapFile = $('{0}\Temp\{1}' -f $env:windir, $(New-UID -ErrorAction SilentlyContinue))

                Try
                {
                    Start-Process -FilePath $RegTool -ArgumentList $('Export "{0}" "{1}" /y' -f $Path, $SnapFile) -Wait -WindowStyle Hidden -ErrorAction Stop
                    Start-Sleep -Seconds 2
                    $RegSnapContent = Get-Content -Path $SnapFile -ErrorAction Stop | Out-String
                    $HashReturn.RegistrySnapshot.Snapshot = @{
                        'Status' = $true
                        'Value' = $RegSnapContent
                        'TimeStamp' = $(New-TimeStamp)
                        'Error' = $null
                    }
                }
                Catch
                {
                    $HashReturn.RegistrySnapshot.Snapshot = @{
                        'Status' = $false
                        'Comment' = 'Could not load snapshot data'
                        'TimeStamp' = $(New-TimeStamp)
                        'Error' = $($Error.exception | Out-String).Trim()
                    }
                }

                If
                (
                    -Not $LeaveFile
                )
                {
                    If
                    (
                        $($HashReturn.RegistrySnapshot.Snapshot.Status -eq $true)
                    )
                    {
                        If
                        (
                            -Not $(Get-Item -Path $SnapFile -ErrorAction SilentlyContinue | Select-Object -ExpandProperty PSIsContainer)
                        )
                        {
                            $null = Remove-Item -Path $SnapFile -Force -ErrorAction SilentlyContinue
                        }
                    }
                }
            }
            Else
            {
                $LoadedHives = Get-LoadedRegHives -ReturnObject -ErrorAction SilentlyContinue
                $HashReturn.RegistrySnapshot.Snapshot = @{}
                $LoadedHives | ForEach-Object `
                -Process `
                {
                    $Error.Clear()
                    $CurHive = $_
                    $CurSnapFile = $('{0}\Temp\{1}' -f $env:windir, $(New-UID -ErrorAction SilentlyContinue))
                    $CurPath = $Path -replace ('HKEY_CURRENT_USER',$CurHive.UserHive)

                    Try
                    {
                        Start-Process -FilePath $RegTool -ArgumentList $('Export "{0}" "{1}" /y' -f $CurPath, $CurSnapFile) -Wait -WindowStyle Hidden -ErrorAction Stop
                        $CurRegSnapContent = Get-Content -Path $CurSnapFile -ErrorAction Stop | Out-String
                        $CurHive | Add-Member -MemberType NoteProperty -Name 'Status' -Value $true -Force -ErrorAction SilentlyContinue
                        $CurHive | Add-Member -MemberType NoteProperty -Name 'Value' -Value $CurRegSnapContent.ToString() -Force -ErrorAction SilentlyContinue
                        $CurHive | Add-Member -MemberType NoteProperty -Name 'TimeStamp' -Value $(New-TimeStamp) -Force -ErrorAction SilentlyContinue
                        $CurHive | Add-Member -MemberType NoteProperty -Name 'Error' -Value $null -Force -ErrorAction SilentlyContinue
                    }
                    Catch
                    {
                        $CurHive | Add-Member -MemberType NoteProperty -Name 'Status' -Value $false -Force -ErrorAction SilentlyContinue
                        $CurHive | Add-Member -MemberType NoteProperty -Name 'Value' -Value 'Could not load snapshot data' -Force -ErrorAction SilentlyContinue
                        $CurHive | Add-Member -MemberType NoteProperty -Name 'TimeStamp' -Value $(New-TimeStamp) -Force -ErrorAction SilentlyContinue
                        $CurHive | Add-Member -MemberType NoteProperty -Name 'Error' -Value $($Error.exception | Out-String).Trim() -Force -ErrorAction SilentlyContinue
                    }

                    If
                    (
                        -Not $LeaveFile
                    )
                    {
                        If
                        (
                            $HashReturn.RegistrySnapshot.Snapshot.$($CurHive.UserName).Status
                        )
                        {
                            If
                            (
                                -Not $(Get-Item -Path $CurSnapFile -ErrorAction SilentlyContinue | Select-Object -ExpandProperty PSIsContainer)
                            )
                            {
                                $null = Remove-Item -Path $CurSnapFile -Force -ErrorAction SilentlyContinue
                            }
                        }
                    }
                }
            }

        #endregion

        #region Output
            If
            (
                $ReturnObject
            )
            {
                If
                (
                    $($HashReturn.RegistrySnapshot.IsHKCUResults.Status -eq $true)
                )
                {
                    $LoadedHives
                }
                Else
                {
                    $RegSnapContent
                }
            }
            Else
            {
                If
                (
                    $($HashReturn.RegistrySnapshot.IsHKCUResults.Status -eq $true)
                )
                {
                    $HashReturn.RegistrySnapshot.Snapshot = $LoadedHives
                }

                If
                (
                    -Not $OutUnEscapedJSON
                )
                {
                    Return $HashReturn
                }
                Else
                {
                    Return $($HashReturn | ConvertTo-Json -Depth 50 | ForEach-Object `
                    -Process `
                    {
                        [regex]::Unescape($_) 
                    })
                }
            }
        #endregion
    }
#endregion Get-BluGenieRegSnapshot (Function)