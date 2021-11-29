#region Get-BluGenieLiteralPath (Function)
Function Get-BluGenieLiteralPath
{
<#
    .SYNOPSIS
        Get-BluGenieLiteralPath will convert System Variable defined paths to a Literal Path

    .DESCRIPTION
        Get-BluGenieLiteralPath will convert System Variable defined paths to a Literal Path

    .PARAMETER Path
        Description: Specifies the path to convert or validate
        Notes:  
        Alias:
        ValidateSet:  

    .PARAMETER Walkthrough
        Description:  Start the dynamic help menu system to help walk through the current command and all of the parameters
        Notes:  
        Alias: Help
        ValidateSet: 

    .EXAMPLE
	    Command: Get-BluGenieLiteralPath -Path '%SystemDrive%\Users\%Username%'
        Description: Return a literal path of ( C:\Users\Administrator )
        Notes: 

    .EXAMPLE
	    Command: Get-BluGenieLiteralPath -Help
        Description: Call Help Information
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .EXAMPLE
	    Command: Get-BluGenieLiteralPath -WalkThrough
        Description: Call Help Information [2]
        Notes: If Help / WalkThrough is setup as a parameter, this script will be called to setup the Dynamic Help Menu if not the normal Get-Help will be called with the -Full parameter

    .OUTPUTS
        TypeName: System.Collections.Hashtable

    .NOTES

        * Original Author           : Michael Arroyo
        * Original Build Version    : 1901.2701
        * Latest Author             : Michael Arroyo
        * Latest Build Version      : 1911.0101
        * Comments                  :
        * Dependencies              :
                                        ~ Invoke-WalkThrough
        * Build Version Details     :
                                        ~ 1901.2701: * [Michael Arroyo] Posted
                                        ~ 1902.0401: * [Michael Arroyo] Update the function with a Dynamic menu system for Syntax, Parameters, Examples, and Help information
                                        ~ 1903.1201: * [Michael Arroyo] Removed the Parameter argument to check for $null strings.  I do this already in the script and it was causing issues for calling scripts.
                                        ~ 1911.0101: * [Michael Arroyo] Updated the Help information to the new standard for Invoke-WalkThrough (External Call)
                                                     * [Michael Arroyo] Updated the Hash Information to follow the new function standards
                                                     * [Michael Arroyo] Added more detailed information to the Return data
#>
    [Alias('Get-LiteralPath')]
    Param
    (
        [Parameter(Position=1)]
        [Alias('FullName')]
        [String]$Path,

        [Parameter(Position=2)]
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

     #region Parameter Check
        If
        (
            -Not $Path
        )
        {
            Return
        }
    #endregion

    #region Function Variables
        $VarArray = @()
        $Counter = 0
        [String]$NewVariable = ''
    #endregion

    #region Check each Char for a [%] and build out system variable string
        for
        (
            $i = 0
            $i -lt $($Path.Length)
            $i++
        )
        {
            If
            (
                $Path.ToString()[$i] -eq '%'
            )
            {
                $Counter += 1
                $NewVariable += $Path.ToString()[$i]

                If
                (
                    $Counter -eq 2
                )
                {
                    $Counter = 0
                    $VarArray += $NewVariable
                    $NewVariable = ''
                }
            }

            If
            (
                $Counter -eq 1
            )
            {
                If
                (
                    $Path.ToString()[$i] -ne '%'
                )
                {
                    $NewVariable += $Path.ToString()[$i]
                }
            }
        }
    #endregion

    #region Rebuild path
        [String]$NewPath = $Path

        If
        (
            $VarArray
        )
        {
            $VarArray | ForEach-Object `
            -Process `
            {
                $CurVar = $_
                $CurVarName = $CurVar.Replace('%','')
                If
                (
                    Get-Item -Path $('env:{0}' -f $CurVarName) -ErrorAction SilentlyContinue
                )
                {
                    $NewPath = $NewPath.Replace($CurVar, $(Get-Item -Path $('env:{0}' -f $CurVarName)).Value)
                }
            }
        }
    #endregion

    Return $NewPath
}
#endregion Get-BluGenieLiteralPath (Function)