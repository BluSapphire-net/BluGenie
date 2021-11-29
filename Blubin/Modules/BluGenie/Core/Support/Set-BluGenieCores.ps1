#region Set-BluGenieCores (Function)
Function Set-BluGenieCores {
    <#
    .SYNOPSIS
        Set-BluGenieCores is an add-on to control how many Cores to use while in the BluGenie Console

    .DESCRIPTION
        Set-BluGenieCores is an add-on to control how many Cores to use while in the BluGenie Console

        Select the amount of cores you want this job to use.  Default is (ALL).
        Core information is pulled from the ($env:NUMBER_OF_PROCESSORS) variable.

    .PARAMETER Cores
        Description: Select the amount of cores you want this job to use.
        Notes: Default is (ALL)
        Alias:
        ValidateSet:

    .PARAMETER Walkthrough
        Description: An automated process to walk through the current function and all the parameters
        Notes:
        Alias:
        ValidateSet:

    .EXAMPLE
        Command: Set-BluGenieCores
        Description: This will set the Core to use to (ALL)
        Notes:
        Output:

    .EXAMPLE
        Command: Set-BluGenieCores -Cores 2
        Description :This will set the Core to use to 2
        Notes:
        Output:

    .EXAMPLE
        Command: Set-BluGenieCores 2,3,4
        Description: This will set the Core to use to 2,3,4 while using Position 0 in the parameter index
        Notes:
        Output:

    .OUTPUTS
            TypeName: System.String

    .NOTES
        * Original Author           : Michael Arroyo
        * Original Build Version    : 1908.2201
        * Latest Author             :
        * Latest Build Version      :
        * Comments                  :
        * Dependencies              :
            ~
        * Build Version Details     :
            ~ 1908.2201: * [Michael Arroyo] Posted
    #>

    [CmdletBinding(ConfirmImpact='Medium')]
    [Alias('Set-BGCores','Set-Cores','Cores')]
    Param (
        [ArgumentCompleter( {
                param ( $CommandName,
                    $ParameterName,
                    $WordToComplete,
                    $CommandAst,
                    $FakeBoundParameters )
                return $(
                    $IntArrCores = @()

                    for (
                        $i = 0
                        $i -lt $env:NUMBER_OF_PROCESSORS;
                        $i++
                    ) {
                        $null = $IntArrCores += [Int]$($i + 1)
                    }

                    $IntArrCores += $IntArrCores -Join ','

                    return $IntArrCores
                )
            })]
            [System.Object[]]$Cores,

        [Alias('Help')]
        [Switch]$Walkthrough
    )

    #region WalkThrough (Dynamic Help)
        If ($Walkthrough) {
            If ($($PSCmdlet.MyInvocation.InvocationName)) {
                $Function = $($PSCmdlet.MyInvocation.InvocationName)
            } Else {
                If ($Host.Name -match 'ISE') {
                    $Function = $(Split-Path -Path $psISE.CurrentFile.FullPath -Leaf) -replace '((?:.[^.\r\n]*){1})$'
                }
            }

            If (Get-Command | Select-Object -Property Invoke-WalkThrough) {
                If ($Function -eq 'Invoke-WalkThrough') {
                    #Disable Invoke-WalkThrough looping
                    Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function -RemoveRun }
                    Return
                } Else {
                    Invoke-Command -ScriptBlock { Invoke-WalkThrough -Name $Function }
                    Return
                }
            } Else {
                Get-Help -Name $Function -Full
                Return
            }
        }
    #endregion WalkThrough (Dynamic Help)

    #region Main
        If ($Cores) {
            $Global:BGCores = $Cores
        } Else {
            $IntArrCores = @()

            for (
                $i = 0
                $i -lt $env:NUMBER_OF_PROCESSORS;
                $i++
            ) {
                $null = $IntArrCores += [Int]$($i + 1)
            }

            $Global:BGCores = $IntArrCores
        }
    #endregion Main

    #region Output
        $SetCoresText = "$Global:BGCores".PadRight(25,' ') + "|| `t"
        $SetCoresMsg = '..Cores Value..'
        write-host -NoNewline $("`n{0}" -f $SetCoresText) -ForegroundColor Yellow
        Write-Host -NoNewline $SetCoresMsg -ForegroundColor Green

        Write-Host "`n"
    #endregion Output
}
#endregion Set-BluGenieCores (Function)