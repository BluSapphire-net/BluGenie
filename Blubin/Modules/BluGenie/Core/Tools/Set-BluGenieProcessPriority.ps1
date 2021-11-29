#region Set-BluGenieProcessPriority (Function)
Function Set-BluGenieProcessPriority
{
<#
    .SYNOPSIS
        Set the Processor Priority of a running Process.

    .DESCRIPTION
        Set the Processor Priority for a running Process based on 6 different priority levels.

        =====================================================================================================
        || Set Priority Level ID || Priority Level Name  || Get Priority Level ID   ||  Parameter Index ID ||
        =====================================================================================================
        || 256                   ||	Realtime             || 24                      || 	5                  ||
        || 128                   ||	High                 || 13                      || 	4                  ||
        || 32768                 ||	Above normal         || 10                      ||	3                  ||
        || 32                    ||	Normal               || 8                       ||	2                  ||
        || 16384                 ||	Below normal         || 6                       ||	1                  ||
        || 64                    ||	Low                  || 4                       ||	0                  ||
        =====================================================================================================

    .PARAMETER ID
        Description: The Process ID for the Process(es) to Set Priority. 
        Notes:  
        Alias:
        ValidateSet:  

    .PARAMETER Name
        Description: The Process Name for the Process(es) to Set Priority.
        Notes:  
        Alias:
        ValidateSet: 
        
    .PARAMETER PriorityLevel
        Description: Priority Level (5 - Highest / 0 - Lowest)
        Notes:  
        Alias:
        ValidateSet: '5, 4, 3, 2, 1, 0'

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
	    Command: Set-BluGenieProcessPriority -Name powershell_ise -PriorityLevel 0
        Description: Set PowerShell_ise.exe to a priority level of 0 / Lowest Priority
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieProcessPriority -Name powershell_ise -PriorityLevel 2
        Description: Set PowerShell_ise.exe to a priority level of 2 / Normal Priority
        Notes: 
        
    .EXAMPLE
	    Command: Set-BluGenieProcessPriority -Name powershell_ise -PriorityLevel 5
        Description: Set PowerShell_ise.exe to a priority level of 5 / Realtime Priority
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieProcessPriority -Name powershell_ise -ReviewOnly -ReturnObject
        Description: Review the Priority level for PowerShell_ise.exe as an object
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieProcessPriority -Name powershell_ise,notepad -ReviewOnly -ReturnObject
        Description: Review the Priority level for a list of processes as an object
        Notes: 

    .EXAMPLE
	    Command: Set-BluGenieProcessPriority -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
               Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Set-BluGenieProcessPriority -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
               Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Set-BluGenieProcessPriority -OutUnEscapedJSON
        Description: <command_here> and Return Output as UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to beatify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Set-BluGenieProcessPriority -ReturnObject
        Description: <command_here> and Return Output an Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
		
	.EXAMPLE
	    Command: Set-BluGenieProcessPriority -ReturnObject -FormatView JSON
        Description: <command_here> and Return Object formatted in a JSON view
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
		
	.EXAMPLE
	    Command: Set-BluGenieProcessPriority -ReturnObject -FormatView Custom
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
            ~ 
        * Links                      :
            ~ 
        * Dependencies              :
            ~ Invoke-WalkThrough - Invoke-WalkThrough is an interactive help menu system
            ~ Get-ErrorAction - Get-ErrorAction will round up any errors into a simple object
        * Build Version Details     :
            ~ 2005.0801: * [Michael Arroyo] Posted
                                                    
#>
    [cmdletbinding()]
    [alias('Set-ProcessPriority')]
    #region Parameters
        Param
        (
            [Parameter(ValueFromPipeline=$true,
                       ValueFromPipelineByPropertyName=$true
                       )
            ]
            [int[]]
            $Id,

            [ValidateSet('5', '4', '3', '2', '1', '0')]
            [string]$PriorityLevel = 2,

            [Switch]$ReviewOnly,

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
                $ParameterName2 = 'Name'
            #endregion Set the dynamic parameters' name
            
            #region Create the dictionary
                $RuntimeParameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
            #endregion Create the dictionary

            #region Create the collection of attributes
                $AttributeCollection2 = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
            #endregion Create the collection of attributes

            #region Create and set the parameters' attributes
                $ParameterAttribute2 = New-Object System.Management.Automation.ParameterAttribute
                $ParameterAttribute2.Mandatory = $false
                #$ParameterAttribute2.ParameterSetName = "Name"
            #endregion Create and set the parameters' attributes

            #region Add the attributes to the attributes collection
                $AttributeCollection2.Add($ParameterAttribute2)
            #endregion Add the attributes to the attributes collection

            #region Generate and set the ValidateSet
                [string[]]$arrNameSet = $null
                [string[]]$arrNameSet += (Get-Process).Name | Select-Object -Unique
                $ValidateSetAttribute2 = New-Object System.Management.Automation.ValidateSetAttribute($arrNameSet)
            #endregion Generate and set the ValidateSet

            #region Add the ValidateSet to the attributes collection
                $AttributeCollection2.Add($ValidateSetAttribute2)
            #endregion Add the ValidateSet to the attributes collection

            #region Create and return the dynamic parameter
                $RuntimeParameter2 = New-Object System.Management.Automation.RuntimeDefinedParameter($ParameterName2, [string[]], $AttributeCollection2)

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

            #region Set Index / ProirityLevel
                # =====================================================================================================
                # || Set Priority Level ID ||	Priority Level Name  || Get Priority Level ID  || Parameter Index ID ||
                # =====================================================================================================
                # || 256				   ||	Realtime			 || 24				 		|| 	5				 ||
                # || 128				   ||	High				 || 13						|| 	4				 ||
                # || 32768				   ||	Above normal		 || 10						||	3			     ||
                # || 32					   ||	Normal				 || 8						||	2				 ||
                # || 16384				   ||	Below normal		 || 6						||	1				 ||
                # || 64					   ||	Low					 || 4						||	0				 ||
                # =====================================================================================================

                    $PLLookUpTable = @{
                        '5' = @{
                            Name = 'Realtime'
                            SetID = 256
                        }
                        '4' = @{
                            Name = 'High'
                            SetID = 128
                        }
                        '3' = @{
                            Name = 'Above_Normal'
                            SetID = 32768
                        }
                        '2' = @{
                            Name = 'Normal'
                            SetID = 32
                        }
                        '1' = @{
                            Name = 'Below_Normal'
                            SetID = 16384
                        }
                        '0' = @{
                            Name = 'Low'
                            SetID = 64
                        }
                        GetID = @{
                            24 = 5
                            13 = 4
                            10 = 3
                            8  = 2
                            6  = 1
                            4  = 0
                        }
                    }
            #endregion Set Index / ProirityLevel
        
            #region Create Return hash
                $HashReturn = @{}
                $HashReturn['Set-ProcessPriority'] = @{}
                $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
                $HashReturn['Set-ProcessPriority'].StartTime = $($StartTime).DateTime
                $HashReturn['Set-ProcessPriority']['ResultSet'] = @()
            #endregion Create Return hash

            #region Parameter Set Results
                $HashReturn['Set-ProcessPriority'].ParameterSetResults = $PSBoundParameters
            #endregion Parameter Set Results
        
            #region Bind the parameter to a friendly variable
                $Name  = $( 
                            IF
                            (
                                $null -ne $PsBoundParameters['Name']
                            )
                            {
                                $PsBoundParameters['Name']
                            }
                          )
            #endregion Bind the parameter to a friendly variable
        }
    #endregion begin
    
    #region process
        Process
        {
            #region process Script Block Execution Check
                If
                (
                    -Not $fbegin
                )
                {
                    #Clean Exit (Do not process anything further)
                    $fprocess = $false
                    Return
                }
            #endregion process Script Block Execution Check
            
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
                $ResultSet = @()
                Switch($Identifier)
                {
                    Name
                    {
                        Foreach ($Process in $Processes)
                        {
                            Foreach ($ProcID in (Get-Process -Name $Process).Id)
                            {
                                If
                                (
                                    -Not $ReviewOnly
                                )
                                {
                                    $null = $(Get-WmiObject Win32_process -filter $('ProcessId = {0}' -f $ProcID)).SetPriority($($PLLookUpTable["$PriorityLevel"]['SetID']))
                                }
                                    $ReturnInfo = Get-Process -Id $ProcID | Select-Object -Property Name,ID,BasePriority
                                    $ReturnInfo | Add-Member -MemberType NoteProperty -Name 'StringPriority' -Value $PLLookUpTable."$($PLLookUpTable.GetID.$($ReturnInfo.BasePriority))".Name
                                    $ResultSet += $ReturnInfo
                                
                            }

                        }
                    }

                    Id
                    {
                        Foreach ($Process in $Processes)
                        {
                            If
                            (
                                -Not $ReviewOnly
                            )
                            {
                                $null = $(Get-WmiObject Win32_process -filter $('ProcessId = {0}' -f $process)).SetPriority($($PLLookUpTable["$PriorityLevel"]['SetID']))
                            }
                                $ReturnInfo = Get-Process -Id $Process | Select-Object -Property Name,ID,BasePriority
                                $ReturnInfo | Add-Member -MemberType NoteProperty -Name 'StringPriority' -Value $PLLookUpTable."$($PLLookUpTable.GetID.$($ReturnInfo.BasePriority))".Name
                                $ResultSet += $ReturnInfo
                            
                        }
                    }

                }
            #endregion Switch to code block for the selected Process Identifier

            #region Update Result Set in Hash Table
                $HashReturn['Set-ProcessPriority']['ResultSet'] += $ResultSet
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
                $HashReturn['Set-ProcessPriority'].EndTime = $($EndTime).DateTime
                $HashReturn['Set-ProcessPriority'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
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
#endregion Set-BluGenieProcessPriority (Function)