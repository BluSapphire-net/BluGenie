#region Show-BluGenieMore (Function)
Function Show-BluGenieMore
{
<#
    .SYNOPSIS
        Show-BluGenieMore is a command used to view content one screen at a time in case the file is large.

    .DESCRIPTION
        Show-BluGenieMore is a command used to view content one screen at a time in case the file is large.  You can
        define how many lines are diplayed to the screen as well.  The default is 25.

    .PARAMETER LineCount
        Description: Define the line items to display.  The Default is 25.
        Notes:  
        Alias:
        ValidateSet:  

    .PARAMETER Source
        Description: The content to display.  While sending content over the pipeline you need to use an Unary Comma Operator.
        Notes: 
				Comma operator ,
                As a binary operator, the comma creates an array. As a unary operator, the comma creates an array with one member. Place the comma before the member.

                ,$MyArray | More 
        Alias:
        ValidateSet: 
		
	.PARAMETER Suffix
        Description: Return each line with a suffix.  This can be used as a check list to mark each line. 
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
	    Command: ,$(Get-ChildItem -Path $env:windir\System32 -File | Select-Object -ExpandProperty FullName) | Show-BluGenieMore
        Description: Query C:\Windows\System32 for all files and display the Full Path names 25 lines per page using the Pipeline
        Notes: 
			While sending content over the pipeline you need to use an Unary Comma Operator.
            As a binary operator, the comma creates an array. As a unary operator, the comma creates an array with one member. Place the comma before the member.

            ,$MyArray | More
	
	.EXAMPLE
	    Command: ,$(Get-ChildItem -Path $env:windir\System32 -File | Select-Object -ExpandProperty FullName) | More
        Description: Query C:\Windows\System32 for all files and display the Full Path names using the Show-BluGenieMore Alias
        Notes: 
			While sending content over the pipeline you need to use an Unary Comma Operator.
            As a binary operator, the comma creates an array. As a unary operator, the comma creates an array with one member. Place the comma before the member.

            ,$MyArray | More
			
    .EXAMPLE
	    Command: ,$(Get-ChildItem -Path $env:windir\System32 -File | Select-Object -ExpandProperty FullName) | More -Suffix ' * ' -LineCount 30
        Description: Display content 30 lines per page request.  Each line item will have a Suffix ' * ' appended.
        Notes: 
		
	.EXAMPLE
	    Command: Show-BluGenieMore -Source $(Get-ChildItem -Path $env:windir\System32 -File | Select-Object -ExpandProperty FullName)
	    Description: Query C:\Windows\System32 for all files and display the Full Path names 25 lines per page using the Source Parameter
	    Notes: 

    .EXAMPLE
	    Command: Show-BluGenieMore -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Show-BluGenieMore -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .OUTPUTS
        TypeName: System.String

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1904.1801
        * Latest Author             : 
        * Latest Build Version      : 
        * Comments                  :
        * Dependencies              :
                                        ~ Invoke-WalkThrough            - Invoke-WalkThrough is an interactive help menu system
        * Build Version Details     :
                                        ~ 1904.1801: * [Michael Arroyo] Posted
										~ 1911.2401: * [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                                                     * [Michael Arroyo] Updated the Hash Information to follow the new function standards
                                                     * [Michael Arroyo] Added more detailed information to the Return data
													 * [Michael Arroyo] Fixed the Pipeline passthrough
													 * [Michael Arroyo] Added a ( Q - Quit ) switch to exit the processing command in mid stream
													 
                                                    
#>
    [cmdletbinding()]
	[Alias('More','Show-More')]
    [OutputType([String])]
    Param
    (
		 [Parameter(Position=0,
				   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [Object]$Source,
		
        [Parameter(Position=1)]
        [Int]$LineCount = 25,

        [Parameter(Position=2)]
        [string]$Suffix,

        [Alias('Help')]
        [Switch]$Walkthrough
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
	
	#region Source Check
        If
        (
            -Not $Source
        )
        {
            Return
        }
    #endregion

    #region Main
         #region Parse Source for Display
            $Counter = 0

            foreach
			(
				$CurLine in $Source
			)
            {
                If
                (
                    $Counter -ge $LineCount
                )
                {
                    $Options = Read-Host -Prompt '-- More -- <Type Q> and {Enter} to Quit' -ErrorAction SilentlyContinue
					
					If
					(
						$Options -eq 'q'
					)
					{
						break
					}
					Else
					{
						Write-Host $('{0}{1}' -f $Suffix,$CurLine) -ErrorAction SilentlyContinue
                    	$Counter = 1
					}
                }
                Else
                {
                    Write-Host $('{0}{1}' -f $Suffix,$CurLine) -ErrorAction SilentlyContinue
                    $Counter ++
                }
            }
        #endregion
    #endregion Main
}
#endregion Show-BluGenieMore (Function)