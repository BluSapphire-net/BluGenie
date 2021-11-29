#region Get-BluGenieSessionAliasList (Function)
Function Get-BluGenieSessionAliasList
{
<#
    .SYNOPSIS
        Get-BluGenieSessionAliasList will display, remove, and export all user defined Aliases for the current powershell session

    .DESCRIPTION
        Get-BluGenieSessionAliasList will display, remove, and export all user defined Aliases for the current powershell session
		
	.PARAMETER RemoveAll
		Description: Remove all user defined Aliases
		Notes: 
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
	    Command: Get-BluGenieSessionAliasList
        Description: Get the user defined Aliases for the current PowerShell session
        Notes: 
		
	.EXAMPLE
	    Command: Get-BluGenieSessionAliasList -RemoveAll
        Description: Remove all user defined Aliases for the current PowerShell session
        Notes: 
		
	.EXAMPLE
	    Command: Get-BluGenieSessionAliasList -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
               Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieSessionAliasList -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
               Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieSessionAliasList -OutUnEscapedJSON
        Description: Get the user defined Aliases for the current PowerShell session and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Get-BluGenieSessionAliasList -ReturnObject
        Description: Get the user defined Aliases for the current PowerShell session and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Get-BluGenieSessionAliasList -ReturnObject -FormatView JSON
        Description: Get the user defined Aliases for the current PowerShell session and Return Object formatted in a JSON view
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
		
	.EXAMPLE
	    Command: Get-BluGenieSessionAliasList -ReturnObject -FormatView Custom
        Description: Get the user defined Aliases for the current PowerShell session and Return Object formatted in a PSCustom view
        Notes:  Format-Custom is designed to display views that are not just tables or just lists. You can use the views defined in the 
                *format.PS1XML files in the PowerShell directory, or you can create your own views in new PS1XML files and use the 
                Update-FormatData cmdlet to add them to PowerShell.

    .OUTPUTS
        TypeName: Selected.System.Management.Automation.PSCustomObject

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 20.07.0601
        * Latest Author             : 
        * Latest Build Version      : 
        * Comments                  :
        * Dependencies              :
            ~ Invoke-WalkThrough - Invoke-WalkThrough is an interactive help menu system
			~ Get-ErrorAction - Get-ErrorAction will round up any errors into a simple object
			~ Get-CurrentSessionAliases	- Get-CurrentSessionAliases will display the current powershell 
                                          sessions Alias list
			~ Get-RunSpaceSessionAliases - Get-RunSpaceSessionAliases will display the default powershell 
                                           sessions Alias list
        * Build Version Details     :
            ~ 20.07.0601: * [Michael Arroyo] Posted
                                                    
#>
    [cmdletbinding()]
    #[Alias('')]
    Param
    (
		[switch]$RemoveAll,
		
		[switch]$Force,
		
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
        $HashReturn['GetSessionAliasList'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetSessionAliasList'].StartTime = $($StartTime).DateTime
        $HashReturn['GetSessionAliasList']['Items'] = @()
		$HashReturn['GetSessionAliasList']['Comments'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['GetSessionAliasList'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
		#region Query Information
			Try
			{
				$Error.Clear()
                $CurSessionAliasList = $(Get-BluGenieCurrentSessionAliases -ErrorAction Stop)
                $CurRunSpaceAliasList = $(Get-BluGenieRunSpaceSessionAliases -ErrorAction Stop)

	        	$CurSessionInfo = $(Compare-Object -ReferenceObject $CurSessionAliasList.Name `
                                  -DifferenceObject $CurRunSpaceAliasList.Name) | 
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
								  						      Name = 'Module'
															  Expression = {
															  	$(Get-Alias -Name $_.InputObject).Source.ToString()
															  }
								  						  },
														  @{
								  						        Name = 'Version'
															    Expression = {
                                                                    $Version = $null
                                                                    $Version = $(Get-Alias -Name $_.InputObject).Version
															  	    If
                                                                    (
                                                                        $Version
                                                                    )
                                                                    {
                                                                        Return $($Version).ToString()
                                                                    }
                                                                    Else
                                                                    {
                                                                        Return ''
                                                                    }
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
				$HashReturn['GetSessionAliasList']['Comments'] += Get-ErrorAction -Clear
			}
		#endregion Query Information
		
		#region Remove Items
			If
			(
				$RemoveAll -and $(-Not $Export)
			)
			{
				$CurSessionInfo | ForEach-Object `
				-Process `
				{
					$CurAliasItem = $_
					
					Try
					{
						If
						(
							$Force
						)
						{
							$Error.Clear()
							$null = Remove-Item -Path $('Alias:\{0}' -f $CurAliasItem.Name) -Force -ErrorAction Stop
							$CurAliasItem.Status = 'Removed'
						}
						Else
						{
							If
							(
								-Not $($CoreAliasList -contains $CurAliasItem.Name)
							)
							{
								$Error.Clear()
								$null = Remove-Item -Path $('Alias:\{0}' -f $CurAliasItem.Name) -Force -ErrorAction Stop
								$CurAliasItem.Status = 'Removed'
							}
						}
					}
					Catch
					{
						$HashReturn['GetSessionAliasList']['Comments'] += Get-ErrorAction -Clear
						$CurAliasItem.Status = 'RemovedError'
					}
				}
			}
		#endregion Remove Items
		
		#region Export Session Aliases
			If
			(
				$Export
			)
			{
				$SelectedAliases = $CurSessionInfo | Select-Object -Property Name,Module,Version | Out-GridView -PassThru `
                -Title 'Select which Aliases to export' | Select-Object -ExpandProperty Name

                If
                (
                    $SelectedAliases
                )
                {
                    $CurSessionInfo | ForEach-Object `
                    -Process `
                    {
                        $CurSelAlias = $_
                        $CurSelAliasName = $CurSelAlias.Name
                        If
                        (
                            $SelectedAliases -contains $CurSelAliasName
                        )
                        {
                            $CurSelAliasSB = $(Get-Item -Path $('Alias:\{0}' -f $CurSelAliasName) -ErrorAction SilentlyContinue | 
                            Select-Object -ExpandProperty Definition) | Out-String

                            If
                            (
                                $CurSelAliasSB
                            )
                            {
                                Try
                                {
                                    $('Alias {0} {1}' -f $CurSelAliasName,'{') | Out-File -FilePath $('{0}\{1}.txt' -f $ExportPath, `
                                    $CurSelAliasName) -Force
                                    $CurSelAliasSB.Trim() | Out-File -FilePath $('{0}\{1}.txt' -f $ExportPath, $CurSelAliasName) -Append
                                    '}' | Out-File -FilePath $('{0}\{1}.txt' -f $ExportPath, $CurSelAliasName) -Append
                                    $($CurSessionInfo | Where-Object -Property 'Name' -eq $CurSelAliasName).Status = 'Exported'
                                    $($CurSessionInfo | Where-Object -Property 'Name' -eq $CurSelAliasName).Path = $ExportPath
                                }
                                Catch
                                {
                                    $HashReturn['GetSessionAliasList']['Comments'] += Get-ErrorAction -Clear
                                }
                            }
                        }
                        
                    }
                }
			}
		#endregion Export Session Aliases

        #region Export to HashTable
			$HashReturn['GetSessionAliasList']['Items'] = $CurSessionInfo
		#endregion Export to HashTable
    #endregion Main

	#region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetSessionAliasList'].EndTime = $($EndTime).DateTime
        $HashReturn['GetSessionAliasList'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

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
                                            Return $($CurSessionInfo | ConvertTo-Json -Depth 10 | ForEach-Object -Process { [regex]::Unescape($_) })
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
#endregion Get-BluGenieSessionAliasList (Function)