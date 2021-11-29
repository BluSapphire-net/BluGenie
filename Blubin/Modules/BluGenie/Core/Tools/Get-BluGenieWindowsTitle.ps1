#region Get-BluGenieWindowsTitle (Function)
Function Get-BluGenieWindowsTitle
{
<#
    .SYNOPSIS
        Get-BluGenieWindowsTitle is a Sample Script Template with predefined Help descriptors for Invoke-WalkThrough

    .DESCRIPTION
        Invoke-WalkThrough is Dynamic Help.  It will convert the static PowerShell help into an interactive menu system
            -Added with a few new tag descriptors for (Parameter and Examples).  This information will structure the help 
            information displayed and also help with bulding  the dynamic help menu

            Example
             PARAMETER <parameter>
                Description:  Desciption of the Parameter
                Notes:        Any Notes
                Alias:        Alias if any
                ValidateSet:  ValidationSet Array Items

             EXAMPLE
                Command:     Your command string
                Description: Decription of what the command above will do
                Notes:       Any Notes

    .PARAMETER Param1
        Description:  
        Notes:  
        Alias:
        ValidateSet:  

    .PARAMETER Param2
        Description:  
        Notes:  
        Alias:
        ValidateSet: 'Item1','Item2','Item3' 

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
	    Command: <Example 1 Command>
        Description: 
        Notes: 

    .EXAMPLE
	    Command: <Example 1 Command>
        Description: 
        Notes: 

    .EXAMPLE
	    Command: <Verb-Function_Name> -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: <Verb-Function_Name> -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: <Verb-Function_Name> -OutUnEscapedJSON
        Description: <command_here> and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: <Verb-Function_Name> -ReturnObject
        Description: <command_here> and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • Original Author           : 
            o    Michael Arroyo
        • Original Build Version    : 
            o    20.05.2201 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • Latest Author             : 
            o        
        • Latest Build Version      : 
            o    
        • Comments                  :
            o    
        • PowerShell Compatibility  : 
            o    2,3,4,5.x
        • Forked Project            : 
            o    
        • Links                     :
            o    
        • Dependencies              :
            o    Invoke-WalkThrough - will convert the static PowerShell help into an interactive menu system
            o    Get-ErrorAction - Get-ErrorAction will round up any errors into a simple object
        • Build Version Details     :
            o 20.05.2201: * [Michael Arroyo] Posted
                                                    
#>
    [cmdletbinding()]
    [Alias('Get-WindowsTitle')]
    #region Parameters
        Param
        (
            [Parameter(Position=0)]
            [String]$Title = '.*',

            [Alias('Help')]
            [Switch]$Walkthrough,

            [Switch]$ReturnObject = $true,

            [Switch]$OutUnEscapedJSON,

            [ValidateSet('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV')]
            [string]$FormatView = 'None'
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
                Test-Path -Path Function:\Invoke-BluGenieWalkThrough
            )
            {
                If
                (
                    $Function -eq 'Invoke-BluGenieWalkThrough'
                )
                {
                    #Disable Invoke-BluGenieWalkThrough looping
                    Invoke-Command -ScriptBlock { Invoke-BluGenieWalkThrough -Name $Function -RemoveRun }
                    Return
                }
                Else
                {
                    Invoke-Command -ScriptBlock { Invoke-BluGenieWalkThrough -Name $Function }
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
        $HashReturn['Get-BluGenieWindowsTitle'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['Get-BluGenieWindowsTitle'].StartTime = $($StartTime).DateTime
        $HashReturn['Get-BluGenieWindowsTitle']['Titles'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['Get-BluGenieWindowsTitle'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        $HashReturn['Get-BluGenieWindowsTitle']['Titles'] = $(Get-Process | Where-Object -FilterScript { $_.mainWindowTItle -and $_.mainWindowTItle -match $Title } | Select-Object -Property Id,Name,MainWindowHandle,MainWindowTitle)
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['Get-BluGenieWindowsTitle'].EndTime = $($EndTime).DateTime
        $HashReturn['Get-BluGenieWindowsTitle'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
                                                            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        #region Output Type
            $ResultSet = $HashReturn['Get-BluGenieWindowsTitle']['Titles']

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
        				                Return $($ResultSet | Format-Table -AutoSize -Wrap)
        			                }
        		                #endregion Table

                                #region CSV
        			                'CSV'
        			                {
        				                Return $($ResultSet | ConvertTo-Csv -NoTypeInformation)
        			                }
        		                #endregion CSV

                                #region CustomModified
        			                'CustomModified'
        			                {
        				                Return $($ResultSet | Format-Custom | Out-String) -replace '}\s\s','},' `
                                        -replace '\sclass\s.*\s'
        			                }
        		                #endregion CustomModified

                                #region Custom
        			                'Custom'
        			                {
        				                Return $($ResultSet | Format-Custom)
        			                }
        		                #endregion Custom

                                #region JSON
        			                'JSON'
        			                {
                                        Try
                                        {
                                            $null = Get-Command -Name ConvertTo-Json -ErrorAction Stop
                                            Return $($ResultSet | ConvertTo-Json -Depth 10)
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
                                            Return $($ResultSet | ConvertTo-Json -Depth 10 | ForEach-Object `
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
        			                    Return $ResultSet
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
#endregion Get-BluGenieWindowsTitle (Function)