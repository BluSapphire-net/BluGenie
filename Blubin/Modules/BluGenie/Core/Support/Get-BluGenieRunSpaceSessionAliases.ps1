#region Get-BluGenieRunSpaceSessionAliases (Function)
Function Get-BluGenieRunSpaceSessionAliases
{
<#
    .SYNOPSIS
        Get-BluGenieRunSpaceSessionAliases will display, the default powershell sessions Alias list

    .DESCRIPTION
        Get-BluGenieRunSpaceSessionAliases will display, the default powershell sessions Alias list

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:  
        Alias: Help
        ValidateSet: 

    .PARAMETER ReturnObject
        Description: Return information as an Object
        Notes: This is the default return type
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
	    Command: Get-BluGenieRunSpaceSessionAliases
        Description: Get the default PowerShell's Alias list
        Notes: 

    .EXAMPLE
	    Command: Get-BluGenieRunSpaceSessionAliases -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
               Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieRunSpaceSessionAliases -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
               Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieRunSpaceSessionAliases -OutUnEscapedJSON
        Description: Get the default PowerShell's Function list and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Get-BluGenieRunSpaceSessionAliases -ReturnObject
        Description: Get the default PowerShell's Function list and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Get-BluGenieRunSpaceSessionAliases -ReturnObject -FormatView JSON
        Description: Get the default PowerShell's Function list and Return Object formatted in a JSON view
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
		
	.EXAMPLE
	    Command: Get-BluGenieRunSpaceSessionAliases -ReturnObject -FormatView Custom
        Description: Get the default PowerShell's Function list and Return Object formatted in a PSCustom view
        Notes:  Format-Custom is designed to display views that are not just tables or just lists. You can use the views defined in the 
                *format.PS1XML files in the PowerShell directory, or you can create your own views in new PS1XML files and use the 
                Update-FormatData cmdlet to add them to PowerShell.

    .OUTPUTS
        TypeName: System.Array

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 20.07.0601
        * Latest Author             : 
        * Latest Build Version      : 
        * Comments                  :
        * Dependencies              :
            ~ Invoke-WalkThrough - Invoke-WalkThrough is an interactive help menu system
			~ Get-ErrorAction - Get-ErrorAction will round up any errors into a simple object
        * Build Version Details     :
            ~ 20.07.0601: * [Michael Arroyo] Posted
                                                    
#>
    [cmdletbinding()]
    #[Alias('')]
    Param
    (
        [Alias('Help')]
        [Switch]$Walkthrough,

        [Switch]$ReturnObject = $true,

        [ValidateSet('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV')]
        [string]$FormatView = 'None',

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

    #region Create Return hash
        $HashReturn = @{}
        $HashReturn['GetRunSpaceSessionAliases'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetRunSpaceSessionAliases'].StartTime = $($StartTime).DateTime
        $HashReturn['GetRunSpaceSessionAliases']['Items'] = @()
		$HashReturn['GetRunSpaceSessionAliases']['Comments'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['GetRunSpaceSessionAliases'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
		#region Query Information
			Try
			{
				$Error.Clear()
	        	$CurSessionInfo = [powershell]::Create().addscript(
	            {
	                $(Get-ChildItem -Path Alias:\ -ErrorAction Stop | Select-Object Name, Definition)
	            }
	            ).invoke()

				$HashReturn['GetRunSpaceSessionAliases']['Items'] += $CurSessionInfo
			}
			Catch
			{
				$HashReturn['GetRunSpaceSessionAliases']['Comments'] += Get-ErrorAction -Clear
			}
		#endregion Query Information
    #endregion Main

	#region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetRunSpaceSessionAliases'].EndTime = $($EndTime).DateTime
        $HashReturn['GetRunSpaceSessionAliases'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) `
        | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

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
				                        Return $($CurSessionInfo | Format-Table -AutoSize -Wrap)
			                        }
		                        #endregion Table

                                #region CSV
			                        'CSV'
			                        {
                                        Return $($CurSessionInfo | ConvertTo-Csv -NoTypeInformation)
			                        }
		                        #endregion CSV

                                #region CustomModified
			                        'CustomModified'
			                        {
				                        Return $($CurSessionInfo | Format-Custom | Out-String) -replace '}\s\s','},' `
                                        -replace '\sclass\s.*\s'
			                        }
		                        #endregion CustomModified

                                #region Custom
			                        'Custom'
			                        {
				                        Return $($CurSessionInfo | Format-Custom)
			                        }
		                        #endregion Custom

                                #region JSON
			                        'JSON'
			                        {
                                        Try
                                        {
                                            $null = Get-Command -Name ConvertTo-Json -ErrorAction Stop
                                            Return $($CurSessionInfo | ConvertTo-Json -Depth 10)
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
                                            Return $($CurSessionInfo | ConvertTo-Json -Depth 10 | ForEach-Object `
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
			                            Return $CurSessionInfo
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
#endregion Get-BluGenieRunSpaceSessionAliases (Function)