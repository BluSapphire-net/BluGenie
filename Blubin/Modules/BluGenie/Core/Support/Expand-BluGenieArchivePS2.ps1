#region Expand-BluGenieArchivePS2 (Function)
    function Expand-BluGenieArchivePS2
    {
        <#
            .SYNOPSIS
                Expand-BluGenieArchivePS2 Extracts files from a specified archive (zipped) file.

            .DESCRIPTION
                Expand-BluGenieArchivePS2 is a PowerShell 2.0 version of Expand-Archive which extracts files from a specified archive (zipped) file.

            .PARAMETER Path
                The .Zip file source path

                <Type>String<Type>

            .PARAMETER Destination
                The Destination path

                <Type>String<Type>

            .PARAMETER NoProgressBar
                Do not show an active progress bar

                <Type>SwitchParameter<Type>

            .PARAMETER Force
                Forces the file overwrite

                <Type>SwitchParameter<Type>

            .PARAMETER ProgressOnly
                Only show the progress bar, do not show the extracted content.

                <Type>SwitchParameter<Type>

            .PARAMETER NoErrorMsg
                Do not show any pop up error messages to the screen

                <Type>SwitchParameter<Type>

            .PARAMETER Walkthrough
                An automated process to walk through the current function and all the parameters

                <Type>SwitchParameter<Type>

            .PARAMETER ReturnObject
                Return information as an Object.
                By default the data is returned as a Hash Table

                <Type>SwitchParameter<Type>

            .PARAMETER OutUnEscapedJSON
                Removed UnEsacped Char from the JSON Return.
                This will beautify json and clean up the formatting.

                <Type>SwitchParameter<Type>

            .EXAMPLE
                Expand-BluGenieArchivePS2 -Path C:\Source\SysinternalsSuite.zip -Destination C:\Source\SysinternalsSuite

                This will extact the zip files contents to the destination directory.  If the directory doesn't exist it will be created on the fly.
                ~ By default this will not overwrite any files 
                ~ A progress bar is displayed showing the current activities, including what file is currently being extracted.

            .EXAMPLE
                Expand-BluGenieArchivePS2 -Path C:\Source\SysinternalsSuite.zip -Destination C:\Source\SysinternalsSuite -ProgressOnly

                This will extact the zip files contents to the destination directory.  If the directory doesn't exist it will be created on the fly.
                ~ By default this will not overwrite any files 
                ~ A progress bar is displayed showing the current activities.  However all file names are hidden from view.  Only the overall progress is shown.

             .EXAMPLE
                Expand-BluGenieArchivePS2 -Path C:\Source\SysinternalsSuite.zip -Destination C:\Source\SysinternalsSuite -NoProgressBar -NoErrorMsg -Force

                This will extact the zip files contents to the destination directory.  If the directory doesn't exist it will be created on the fly.
                ~ All extracted content with the same name as the destination direcotry content will be overwritten 
                ~ All progress information including error messages will be hidden

            .EXAMPLE
                Expand-BluGenieArchivePS2 -Path C:\Source\SysinternalsSuite.zip -Destination C:\Source\SysinternalsSuite -NoProgressBar -NoErrorMsg -Force -ReturnObject

                This will extact the zip files contents to the destination directory.  If the directory doesn't exist it will be created on the fly.
                ~ All extracted content with the same name as the destination direcotry content will be overwritten 
                ~ All progress information including error messages will be hidden
                ~ The Return data will be in an Object format.  $true / $false  

            .EXAMPLE
                Expand-BluGenieArchivePS2 -Path C:\Source\SysinternalsSuite.zip -Destination C:\Source\SysinternalsSuite -NoProgressBar -NoErrorMsg -Force -OutUnEscapedJSON

                This will extact the zip files contents to the destination directory.  If the directory doesn't exist it will be created on the fly.
                ~ All extracted content with the same name as the destination direcotry content will be overwritten 
                ~ All progress information including error messages will be hidden
                ~ The Return data will be in a beautified json format 

            .OUTPUTS
                System.Collections.Hashtable

            .NOTES

                * Original Author           : Michael Arroyo
                * Original Build Version    : 1905.1601
                * Latest Author             : Michael Arroyo
                * Latest Build Version      : 21.06.2501
                * Comments                  :
                * Dependencies              :
                                                ~
                * Build Version Details     :
                    ~ 1905.1601: * [Michael Arroyo] Posted
                    ~ 21.06.2501:* [Michael Arroyo] Fixed parameter $NoErrorMsg in the (Set Extraction Flags) region.
                                    It was not set as it should so when calling it the parameter would cause a process failure.
        #>
        [Alias('Expand-ArchivePS2')]
        Param
        (
            [Parameter(Position = 1)]
            [String]$Path,

            [Parameter(Position = 2)]
            [String]$Destination,

            [Parameter(Position = 3)]
            [Switch]$NoProgressBar,

            [Parameter(Position = 4)]
            [Switch]$Force,

            [Parameter(Position = 5)]
            [Switch]$ProgressOnly,

            [Parameter(Position = 6)]
            [Switch]$NoErrorMsg,

            [Parameter(Position = 7)]
            [Alias('Help')]
            [Switch]$Walkthrough,

            [Parameter(Position = 8)]
            [Switch]$ReturnObject,

            [Parameter(Position = 9)]
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
            $HashReturn = @{ }
            $HashReturn.ExpandArchivePS2 = @{ }
            $HashReturn.ExpandArchivePS2.TimeStamp = $(New-TimeStamp -ErrorAction SilentlyContinue)
        #endregion Create Hash

        #region Parameter Set Results
            $HashReturn.ExpandArchivePS2.ParameterSetResults = $PSBoundParameters
        #endregion Parameter Set Results

        #region Parameter Check
            $Error.Clear()
            Switch
            (
                $null
            )
            {
                {-Not $Path}
                {
                    Write-Error -Message 'No Path specified' -ErrorAction SilentlyContinue
                    $HashReturn.ExpandArchivePS2.ParameterCheck = @{
                        'Parameter' = 'Path'
                        'Status'    = $false
                        'TimeStamp' = $(New-TimeStamp -ErrorAction SilentlyContinue)
                        'Error'     = $($Error.Exception | out-string).trim()
                    }
                    Break
                }
                {$Destination -eq $null}
                {
                    Write-Error -Message 'No Destination information specified' -ErrorAction SilentlyContinue
                    $HashReturn.ExpandArchivePS2.ParameterCheck = @{
                        'Parameter' = 'Destination'
                        'Status'    = $false
                        'TimeStamp' = $(New-TimeStamp -ErrorAction SilentlyContinue)
                        'Error'     = $($Error.Exception | out-string).trim()
                    }
                    Break
                }
            }

            if
            (
                $Error
            )
            {
                #region Output
                    If
                    (
                        $ReturnObject
                    )
                    {
                        Return New-Object -TypeName PSObject -Property $($HashReturn.ExpandArchivePS2.ParameterCheck)
                    }
                    Else
                    {
                        If
                        (
                            -Not $OutUnEscapedJSON
                        )
                        {
                            Return $HashReturn
                        }
                        Else
                        {
                            Return $($HashReturn | ConvertTo-Json -Depth 10 | ForEach-Object -Process { [regex]::Unescape($_) })
                        }
                    }
                #endregion Output
            }
        #endregion Parameter Check

        #region Create Destination
            If
            (
                -Not $(Test-Path -Path $Destination -ErrorAction SilentlyContinue)
            )
            {
                $null = New-Item -Path $Destination -ItemType Directory -Force -ErrorAction SilentlyContinue
            }
        #endregion Create Destination

        #region Flag Start Time for Extraction
            $HashReturn.ExpandArchivePS2.StartExtractTime = $(New-TimeStamp -ErrorAction SilentlyContinue)
        #endregion Flag Start Time for Extraction

        #region Set Extraction Flags
            [Int]$CopyFlags = 0
            Switch
            (
                $null
            )
            {
                #4: Do not display a progress dialog box.
                {$NoProgressBar -eq $true}
                {$CopyFlags += 4}

                #16: Click "Yes to All" in any dialog box that is displayed.
                {$Force -eq $true}
                {$CopyFlags += 16}

                #256: Display a progress dialog box but do not show the file names
                {$ProgressOnly -eq $true}
                {$CopyFlags += 256}

                #1024: Do not display a user interface if an error occurs
                {$NoErrorMsg -eq $true}
                {$CopyFlags += 1024}
            }
        #endregion Set Extraction Flags

        #region Extract Content
            $Shell = New-Object -ComObject shell.application
            $Zip = $Shell.NameSpace($Path)
            $DestinationPath = $Shell.NameSpace($Destination)

            $Error.Clear()

            Try
            {
                $DestinationPath.CopyHere($Zip.Items(),$CopyFlags)
                $HashReturn.ExpandArchivePS2.Status = $true
            }
            Catch
            {
                $HashReturn.ExpandArchivePS2.Status = $false
            }
        #endregion Extract Content

        #region Flag End Time for Extraction
            $HashReturn.ExpandArchivePS2.EndExtractTime = $(New-TimeStamp -ErrorAction SilentlyContinue)
        #endregion Flag End Time for Extraction

        #region Output
            If
            (
                $ReturnObject
            )
            {
                Return New-Object -TypeName PSObject -Property $($HashReturn.ExpandArchivePS2.Status)
            }
            Else
            {
                If
                (
                    -Not $OutUnEscapedJSON
                )
                {
                    Return $HashReturn
                }
                Else
                {
                    Return $($HashReturn | ConvertTo-Json -Depth 10 | ForEach-Object -Process { [regex]::Unescape($_) })
                }
            }
        #endregion Output
    }
#endregion Expand-BluGenieArchivePS2 (Function)