#region Start-BluGenieNewProcess (Function)
Function Start-BluGenieNewProcess
{
<#
    .SYNOPSIS
        Start-BluGenieNewProcess is similar to Start-Process but can capture all Standard Output

    .DESCRIPTION
        Start-BluGenieNewProcess is similar to Start-Process but can capture all Standard Output while keeping the screen hidden

    .PARAMETER FileName
        Description: The Path and Filename of the process
        Notes:  
        Alias:
        ValidateSet:  

    .PARAMETER Arguments
        Description: Process arguments
        Notes:  
        Alias:
        ValidateSet: 
		
	.PARAMETER WorkingDirectory
        Description: Working direcotry for the started process
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
	    Command: Start-BluGenieNewProcess ping.exe 'localhost'
        Description: Start a process and capture the Standard Output using the default parameter position
        Notes: 
			- Sample Output -
				FileName         : ping.exe                                                 
				Arguments        : localhost                                                
				WorkingDirectory :                                                          
				StdOut           :                                                          
				                   Pinging Computer1 [::1] with 32 bytes of data:
				                   Reply from ::1: time<1ms                                 
				                   Reply from ::1: time<1ms                                 
				                   Reply from ::1: time<1ms                                 
				                   Reply from ::1: time<1ms                                 
				                                                                            
				                   Ping statistics for ::1:                                 
				                       Packets: Sent = 4, Received = 4, Lost = 0 (0% loss), 
				                   Approximate round trip times in milli-seconds:           
				                       Minimum = 0ms, Maximum = 0ms, Average = 0ms          
									   
	.EXAMPLE
	    Command: Start-BluGenieNewProcess -FileName 'ping.exe' -Arguments 'localhost' | Select-Object -ExpandProperty StdOut
	    Description: Start a process and only capture the Standard Output
	    Notes: 			
		
	.EXAMPLE
	    Command: Start-BluGenieNewProcess -FileName 'ping.exe' -Arguments 'localhost'
	    Description: Start a process and capture the Standard Output using the parameter names
	    Notes: 

    .EXAMPLE
	    Command: Start-BluGenieNewProcess -FileName 'ping.exe' -Arguments 'localhost' -WorkingDirectory 'C:\Windows\System32'
        Description: Start a process from a specfic Working Directory
        Notes: 
		
	.EXAMPLE
	    Command: Start-BluGenieNewProcess -FileName 'ping.exe' -Arguments 'localhost' -ReturnObject:$false
	    Description: Start a process and capture the Standard Output and Return Output as a Hash Table
	    Notes: 
		
    .EXAMPLE
	    Command: Start-BluGenieNewProcess -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Start-BluGenieNewProcess -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Start-BluGenieNewProcess -FileName 'ping.exe' -Arguments 'localhost' -OutUnEscapedJSON
        Description: Start a process and capture the Standard Output and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Start-BluGenieNewProcess -FileName 'ping.exe' -Arguments 'localhost' -ReturnObject
        Description: Start a process and capture the Standard Output and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  This is the default

    .OUTPUTS
        TypeName: System.Object

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 2004.2301
        * Latest Author             : 
        * Latest Build Version      : 
        * Comments                  :
        * Dependencies              :
                                        ~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
        * Build Version Details     :
                                        ~ 1911.2301: * [Michael Arroyo] Posted
                                        ~ 2004.2301: * [Michael Arroyo] Updated the WindowStyle property to --> 'Hidden'
                                                     * [Michael Arroyo] Updated the CreateNoWindow property to --> $true
#>
    [cmdletbinding()]
    [Alias('Start-NewProcess')]
    Param
    (
        [Parameter(Position=0)]
        [String]$FileName,

        [Parameter(Position=1)]
        [String]$Arguments,
		
		[Parameter(Position=2)]
        [String]$WorkingDirectory,

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
        $HashReturn['StartNewProcess'] = @{}
        $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['StartNewProcess'].StartTime = $($StartTime).DateTime
        $HashReturn['StartNewProcess']['Process'] = @()
    #endregion Create Return hash

    #region Parameter Set Results
        $HashReturn['StartNewProcess'].ParameterSetResults = $PSBoundParameters
    #endregion Parameter Set Results

    #region Main
        $ProcessInfo = New-Object System.Diagnostics.ProcessStartInfo
		$ProcessInfo.FileName = $FileName
		$ProcessInfo.RedirectStandardError = $true
		$ProcessInfo.RedirectStandardOutput = $true
		$ProcessInfo.UseShellExecute = $false
		$ProcessInfo.Arguments = $Arguments
		$ProcessInfo.WorkingDirectory = $WorkingDirectory
		$Process = New-Object System.Diagnostics.Process
		$Process.StartInfo = $ProcessInfo
        $Process.StartInfo.WindowStyle = 'Hidden'
        $Process.StartInfo.CreateNoWindow = $true
		$Process.Start() | Out-Null
		$Process.WaitForExit()
		$output = $Process.StandardOutput.ReadToEnd()
		
		$ProcessReturn = New-Object -TypeName PSObject -Property @{
			FileName = $FileName
			Arguments = $Arguments
			WorkingDirectory = $WorkingDirectory
			StdOut = $output
		}
		
		$HashReturn['StartNewProcess']['Process'] += $ProcessReturn
    #endregion Main

    #region Output
        $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
        $HashReturn['StartNewProcess'].EndTime = $($EndTime).DateTime
        $HashReturn['StartNewProcess'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

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
						Return $ProcessReturn
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
#endregion Start-BluGenieNewProcess (Function)