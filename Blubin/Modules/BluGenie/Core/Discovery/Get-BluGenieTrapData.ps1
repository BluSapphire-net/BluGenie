#region Get-BluGenieTrapData (Function)
Function Get-BluGenieTrapData
{
<#
    .SYNOPSIS
        Get-BluGenieTrapData will report back any captured BluGenie trap logs.  Functions as follows
            * List - Display a list of all the Blugenie Logs captured on the remote machine
            * Path - Specificy a path to query for Blugenie Logs (By defautl this is %SystemDrive%\Windows\Temp)
            * FileName - Specifically select which file you want to report on (By default the last file created is picked).  The file name can be picked using RegEx.
            * JobID - Specify which file you want to remote on using the Job ID (Be default this is the last log created with the Job ID specified.  You can have more then one log with the same Job ID)
            * Remove - Remove a Specific log file
            * RemoveAll - Remove BluGenie log files including the Debugging Log files
            * Overwrite - Return the current JSON Job data to look just like the Trapped Log data for easier reporting and parsing

    .DESCRIPTION
        Invoke-WalkThrough is Dynamic Help.  It will convert the static PowerShell help into an interactive menu system
            -Added with a few new tag descriptors for (Parameter and Examples).  This information will structure the help 
            information displayed and also help with bulding  the dynamic help menu

    .PARAMETER Path
        Description:  Path to the BG*.log files.
        Notes: Default is set to $ENV:Systemdrive\Windows\Temp
        Alias:
        ValidateSet:  

    .PARAMETER FileName
        Description:  Specify which file to pull
        Notes:  You can determine what log files are saved using the -List parameter
        Alias:
        ValidateSet:

    .PARAMETER JobID
        Description:  Specify the Job ID
        Notes:  The last file created with the Job ID specified will be the information returned
        Alias:
        ValidateSet:

    .PARAMETER List
        Description:  List all the BG*.log files
        Notes:  You can return just file File Names, LastWriteTime, and Size by using the -ReturnObject parameter
        Alias:
        ValidateSet:

    .PARAMETER Remove
        Description:  Remove the file specified or the last know log file found
        Notes:  
        Alias:
        ValidateSet:

    .PARAMETER RemoveAll
        Description:  Remove all BG*.log files
        Notes:  
        Alias:
        ValidateSet:

    .PARAMETER Overwrite
        Description:  Flag used to return the Trapped data as the original return in BluGenie
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
        Notes: By default the data is returned as a Hash Table
        Alias: 
        ValidateSet: 

    .PARAMETER OutUnEscapedJSON
        Description: Remove UnEsacped Char from the JSON information.
        Notes: This will beautify json and clean up the formatting.
        Alias: 
        ValidateSet: 

    .EXAMPLE
	    Command: Get-BluGenieTrapData -List
        Description: List all BluGenie log files from the default location $ENV:SystemDrive\Windows\Temp
        Notes: 

    .EXAMPLE
	    Command: Get-TrapData -path '\\win7sp1001\c$\Windows\Temp' -ReturnObject -List
        Description: List all BluGenie log files from a remote systems log location.  Return on the Name, File Size, and LastWriteTime
        Notes:
        
    .EXAMPLE
	    Command: Get-BluGenieTrapData
        Description: Return the last written log file from the default log location
        Notes:
        
    .EXAMPLE
	    Command: Get-BluGenieTrapData -path '\\win7sp1001\c$\Windows\Temp' -ReturnObject -Remove
        Description: Return the last written log file data in an object format and, remove the file from disk
        Notes:
        
    .EXAMPLE
	    Command: Get-BluGenieTrapData -Remove -List
        Description: Remove all items that are found
        Notes:

     .EXAMPLE
	    Command: Get-BluGenieTrapData -RemoveAll -List
        Description: Remove all items that are found
        Notes:

    .EXAMPLE
	    Command: Get-BluGenieTrapData -path '\\win7sp1001\c$\Windows\Temp' -Remove
        Description: Remove the file on disk after grabbing the trapped data
        Notes:

    .EXAMPLE
	    Command: Get-BluGenieTrapData -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieTrapData -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieTrapData -OutUnEscapedJSON
        Description: <command_here> and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Get-BluGenieTrapData -ReturnObject
        Description: <command_here> and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • Original Author           : 
            o    Michael Arroyo
        • Original Build Version    : 
            o    20.07.0601
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
            o 20.07.0601: * [Michael Arroyo] Posted
                                                    
#>
    [cmdletbinding()]
    [Alias('Get-TrapData')]
    #region Parameters
        Param
        (
            [Parameter(Position=0)]
            [String]$Path = $('{0}\Windows\Temp' -f $env:SystemDrive),

            [Parameter(Position=1)]
            [String]$FileName,

            [String]$JobID,

            [Switch]$List,

            [Switch]$Remove,

            [Switch]$RemoveAll,

            [Switch]$OverWrite,

            [Alias('Help')]
            [Switch]$Walkthrough,

            [Switch]$ReturnObject,

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

    #region Update Path
        If
        (
            -Not $($Path -match '.*\\$')
        )
        {
            $Path = $('{0}\' -f $Path)
        }
    #endregion Update Path

    #region Create Return hash
        $HashReturn = @{}
        $HashReturn['GetBluGenieTrapData'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetBluGenieTrapData'].StartTime = $($StartTime).DateTime
        $HashReturn['GetBluGenieTrapData']['JobList'] = @()
        $HashReturn['GetBluGenieTrapData']['JobData'] = @()
        $HashReturn['GetBluGenieTrapData']['SelectedFile'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['GetBluGenieTrapData'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        Switch
        (
            $Null
        )
        {
            {$FileName -and $($List -eq $false)}
            {
                $CurTrapFileName = Get-ChildItem -Path $Path | Where-Object -FilterScript { $_.Name -Match $FileName } | Sort-Object LastWriteTime | Select-Object -Last 1

                Try
                {
                    $HashReturn['GetBluGenieTrapData']['JobData'] += $CurTrapFileName | Get-Content | ConvertFrom-Json -ErrorAction Stop
                }
                Catch
                {
                    If
                    (
                        $Error
                    )
                    {
                        $Error.RemoveAt(-0)
                    }

                    $HashReturn['GetBluGenieTrapData']['JobData'] += $CurTrapFileName | Import-Clixml -ErrorAction Stop
                }

                Switch
                (
                    $null
                )
                {
                    {$Remove -eq $true}
                    {
                        If
                        (
                            $CurTrapFileName
                        )
                        {
                            $Null = Remove-Item -Path $CurTrapFileName.FullName -Force -ErrorAction SilentlyContinue
                        }
                    }

                    {$RemoveAll -eq $true}
                    {
                        $Null = Get-ChildItem -Path $Path | Where-Object -FilterScript { $_.Name -Match '^BG.*\.log$' } | Remove-Item -Force -ErrorAction SilentlyContinue
                    }
                }
                
                break
            }

            {$JobID -and $($List -eq $false)}
            {
                $CurTrapFileName = Get-ChildItem -Path $Path | Where-Object -FilterScript { $($_.Name -Match '^BG{0}.*\.log$' -f $JobID) } | Sort-Object LastWriteTime | Select-Object -Last 1

                Try
                {
                    $HashReturn['GetBluGenieTrapData']['JobData'] += $CurTrapFileName | Get-Content | ConvertFrom-Json -ErrorAction Stop
                }
                Catch
                {
                    If
                    (
                        $Error
                    )
                    {
                        $Error.RemoveAt(-0)
                    }

                    $HashReturn['GetBluGenieTrapData']['JobData'] += $CurTrapFileName | Import-Clixml -ErrorAction Stop
                }

                Switch
                (
                    $null
                )
                {
                    {$Remove -eq $true}
                    {
                        If
                        (
                            $CurTrapFileName
                        )
                        {
                            $Null = Remove-Item -Path $CurTrapFileName.FullName -Force -ErrorAction SilentlyContinue
                        }
                    }

                    {$RemoveAll -eq $true}
                    {
                        $Null = Get-ChildItem -Path $Path | Where-Object -FilterScript { $_.Name -Match '^BG.*\.log$' } | Remove-Item -Force -ErrorAction SilentlyContinue
                    }
                }

                break
            }

            {$List -eq $true}
            {
                $CurTrapFileName = Get-ChildItem -Path $Path | Where-Object -FilterScript { $($_.Name -Match '^BG{0}.*\.log$' -f $JobID) } | Select-Object -Property Name,
                    @{
                        Name = 'LastWriteTime' 
                        Expression = { $_.LastWriteTime.ToString() }
                    },
                    @{
                        Name = 'Size'
                        Expression = {
                            if ($_.Length -ge 1GB)
                            {
                                '{0:F2} GB' -f ($_.Length / 1GB)
                            }
                            elseif ($_.Length -ge 1MB)
                            {
                                '{0:F2} MB' -f ($_.Length / 1MB)
                            }
                            elseif ($_.Length -ge 1KB)
                            {
                                '{0:F2} KB' -f ($_.Length / 1KB)
                            }
                            else
                            {
                                '{0} bytes' -f $_.Length
                            }
                        }
                    }

                $HashReturn['GetBluGenieTrapData']['JobList'] += $CurTrapFileName

                Switch
                (
                    $null
                )
                {
                    {$Remove -eq $true}
                    {
                        $Null = Get-ChildItem -Path $Path | Where-Object -FilterScript { $_.Name -Match '^BG.*\.log$' } | Remove-Item -Force -ErrorAction SilentlyContinue
                    }

                    {$RemoveAll -eq $true}
                    {
                        $Null = Get-ChildItem -Path $Path | Where-Object -FilterScript { $_.Name -Match '^BG.*\.log$' } | Remove-Item -Force -ErrorAction SilentlyContinue
                    }
                }

                break
            }

            Default
            {
                $CurTrapFileName = Get-ChildItem -Path $Path | Where-Object -FilterScript { $_.Name -Match '^BG.*\.log$' } | Sort-Object LastWriteTime | Select-Object -Last 1

                Try
                {
                    $HashReturn['GetBluGenieTrapData']['JobData'] += $CurTrapFileName | Get-Content | ConvertFrom-Json -ErrorAction Stop
                }
                Catch
                {
                    If
                    (
                        $Error
                    )
                    {
                        $Error.RemoveAt(-0)
                    }

                    $HashReturn['GetBluGenieTrapData']['JobData'] += $CurTrapFileName | Import-Clixml -ErrorAction Stop
                }

                Switch
                (
                    $null
                )
                {
                    {$Remove -eq $true}
                    {
                        If
                        (
                            $CurTrapFileName
                        )
                        {
                            $Null = Remove-Item -Path $CurTrapFileName.FullName -Force -ErrorAction SilentlyContinue
                        }
                    }

                    {$RemoveAll -eq $true}
                    {
                        $Null = Get-ChildItem -Path $Path | Where-Object -FilterScript { $_.Name -Match '^BG.*\.log$' } | Remove-Item -Force -ErrorAction SilentlyContinue
                    }
                }
            }
        }

        If
        (
            $HashReturn['GetBluGenieTrapData']['JobData'].Count -gt 0
        )
        {
            $HashReturn['GetBluGenieTrapData']['SelectedFile'] += $CurTrapFileName | Select-Object -Property FullName,
                    @{
                        Name = 'LastWriteTime' 
                        Expression = { $_.LastWriteTime.ToString() }
                    },
                    @{
                        Name = 'Size'
                        Expression = {
                            if ($_.Length -ge 1GB)
                            {
                                '{0:F2} GB' -f ($_.Length / 1GB)
                            }
                            elseif ($_.Length -ge 1MB)
                            {
                                '{0:F2} MB' -f ($_.Length / 1MB)
                            }
                            elseif ($_.Length -ge 1KB)
                            {
                                '{0:F2} KB' -f ($_.Length / 1KB)
                            }
                            else
                            {
                                '{0} bytes' -f $_.Length
                            }
                        }
                    }
        }
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['GetBluGenieTrapData'].EndTime = $($EndTime).DateTime
        $HashReturn['GetBluGenieTrapData'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
                                                            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        #region Output Type
            $ResultSet = #'Update with Object or Array of Objects'

        	switch
        	(
        		$Null
        	)
        	{
        		#region Beatify the JSON return and not Escape any Characters
        	        { $OutUnEscapedJSON }
        			{
        				Return $($HashReturn | ConvertTo-Json -Depth 20 | ForEach-Object -Process { [regex]::Unescape($_) })
        			}
        		#endregion Beatify the JSON return and not Escape any Characters
        				
        		#region Return a PowerShell Object
        			{ $ReturnObject }
        			{
                        #region Determine what data gets returned
                            If
                            (
                                $List
                            )
                            {
                                $ReturningObject = $HashReturn['GetBluGenieTrapData']['JobList']
                            }
                            Else
                            {
                                $ReturningObject = $HashReturn['GetBluGenieTrapData']['JobData']
                            }
                        #endregion Determine what data gets returned

        				#region Switch FormatView
        	                switch 
                            (
                                $FormatView
                            )
        	                {
        		                #region Table
        			                'Table'
        			                {
        				                Return $($ReturningObject | Format-Table -AutoSize -Wrap)
        			                }
        		                #endregion Table

                                #region CSV
        			                'CSV'
        			                {
        				                Return $($ReturningObject | ConvertTo-Csv -NoTypeInformation)
        			                }
        		                #endregion CSV

                                #region CustomModified
        			                'CustomModified'
        			                {
        				                Return $($ReturningObject | Format-Custom | Out-String) -replace '}\s\s','},' `
                                        -replace '\sclass\s.*\s'
        			                }
        		                #endregion CustomModified

                                #region Custom
        			                'Custom'
        			                {
        				                Return $($ReturningObject | Format-Custom)
        			                }
        		                #endregion Custom

                                #region JSON
        			                'JSON'
        			                {
                                        Try
                                        {
                                            $null = Get-Command -Name ConvertTo-Json -ErrorAction Stop
                                            Return $($ReturningObject | ConvertTo-Json -Depth 20)
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
                                            Return $($ReturningObject | ConvertTo-Json -Depth 20 | ForEach-Object `
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
        			                    Return $ReturningObject
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
#endregion Get-BluGenieTrapData (Function)