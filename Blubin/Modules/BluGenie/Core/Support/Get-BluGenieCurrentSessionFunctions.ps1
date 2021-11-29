#region Get-BluGenieCurrentSessionFunctions (Function)
Function Get-BluGenieCurrentSessionFunctions
{
<#
    .SYNOPSIS
        Get-BluGenieCurrentSessionFunctions will display the current powershell sessions function list

    .DESCRIPTION
        Get-BluGenieCurrentSessionFunctions will display the current powershell sessions function list

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
	    Command: Get-BluGenieCurrentSessionFunctions
        Description: Get the current PowerShell's Function list
        Notes: 

    .EXAMPLE
	    Command: Get-BluGenieCurrentSessionFunctions -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieCurrentSessionFunctions -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieCurrentSessionFunctions -OutUnEscapedJSON
        Description: Get the current PowerShell's Function list and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Get-BluGenieCurrentSessionFunctions -ReturnObject
        Description: Get the current PowerShell's Function list and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Get-BluGenieCurrentSessionFunctions -ReturnObject -FormatView JSON
        Description: Get the current PowerShell's Function list and Return Object formatted in a JSON view
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
		
	.EXAMPLE
	    Command: Get-BluGenieCurrentSessionFunctions -ReturnObject -FormatView Custom
        Description: Get the current PowerShell's Function list and Return Object formatted in a PSCustom view
        Notes:  Format-Custom is designed to display views that are not just tables or just lists. You can use the views defined in the 
                *format.PS1XML files in the PowerShell directory, or you can create your own views in new PS1XML files and use the 
                Update-FormatData cmdlet to add them to PowerShell.

    .OUTPUTS
        TypeName: System.Array

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1912.2301
        * Latest Author             : 
        * Latest Build Version      : 
        * Comments                  :
        * Dependencies              :
                                        ~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
										~ Get-ErrorAction				- Get-ErrorAction will round up any errors into a simple object
        * Build Version Details     :
                                        ~ 1912.2301: * [Michael Arroyo] Posted
                                                    
#>
    [cmdletbinding()]
    [Alias('Get-CurrentSessionFunctions')]
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
        $HashReturn['GetCurrentSessionFunctions'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetCurrentSessionFunctions'].StartTime = $($StartTime).DateTime
        $HashReturn['GetCurrentSessionFunctions']['Items'] = @()
		$HashReturn['GetCurrentSessionFunctions']['Comments'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['GetCurrentSessionFunctions'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
		#region Query Information
			Try
			{
				$Error.Clear()
	        	$ArrFunctionList = $(Get-ChildItem -Path Function:\ -ErrorAction Stop | Where-Object -FilterScript { $_.'Source' -NotMatch '^Microsoft|^ISE' } | Select-Object -Property Name)
				$HashReturn['GetCurrentSessionFunctions']['Items'] += $ArrFunctionList.Name	
			}
			Catch
			{
				$HashReturn['GetCurrentSessionFunctions']['Comments'] += Get-ErrorAction -Clear
			}
		#endregion Query Information
		
    #endregion Main

	#region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetCurrentSessionFunctions'].EndTime = $($EndTime).DateTime
        $HashReturn['GetCurrentSessionFunctions'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) `
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
				                        Return $($ArrFunctionList | Format-Table -AutoSize -Wrap)
			                        }
		                        #endregion Table

                                #region CSV
			                        'CSV'
			                        {
				                        Return $($ArrFunctionList | ConvertTo-Csv -NoTypeInformation)
			                        }
		                        #endregion CSV

                                #region CustomModified
			                        'CustomModified'
			                        {
				                        Return $($ArrFunctionList | Format-Custom | Out-String) -replace '}\s\s','},' `
                                        -replace '\sclass\s.*\s'
			                        }
		                        #endregion CustomModified

                                #region Custom
			                        'Custom'
			                        {
				                        Return $($ArrFunctionList | Format-Custom)
			                        }
		                        #endregion Custom

                                #region JSON
			                        'JSON'
			                        {
                                        Try
                                        {
                                            $null = Get-Command -Name ConvertTo-Json -ErrorAction Stop
                                            Return $($ArrFunctionList | ConvertTo-Json -Depth 10)
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
                                            Return $($ArrFunctionList | ConvertTo-Json -Depth 10 | ForEach-Object `
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
			                            Return $ArrFunctionList.Name
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
#endregion Get-BluGenieCurrentSessionFunctions (Function)