#region Get-BluGenieSignature (Function)
Function Get-BluGenieSignature
{
<#
    .SYNOPSIS
        Report on the Files Authenication Signature Information

    .DESCRIPTION
        Report on the Files Authenication Signature Information

    .PARAMETER Path
        Description: Path to the file(s) to determine the Signature Information
        Notes:
        Alias:
        ValidateSet:

    .PARAMETER ToolPath
        Description: Path to the SigCheck.exe SysInternals Utility
        Notes: The default ToolPath is ( .\Tools\SysinternalsSuite ) with a backup path of ( $env:Windir\Temp )
        Alias:
        ValidateSet:

	.PARAMETER Algorithm
        Description:  Specifies the cryptographic hash to use for computing the hash value of the contents of the specified file.
        Notes:  The acceptable values for this parameter are:

                    - SHA1
                    - SHA256
                    - SHA384
                    - SHA512
                    - MACTripleDES
                    - MD5 = (Default)
                    - RIPEMD160
        Alias:
        ValidateSet: 'MACTripleDES','MD5','RIPEMD160','SHA1','SHA256','SHA384','SHA512'

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:
        Alias: Help
        ValidateSet:

    .PARAMETER ReturnObject
        Description: Return information as an Object
        Notes: This is set to $true by default.  To change to false run -ReturnObject:$false
        Alias:
        ValidateSet:

    .PARAMETER OutUnEscapedJSON
        Description: Remove UnEsacped Char from the JSON information.
        Notes: This will beautify json and clean up the formatting.
        Alias:
        ValidateSet:

    .EXAMPLE
        Command: Get-BluGenieSignature -Path 'C:\Windows\Notepad.exe'
        Description: Show the Authentication Signature Information for the file given
        Notes:
			- Sample Output -
                Comment         :
                Path            : c:\windows\system32\cmd.exe
                File Version    : 10.0.17134.1 (WinBuild.160101.0800)
                Description     : Windows Command Processor
                Product Version : 10.0.17134.1
                Date            : 5:16 PM 4/11/2018
                Company         : Microsoft Corporation
                Publisher       : Microsoft Windows
                Verified        : Signed
                Product         : Microsoft® Windows® Operating System
                Machine Type    : 64-bit
                Hash            : 4e2acf4f8a396486ab4268c94a6a245f

    .EXAMPLE
        Command: Get-BluGenieSignature -Path 'C:\Windows\Notepad.exe,C:\Windows\system32\cmd.exe'
        Description: Show the Authentication Signature Information for the file(s) in a sinlge string using a comma separator
        Notes:

	.EXAMPLE
        Command: Get-BluGenieSignature -Path 'C:\Windows\Notepad.exe','C:\Windows\system32\cmd.exe'
        Description: Show the Authentication Signature Information for the file(s) in an Array
        Notes:

	.EXAMPLE
        Command: Get-BluGenieSignature -Path 'C:\Windows\Notepad.exe' -ReturnObject:$False
        Description: Reset the default output to a Hash Table
        Notes:

	.EXAMPLE
        Command: Get-BluGenieSignature -Path 'C:\Windows\Notepad.exe' -ToolPath 'C:\Temp\SigCheck.exe'
        Description: Locate the SigCheck.exe tool in C:\Temp and Show the Authentication Signature Information for Notepad.exe
        Notes:

    .EXAMPLE
        Command: Get-BluGenieSignature -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieSignature -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieSignature -Path 'C:\Windows\Notepad.exe' -ReturnObject:$False -OutUnEscapedJSON
        Description: Show the Authentication Signature Information and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BluGenieSignature -Path 'C:\Windows\Notepad.exe' -ReturnObject
        Description: Show the Authentication Signature Information and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  This is the default option

    .OUTPUTS
        TypeName: System.Object

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1902.1201
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 21.06.2301
        * Comments                  :
        * Dependencies              :
                                        ~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
										~ SigCheck.exe 					- SysInternals Utility
										~ Get-LiteralPath				- Get-LiteralPath will convert System Variable defined paths to a Literal Path
        * Build Version Details     :
            ~ 1902.1201: * [Michael Arroyo] Posted
            ~ 1902.1802: * [Michael Arroyo] Completly rewritten to support the SysInternals Exec SigCheck.exe.  Can now pull clean from all Windows OS's.
            ~ 1904.0401: * [Michael Arroyo] Added LiteralPath Property to the main object
                            * [Michael Arroyo] Updated the file check process
                            * [Michael Arroyo] Updated the error control around Get-HashInfo
            ~ 1911.2201: * [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                            * [Michael Arroyo] Updated the Hash Information to follow the new function standards
                            * [Michael Arroyo] Added more detailed information to the Return data
                            * [Michael Arroyo] Added a directory lookup table to search for SigCheck.exe
                            * [Michael Arroyo] Added option for file(s) to be passed in a sinlge string using a comma separator
                            * [Michael Arroyo] Added option for file(s) to be passed in an Array
            ~ 20.05.2101:   • [Michael Arroyo] Updated to support Posh 2.0
            ~ 21.06.2301:   • [Michael Arroyo] Updated the function based on the PSScriptAnalyzerSettings configuration.
                            • [Michael Arroyo] Added funtion Alias ( Get-BGSignature )
                            • [Michael Arroyo] Updated the ArrToolPath scriptblock
#>
    [Alias('Get-Signature','Get-BGSignature')]
    Param
    (
        [Parameter(Position=1)]
        [String[]]$Path,

        [Parameter(Position=2)]
        [String]$ToolPath,

        [Parameter(Position=3)]
        [ValidateSet('MACTripleDES', 'MD5', 'RIPEMD160', 'SHA1', 'SHA256', 'SHA384', 'SHA512')]
        [string]$Algorithm = 'MD5',

        [Alias('Help')]
        [Switch]$Walkthrough,

        [Switch]$ReturnObject = $true,

        [Switch]$OutUnEscapedJSON
    )

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

	#region Path Parameter Check
        If
        (
            -Not $Path
        )
        {
            Return
        }
    #endregion Path Parameter Check

    #region Create Return hash
        $HashReturn = @{}
        $HashReturn['GetSignature'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetSignature'].StartTime = $($StartTime).DateTime
        $HashReturn['GetSignature']['Signatures'] = @()
		$HashReturn['GetSignature']['ToolCheck'] = $false
		$HashReturn['GetSignature']['ToolPath'] = $null
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['GetSignature'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Arch Type
        if
        (
            $env:PROCESSOR_ARCHITECTURE -match '64'
        )
        {
            $Sigcheck = 'sigcheck64.exe'
        }
        else
        {
            $Sigcheck = 'sigcheck.exe'
        }
    #endregion Arch Type

    #region Tool Check
        $Error.Clear()
        $CurTool = $Sigcheck
        $NestedToolPath = 'SysinternalsSuite'
        $ResolveToolDirectory = Resolve-Path -Path $ToolsDirectory | Select-Object -ExpandProperty Path
        $ArrToolPath = @(
            $('{0}\{1}' -f $ToolPath, $CurTool),
            $('{0}\Windows\Temp\{1}}' -f $env:SystemDrive, $CurTool),
            $('{0}\{1}' -f $env:Temp, $CurTool),
            ".\Blubin\Modules\Tools\$NestedToolPath\$CurTool",
            "..\Tools\$NestedToolPath\$CurTool",
            $('{0}\{1}\{2}' -f $ResolveToolDirectory, $NestedToolPath, $CurTool)
        )

        foreach
        (
            $CurToolPath in $ArrToolPath
        )
        {
			If
			(
				$CurToolPath
			)
			{
				if
				(
					Test-Path -Path $CurToolPath -ErrorAction SilentlyContinue
				)
				{
					$HashReturn['GetSignature']['ToolPath'] = $CurToolPath
					$HashReturn['GetSignature']['ToolCheck'] = $true
					Break
				}
			}
		}
    #endregion Tool Check

    #region Main
        #region If Tool Exists --> Continue
			If
			(
				$HashReturn['GetSignature']['ToolCheck']
			)
			{
				#region Signature Properties
					$SigProps = @{
                        'Path' 				= ''
                        'Verified' 			= ''
                        'Date' 				= ''
                        'Publisher'  		= ''
                        'Company' 			= ''
                        'Description' 		= ''
                        'Product' 			= ''
                        'Product Version' 	= ''
                        'File Version' 		= ''
                        'Machine Type' 		= ''
                        'Comment' 			= ''
                        'Hash' 				= ''
					}
				#endregion Signature Properties

				#region Validate Path(s)
					[System.Collections.ArrayList]$ArrPaths = @()

					#region Parse and validate all paths
						switch
						(
							$Null
						)
						{
							#region Check if path is a single string with a comma separator
								{$Path -match ','}
								{
									$Paths = $Path -split ',' | ForEach-Object `
									-Process `
									{
                                        $CurPathCheck = Get-LiteralPath -Path $($_) -ErrorAction SilentlyContinue
										If
										(
											Get-Item -Path $CurPathCheck -Force -ErrorAction SilentlyContinue
										)
										{
											$CurPathObject = New-Object -TypeName PSObject -Property  $SigProps
											$CurPathObject.Path = $CurPathCheck
											$null = $ArrPaths.Add($CurPathObject)
										}
										Else
										{
											$CurPathObject = New-Object -TypeName PSObject -Property  $SigProps
											$CurPathObject.Path = $CurPathCheck
											$CurPathObject.Comment = 'Path not found'
											$null = $ArrPaths.Add($CurPathObject)
										}
									}
								}
							#endregion Check if path is a single string with a comma separator

							#region Check if path is an Array with more than 1 item
								{$Path.Count -gt 1}
								{
									$Path | ForEach-Object `
									-Process `
									{
										$CurPathCheck = Get-LiteralPath -Path $($_) -ErrorAction SilentlyContinue
										If
										(
											Get-Item -Path $CurPathCheck -Force -ErrorAction SilentlyContinue
										)
										{
											$CurPathObject = New-Object -TypeName PSObject -Property  $SigProps
											$CurPathObject.Path = $CurPathCheck
											$null = $ArrPaths.Add($CurPathObject)
										}
										Else
										{
											$CurPathObject = New-Object -TypeName PSObject -Property  $SigProps
											$CurPathObject.Path = $CurPathCheck
											$CurPathObject.Comment = 'Path not found'
											$null = $ArrPaths.Add($CurPathObject)
										}
									}
								}
							#endregion Check if path is an Array with more than 1 item

							#region Default - Single Path
								Default
								{
									$CurPathCheck = Get-LiteralPath -Path $($Path) -ErrorAction SilentlyContinue
									If
									(
										Get-Item -Path $CurPathCheck -Force -ErrorAction SilentlyContinue
									)
									{
										$CurPathObject = New-Object -TypeName PSObject -Property  $SigProps
										$CurPathObject.Path = $CurPathCheck
										$null = $ArrPaths.Add($CurPathObject)
									}
									Else
									{
										$CurPathObject = New-Object -TypeName PSObject -Property  $SigProps
										$CurPathObject.Path = $CurPathCheck
										$CurPathObject.Comment = 'Path not found'
										$null = $ArrPaths.Add($CurPathObject)
									}
								}
							#endregion Default - Single Path
						}
					#endregion Parse and validate all paths
                #endregion Validate Path(s)

				#region Process All Valid Paths
					$ArrPaths | Where-Object -Property Comment -EQ '' | ForEach-Object `
                    -Process `
					{
						$CurValidPathObj = $_

						$SigOptions = '-nobanner -c -accepteula' #NoBanner, Export to CSV
                        $SigObj = Invoke-Expression -Command $('{0} {1} "{2}"' -f $($HashReturn['GetSignature']['ToolPath']),$SigOptions,$($CurValidPathObj.Path)) -ErrorAction SilentlyContinue | ConvertFrom-Csv -ErrorAction SilentlyContinue

						$CurValidPathObj.Verified = $SigObj.Verified
						$CurValidPathObj.Date = $SigObj.Date
						$CurValidPathObj.Publisher = $SigObj.Publisher
						$CurValidPathObj.Company = $SigObj.Company
						$CurValidPathObj.Description = $SigObj.Description
						$CurValidPathObj.Product = $SigObj.Product
						$CurValidPathObj.'Product Version' = $SigObj.'Product Version'
						$CurValidPathObj.'File Version' = $SigObj.'File Version'
						$CurValidPathObj.'Machine Type' = $SigObj.'Machine Type'
						$CurValidPathObj.Hash = $(Get-HashInfo -Path $($CurValidPathObj.Path) -Algorithm $Algorithm -ErrorAction SilentlyContinue)
					}
				#endregion Process All Valid Paths

				$HashReturn['GetSignature']['Signatures'] += $ArrPaths
			}
		#endregion If Tool Exists --> Continue
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetSignature'].EndTime = $($EndTime).DateTime
        $HashReturn['GetSignature'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

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
						Return $ArrPaths
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
#endregion Get-BluGenieSignature (Function)