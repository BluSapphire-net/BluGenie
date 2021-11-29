#region Set-BluGenieAuditProcessPol (Function)
    function Set-BluGenieAuditProcessPol
    {
    <#
        .SYNOPSIS
            Enable or Disable Audit Process Tracking

        .DESCRIPTION
            Enable or Disable Audit Process Tracking

        .PARAMETER ReturnObject
            Return information as an Object.
            By default the data is returned as a Hash Table

            <Type>SwitchParameter<Type>

        .PARAMETER ViewOnly
            View the current settings only.  Do not process an update.
            By default the data is returned as a Hash Table

            <Type>SwitchParameter<Type>

        .PARAMETER Status
            Set the Prefetch process status.
            The acceptable values for this parameter are:

            - Enable = (Default) : Enable Audit Process Tracking
            - Disable            : Disable Audit Process Tracking

            If no value is specified, or if the parameter is omitted, the default value is (Enable).

            <Type>ValidateSet<Type>
            <ValidateSet>Enable,Disable<ValidateSet>

        .EXAMPLE
            Set-BluGenieAuditProcessPol

            This will enable Auditing for Process Creation and Process Exits
            The returned data will be a Hash Table

        .EXAMPLE
            Set-BluGenieAuditProcessPol -ViewOnly

            This will display the current status of the Audit policy for Process Tracking.
            Note:  This will not change any settings.

        .EXAMPLE
            Set-BluGenieAuditProcessPol -ReturnObject

            This will enable Auditing for Process Creation and Process Exits

            The returned data will be an Object

        .EXAMPLE
            Set-BluGenieAuditProcessPol -Status Disable

            This will disable Auditing for Process Creation and Process Exits

        .OUTPUTS
            TypeName: System.Collections.Hashtable

        .NOTES

            * Original Author           : Michael Arroyo
            * Original Build Version    : 1903.2801
            * Latest Author             :
            * Latest Build Version      :
            * Comments                  :
            * Dependencies              :
                                            ~
            * Build Version Details     :
                                            ~ 1903.2801: * [Michael Arroyo] Posted
    #>
        [Alias('Set-AuditProcessPol')]
        Param
        (
            [Parameter(Position=0)]
            [Switch]$ReturnObject,

            [Parameter(Position=1)]
            [ValidateSet("Enable", "Disable")]
            [string]$Status = "Enable",

            [Parameter(Position = 2)]
            [switch]$ViewOnly,

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
            $HashReturn.AuditProcessPol = @{}
        #endregion

        #region Parameter Set Results
            $HashReturn.AuditProcessPol.ParameterSetResults = @{
                Status = $Status
                ReturnObject = $ReturnObject
                ViewOnly = $ViewOnly
            }
        #endregion

        #region Enable / Disable Audit Policy
            If
            (
                -Not $ViewOnly
            )
            {
                $Error.Clear()
                Switch
                (
                    $Status
                )
                {
                    'Enable'
                    {
                        $null = Invoke-Expression -Command $('{0}\System32\Auditpol.exe /set /category:"Detailed Tracking" /subcategory:"Process Creation" /success:enable /failure:enable' -f $env:windir) -ErrorAction SilentlyContinue
                        $null = Invoke-Expression -Command $('{0}\System32\Auditpol.exe /set /category:"Detailed Tracking" /subcategory:"Process Termination" /success:enable /failure:enable' -f $env:windir) -ErrorAction SilentlyContinue
                    }
                    'Disable'
                    {
                        $null = Invoke-Expression -Command $('{0}\System32\Auditpol.exe /set /category:"Detailed Tracking" /subcategory:"Process Creation" /success:disable /failure:disable' -f $env:windir) -ErrorAction SilentlyContinue
                        $null = Invoke-Expression -Command $('{0}\System32\Auditpol.exe /set /category:"Detailed Tracking" /subcategory:"Process Termination" /success:disable /failure:disable' -f $env:windir) -ErrorAction SilentlyContinue
                    }
                }
            }
        #endregion

        #region Query Auditpol information
            $ObjAuditPol = New-Object -TypeName System.Object
            $($(Invoke-Expression -Command $('{0}\System32\Auditpol.exe /get /category:"Detailed Tracking"' -f $env:windir)) -Split ('\n') -match ('\s\s')) -match 'Process' | ForEach-Object `
            -Process `
            {
                $CurString = $_
                $CurStringUpdate = $CurString.Trim() -split '\s\s.*\s\s'
                Try
                {
                    $ObjAuditPol | Add-Member -MemberType NoteProperty -Name $($CurStringUpdate[0].Trim() -replace ' ','') -Value $CurStringUpdate[1]
                }
                Catch
                {
                }
            }
            $HashReturn.AuditProcessPol.AuditPolicyInfo = $ObjAuditPol
        #endregion

        #region Audit Error Check
            If
            (
                -Not $ViewOnly
            )
            {
                Switch
                (
                    $Status
                )
                {
                    'Enable'
                    {
                        $CheckValue = 'Success and Failure'
                    }
                    'Disable'
                    {
                        $CheckValue = 'No Auditing'
                    }
                }

                If
                (
                    $($CheckValue -eq $ObjAuditPol.ProcessCreation) -and $($CheckValue -eq $ObjAuditPol.ProcessTermination)
                )
                {
                    $HashReturn.AuditProcessPol.ProcessingResults = @{
                        'Status' = $true
                        'Comment' = ''
                        'TimeStamp' = $(New-TimeStamp)
                        'Error' = ''
                    }
                }
                Else
                {
                    $HashReturn.AuditProcessPol.ProcessingResults = @{
                        'Status' = $false
                        'Comment' = 'Processing Command and Audit Policy Settings do not match.'
                        'TimeStamp' = $(New-TimeStamp)
                        'Error' = $($Error.Exception | Out-String)
                    }

                    Return $HashReturn
                }
            }
        #endregion

        #region Output
            If
            (
                $ReturnObject
            )
            {
                $ObjAuditPol
            }
            Else
            {
                Return $HashReturn
            }
        #endregion
    }
#endregion Set-BluGenieAuditProcessPol (Function)