#region Convert-BluGenieSize (Function)
Function Convert-BluGenieSize
{
<#
    .SYNOPSIS
        convert a value from Bytes, KB, MB, GB, TB to [TB/GB/MB/KB/Bytes]

    .DESCRIPTION
        convert a value from Bytes, KB, MB, GB, TB to [TB/GB/MB/KB/Bytes]

    .PARAMETER InputType
        Description: Source Size Type
        Notes: Default is KB
        Alias:
        ValidateSet: 'Bytes','KB','MB','GB','TB'

    .PARAMETER OutputType
        Description: Destination Size Type
        Notes: Default is MB
        Alias:
        ValidateSet: 'Bytes','KB','MB','GB','TB'

    .PARAMETER Value
        Description: The Size value to be converted
        Notes: 
        Alias:
        ValidateSet: 

    .PARAMETER Precision
        Description: Return the value of digits after the dot/decimal point
        Notes: Default is 2
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
	    Command: <Example 1 Command>
        Description: 
        Notes: 

    .EXAMPLE
	    Command: <Example 1 Command>
        Description: 
        Notes: 

    .EXAMPLE
	    Command: Convert-BluGenieSize -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Convert-BluGenieSize -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Convert-BluGenieSize -OutUnEscapedJSON
        Description: <command_here> and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Convert-BluGenieSize -ReturnObject
        Description: <command_here> and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • Original Author           : 
            o    Michael Arroyo
        • Original Build Version    : 
            o    20.11.2501 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
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
            o 20.11.2501: * [Michael Arroyo] Posted
                                                    
#>
    [cmdletbinding()]
    [Alias('Convert-Size','CSZ')]
    #region Parameters
        Param
        (
            [Parameter(Position = 0,
                       Mandatory=$true)]
            [double]$Value,

            [ValidateSet('Bytes','KB','MB','GB','TB')]
            [String]$InputType = 'KB',

            [ValidateSet('Bytes','KB','MB','GB','TB')]
            [string]$OutputType = 'MB',

            [int]$Precision = 2,

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
        $HashReturn['Convert-BluGenieSize'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['Convert-BluGenieSize'].StartTime = $($StartTime).DateTime
        $HashReturn['Convert-BluGenieSize'].ParameterSetResults = @()
        $HashReturn['Convert-BluGenieSize']['Size'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['Convert-BluGenieSize'].ParameterSetResults += $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        #region InputType
        switch
        (
            $From
        )
        {
            #region Bytes            
                'Bytes'
                {
                    $value = $Value
                }
            #endregion Bytes

            #region KB
                'KB'
                {
                    $value = $Value * 1024
                }
            #endregion KB

            #region MB
                'MB'
                {
                    $value = $Value * 1024 * 1024
                }
            #endregion MB

            #region GB
                'GB'
                {
                    $value = $Value * 1024 * 1024 * 1024
                }
            #endregion GB

            #region TB
                'TB'
                {
                    $value = $Value * 1024 * 1024 * 1024 * 1024
                }
            #endregion TB
        }      
    #endregion InputType      

        #region OutputType
            switch
            (
                $OutputType
            )
            {
                #region Bytes
                    'Bytes'
                    {
                        return $value
                    }
                #endregion Bytes

                #region KB
                    'KB'
                    {
                        $Value = $Value/1KB
                    }
                #endregion KB

                #region MB
                    'MB'
                    {
                        $Value = $Value/1MB
                    }
                #endregion MB

                #region GB
                    'GB'
                    {
                        $Value = $Value/1GB
                    }
                #endregion GB

                #region GB
                    'TB'
                    {
                        $Value = $Value/1TB
                    }
                #endregion GB
            }
        #endregion OutputType
                        
        #region Create Size Return object
        $ObjSizeValue = New-Object -TypeName psobject -Property @{
            Size = 0
            Type = $OutputType
            String = ''
        }
                        
        $ObjSizeValue.Size = [Math]::Round($value,$Precision,[MidPointRounding]::AwayFromZero)
        $ObjSizeValue.String = $('{0} {1}' -f $ObjSizeValue.Size, $ObjSizeValue.Type)
        $HashReturn['Convert-BluGenieSize']['Size'] += $ObjSizeValue
                        
        #endregion Create Size Return object
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['Convert-BluGenieSize'].EndTime = $($EndTime).DateTime
        $HashReturn['Convert-BluGenieSize'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
                                                            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        #region Output Type
            $ResultSet = $ObjSizeValue

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
#endregion Convert-BluGenieSize (Function)