#region Get-BluGenieErrorAction (Function)
Function Get-BluGenieErrorAction
{
<#
    .SYNOPSIS
        Get-BluGenieErrorAction is a function that will round up any errors into a smiple object

    .DESCRIPTION
        Get-BluGenieErrorAction is a function that will round up any errors into a smiple object

    .PARAMETER Clear
        Description: Clear all errors after trapping 
        Notes:  
        Alias:
        ValidateSet:  
		
	.PARAMETER List
		Description: Return data is in a List format
		Notes: By default the return data is in a Table format
		Alias:
		ValidateSet:  

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

    .EXAMPLE
	    Command: Get-BluGenieErrorAction
        Description: Display error information in a readable format
        Notes: This includes 
			       * Action			= The actioning item or cmdlet
				   * StackTracke	= From what Function, ScriptBlock, or CmdLet the error came from and the Line number
				   * Line			= The command used when the error was generated
				   * Error			= A string with a readable error message

    .EXAMPLE
	    Command: Get-BluGenieErrorAction -Clear
        Description: Clear all errors after processing each error message
        Notes: 
		
	.EXAMPLE
		Command: Get-BluGenieErrorAction -List
		Description: Return information in a List format
		Notes: By default the information is displayed in a Table format

    .EXAMPLE
	    Command: Get-BluGenieErrorAction -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieErrorAction -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieErrorAction -OutUnEscapedJSON
        Description: Get-BluGenieErrorAction and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is an Object.

    .EXAMPLE
	    Command: Get-BluGenieErrorAction -ReturnObject
        Description: Get-BluGenieErrorAction and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  This is the default.

    .OUTPUTS
        TypeName: System.Management.Automation.PSCustomObject

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 20.05.2101
        * Latest Author             : 
        * Latest Build Version      : 
        * Comments                  :
        * Dependencies              :
                                        ~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
        * Build Version Details     :
                                        ~ 1912.1901: * [Michael Arroyo] Posted
                                        ~ 20.05.2101:• [Michael Arroyo] Updated to support Posh 2.0
                                                    
#>
    [cmdletbinding()]
    [Alias('Get-ErrorAction')]
    Param
    (
        [switch]$Clear,
		
		[switch]$List,

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

    #region Create Return hash
        $HashReturn = @{}
        $HashReturn['GetErrorAction'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetErrorAction'].StartTime = $($StartTime).DateTime
        $HashReturn['GetErrorAction']['Errors'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['GetErrorAction'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        $ArrErrorControl = @()

		If
		(
			$Error
		)
		{
			$Error | ForEach-Object `
			-Process `
			{
				$CurError = $_
				
				If
				(
					$CurError.exception
				)
				{
					$ErrorReturn = New-Object -TypeName PSObject -Property @{
						'Action' 		= ''
						'StackTrace' 	= ''
						'Line'			= ''
						'Error' 		= ''
					}
					
					switch
					(
						$null
					)
					{
						{ $CurError.exception }
						{
							$ErrorReturn.Error = $($CurError.exception | Out-String).trim() -replace '\n'
						}
						
						{ $CurError.ScriptStackTrace }
						{
							$ErrorReturn.StackTrace = $($CurError.ScriptStackTrace -replace '^(.*)?,.*:\s(line\s\d?)','$1,$2' -split '\n') | Select-Object -First 1
						}
						
						{ $CurError.CategoryInfo.Activity }
						{
							$ErrorReturn.Action = $CurError.CategoryInfo.Activity
						}
						
						{ $CurError.InvocationInfo.Line }
						{
							$ErrorReturn.Line = $($CurError.InvocationInfo.Line).Trim()
						}
					}
					
					$ArrErrorControl += $ErrorReturn
					
					If
					(
						$ErrorReturn
					)
					{
						$null = Remove-Variable -Name 'ErrorReturn' -Force
					}
				}
			}
			
			$HashReturn['GetErrorAction']['Errors'] += $ArrErrorControl
		}
		
		if
		(
			$Clear
		)
		{
			$Error.clear()
		}
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetErrorAction'].EndTime = $($EndTime).DateTime
        $HashReturn['GetErrorAction'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

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
						If
						(
							$List
						)
						{
							Return $($ArrErrorControl | Format-List)
						}
						Else
						{
							Return $ArrErrorControl
						}
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
#endregion Get-BluGenieErrorAction (Function)