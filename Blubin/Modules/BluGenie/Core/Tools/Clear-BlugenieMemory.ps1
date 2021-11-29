#region Clear-BlugenieMemory (Function)
Function Clear-BlugenieMemory
{
<#
    .SYNOPSIS
        Garbage Collection in Powershell to Speed up Scripts and help lower memory consumption

    .DESCRIPTION
        Garbage Collection in Powershell to Speed up Scripts and help lower memory consumption.

    .PARAMETER All
        Description:  Clear the Console Screen, and any variables that might be holding a lot of data
        Notes: Variables that are cleared of data are ($StackTrace, Error)
        Alias: Help
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
	    Command: Clear-BlugenieMemory
        Description: Remove any garbage collected in memory
        Notes: 

    .EXAMPLE
	    Command: 1..4 | ForEach-Object -Process { Get-ChildItem -Path C:\Windows -Recurse }; CM
        Description: Run Get-ChildItem 5 times to start adding artifacts to memory, then remove any garbage collected in memory using the ( CM ) alias.
        Notes: 


    .EXAMPLE
	    Command: Clear-BlugenieMemory -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Clear-BlugenieMemory -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Clear-BlugenieMemory -OutUnEscapedJSON
        Description: <command_here> and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Clear-BlugenieMemory -ReturnObject
        Description: <command_here> and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
        Boolean

    .NOTES

        • Original Author           : 
            o    Michael Arroyo
        • Original Build Version    : 
            o    20.11.2401 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
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
            o    Convert-Size - convert a value from Bytes, KB, MB, GB, TB to [TB/GB/MB/KB/Bytes]
        • Build Version Details     :
            o 20.11.2401: * [Michael Arroyo] Posted
                                                    
#>
    [cmdletbinding()]
    [Alias('Clear-Memory','CM')]
    #region Parameters
        Param
        (
            [Switch]$All,

            [Int]$SleepTimer = 1,

            [Int]$LoopCount = 1,

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
        $HashReturn['Clear-BlugenieMemory'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['Clear-BlugenieMemory'].StartTime = $($StartTime).DateTime
        $HashReturn['Clear-BlugenieMemory']['TrackedChange'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['Clear-BlugenieMemory'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        $ObjMemoryManager = New-Object -TypeName PSObject -Property @{
            'PreMemory_CleanUp' = ''
            'PostMemory_CleanUp' = ''
        }
        $ObjMemoryManager.PreMemory_CleanUp = $(Convert-BluGenieSize -Value $(Get-Process -Id $Pid | Measure-Object WorkingSet -Sum).Sum | Select-Object -ExpandProperty String)
        
        If
        (
            $All
        )
        {
            Clear-Host
            $StackTrace = $null
            $Error.Clear()
        }

        for
        (
            $x = 1
            $x -le $LoopCount
            $x += 1) 
        {
            [System.GC]::Collect()
            Start-Sleep -Seconds $SleepTimer
        }

        $ObjMemoryManager.PostMemory_CleanUp = $(Convert-BluGenieSize -Value $(Get-Process -Id $Pid | Measure-Object WorkingSet -Sum).Sum | Select-Object -ExpandProperty String)
        $HashReturn['Clear-BlugenieMemory']['TrackedChange'] += $ObjMemoryManager
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['Clear-BlugenieMemory'].EndTime = $($EndTime).DateTime
        $HashReturn['Clear-BlugenieMemory'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
                                                            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        #region Output Type
            $ResultSet = $ObjMemoryManager

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
#endregion Clear-BlugenieMemory (Function)