#region Invoke-BluGenieThreadLock (Function)
Function Invoke-BluGenieThreadLock
{
<#
    .SYNOPSIS
        Create a named Mutex

    .DESCRIPTION
        With a named mutex, we can specify a mutex with a name on one process and then tell it to take the mutex and on another process 
        (yes, another PowerShell console would work) and call the same named mutex and if we attempt to take the mutex, it will create 
        a blocking call until the other process relinquishes control of it. What this allows us to do is have multiple processes that 
        can write to a single file without fear of missing data due to the file being locked.

    .PARAMETER Name
        Description: Name of the Mutex
        Notes:  
        Alias:
        ValidateSet:  

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:  
        Alias: Help
        ValidateSet: 

    .EXAMPLE
	    Command: $mtx = Invoke-BluGenieMutux -Name Log
                 $mtx.WaitOne()
                 'other important data' | Out-File C:\importantlogfile.txt -Append
                 $mtx.ReleaseMutex()

        Description: Create Mutux Threading to lock Logging file. 
        Notes: 

    ..EXAMPLE
	    Command: $mtx = Invoke-BluGenieMutux -Name Log
                 $mtx.WaitOne(1000)
                 'other important data' | Out-File C:\importantlogfile.txt -Append
                 $mtx.ReleaseMutex()

        Description: Create Mutux Threading with a 1000 second timeout. 
        Notes: 

    .EXAMPLE
	    Command: <Verb-Function_Name> -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: <Verb-Function_Name> -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .OUTPUTS
        TypeName: System.Threading.Mutex

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
            o    https://www.lieben.nu/liebensraum/2017/08/powershell-lock-function/
        • Dependencies              :
            o    Invoke-WalkThrough - will convert the static PowerShell help into an interactive menu system
            o    Get-ErrorAction - Get-ErrorAction will round up any errors into a simple object
        • Build Version Details     :
            o 20.11.2501: * [Michael Arroyo] Posted
                                                    
#>
    
    [CmdletBinding(DefaultParameterSetName='Show',
                   ConfirmImpact='Low')]
    [Alias('Invoke-ThreadLock','ThreadLock')]
    #region Parameters
        Param
        (
            [Parameter(ParameterSetName='Default')]
            [switch]$setLock,

            [Parameter(ParameterSetName='Release')]
            [switch]$releaseLock,

            [Parameter(ParameterSetName='Default',
                       Position=1)]
            [Parameter(ParameterSetName='Release',
                       Position=1)]
            [string]$lockName = 'ThreadLock',

            [Parameter(ParameterSetName='Default')]
            [Parameter(ParameterSetName='Release')]
            [int]$timeOut = 600,

            [Parameter(ParameterSetName='Default')]
            [Parameter(ParameterSetName='Release')]
            [string]$GlobalName = 'MyLock',

            [Parameter(ParameterSetName='Show')]
            [switch]$ShowLocks,

            [Parameter(ParameterSetName='Show')]
            [Parameter(ParameterSetName='Default')]
            [Parameter(ParameterSetName='Release')]
            [Alias('Help')]
            [Switch]$Walkthrough
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

    #region Main
        Switch
        (
            $Null
        )
        {
            #region register a thread lock
                {$setLock}
                {
                    Try
                    {
                        New-Variable -Name $('TThread_{0}_{1}' -f $GlobalName, $lockName) -Value $(New-Object System.Threading.Mutex($false, $lockName)) -Scope Global -ErrorAction Stop
                        Invoke-Expression -Command $('$global:TThread_{0}_{1} | Add-Member -MemberType NoteProperty -Name "GlobalName" -Value "{0}" -Force' -f $GlobalName, $lockName)
                        Invoke-Expression -Command $('$global:TThread_{0}_{1} | Add-Member -MemberType NoteProperty -Name "LockName" -Value "{1}" -Force' -f $GlobalName, $lockName)
                    }
                    Catch
                    {
                        #Do Nothing
                    }

                    $waited = 0
                    while
                    (
                        $true
                    )
                    {
                        try
                        {
                            $lockState = Invoke-Expression -Command $('$global:TThread_{0}_{1}.WaitOne(1000)' -f $GlobalName, $lockName)
                        }
                        catch
                        {
                            $lockState = $False
                        }

                        if
                        (
                            $lockState
                        )
                        {
                            break
                        }
                        else
                        {
                            $waited += 1
                            if
                            (
                                $waited -gt $timeOut
                            )
                            {
                                Write-Error -Exception "Failed to get a thread within $timeOut seconds!"
                            }
                        }
                    }

                    break
                }
            #endregion register a thread lock

            #region release lock
                {$releaseLock}
                {
                    Try
                    {
                        If
                        (
                            Test-Path -Path $('Variable:\TThread_{0}_{1}' -f $GlobalName, $lockName)
                        )
                        {
                            $Null = Invoke-Expression -Command $('$global:TThread_{0}_{1}.ReleaseMutex()' -f $GlobalName, $lockName)
                            Write-Host $('Released Tracked Thread ( TThread_{0}_{1} )' -f $GlobalName, $lockName)
                            $null = Remove-Variable -Name ('TThread_{0}_{1}' -f $GlobalName, $lockName) -Scope Global -Force
                        }
                        Else
                        {
                            Write-Host "No Tracked Threads Exist with that Global and Lock Name`n`n" -ForegroundColor Red
                            Write-Host "Tracked Threads`n" -ForegroundColor Yellow
                            Get-Variable -Scope Global | Where-Object -FilterScript { $_.Name -match '^TThread_' }
                        }
                        
                    }
                    Catch
                    {
                        If
                        (
                            $Error[0]
                        )
                        {
                            $Error.RemoveAt('0')
                        }

                        Write-Host 'Nothing to release'
                    }

                    break
                }
            #endregion release lock

            #region Default / ShowLocks
                Default
                {
                    If
                    (
                        Get-Variable -Scope Global | Where-Object -FilterScript { $_.Name -match '^TThread_' }
                    )
                    {
                        Write-Host "Tracked Threads`n" -ForegroundColor Yellow
                        Get-Variable -Scope Global | Where-Object -FilterScript { $_.Name -match '^TThread_' } | Select-Object -Property Name,
                                                                                                                                         @{
                                                                                                                                            Name = 'GlobalName'
                                                                                                                                            Expression = {$($_.Name -split '_')[1]}
                                                                                                                                         },
                                                                                                                                         @{
                                                                                                                                            Name = 'LockName'
                                                                                                                                            Expression = {$($_.Name -split '_')[2]}
                                                                                                                                         },
                                                                                                                                         Value
                    }
                    Else
                    {
                        Write-Host 'Nothing to track'
                    }
                }
            #endregion Default / ShowLocks
    }
    #endregion Main
}
#endregion Invoke-BluGenieThreadLock (Function)