#region Get-BluGenieHashInfo (Function)
Function Get-BluGenieHashInfo
{
    <#
    .SYNOPSIS
        Get-BluGenieHashInfo is a PowerShell Version 2 port of Get-FileHash

    .DESCRIPTION
        Specifies the path to a file to hash. Wildcard characters are permitted.

        Note:  If more than 1 path is specified the return will output a list of items including the Paths and Hash information of each file.

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

                If no value is specified, or if the parameter is omitted, the default value is (MD5)
        Alias:
        ValidateSet: 'MACTripleDES','MD5','RIPEMD160','SHA1','SHA256','SHA384','SHA512'

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

    .PARAMETER FormatView
		Description: Select which format to return the object data in.
		Notes: Default value is set to (None).  This value is only valid when using the -ReturnObject parameter
		Alias:
		ValidateSet: 'Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV'

    .EXAMPLE
        Command: Get-BluGenieHashInfo -Path C:\Windows\Notepad.exe
        Description: This will return the (MD5) hash value for C:\Windows\Notepad.exe
        Notes:

    .EXAMPLE
        Command: Get-BluGenieHashInfo -Path C:\Windows\Note* -Algorithm SHA256
        Description: This will return the (SHA256) hash value for C:\Windows\Notepad.exe
        Notes:

    .EXAMPLE
        Command: Get-BluGenieHashInfo -Path '%Windir%\notepad.exe'
        Description:  This will convert the path to the literal path and return the (MD5) hash value for C:\Windows\Notepad.exe
        Notes:

    .EXAMPLE
        Command: Get-BluGenieHashInfo -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
        Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieHashInfo -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal
        Get-Help will be called with the -Full parameter

    .EXAMPLE
        Command: Get-BluGenieHashInfo -OutUnEscapedJSON
        Description: Get-BluGenieHashInfo and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BluGenieHashInfo -ReturnObject
        Description: Get-BluGenieHashInfo and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .EXAMPLE
        Command: Get-BluGenieHashInfo -ReturnObject -FormatView Custom
        Description: Get-BluGenieHashInfo and Return Object formatted in a PSCustom view
        Notes:  Format-Custom is designed to display views that are not just tables or just lists. You can use the views defined in the
                *format.PS1XML files in the PowerShell directory, or you can create your own views in new PS1XML files and use the
                Update-FormatData cmdlet to add them to PowerShell.

    .OUTPUTS
        * TypeName: System.Management.Automation.PSCustomObject
        * TypeName: System.String

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1901.1601
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 21.01.0401
        * Comments                  :
        * Dependencies              :
            ~ New-TimeStamp                 • Return a Time Stamp specifically for log files
            ~ Invoke-WalkThrough            • Invoke-WalkThrough is an interactive help menu system
            ~ Get-ErrorAction               • Get-ErrorAction will round up any errors into a simple object
            ~ Get-LiteralPath               • Get-LiteralPath will convert System Variable defined paths to a Literal Path
    #>

    #region Build Notes
    <#
    ~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
        ~ 1901.1601:    * [Michael Arroyo] Posted
        ~ 1901.2701:    * [Michael Arroyo] Added a call to Get-LiteralPath to validate and convert a System defined variable path to a liter path.
        ~ 1902.0401:    * [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help
                                            information
        ~ 1902.0601:    * [Michael Arroyo] Updated to the latest snippet of WalkTrough
        ~ 1902.1201:    * [Michael Arroyo] Updated the script to support better error control when managing a null path
        ~ 1906.1401     * [Michael Arroyo] Updated the Get-Item call to pull hidden file information.
        ~ 1908.1301     * [Michael Arroyo] Updated the overall process of this function so it can be run on its own.  Previsouly this was
                                            setup as a helper/sub function for other functions.
                        * [Michael Arroyo] Updated the Sub Function WalkThrough to (Ver: 1905.2401)
                        * [Michael Arroyo] Updated the ( Path ) variable to support multiple paths
                        * [Michael Arroyo] Added a list output for more than 1 item to have the Hash listed for
                        * [Michael Arroyo] Added parameter and process for ( ReturnObject )
                        * [Michael Arroyo] Added parameter and process for ( OutUnEscapedJSON )
                        * [Michael Arroyo] Added $PSBoundParameters to the returning JSON
                        * [Michael Arroyo] Added Start, End, and Time Span values to the returning JSON
        ~ 1908.1401     * [Michael Arroyo] Updated the Path count check.  It was not pulling the count value correctly.
        ~ 2003.2601     * [Michael Arroyo] Fixed the Get-Item file information check to [System.IO.FileInfo].  Get-Item code uses the
                                            GetFileAttributes function to determine whether a file exists. Because it's returning -1 for
                                            in use system files, the FileSystemProvider is behaving as though the file doesn't exist.
                        * [Michael Arroyo] Updated the Help Information to the new External format
                        * [Michael Arroyo] Added Error reporting to Comment Section
        ~ 2004.0201     * [Michael Arroyo] Fixed the $Null error msg when a file was not found
                        * [Michael Arroyo] Added new commnets for missing files
        ~ 2004.0601     * [Michael Arroyo] Fixed the default return data.  If you select ReturnObject or OutUnEscapedJSON the data was coming
                                            back fine.  But without one of those options the value was not returning.
        ~ 20.11.2301    * [Michael Arroyo] Changed the validation set for Algorithm from using (Double Quotes) to (Single Quotes)
                        * [Michael Arroyo] Updated the ParameterSetResutls Hash table to have the value defined as an Array before the value is
                                            posted
                        * [Michael Arroyo] Updated the Get-LiteralPath command to Get-BluGenieLiteralPath
                        * [Michael Arroyo] Addeded a check to see if the file is locked prior to Generating the Hash value.  Added a Return if
                                            the file is Locked instead of returning nothing like prior versions.
        ~ 21.01.0401    * [Michael Arroyo] Fixed false return when a file was set to Read-Only.  Now the hash information is captured correctly
                        * [Michael Arroyo] Fixed the Help information region. Moved the ( Build Version Details ) from main help.
													There is a Char limit and PSHelp could not read all the information correctly which also created
													issues using the ( WalkThrough ) parameter as well.
                        * [Michael Arroyo] Updated this function / script based on the new Linter ( PSScriptAnalyzerSettings )
                        * [Michael Arroyo] Added Alias 'Get-BGHashInfo' directly to the Function
    #>
    #endregion Build Notes

    [CmdletBinding(ConfirmImpact='Medium')]
    [Alias('Get-HashInfo','Get-BGHashInfo')]
    #region Parameters
        param
        (
            [Parameter(Position = 0)]
            [Alias('FullName','FilePath')]
            [String[]]$Path,

            [Parameter(Position = 1)]
            [ValidateSet('MACTripleDES', 'MD5', 'RIPEMD160', 'SHA1', 'SHA256', 'SHA384', 'SHA512')]
            [string]$Algorithm = 'MD5',

            [Parameter(Position = 2)]
            [Alias('Help')]
            [Switch]$Walkthrough,

            [Parameter(Position = 3)]
            [Switch]$ReturnObject,

            [Parameter(Position = 4)]
            [Switch]$OutUnEscapedJSON,

            [ValidateSet('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV')]
            [string]$FormatView = 'Table'
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

    #region Parameter Check
        If
        (
            -Not $Path
        )
        {
            Return
        }
    #endregion

    #region Create Return hash
        If
        (
            $ReturnObject -or $OutUnEscapedJSON -or $($Path.Count -gt 1)
        )
        {
            $HashReturn = @{}
            $HashReturn['HashInfo'] = @{}
            $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn['HashInfo'].StartTime = $($StartTime).DateTime
            $HashReturn['HashInfo'].ParameterSetResults = @()
            $HashReturn['HashInfo'].Hash = @()
            $HashReturn['HashInfo'].Comments = @()

            #region Parameter Set Results
                $HashReturn['HashInfo'].ParameterSetResults += $PSBoundParameters
                $HashReturn['HashInfo'].ParameterSetResults += $(New-Object -TypeName PsObject -Property @{'PathCount' = $($Path.Count)})
            #endregion Parameter Set Results
        }
    #endregion

    #region Create Algorithm Cryptography
        $hashtype = [Security.Cryptography.HashAlgorithm]::Create("$Algorithm")
    #endregion Create Algorithm Cryptography

    #region Process Path(s)

        $Error.Clear()

        $ObjHashProps = @{
            Algorithm   = ''
            Path        = ''
            LiteralPath = ''
            HashValue   = ''
            Comment     = ''
        }

        If
        (
            $Path.Count -gt 1
        )
        {
            $Path | ForEach-Object `
            -Process `
            {
                $CurPath = $_

                $ValidatePath = $(Get-BluGenieLiteralPath -Path $($CurPath))

                Try
                {
                    $Checkpath = [System.IO.FileInfo]"$($ValidatePath)"
                }
                Catch
                {

                }

                If
                (
                    $Checkpath.Exists
                )
                {
                    Try
                    {
                        $CurStream = ([IO.StreamReader]"$($Checkpath.FullName)").BaseStream
                        $CurHash = -join ($hashtype.ComputeHash($CurStream) | ForEach-Object { '{0:x2}' -f $_ })

                        $CurHashobj = New-Object -TypeName PSObject -Property $ObjHashProps
                        $CurHashobj.Algorithm = $Algorithm
                        $CurHashobj.Path = $CurPath
                        $CurHashobj.LiteralPath = $ValidatePath
                        $CurHashobj.HashValue = $CurHash
                        $CurHashobj.Comment = ''

                        $HashReturn.HashInfo.Hash += $CurHashobj
                    }
                    Catch
                    {
                        $CurHashobj = New-Object -TypeName PSObject -Property $ObjHashProps
                        $CurHashobj.Algorithm = $Algorithm
                        $CurHashobj.Path = $CurPath
                        $CurHashobj.LiteralPath = $ValidatePath
                        $CurHashobj.HashValue = 'Failed to get Hash'

                        If
                        (
                            $Error[0]
                        )
                        {
                            $CurHashobj.Comment = $Error[0].ToString()
                        }

                        $HashReturn.HashInfo.Hash += $CurHashobj
                        $null = $($HashReturn['HashInfo']['Comments'] += Get-BluGenieErrorAction -Clear)
                        $NULL = $HashReturn['HashInfo'].Hash += $CurHashobj
                    }
                }
                Else
                {
                    $CurHashobj = New-Object -TypeName PSObject -Property $ObjHashProps
                    $CurHashobj.Algorithm = $Algorithm
                    $CurHashobj.Path = $CurPath
                    $CurHashobj.LiteralPath = 'Path Not Found'
                    $CurHashobj.HashValue = ''

                    If
                    (
                        $Error[0]
                    )
                    {
                        $CurHashobj.Comment = $Error[0].ToString()
                    }

                    $null = $($HashReturn['HashInfo']['Comments'] += Get-BluGenieErrorAction -Clear)
                    $null = $HashReturn['HashInfo'].Hash += $CurHashobj
                }

                $null = $($CurPath = $null)
                $null = $($ValidatePath = $null)
                $null = $($CurHash = $null)
                $null = $($Checkpath = $null)
                $null = $($CurHashobj = $null)
            }
        }
        Else
        {
            If
            (
                $HashReturn.HashInfo.StartTime
            )
            {
                $ValidatePath = $(Get-BluGenieLiteralPath -Path $($Path))

                Try
                {
                    $Checkpath = [System.IO.FileInfo]"$($ValidatePath)"
                }
                Catch
                {
                }

                If
                (
                    $Checkpath.Exists
                )
                {
                    Try
                    {
                        $CurStream = ([IO.StreamReader]"$($Checkpath.FullName)").BaseStream
                        $CurHash = -join ($hashtype.ComputeHash($CurStream) | ForEach-Object { '{0:x2}' -f $_ })

                        $CurHashobj = New-Object -TypeName PSObject -Property $ObjHashProps
                        $CurHashobj.Algorithm = $Algorithm
                        $CurHashobj.Path = $($Checkpath.FullName)
                        $CurHashobj.LiteralPath = $ValidatePath
                        $CurHashobj.HashValue = $CurHash
                        $CurHashobj.Comment = ''

                        $HashReturn.HashInfo.Hash += $CurHashobj
                    }
                    Catch
                    {
                        $CurHashobj = New-Object -TypeName PSObject -Property $ObjHashProps
                        $CurHashobj.Algorithm = $Algorithm
                        $CurHashobj.Path = $($Checkpath.FullName)
                        $CurHashobj.LiteralPath = $ValidatePath
                        $CurHashobj.HashValue = 'Failed to get Hash'

                        If
                        (
                            $Error[0]
                        )
                        {
                            $CurHashobj.Comment = $Error[0].ToString()
                        }

                        $null = $($HashReturn['HashInfo']['Comments'] += Get-BluGenieErrorAction -Clear)
                        $NULL = $HashReturn['HashInfo'].Hash += $CurHashobj
                    }
                }
                Else
                {
                    $CurHashobj = New-Object -TypeName PSObject -Property $ObjHashProps
                    $CurHashobj.Algorithm = $Algorithm
                    $CurHashobj.Path = $($Checkpath.FullName)
                    $CurHashobj.LiteralPath = 'Path Not Found'
                    $CurHashobj.HashValue = ''

                    If
                    (
                        $Error[0]
                    )
                    {
                        $CurHashobj.Comment = $Error[0].ToString()
                    }

                    $null = $($HashReturn['HashInfo']['Comments'] += Get-BluGenieErrorAction -Clear)
                    $NULL = $HashReturn['HashInfo'].Hash += $CurHashobj
                }
            }
            Else
            {
                $ValidatePath = $(Get-BluGenieLiteralPath -Path $($Path))

                Try
                {
                    $Checkpath = [System.IO.FileInfo]"$($ValidatePath)"
                }
                Catch
                {
                    $null= $($HashReturn['HashInfo']['Comments'] += Get-BluGenieErrorAction -Clear)
                }

                If
                (
                    $Checkpath.Exists
                )
                {
                    If
                    (
                        $(Test-BluGenieIsFileLocked -path $($Checkpath.FullName) | Select-Object -ExpandProperty IsLocked) -ne $true
                    )
                    {
                        Try
                        {
                            $CurStream = ([IO.StreamReader]"$($Checkpath.FullName)").BaseStream
                            $CurHash = -join ($hashtype.ComputeHash($CurStream) | ForEach-Object { '{0:x2}' -f $_ })
                        }
                        Catch
                        {
                            $GrabCurErrors = $(Get-BluGenieErrorAction -Clear)
                            If
                            (
                                $GrabCurErrors
                            )
                            {
                                $null = $($HashReturn['HashInfo']['Comments'] += $GrabCurErrors)
                            }
                            $GrabCurErrors = $null
                        }
                    }
                    Else
                    {
                        $CurHash = 'The process cannot access the file because it is being used by another process'
                    }
                }
            }
        }
    #endregion Process Path(s)

    #region Output
		If
		(
			$HashReturn.HashInfo
		)
		{
            $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
            $HashReturn['HashInfo'].EndTime = $($EndTime).DateTime
            $HashReturn['HashInfo'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | `
                                                    Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

            If
            (
                $(-Not $ReturnObject) -and $(-Not $OutUnEscapedJSON) -and $($Path.Count -gt 1)
            )
            {
                $ReturnObject = $true
            }
		}

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
						#region Switch FormatView
                            switch
                            (
                                $FormatView
                            )
                            {
                                #region Table
                                    'Table'
                                    {
                                        Return $($HashReturn.HashInfo.Hash | Format-Table -AutoSize -Wrap)
                                    }
                                #endregion Table

                                #region CSV
                                    'CSV'
                                    {
                                        Return $($HashReturn.HashInfo.Hash | ConvertTo-Csv -NoTypeInformation)
                                    }
                                #endregion CSV

                                #region CustomModified
                                    'CustomModified'
                                    {
                                        Return $($HashReturn.HashInfo.Hash | Format-Custom | Out-String) -replace '}\s\s','},' `
                                        -replace '\sclass\s.*\s'
                                    }
                                #endregion CustomModified

                                #region Custom
                                    'Custom'
                                    {
                                        Return $($HashReturn.HashInfo.Hash | Format-Custom)
                                    }
                                #endregion Custom

                                #region JSON
                                    'JSON'
                                    {
                                        Try
                                        {
                                            $null = Get-Command -Name ConvertTo-Json -ErrorAction Stop
                                            Return $($HashReturn.HashInfo.Hash | ConvertTo-Json -Depth 10)
                                        }
                                        Catch
                                        {
                                        }
                                    }
                                #endregion JSON

                                #region OutUnEscapedJSON
                                    'OutUnEscapedJSON'
                                    {
                                        Try
                                        {
                                            $null = Get-Command -Name ConvertTo-Json -ErrorAction Stop
                                            Return $($HashReturn.HashInfo.Hash | ConvertTo-Json -Depth 10 | ForEach-Object `
                                                -Process `
                                                {
                                                    [regex]::Unescape($_)
                                                }
                                            )
                                        }
                                        Catch
                                        {
                                        }
                                    }
                                #endregion OutUnEscapedJSON

                                #region Default
                                    Default
                                    {
                                        Return $HashReturn.HashInfo.Hash
                                    }
                                #endregion Default
                            }
                        #endregion Switch Statement RegEx
					}
				#endregion Return a PowerShell Object

				#region Default
					Default
					{
						Return $CurHash
					}
				#endregion Default
			}
		#endregion Output Type
    #endregion Output
}
#endregion Get-BluGenieHashInfo (Function)