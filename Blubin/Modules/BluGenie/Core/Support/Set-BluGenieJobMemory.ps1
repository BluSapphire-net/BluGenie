#region Set-BluGenieJobMemory (Function)
Function Set-BluGenieJobMemory {
    <#
    .SYNOPSIS
        Set-BluGenieJobMemory is an add-on to control the Job Memory used while processing a BluGenie Job

    .DESCRIPTION
        Set-BluGenieJobMemory is an add-on to control the Job Memory used while processing a BluGenie Job

        Select the amount of Memory you want this job to use.  Default is (512mb).
        Memory information is pulled from (ClassName Win32_PhysicalMemory)

    .PARAMETER Memory
        Description: Select the amount of Memory you want this job to use.
        Notes: Default is (512)
        Alias:
        ValidateSet:

    .PARAMETER Walkthrough
        Description: An automated process to walk through the current function and all the parameters
        Notes:
        Alias:
        ValidateSet:

    .EXAMPLE
        Command: Set-BluGenieJobMemory
        Description: This will show the job memory limit
        Notes:
        Output:

    .EXAMPLE
        Command: Set-BluGenieJobMemory -Memory 512
        Description : This will set the memory limit for this job to 512
        Notes: Value is set in MB
        Output:

    .EXAMPLE
        Command: Memory 1024
        Description: This will set the memory limit for this job to 1024 use the Quick Alias command
        Notes: Value is set in MB
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
    [Alias('Set-BGJobMemory','Memory')]
    Param (
        [ArgumentCompleter( {
                param ( $CommandName,
                    $ParameterName,
                    $WordToComplete,
                    $CommandAst,
                    $FakeBoundParameters )
                return $(
                    [Int64]$TotalPhyMem = 0
                    $Increment = 1024
                    Get-CimInstance -ClassName Win32_PhysicalMemory | Select-Object -ExpandProperty Capacity | `
                        ForEach-Object -Process {
                            $CurMemCap = $_
                            $TotalPhyMem += $CurMemCap
                        }
                    $MemBreakDown = @(512)
                    ForEach ($MemInc in 1..$($($TotalPhyMem /1mb) / $Increment)) {
                        $MemBreakDown += $($Increment * $MemInc)
                    }

                    return $MemBreakDown
                )
            })]
            [Int64]$Memory,

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
        If ($Memory) {
            $Global:BGMemory = $Memory
        }

        If (-Not $($Global:BGMemory -ge 256)) {
            $Global:BGMemory = 512
        }
    #endregion Main

    #region Output
        $SetMemoryText = "$Global:BGMemory".PadRight(25,' ') + "|| `t"
        $SetMemoryMsg = '..Memory Value..'
        write-host -NoNewline $("`n{0}" -f $SetMemoryText) -ForegroundColor Yellow
        Write-Host -NoNewline $SetMemoryMsg -ForegroundColor Green

        Write-Host "`n"
    #endregion Output
}
#endregion Set-BluGenieJobMemory (Function)