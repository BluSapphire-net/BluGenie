#region Resolve-BluGenieDnsName (Function)
    function Resolve-BluGenieDnsName
    {
    <#
        .SYNOPSIS 
            Resolve-BluGenieDnsName will validate a Domain Name and test if the system is online

        .DESCRIPTION
            Resolve-BluGenieDnsName will validate a Domain Name and test if the system is online.
            Validating a Domain Name will resolve an IP to a hostname.
            If the system is pingable the OS type will be identified as well.

        .PARAMETER ComputerName
            One or more computer names or IP Address.

            <Type>String<Type>

        .PARAMETER TestConnection
            Test if the system is pingable

            <Type>SwitchParameter<Type>

        .PARAMETER TimeToLive
            The amount of time for the connect to wait before timing out.  
            The default valie is ( 12 )

            <Type>Int<Type>

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
            Resolve-BluGenieDnsName -ComputerName 172.217.15.110 -ReturnObject -TestConnection -TimeToLive 25
    
            This will try and resolve the IP to a Domain name.  It will also see if the system is online.  The time to live is set to 25ms however the default is 12.
            The items will be returned in an object

        .EXAMPLE
            Resolve-BluGenieDnsName -ComputerName 'Test-PC1','Test-PC2','10.0.0.25','10.0.026' -ReturnObject -TestConnection
    
            This will try and resolve the IP's to a Domain name.  It will also see if all the systems are online.  The time to live is 12ms by default.
            The items will be returned in an object

        .EXAMPLE
            Resolve-BluGenieDnsName -ComputerName 'Test-PC1','Test-PC2','10.0.0.25','10.0.026' -ReturnObject
            The items will be returned in an object

        .EXAMPLE
            Resolve-BluGenieDnsName -ComputerName 10.0.0.25 -Test:$false

            This will try and resolve the IP's to a Domain name.
            There will be no action to ping the device.  (Test / TestConnection) is set to $false.  By default (Test / TestConnection ) is set to $true
            The items will be returned in a object by default

        .EXAMPLE
            Resolve-BluGenieDnsName -ComputerName 10.0.026 -OutUnEscapedJSON
            
            This will try and resolve the IP's to a Domain name.
            The items will be returned in a beautified JSON report
    
        .OUTPUTS
            System.Collections.Hashtable

        .NOTES
            
            * Original Author           : Michael Arroyo
            * Original Build Version    : 1907.1201
            * Latest Author             : Michael Arroyo
            * Latest Build Version      : 20.05.2101
            * Comments                  : 
            * Dependencies              : 
                                            ~
            * Build Version Details     : 
                                            ~ 1907.1201: * [Michael Arroyo] Posted   
                                            ~ 1907.1601: * [Michael Arroyo] Added the TTL / TimeToLive object property.  This gives more info on the connection.
                                            ~ 1908.2701: * [Michael Arroyo] Added 2nd process for TTL detection
                                                         * [Michael Arroyo] Added Routing Hop detection.  The OS can still be picked up within ( 10 ) Routing hops.  If TTL is 124 the OS is detected as Windows with a normal TTL of 128.
                                            ~ 1908.2702: * [Michael Arroyo] Added Error trapping around TTL Return
                                            ~ 20.05.2101:• [Michael Arroyo] Updated to support Posh 2.0
    #>
        [Alias('Resolve-BGDnsName','Ping')]
        Param
        (
            [Parameter(Position = 0)]
            [string[]]$ComputerName,

            [Parameter(Position=1)]
            [Alias('Test, TC')]
            [Switch]$TestConnection = $true,

            [Parameter(Position=2)]
            [Int]$TimeToLive = 12,

            [Parameter(Position=3)]
            [Switch]$ReturnObject,

            [Parameter(Position=4)]
            [Alias('Help')]
            [Switch]$Walkthrough,

            [Parameter(Position = 5)]
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
                                                        Get-Help -Name $Function -ShowWindow
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

        #region Create SystemInfo Hash Table
            $HashReturn = @{}
            $HashReturn.BgDnsName = @{}
            $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn.BgDnsName.StartTime = $($StartTime).DateTime
        #endregion

        #region Place holder for all objects
            $ArrComputers = @()
        #endregion Place holder for all objects

        #region Status Information
            $ComputerName | ForEach-Object `
            -Process `
            {
                $Computer = $_

                #region Create Object
                    $status = New-Object -TypeName PSObject -Property @{
                        'ComputerName' = $null
                        'TimeStamp'   = $('D{0}' -f $(Get-Date -f s))
                        'Results'     = $null
                        'IP'          = $null
                        'Resolved'    = $False
                        'OS'          = $null
                        'TTL'         = $null
                        'RoutingHops' = 0
                    }
                #endregion Create Object

                #region Detect if ComputerName is set to IP or Hostname
                    If
                    (
                        $Computer -match '\d+?\.\d+?\.\d+?\.\d*' #IP was used.  Convert back to hostname
                    )
                    {
                        $status.ComputerName = [net.dns]::GetHostByAddress($Computer) | Select-Object -ExpandProperty Hostname
                        $status.IP = $Computer
                    }
                    Else
                    {
                        $status.ComputerName = $Computer
                        $status.IP = [Net.Dns]::GetHostAddresses("$Computer")  |
								     Where-Object { $_.AddressFamily -eq 'InterNetwork' } |
								     Select-Object -Expand IPAddressToString
                        If
                        (
                            $status.IP.count -gt 1
                        )
                        {
                            $status.IP = $status.IP[0]
                        }
                    }
                #endregion Detect if ComputerName is set to IP or Hostname

                #region Computer Name Double Check
                    If
                    (
                        $status.ComputerName -match '\d+?\.\d+?\.\d+?\.\d*' #IP was used.
                    )
                    {
                        #do nothing
                    }
                    Else
                    {
                        If
                        (
                           $($status.ComputerName).length -gt 1
                        )
                        {
                            $status.Resolved = $true
                        }
                    }
                #endregion Computer Name Double Check
            
                #region Test Connection
                    If
                    (
                        $TestConnection
                    )
                    {
                        Try
                        {
                            $result = Test-Connection -ComputerName $Computer -Count 1 -TimeToLive $TimeToLive -ErrorAction Stop
                        }
                        Catch
                        {
                            $Error.RemoveAt(0)
                        }

                        if
                        (
                            $result
                        )
                        {
                            $status.Results = 'Up'
                            $status.IP =  $($result.IPV4Address).IPAddressToString

                            If
                            (
                                $result.ResponseTimeToLive
                            )
                            {
                                $status.TTL = $($result.ResponseTimeToLive).ToString()
                            }

                            If
                            (
                                $status.TTL -eq $null
                            )
                            {
                                Try
                                {
                                    $result = Test-Connection -ComputerName $status.IP -Count 1 -TimeToLive $TimeToLive -ErrorAction Stop
                                    $status.TTL = $($result.ResponseTimeToLive).ToString()
                                }
                                Catch
                                {
                                    $Error.RemoveAt(0)
                                }
                            }

                            #region Ranges
                                #Linux
                                $LinuxRangeLow = 54
                                $LinuxRangeHigh = 64

                                #Unix
                                $UnixRangeLow = 245
                                $UnixRangeHigh = 255

                                #Windows Older
                                $WinRangeLow = 22
                                $WinRangeHigh = 32

                                #Windows Newer
                                $WindowsRangeLow = 118
                                $WindowsRangeHigh = 128

                            #endregion Ranges

                            Switch
                            (
                                $result.ResponseTimeToLive
                            )
                            {
                                #Linux System have a Response Time To Live of 64
                                {$_ -ge $LinuxRangeLow -and $_ -le $LinuxRangeHigh}
                                {
                                    $status.OS = 'Linux'
                                    $DefaultTTL = $LinuxRangeHigh
                                    Break
                                }
                                #Unix System have a Response Time To Live of 255
                                {$_ -ge $UnixRangeLow -and $_ -le $UnixRangeHigh}
                                {
                                    $status.OS = 'Unix'
                                    $DefaultTTL = $UnixRangeHigh
                                    Break
                                }
                                #Old Windows System have a Response Time To Live of 32
                                {$_ -ge $WinRangeLow -and $_ -le $WinRangeHigh}
                                {
                                    $status.OS = 'Windows'
                                    $DefaultTTL = $WinRangeHigh
                                    Break
                                }
                                #Windows System have a Response Time To Live of 128
                                {$_ -ge $WindowsRangeLow -and $_ -le $WindowsRangeHigh}
                                {
                                    $status.OS = 'Windows'
                                    $DefaultTTL = $WindowsRangeHigh
                                    Break
                                }
                            }

                            $status.RoutingHops = $($DefaultTTL - $status.TTL)
                        }
                        else
                        {
                            $status.Results = 'Down'
                        }
                    }
                #endregion Test Connection

                $ArrComputers += $status
                Try
                {
                    $Null = Remove-Item -path Variable:\status -Force -ErrorAction Stop
                }
                Catch
                {
                    $Error.RemoveAt(0)
                }
            }
        #endregion Status Information

        #region Bind Object to HashTable
            $HashReturn.BgDnsName.Status = @( $ArrComputers )
        #endregion Bind Object to HashTable
        
        #region Output
            $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn.BgDnsName.EndTime = $($EndTime).DateTime
            $HashReturn.BgDnsName.ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

            #region Force Output
                If
                (
                    $OutUnEscapedJSON
                )
                {
                    $ReturnObject = $false
                }
                Else
                {
                    $ReturnObject = $true
                }
            #endregion Force Output

            Write-Host ''
            If
            (
                $ReturnObject
            )
            {
                Return $ArrComputers
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
        #endregion
    }
#endregion Resolve-BluGenieDnsName (Function)