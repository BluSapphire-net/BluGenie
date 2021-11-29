#region Get-BluGenieFileSnapshot (Function)
    function Get-BluGenieFileSnapshot
    {
    <#
        .SYNOPSIS
            Get-BluGenieFileSnapshot takes a snapshot of the requested direcotry path

        .DESCRIPTION
            Get-BluGenieFileSnapshot takes a snapshot of the requested direcotry path.  This can be the parent directory and / or a recursive sub directory snapshot.

            .PARAMETER Path
            The path to the parent directory

            If you specify "Temp" in the begining of the Path field all the %SystemDrive%\Users\* Temp directories will be prefixed to the rest of the path and a snapshot will be taken for each Path
            If you specify "AllUsers" in the begining of the Path field, all the User Profiles directories from %SystemDrive%\Users will be prefixed to the rest of the path and a snapshot will be taken for each Path

                Example:  -Path 'AllUsers\AppData\Roaming'

                Output:   C:\Users\Administrator\AppData\Roaming
                            C:\Users\User1\AppData\Roaming
                            C:\Users\User2\AppData\Roaming
                            C:\Users\User3\AppData\Roaming
                            C:\Users\User4\AppData\Roaming

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
            By default the data is saved as a GUID in the system temp directory

            <Type>SwitchParameter<Type>

        .PARAMETER OutUnEscapedJSON
            Removed UnEsacped Char from the JSON Return.
            This will beautify json and clean up the formatting.

            <Type>SwitchParameter<Type>

        .PARAMETER Recurse
            Recurse through subdirectories

            <Type>SwitchParameter<Type>

        .EXAMPLE
            Get-BluGenieFileSnapshot

            This will output nothing.  If the Path is empty the command will Return $Null

        .EXAMPLE
            Get-BluGenieFileSnapshot -Path 'C:\Windows\System32\Temp'

            This will only take a file and directory Snapshot of the root directory defined 'C:\Windows\System32\Temp'

        .EXAMPLE
            Get-BluGenieFileSnapshot -Path 'C:\Windows\System32\Temp' -Recurse

            This will take a file and directory Snapshot of the root directory and all sub dictories for the path defined 'C:\Windows\System32\Temp'

        .EXAMPLE
            Get-BluGenieFileSnapshot -Path 'C:\Windows\System32\Temp' -ReturnObject

            This will only take a file and directory Snapshot of the root directory defined 'C:\Windows\System32\Temp'
            and return just the Object content

            Note:  The default output is a HashTable

        .EXAMPLE
            Get-BluGenieFileSnapshot -Path 'C:\Windows\System32\Temp' -LeaveFile

            This will only take a file and directory Snapshot of the root directory defined 'C:\Windows\System32\Temp'

            The file is saved by default to the %WinDir%\Temp directory, the fil ename is saved as a GUID with no ext.

        .EXAMPLE
            Get-BluGenieFileSnapshot -Path 'AllUsers\Desktop'

            This will take a file and directory Snapshot of the each users Desktop direcotory

        .EXAMPLE
            Get-BluGenieFileSnapshot -Path 'Temp' -Recurse

            This will take a file and directory Snapshot of the each users Temp direcotory and snapshot all sub files and directories as well.

        .EXAMPLE
            Get-BluGenieFileSnapshot -Path 'C:\Windows\System32\Temp' -OutUnEscapedJSON

            This will only take a file and directory Snapshot of the root directory defined 'C:\Windows\System32\Temp'

            The return data will be in a beautified json format

        .OUTPUTS
            System.Collections.Hashtable

        .NOTES

            * Original Author           : Michael Arroyo
            * Original Build Version    : 1904.2201
            * Latest Author             :
            * Latest Build Version      :
            * Comments                  :
            * Dependencies              :
                                            ~
            * Build Version Details     :
                                            ~ 1904.2201: * [Michael Arroyo] Posted
    #>
        [Alias('Get-FileSnapshot')]
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
            [Switch]$OutUnEscapedJSON,

            [Parameter(Position=4)]
            [Switch]$Recurse
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
            $HashReturn.FileSnapshot = @{}
        #endregion

        #region Parameter Set Results
            $HashReturn.FileSnapshot.ParameterSetResults = @{
                Path = $Path
                ReturnObject = $ReturnObject
                LeaveFile = $LeaveFile
                OutUnEscapedJSON = $OutUnEscapedJSON
                Recurse = $Recurse
            }
        #endregion

        #region Path Check
            Switch
            (
                $Path
            )
            {
                {$_ -eq ''}
                {
                    Return
                }
                {$_ -match '^Temp'}
                {
                    $SnapShotInfo = @()
                    $UserPaths = Get-ChildItem -Path "$env:SystemDrive\Users" -Force -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.'Attributes' -eq 'Directory' } | Select-Object -Property `
                        BaseName,
                        @{Name='FullName';Expression={$('{0}\AppData\Local\Temp' -f $_.FullName,$_.BaseName)}} | ForEach-Object `
                        -Process `
                        {
                            $SnapShotInfo += New-Object -TypeName PSObject -Property @{
                                'User' = $_.BaseName
                                'Path' = $($Path -replace ('Temp',$($_.FullName)))
                                'Leave' = $False
                                'ExportPath' = $null
                                'SnapShot' = $null
                            }
                        }
                }
                {$_ -match '^AllUsers'}
                {
                    $SnapShotInfo = @()
                    $UserPaths = Get-ChildItem -Path "$env:SystemDrive\Users" -Force -ErrorAction SilentlyContinue | Where-Object -FilterScript { $_.'Attributes' -eq 'Directory' } | ForEach-Object `
                    -Process `
                    {
                        $SnapShotInfo += New-Object -TypeName PSObject -Property @{
                            'User' = $_.BaseName
                            'Path' = $($Path -replace ('AllUsers',$($_.FullName)))
                            'Leave' = $False
                            'ExportPath' = $null
                            'SnapShot' = $null
                        }
                    }
                }
                Default
                {
                    $SnapShotInfo = New-Object -TypeName PSObject -Property @{
                            'User' = $null
                            'Path' = $Path
                            'Leave' = $False
                            'ExportPath' = $null
                            'SnapShot' = $null
                        }
                }
            }
        #endregion

        #region Take File Snapshot
            $SnapShotInfo | ForEach-Object `
            -Process `
            {
                $CurSnapshot = $_
                If
                (
                    $Recurse
                )
                {
                    $CurSnapshot.Snapshot = Get-ChildItem -Path $CurSnapshot.Path -Recurse -ErrorAction SilentlyContinue | Select-Object Mode, LastWriteTime, Length, FullName | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1
                }
                Else
                {
                    $CurSnapshot.Snapshot = Get-ChildItem -Path $CurSnapshot.Path -ErrorAction SilentlyContinue | Select-Object Mode, LastWriteTime, Length, FullName | ConvertTo-Csv -NoTypeInformation | Select-Object -Skip 1
                }

                If
                (
                    $CurSnapshot.Snapshot -eq $null
                )
                {
                    $CurSnapshot.Snapshot = 'Path or Data not found, No Snapshot captured'
                }
            }
        #endregion

        #region Leave File Snapshot
            $Error.Clear()

            If
            (
                $LeaveFile
            )
            {
                $SnapShotInfo | ForEach-Object `
                -Process `
                {
                    $CurSnapshotItem = $_
                    $CurSnapshotItem.Leave = $true

                    If
                    (
                        $CurSnapshotItem.Snapshot -notmatch 'Path or Data not found, No Snapshot captured'
                    )
                    {
                        $SnapFile = $('{0}\Temp\{1}' -f $env:windir, $(New-UID -ErrorAction SilentlyContinue))

                        $Error.Clear()
                        Try
                        {
                            $CurSnapshotItem.SnapShot | Out-File -FilePath $SnapFile -Force -ErrorAction Stop
                            $CurSnapshotItem.ExportPath = $SnapFile
                        }
                        Catch
                        {
                            $CurSnapshotItem.ExportPath = $Error.exception.ToString()
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
                $SnapShotInfo
            }
            Else
            {
                $HashReturn.FileSnapshot.TimeStamp = New-TimeStamp
                $HashReturn.FileSnapshot.SnapshotInfo = $SnapShotInfo

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
#endregion Get-BluGenieFileSnapshot (Function)