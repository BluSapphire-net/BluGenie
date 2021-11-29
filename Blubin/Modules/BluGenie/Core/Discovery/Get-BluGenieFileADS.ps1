#region Get-BluGenieFileADS (Function)
Function Get-BluGenieFileADS
{
<#
    .SYNOPSIS
        Query for a files Alternate Data Stream Content

    .DESCRIPTION
        Query for a files Alternate Data Stream Content

    .PARAMETER Path
        Description: File Path
        Notes:  
        Alias: 'Fullname'
        ValidateSet:  

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:  
        Alias: Help
        ValidateSet: 

    .PARAMETER UseCache
        Description: Cache found objects to disk.  This is to not over tax Memory resources with found artifacts
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp
        Alias: 
        ValidateSet: 

    .PARAMETER RemoveCache
        Description: Remove Cache data on completion
        Notes: Cache information is removed right before the data is returned to the calling process
        Alias: 
        ValidateSet: 

    .PARAMETER CachePath
        Description: Path to store the Cache information
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp
        Alias: 
        ValidateSet: 

    .PARAMETER ClearGarbageCollecting
        Description: Garbage Collection in Powershell to Speed up Scripts and help lower memory consumption
        Notes: This is enabled by default.  To disable use -ClearGarbageCollecting:$False
        Alias: 
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

    .PARAMETER OutYaml
        Description: Return detailed information in Yaml Format
        Notes: Only supported in Posh 3.0 and above
        Alias: 
        ValidateSet: 

    .PARAMETER FormatView
        Description: Automatically format the Return Object 
        Notes: Yaml is only supported in Posh 3.0 and above
        Alias: 
        ValidateSet: 'Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml'

    .EXAMPLE
	    Command: Get-BluGenieFileADS -path "C:\Temp\File1.txt","%SystemDrive%\Windows\Notepod.exe"
        Description: Query files for any ADS Information using the Path Parameter
        Notes: 

    .EXAMPLE
	    Command: Get-BluGenieFileADS -path "C:\Temp\File1.txt,%SystemDrive%\Windows\Notepod.exe"
        Description: Query files for any ADS Information using a Single String Array with a comma separator
        Notes: 

    .EXAMPLE
	    Command: Get-BluGenieFileADS -path "C:\Temp\File1.txt;%SystemDrive%\Windows\Notepod.exe"
        Description: Query files for any ADS Information using a Single String Array with a semicolon separator
        Notes: 

    .EXAMPLE
	    Command: Get-ChildItem -path $env:temp -File | Get-BluGenieFileADS
        Description: Query files for any ADS Information using Named value from Pipeline
        Notes: 

    .EXAMPLE
	    Command: Get-ChildItem -path $env:temp -File | Select-Object -ExpandProperty Fullname | Get-BluGenieFileADS
        Description: Query files for any ADS Information using value from Pipeline
        Notes: 

    .EXAMPLE
	    Command: Get-FileADS -path "C:\Temp\File1.txt"
        Description: Query files for any ADS Information using the Function Alias
        Notes: 

    .EXAMPLE
	    Command: Get-BluGenieFileADS -path "C:\Temp\File1.txt" -UseCache
        Description: Cache found objects to disk to not over tax Memory resources
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp

    .EXAMPLE
	    Command: Get-BluGenieFileADS -path "C:\Temp\File1.txt" -UseCache -RemoveCache
        Description: Remove Cache data
        Notes: 

    .EXAMPLE
	    Command: Get-BluGenieFileADS -path "C:\Temp\File1.txt" -UseCache -CachePath $Env:Temp
        Description: Change the Cache path to the current users Temp directory
        Notes: By default the Cache location is %SystemDrive%\Windows\Temp

    .EXAMPLE
	    Command: Get-ChildItem -path $env:temp -File | Get-BluGenieFileADS -UseCache -ClearGarbageCollecting
        Description: Scan large directories and limit the memory used to track data
        Notes: 

    .EXAMPLE
	    Command: Get-BluGenieFileADS -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieFileADS -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal 
Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieFileADS -path "C:\Temp\File1.txt" -OutUnEscapedJSON
        Description: Return a detailed function report in an UnEscaped JSON format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Get-BluGenieFileADS -path "C:\Temp\File1.txt" -OutYaml
        Description: Return a detailed function report in YAML format
        Notes:  The OutUnEscapedJSON is used to Beautify the JSON return and not Escape any Characters.  Normal return data is a Hash Table.

    .EXAMPLE
	    Command: Get-BluGenieFileADS -path "C:\Temp\File1.txt" -ReturnObject
        Description: Return Output as a Object
        Notes:  The ReturnObject is used to return a PowerShell Object.  Normal return data is a Hash Table.
                This parameter is also used with the ForMat

    .EXAMPLE
	    Command: Get-BluGenieFileADS -path "C:\Temp\File1.txt" -ReturnObject -FormatView Yaml
        Description: Output PSObject information in Yaml format
        Notes:  Current formats supported by default are ('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml', 'XML')
                Default is set to (None) and normal PSObject.

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        • [Original Author]
            o    Michael Arroyo
        • [Original Build Version]
            o    20.12.1101 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o        
        • [Latest Build Version]
            o    
        • [Comments]
            o    
        • [PowerShell Compatibility]
            o    2,3,4,5.x
        • [Forked Project]
            o    
        • [Links]
            o    
        • [Dependencies]
            o    Invoke-BluGenieWalkThrough or Invoke-WalkThrough - interactive help menu system
            o    Get-BluGenieErrorAction or Get-ErrorAction - Round up any errors into a smiple, clean object
            o    New-BluGenieUID or New-UID - Create a New UID
            o    ConvertTo-Yaml - ConvertTo Yaml
            o    Clear-BlugenieMemory or Clear-Memory or CM - Free up any garbage collecting that Powershell is managing
            o    ConvertFrom-Yaml - Convert From Yaml
        • [Build Version Details]
            o 20.12.1101: * [Michael Arroyo] Created from Function Template
            o 20.12.1101: * [Michael Arroyo] Posted
#>
    [cmdletbinding()]
    [Alias('Get-FileADS')]
    #region Parameters
        Param
        (
            [parameter(ValueFromPipelineByPropertyName = $true,
                       ValueFromPipeline = $True,
                       Position = 0)]
            [Alias('Fullname')]
            [String[]]$Path,

            [Switch]$ClearGarbageCollecting = $true,

            [Switch]$UseCache,

            [String]$CachePath = $('{0}\Windows\Temp\{1}.log' -f $env:SystemDrive, $(New-BluGenieUID)),

            [Switch]$RemoveCache,

            [Alias('Help')]
            [Switch]$Walkthrough,

            [Switch]$ReturnObject,

            [Switch]$OutUnEscapedJSON,

            [Switch]$OutYaml,

            [ValidateSet('Table','Custom','CustomModified','None','JSON','OutUnEscapedJSON','CSV', 'Yaml')]
            [string]$FormatView = 'None'
        )
    #endregion Parameters
    
    #region begin
        begin
        {
            Write-Verbose 'Begin block'

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
                        Test-Path -Path Function:\Invoke-BluGenieWalkThrough -ErrorAction SilentlyContinue
                    )
                    {
                        If
                        (
                            $Function -eq 'Invoke-BluGenieWalkThrough'
                        )
                        {
                            #Disable Invoke-BluGenieWalkThrough looping
                            Invoke-Command -ScriptBlock { Invoke-BluGenieWalkThrough -Name $Function -RemoveRun }
                            
                            #No longer process Begin, Process, and End script blocks
                            $fbegin = $false
                            Return
                        }
                        Else
                        {
                            Invoke-Command -ScriptBlock { Invoke-BluGenieWalkThrough -Name $Function }
                            
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
                $HashReturn['GetFileADS'] = @{}
                $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
                $HashReturn['GetFileADS'].StartTime = $($StartTime).DateTime
                $HashReturn['GetFileADS'].ParameterSetResults = @()
                $HashReturn['GetFileADS']['Items'] = @()
                $HashReturn['GetFileADS']['CachePath'] = $CachePath
            #endregion Create Return hash

            #region Parameter Set Results
                $HashReturn['GetFileADS'].ParameterSetResults += $PSBoundParameters
            #endregion Parameter Set Results

            #region Dynamic parameter update
                If
                (
                    $PSVersionTable.PSVersion.Major -eq 2
                )
                {
                    $IsPosh2 = $true
                }
                Else
                {
                    $IsPosh2 = $false
                }

                Switch
                (
                    $null
                )
                {
                    {$FormatView -eq 'Yaml' -and $IsPosh2}
                    {
                        $FormatView -eq 'None'
                    }

                    {$FormatView -match 'JSON' -and $IsPosh2}
                    {
                        $FormatView -eq 'None'
                    }

                    {$OutYaml -and $IsPosh2}
                    {
                        $OutYaml -eq $false
                        $FormatView -eq 'None'
                    }

                    {$FormatView -eq 'Yaml'}
                    {
                        $UseCache = $true
                    }
                }
            #endregion Dynamic parameter update
                                            
            #region Array Place Holder
                $ArrADSData = @()                            
            #endregion Array Place Holder
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
            
            #region Main
                #region Determine if the Array is CmdLet binding or via Parameter
                    If
                    (
                        $_.Count -eq 0
                    )
                    {
                        #region Set Tracking Param Value
                            $IsParamString = $true
                        #endregion Set Tracking Param Value
                        
                        If
                        (
                            $Path -Match ','
                        )
                        {
                            $_ = $($Path -split ',')
                        }
                        ElseIf
                        (
                            $Path -Match ';'
                        )
                        {
                            $_ = $($Path -split ';')
                        }
                        Else
                        {
                            $_ = $Path
                        }
                    }
                #endregion Determine if the Array is CmdLet binding or via Parameter

                #region Process Each Instance in Path
                    $_ | ForEach-Object `
                    {
                        Write-Verbose 'Process block'

                        If
                        (
                            $IsParamString
                        )
                        {
                            $Path = $_
                        }

                        #region Query Literal Path
                            $LPath = $(Get-BluGenieLiteralPath -Path $($Path) -ErrorAction SilentlyContinue)
                        #endregion Query Literal Path

                        #region Query ADS Names
                            $NewObjProps = @{
                                Path = ''
                                LiteralPath = ''
                                HasADS = 'FALSE'
                                OnDisk = 'FALSE'
                                ADSName = @()
                                Comment = ''
                            }

                            $CurADSObj = New-Object -TypeName PSObject -Property $NewObjProps
                            $CurADSObj.Path = $($Path)
                            $CurADSObj.LiteralPath = $LPath

                            $Error.Clear()

                            Try
                            {
                                $CurADSData = Get-Item -Path $LPath -force -Stream * -ErrorAction Stop | `
			                        Where-Object -FilterScript { $_.'Stream' -NotLike ':$DATA' } | Select-Object -ExpandProperty Stream

                                $CurADSObj.OnDisk = 'TRUE'
                                If
                                (
                                    $CurADSData
                                )
                                {
                                    $CurADSObj.HasADS = 'TRUE'
                                    $CurADSObj.ADSName += $CurADSData
                                }
                            }
                            Catch
                            {
                                $CurADSObj.Comment = $Error[0].ToString()
                                $Error.Clear()
                            }

                            If
                            (
                                $UseCache
                            )
                            {
                                '---' | Out-File -FilePath $CachePath -Append -Force
                                $CurADSObj | ConvertTo-Yaml | Out-File $CachePath -Append -Force
                            }
                            Else
                            {
                                $ArrADSData += $CurADSObj
                            }

                            $CurPath = $null
                            $CurADSObj = $null
                            If
                            (
                                $ClearGarbageCollecting
                            )
                            {
                                 $null = Clear-BlugenieMemory
                            }
                        #endregion Query ADS Names
                    }
                #endregion Process Each Instance in Path
            #endregion Main
        }
    #endregion process
    
    #region end
        end
        {
            Write-Verbose 'Final work in End block'

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
                                            
            #region Build Return Array
                If
                (
                    $UseCache
                )
                {
                    $HashReturn['GetFileADS']['Items'] += Get-Content -Path $CachePath | ConvertFrom-Yaml -AllDocuments
                    If
                    (
                        $RemoveCache
                    )
                    {
                        If
                        (
                            -Not $($FormatView -eq 'Yaml')
                        )
                        {
                            $null = Remove-Item -Path $CachePath -Force -ErrorAction SilentlyContinue
                        }
                    }
                }
                Else
                {
                    $HashReturn['GetFileADS']['Items'] += $ArrADSData
                }
            #endregion Build Return Array
        
            #region Output
                $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
                $HashReturn['GetFileADS'].EndTime = $($EndTime).DateTime
                $HashReturn['GetFileADS'].ElapsedTime = $(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue)`
                    | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds

                If
                (
                    $ClearGarbageCollecting
                )
                {
                    $null = Clear-BlugenieMemory
                }

                #region Output Type
                    $ResultSet = $($HashReturn['GetFileADS']['Items'])

        	        switch
        	        (
        		        $Null
        	        )
        	        {
        		        #region Beautify the JSON return and not Escape any Characters
        	                { $OutUnEscapedJSON }
        			        {
        				        Return $($HashReturn | ConvertTo-Json -Depth 10 | ForEach-Object -Process { [regex]::Unescape($_) })
        			        }
        		        #endregion Beautify the JSON return and not Escape any Characters

                        #region Yaml Output of Hash Information
        	                { $OutYaml }
        			        {
        				        Return $($HashReturn | ConvertTo-Yaml)
        			        }
        		        #endregion Yaml Output of Hash Information
        				
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

                                        #region Yaml
        			                        'Yaml'
        			                        {
                                                $ResultSet = Get-Content -Path $CachePath
                                                If
                                                (
                                                    $RemoveCache
                                                )
                                                {
                                                    $Null = Remove-Item -Path $CachePath -Force -ErrorAction SilentlyContinue
                                                }

        				                        Return $($ResultSet)
        			                        }
        		                        #endregion Yaml

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
                                                Return $($ResultSet | ConvertTo-Json -Depth 10)
        			                        }
        		                        #endregion JSON

                                        #region OutUnEscapedJSON
        			                        'OutUnEscapedJSON'
        			                        {
                                                Return $($ResultSet | ConvertTo-Json -Depth 10 | ForEach-Object `
                                                    -Process `
                                                    {
                                                        [regex]::Unescape($_)
                                                    }
                                                )
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
#endregion Get-BluGenieFileADS (Function)