#region Test-BluGenieIsMutexAvailable (Function)
Function Test-BluGenieIsMutexAvailable
{
<#
    .SYNOPSIS
        Wait, up to a timeout value, to check if current thread is able to acquire an exclusive lock on a system mutex.

    .DESCRIPTION
        A mutex can be used to serialize applications and prevent multiple instances from being opened at the same time.
        Wait, up to a timeout (default is 1 millisecond), for the mutex to become available for an exclusive lock.

    .PARAMETER MutexName
        Description: The name of the system mutex. 
        Notes:  
        Alias:
        ValidateSet:  

    .PARAMETER MutexWaitTime
        Description: The number of milliseconds the current thread should wait to acquire an exclusive lock of a named mutex. 
        Notes:  Default is: 1 millisecond.
                A wait time of -1 milliseconds means to wait indefinitely. A wait time of zero does not acquire an exclusive lock but instead 
                tests the state of the wait handle and returns immediately. 
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
	    Command: Test-BluGenieIsMutexAvailable -MutexName 'ThreadLock' -MutexWaitTimeInMilliseconds 100000
        Description: Check to see if Mutex 'ThreadLock' is available.  Continue to wait for 1 min if the process is locked.
        Notes: 

    .EXAMPLE
	    Command: Test-IsMutexAvailable -MutexName 'ThreadLock' -MutexWaitTimeInMilliseconds (New-TimeSpan -Minutes 5).TotalMilliseconds
        Description: Use the Alias to check to see if Mutex 'ThreadLock' is available.  
        Notes: Use the New-TimeSpan function to give you the results of 5 minutes in milliseconds

    .EXAMPLE
	    Command: Test-BluGenieIsMutexAvailable -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
                    Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Test-BluGenieIsMutexAvailable -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
                    Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Test-BluGenieIsMutexAvailable -OutUnEscapedJSON
        Description: <command_here> and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Test-BluGenieIsMutexAvailable -ReturnObject
        Description: <command_here> and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • Original Author           : 
            o    Michael Arroyo
        • Original Build Version    : 
            o    20.11.2701 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • Latest Author             : 
            o        
        • Latest Build Version      : 
            o    
        • Comments                  :
            o    
        • PowerShell Compatibility  : 
            o    2,3,4,5.x
        • Forked Project            : 
            o    https://www.powershellgallery.com/packages/PSTerraform
        • Links                     :
            o    http://msdn.microsoft.com/en-us/library/aa372909(VS.85).asp
            o    http://psappdeploytoolkit.com
            o    https://www.powershellgallery.com/packages/PSTerraform
        • Dependencies              :
            o    Invoke-BluGenieWalkThrough - will convert the static PowerShell help into an interactive menu system
            o    Invoke-WalkThrough - will convert the static PowerShell help into an interactive menu system
            o    Get-BluGenieErrorAction - Get-ErrorAction will round up any errors into a simple object
            o    Get-ErrorAction - Get-ErrorAction will round up any errors into a simple object
            o    Invoke-BluGenieThreadLock - Create a named Mutex
            o    Invoke-ThreadLock - Create a named Mutex
        • Build Version Details     :
            o 20.11.2701: * [Michael Arroyo] Posted
                                                    
#>
    [cmdletbinding()]
    [Alias('Test-IsMutexAvailable','IsMutexAvailable')]
    #region Parameters
        Param
        (
            [ValidateLength(1,260)]
            [string]$MutexName = 'ThreadLock',
            
            [ValidateScript({($_ -ge -1) -and ($_ -le [int32]::MaxValue)})]
            [int32]$MutexWaitTimeInMilliseconds = 1,

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
        $HashReturn['TestIsMutexAvailable'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['TestIsMutexAvailable'].StartTime = $($StartTime).DateTime
        $HashReturn['TestIsMutexAvailable'].ParameterSetResults = @()
        $HashReturn['TestIsMutexAvailable']['IsMutexFree'] = $true
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['TestIsMutexAvailable'].ParameterSetResults += $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        #region Initialize Variables
            [timespan]$MutexWaitTime = [timespan]::FromMilliseconds($MutexWaitTimeInMilliseconds)

            If
            (
                $MutexWaitTime.TotalMinutes -ge 1
            )
            {
                [string]$WaitLogMsg = "$($MutexWaitTime.TotalMinutes) minute(s)"
            }
            ElseIf
            (
                $MutexWaitTime.TotalSeconds -ge 1
            )
            {
                [string]$WaitLogMsg = "$($MutexWaitTime.TotalSeconds) second(s)"
            }
            Else
            {
                [string]$WaitLogMsg = "$($MutexWaitTime.Milliseconds) millisecond(s)"
            }
            
            [boolean]$IsUnhandledException = $false
            [boolean]$IsMutexFree = $false
            [Threading.Mutex]$OpenExistingMutex = $null
        #endregion Initialize Variables

        #region Check Mutex
            Write-Verbose "Check to see if mutex [$MutexName] is available. Wait up to [$WaitLogMsg] for the mutex to become available."
            Try
            {
                ## Using this variable allows capture of exceptions from .NET methods. Private scope only changes value for current function.
                $private:previousErrorActionPreference = $ErrorActionPreference
                $ErrorActionPreference = 'Stop'
                
                ## Open the specified named mutex, if it already exists, without acquiring an exclusive lock on it. If the system mutex does not 
                ## exist, this method throws an exception instead of creating the system object.
                [Threading.Mutex]$OpenExistingMutex = [Threading.Mutex]::OpenExisting($MutexName)

                ## Attempt to acquire an exclusive lock on the mutex. Use a Timespan to specify a timeout value after which no further attempt is 
                ## made to acquire a lock on the mutex.
                $IsMutexFree = $OpenExistingMutex.WaitOne($MutexWaitTime, $false)
            }
            Catch [Threading.WaitHandleCannotBeOpenedException]
            {
                ## The named mutex does not exist
                $IsMutexFree = $true
            }
            Catch [ObjectDisposedException]
            {
                ## Mutex was disposed between opening it and attempting to wait on it
                $IsMutexFree = $true
            }
            Catch [UnauthorizedAccessException]
            {
                ## The named mutex exists, but the user does not have the security access required to use it
                $IsMutexFree = $false
            }
            Catch [Threading.AbandonedMutexException]
            {
                ## The wait completed because a thread exited without releasing a mutex. This exception is thrown when one thread acquires a 
                ## mutex object that another thread has abandoned by exiting without releasing it.
                $IsMutexFree = $true
            }
            Catch
            {
                $IsUnhandledException = $true
                ## Return $true, to signify that mutex is available, because function was unable to successfully complete a check due to an 
                ## unhandled exception. Default is to err on the side of the mutex being available on a hard failure.
                Write-Verbose "Unable to check if mutex [$MutexName] is available due to an unhandled exception. Will default to return value of 
                [$true]."
                $IsMutexFree = $true
            }
            Finally
            {
                If
                (
                    $IsMutexFree
                )
                {
                    If
                    (
                        -not $IsUnhandledException
                    )
                    {
                        Write-Verbose "Mutex [$MutexName] is available for an exclusive lock."
                    }
                }
                Else
                {
                    Write-Verbose "Mutex [$MutexName] is not available because another thread already has an exclusive lock on it."
                }
                
                If
                (
                    ($null -ne $OpenExistingMutex) -and ($IsMutexFree)
                )
                {
                    ## Release exclusive lock on the mutex
                    $null = $OpenExistingMutex.ReleaseMutex()
                    $OpenExistingMutex.Close()
                }

                If
                (
                    $private:previousErrorActionPreference
                )
                {
                    $ErrorActionPreference = $private:previousErrorActionPreference
                }
            }

            $HashReturn['TestIsMutexAvailable']['IsMutexFree'] = $IsMutexFree
        #endregion Check Mutex
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['TestIsMutexAvailable'].EndTime = $($EndTime).DateTime
        $HashReturn['TestIsMutexAvailable'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
                                                            | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

        #region Output Type
            $ResultSet = $IsMutexFree

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
#endregion Test-BluGenieIsMutexAvailable (Function)