#region Set-BluGenieProcessCPUAffinity (Function)
Function Set-BluGenieProcessCPUAffinity
{
<#
    .SYNOPSIS
        Set the Processor affinity of a running Process.

    .DESCRIPTION
        Set the Processor affinity for a running Process by specifying the CPU Cores that it can run on, and the name or PID of a Process(s).

    .PARAMETER ID
        Description: The Process ID for the Process(es) to Set Affinity. 
        Notes:  
        Alias:
        ValidateSet:  

    .PARAMETER Name
        Description: The Process Name for the Process(es) to Set Affinity.
        Notes:  
        Alias:
        ValidateSet: 
        
    .PARAMETER Cores
        Description: The cores that are allowed to run the Process.
        Notes:  Separate each chosen core with a comma e.g. 1,3.
                Omit Parameter to set affinity to 100% CPU Cores.
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
		
    .PARAMETER FormatView
		Description: Select which format to return the object data in.
		Notes: Default value is set to (None).  This value is only valid when using the -ReturnObject parameter
		Alias:
		ValidateSet: 'Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV'

    .EXAMPLE
	    Command: Set-BluGenieProcessCPUAffinity -Cores 2 -PID 468
        Description: This will Set the CPU Affinity for the process ID for Chrome to Core 2
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieProcessCPUAffinity -Cores 1,3,4 -Name "Chrome"
        Description: This will Set the CPU Affinity for the process named Chrome to Core 1,3 and 4
        Notes: 
        
    .EXAMPLE
	    Command: Set-BluGenieProcessCPUAffinity -Name "Explorer"
        Description: This will Set the CPU Affinity for the process named Explorer to all available Cores
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieProcessCPUAffinity -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
               Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Set-BluGenieProcessCPUAffinity -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
               Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Set-BluGenieProcessCPUAffinity -OutUnEscapedJSON
        Description: <command_here> and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Set-BluGenieProcessCPUAffinity -ReturnObject
        Description: <command_here> and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
		
	.EXAMPLE
	    Command: Set-BluGenieProcessCPUAffinity -ReturnObject -FormatView JSON
        Description: <command_here> and Return Object formatted in a JSON view
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
		
	.EXAMPLE
	    Command: Set-BluGenieProcessCPUAffinity -ReturnObject -FormatView Custom
        Description: <command_here> and Return Object formatted in a PSCustom view
        Notes:  Format-Custom is designed to display views that are not just tables or just lists. You can use the views defined in the 
                *format.PS1XML files in the PowerShell directory, or you can create your own views in new PS1XML files and use the 
                Update-FormatData cmdlet to add them to PowerShell.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 2005.0801
        * Latest Author             : 
        * Latest Build Version      : 
        * Comments                  :
        * PowerShell Compatibility  : 2,3,4,5.x
        * Forked Project            : 
            ~ https://github.com/ALParsons/Set-BluGenieProcessCPUAffinity
        * Links                      :
            ~ https://offtheshell.com/2018/07/20/advanced-function-adjust-cpu-affinity-for-a-process-using-powershell/
        * Dependencies              :
            ~ Invoke-WalkThrough - Invoke-WalkThrough is an interactive help menu system
            ~ Get-ErrorAction - Get-ErrorAction will round up any errors into a simple object
        * Build Version Details     :
            ~ 2005.0801: * [Michael Arroyo] Posted
                                                    
#>
    [cmdletbinding()]
    [alias('Set-ProcessCPUAffinity')]
    #region Parameters
        Param
        (
            [Parameter(ValueFromPipeline=$true,
                       ValueFromPipelineByPropertyName=$true
                       )
            ]
            [int[]]
            $Id,

            [Alias('Help')]
            [Switch]$Walkthrough,

            [Switch]$ReturnObject,

            [Switch]$OutUnEscapedJSON,

            [ValidateSet('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV')]
            [string]$FormatView = 'None'
        )
    #endregion Parameters
    
    #region Dynamic Parameters
        DynamicParam
        {
            #region Set the dynamic parameters' name
                $ParameterName1 = 'Cores'
                $ParameterName2 = 'Name'
            #endregion Set the dynamic parameters' name
            
            #region Create the dictionary
                $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            #endregion Create the dictionary

            #region Create the collection of attributes
                $AttributeCollection1 = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
                $AttributeCollection2 = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            #endregion Create the collection of attributes

            #region Create and set the parameters' attributes
                $ParameterAttribute1 = New-Object System.Management.Automation.ParameterAttribute
                $ParameterAttribute1.Mandatory = $false
            

                $ParameterAttribute2 = New-Object System.Management.Automation.ParameterAttribute
                $ParameterAttribute2.Mandatory = $false
                #$ParameterAttribute2.ParameterSetName = "Name"
            #endregion Create and set the parameters' attributes

            #region Add the attributes to the attributes collection
                $AttributeCollection1.Add($ParameterAttribute1)
                $AttributeCollection2.Add($ParameterAttribute2)
            #endregion Add the attributes to the attributes collection

            #region Generate and set the ValidateSet
                [int[]]$arrCPUSet = $null
                [int[]]$arrCPUSet += (1..$env:NUMBER_OF_PROCESSORS)
                $ValidateSetAttribute1 = New-Object System.Management.Automation.ValidateSetAttribute($arrCPUSet)
            

                [string[]]$arrNameSet = $null
                [string[]]$arrNameSet += (Get-Process).Name | Select-Object -Unique
                $ValidateSetAttribute2 = New-Object System.Management.Automation.ValidateSetAttribute($arrNameSet)
            #endregion Generate and set the ValidateSet

            #region Add the ValidateSet to the attributes collection
                $AttributeCollection1.Add($ValidateSetAttribute1)
                $AttributeCollection2.Add($ValidateSetAttribute2)
            #endregion Add the ValidateSet to the attributes collection

            #region Create and return the dynamic parameter
                $RuntimeParameter1 = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName1, [int[]], $AttributeCollection1)
                $RuntimeParameter2 = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName2, [string[]], $AttributeCollection2)

                $RuntimeParameterDictionary.Add($ParameterName1, $RuntimeParameter1)
                $RuntimeParameterDictionary.Add($ParameterName2, $RuntimeParameter2)
            #endregion Create and return the dynamic parameter


            return $RuntimeParameterDictionary
        }
    #endregion Dynamic Parameters
    
    #region begin
        begin
        {
            #region Load begin, and process (code execution flags)
                $fbegin = $true
                $fprocess = $true
            #endregion Load begin, and process (code execution flags)
        
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
                            
                            #No longer process Begin, Process, and End script blocks
                            $fbegin = $false
                            Return
                        }
                        Else
                        {
                            Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function }
                            
                            #No longer process Begin, Process, and End script blocks
                            $fbegin = $false
                            Return
                        }
                    }
                    Else
                    {
                        Get-Help -Name $Function -Full
                        
                        #No longer process Begin, Process, and End script blocks
                        $fbegin = $false
                        Return
                    }
                }
            #endregion WalkThrough (Dynamic Help)
        
            #region Create Return hash
                $HashReturn = @{}
                $HashReturn['Set-BluGenieProcessCPUAffinity'] = @{}
                $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
                $HashReturn['Set-BluGenieProcessCPUAffinity'].StartTime = $($StartTime).DateTime
                $HashReturn['Set-BluGenieProcessCPUAffinity']['ResultSet'] = @()
            #endregion Create Return hash

            #region Parameter Set Results
                $HashReturn['Set-BluGenieProcessCPUAffinity'].ParameterSetResults = $PSBoundParameters
            #endregion Parameter Set Results
        
            #region Bind the parameter to a friendly variable
                $Cores = $PsBoundParameters['Cores']
                $Name  = $( 
                            IF
                            (
                                $null -ne $PsBoundParameters['Name']
                            )
                            {
                                $PsBoundParameters['Name']
                            }
                          )

                [int]$LogicalProcessors = $env:NUMBER_OF_PROCESSORS
            #endregion Bind the parameter to a friendly variable

            #region Instantiate CPU counters & array
                [int]$CPUid = 1
                [int]$Counter = 1
                [array]$CPUs = @()
            #endregion Instantiate CPU counters & array

            #region Build CPU array for filtering the chosen CPU's Affinity mask
                Do
                {
                    # Create a CPU Object to add to the CPU array
                    $CPUObj = New-Object -TypeName PSCustomObject
                    $CPUObj | Add-Member -Name "CPUid" -MemberType NoteProperty -Value $CPUid
                    $CPUObj | Add-Member -Name "CPU#" -MemberType NoteProperty -Value "CPU$Counter"

                    # Add CPU to array
                    $CPUs += $CPUObj

                    # Increment CPU object counters
                    $CPUid = $CPUid * 2 ; $Counter++

                } 
                Until
                (
                    $Counter -gt $LogicalProcessors
                )
            #endregion Build CPU array for filtering the chosen CPU's Affinity mask

            #region If Cores is ommited, declare all cores for affinity
                IF
                (
                    $null -eq $Cores
                )
                {
                    [string[]]$Cores = (1..$env:NUMBER_OF_PROCESSORS)
                }
            #endregion If Cores is ommited, declare all cores for affinity

            #region Remove possible repeated CPU ID's
                $Cores = $Cores | Select-Object -Unique
            #endregion Remove possible repeated CPU ID's

            #region Filter the CPU array to the CPU's selected for affinity
                $AffinityCores = foreach ($Core in $Cores) { $CPUs | Where-Object { $_."CPU#" -match $Core } }
            #endregion Filter the CPU array to the CPU's selected for affinity

            #region Create Affinity mask for the selected CPU's
                [int]$AffinityMask = 0
                $AffinityCores | ForEach-Object `
                -Process `
                {
                    $AffinityMask += $_.CPUid
                }
            #endregion Create Affinity mask for the selected CPU's
        }
    #endregion begin
    
    #region process
        Process
        {
            #process Script Block Execution Check
                If
                (
                    -Not $fbegin
                )
                {
                    #Clean Exit (Do not process anything further)
                    $fprocess = $false
                    Return
                }
            #Endprocess Script Block Execution Check
            
            #region Set Process collection and Process Identifier (ID vs. Name)
                [String[]]$Processes = $(
                                            IF
                                            (
                                                $null -ne $Name
                                            )
                                            {
                                                $Name ; $Identifier = "Name"
                                            }
                                            Else
                                            {
                                                $Id ; $Identifier = "Id"
                                            }
                                        )
            #endregion Set Process collection and Process Identifier (ID vs. Name)

            #region Switch to code block for the selected Process Identifier
                # Set CPU affinity mask for each selected Process
                [System.Diagnostics.Process[]]$ResultSet = @()
                Switch($Identifier)
                {
                    Name
                    {
                        $Processes = $Processes | Select-Object -Unique
                        Foreach ($Process in $Processes)
                        {
                            Foreach ($ProcID in (Get-Process -Name $Process).Id)
                            {
                                (Get-Process -Id $ProcID).ProcessorAffinity = $AffinityMask
                                $ResultSet += Get-Process -Id $ProcID
                            }

                        }
                    }

                    Id
                    {
                        Foreach ($Process in $Processes)
                        {
                            (Get-Process -Id $Process).ProcessorAffinity = $AffinityMask
                            $ResultSet += Get-Process -Id $Process
                        }
                    }

                }
            #endregion Switch to code block for the selected Process Identifier

            #region Update Result Set in Hash Table
                $HashReturn['Set-BluGenieProcessCPUAffinity']['ResultSet'] += $ResultSet
            #endregion Update Result Set in Hash Table
        }
    #endregion process
    
    #region end
        end
        {
             #end Script Block Execution Check
                If
                (
                    -Not $fprocess
                )
                {
                    #Clean Exit (Do not process anything further)
                    Return
                }
            #Endend Script Block Execution Check
        
            #region Output
                $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
                $HashReturn['Set-BluGenieProcessCPUAffinity'].EndTime = $($EndTime).DateTime
                $HashReturn['Set-BluGenieProcessCPUAffinity'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
                                                                    | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

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
    #endregion end
}
#endregion Set-BluGenieProcessCPUAffinity (Function)