#region Get-BluGenieSessionVariableList (Function)
Function Get-BluGenieSessionVariableList
{
<#
    .SYNOPSIS
        Get-BluGenieSessionVariableList will display, export, and remove all user defined variables for the current powershell session

    .DESCRIPTION
        Get-BluGenieSessionVariableList will display, export, and remove all user defined variables for the current powershell session
		
	.PARAMETER RemoveAll
		Description: Remove all user defined variables
		Notes: This does not include this function or any of the dependencies
		Alias:
		ValidateSet:  

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
	    Command: Get-BluGenieSessionVariableList
        Description: Get the user defined variables for the current PowerShell session
        Notes: 
		
	.EXAMPLE
	    Command: Get-BluGenieSessionVariableList -RemoveAll
        Description: Remove all user defined variables for the current PowerShell session
        Notes: 
		
	.EXAMPLE
		Command: Get-BluGenieSessionVariableList -RemoveAll -Force
		Description: Remove all user defined variables including this function and its dependencies
		Notes: 

    .EXAMPLE
	    Command: Get-BluGenieSessionVariableList -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
               Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieSessionVariableList -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
               Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieSessionVariableList -OutUnEscapedJSON
        Description: Get the user defined variables for the current PowerShell session and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Get-BluGenieSessionVariableList -ReturnObject
        Description: Get the user defined variables for the current PowerShell session and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Get-BluGenieSessionVariableList -ReturnObject -FormatView JSON
        Description: Get the user defined variables for the current PowerShell session and Return Object formatted in a JSON view
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
		
	.EXAMPLE
	    Command: Get-BluGenieSessionVariableList -ReturnObject -FormatView Custom
        Description: Get the user defined variables for the current PowerShell session and Return Object formatted in a PSCustom view
        Notes:  Format-Custom is designed to display views that are not just tables or just lists. You can use the views defined in the 
                *format.PS1XML files in the PowerShell directory, or you can create your own views in new PS1XML files and use the 
                Update-FormatData cmdlet to add them to PowerShell.

    .OUTPUTS
        TypeName: Selected.System.Management.Automation.PSCustomObject

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1912.2301
        * Latest Author             : 
        * Latest Build Version      : 
        * Comments                  :
        * Dependencies              :
                                        ~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
										~ Get-ErrorAction				- Get-ErrorAction will round up any errors into a simple object
										~ Get-CurrentSessionvariables	- Get-CurrentSessionvariables will display the current powershell 
                                                                          sessions function list
										~ Get-RunSpaceSessionvariables	- Get-RunSpaceSessionvariables will display the default powershell 
                                                                          sessions function list
        * Build Version Details     :
                                        ~ 1912.2301: * [Michael Arroyo] Posted
                                                    
#>
    [cmdletbinding()]
    [Alias('Get-SessionVariableList')]
    Param
    (
		[switch]$RemoveAll,
		
		[switch]$Export,
		
		[string]$ExportPath,

        [ValidateSet('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV')]
        [string]$FormatView = 'Table',
	
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
	
	#region Set Path
		If
		(
			-Not $ExportPath
		)
		{
			If
			(
				$PSScriptRoot
			)
			{
				$ExportPath = $PSScriptRoot
			}
			Else
			{
				If
                (
                    $Host.Name -match 'ISE'
                )
                {
                    $ExportPath = Split-Path -Path $($psISE.CurrentFile.FullPath) -Parent
                }
				Else
				{
					$ExportPath = Get-Location | Select-Object -ExpandProperty Path
				}
			}
		}
	#endregion Set Path

    #region Create Return hash
        $HashReturn = @{}
        $HashReturn['GetSessionVariableList'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetSessionVariableList'].StartTime = $($StartTime).DateTime
        $HashReturn['GetSessionVariableList']['Items'] = @()
		$HashReturn['GetSessionVariableList']['Comments'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['GetSessionVariableList'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
		#region Query Information
			Try
			{
				$Error.Clear()
                $CurrentSessionvariables = Get-CurrentSessionvariables -ErrorAction Stop
                $RunSpaceSessionvariables = Get-RunSpaceSessionvariables -ErrorAction Stop

	        	$CurSessionInfo = $(Compare-Object -ReferenceObject $($CurrentSessionvariables.Name) `
                                  -DifferenceObject $($RunSpaceSessionvariables.Name) -ErrorAction Stop) | 
								  Where-Object -FilterScript { $_.'SideIndicator' -eq '<=' } | 
								  Select-Object -Property @{
								  						      Name = 'Name'
															  Expression = {
															  	$_.InputObject
															  }
								  						  },
														  @{
								  						      Name = 'Status'
															  Expression = {
															  	'Reporting'
															  }
								  						  },
														  @{
								  						      Name = 'Value'
															  Expression = {
															  	$CurrentSessionvariables | Where-Object -Property 'Name' -eq $_.InputObject |
                                                                Select-Object -ExpandProperty value
															  }
								  						  },
														  @{
								  						      Name = 'Path'
															  Expression = {
															  	''
															  }
								  						  }
			}
			Catch
			{
				$HashReturn['GetSessionVariableList']['Comments'] += Get-ErrorAction -Clear
			}
		#endregion Query Information
		
		#region Remove Items
			If
			(
				$RemoveAll -and $(-Not $Export)
			)
			{
                If
                (
                    $CurSessionInfo
                )
                {
				    $CurSessionInfo | ForEach-Object `
				    -Process `
				    {
					    $CurVariableItem = $_
					
					    Try
					    {
							$null = Remove-Variable -Name $($CurVariableItem.Name) -Force -ErrorAction Stop
							$CurVariableItem.Status = 'Removed'
						}
					    Catch
					    {
						    Try
					        {
							    $null = Remove-Variable -Name $($CurVariableItem.Name) -Scope Global -Force -ErrorAction Stop
							    $CurVariableItem.Status = 'Removed'
						    }
					        Catch
					        {
						        $HashReturn['GetSessionVariableList']['Comments'] += Get-ErrorAction -Clear
						        $CurVariableItem.Status = 'RemovedError'
					        }
					    }
                    }
				}
			}
		#endregion Remove Items
		
		#region Export Session variables
			If
			(
				$Export
			)
			{
				$Selectedvariables = $CurSessionInfo | Select-Object -Property Name,Value | Out-GridView -PassThru `
                -Title 'Select which variables to export'

                If
                (
                    $Selectedvariables
                )
                {
                    $Selectedvariables | ForEach-Object `
                    -Process `
                    {
                        $CurSelVar = $_
                        $CurSelVarName = $CurSelVar.Name
                        $CurSelVarValue = $CurSelVar.Value
                        
                        Try
                        {
                            $CurSelVar.Value | Out-File -FilePath $('{0}\{1}.var' -f $ExportPath, $CurSelVarName) -Force -ErrorAction Stop

                            $($CurSessionInfo | Where-Object -Property 'Name' -eq $CurSelVarName).Status = 'Exported'
                            $($CurSessionInfo | Where-Object -Property 'Name' -eq $CurSelVarName).Path = $('{0}\{1}.var' -f $ExportPath, 
                            $CurSelVarName)
                        }
                        Catch
                        {
                            $HashReturn['GetSessionVariableList']['Comments'] += Get-ErrorAction -Clear
                        }
                    }
                }
			}
		#endregion Export Session variables

        #region Export to HashTable
			$HashReturn['GetSessionVariableList']['Items'] = $CurSessionInfo
		#endregion Export to HashTable
    #endregion Main

	#region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetSessionVariableList'].EndTime = $($EndTime).DateTime
        $HashReturn['GetSessionVariableList'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

		#region Output Type
			switch
			(
				$Null
			)
			{
				#region Beatify the JSON return and not Escape any Characters
	                { $OutUnEscapedJSON }
					{
						Return $($HashReturn | ConvertTo-Json -Depth 3 | ForEach-Object -Process { [regex]::Unescape($_) })
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
                                            Return $($CurSessionInfo | ConvertTo-Json -Depth 1)
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
                                            Return $($CurSessionInfo | ConvertTo-Json -Depth 1| ForEach-Object -Process { [regex]::Unescape($_) })
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
#endregion Get-BluGenieSessionVariableList (Function)