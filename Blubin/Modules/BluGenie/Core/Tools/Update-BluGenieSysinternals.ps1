#region Update-BluGenieSysinternals
function Update-BluGenieSysinternals
{
<#
    .SYNOPSIS
        Download and Update SysInternals tools

    .DESCRIPTION
        Download and Update SysInternals tools

    .PARAMETER Algorithm
        <String> Specifies the cryptographic hash to use for computing the hash value of the contents of the specified file.
        The acceptable values for this parameter are:

        - SHA1
        - SHA256
        - SHA384
        - SHA512
        - MACTripleDES
        - MD5 = (Default)
        - RIPEMD160

        <Type>ValidateSet<Type>
        <ValidateSet>MACTripleDES,MD5,RIPEMD160,SHA1,SHA256,SHA384,SHA512<ValidateSet>

    .PARAMETER Destination
        Download Destination

        Default Value = '.\ScriptDirectory\Tools'

        <Type>String<Type>

    .PARAMETER BaseDir
        Location to Extract to

        Default Value = '.\ScriptDirectory\Tools\'

        <Type>String<Type>


    .PARAMETER Walkthrough
        An automated process to walk through the current function and all the parameters

        <Type>SwitchParameter<Type>

    .EXAMPLE
        Update-BluGenieSysinternals

        This will download the SysinternalsSuite.zip from the default Sysinternals live download area.
        The file is downloaded to the default .\bin\x64\Tools directory
        Once downloaded the file will be extracted to the same directory

    .OUTPUTS
        System.Collections.Hashtable

    .NOTES
        • [Original Author]
            o  Michael Arroyo
        • [Original Build Version]
            o  20.12.1101 [XX = Year (.) XX = Month (.) XX = Day XX = Build revision]
        • [Latest Author]
            o   Michael Arroyo
        • [Latest Build Version]
            o   21.03.0901
        • [Comments]
            o
        • [PowerShell Compatibility]
            o  2,3,4,5.x
        • [Forked Project]
            o
        • [Links]
            o
        • [Dependencies]
            o  Invoke-BluGenieWalkThrough or Invoke-WalkThrough - interactive help menu system
#>

#region Build Notes
<#
~ Build Version Details "Moved from main help.  There is a Char limit and PSHelp could not read all the information correctly":
    o 1902.0505 * [Michael Arroyo] Posted
    o 1904.0801 * [Michael Arroyo] Updated the error control for the entire process to support External Help (XML) files
                * [Michael Arroyo] Updated the ** Parameters ** section to bypass the Help indicator to support External Help (XML) files
                * [Michael Arroyo] Updated the ** Options ** section to bypass the Help indicator to support External Help (XML) files
    o 1905.1302 * [Michael Arroyo] Converted all Where-Object references to PowerShell 2
    o 1905.2401 * [Michael Arroyo] Updated syntax based on PSAnalyzer
    o 21.03.0901* [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
                * [Michael Arroyo] Moved Build Notes out of General Posh Help section
                * [Michael Arroyo] Updated Tools path to (Blubin\Modules\Tools)
                * [Michael Arroyo] Updated the WalkThrought / Help region with the current Help process
                * [Michael Arroyo] Updated script based on the ( PSScriptAnalyzerSettings.psd1 )
                * [Michael Arroyo] Moved Build Notes out of General Posh Help section
                * [Michael Arroyo] Updated Tools path to (Blubin\Modules\Tools)
                * [Michael Arroyo] Updated the Walkthrough / Help region with the current Help process
                * [Michael Arroyo] Updated $Destination to $Global:ToolsDirectory.  This changes now works with Importing the Module itself and
                    not running the BluGenie.exe if you don’t want to
                * [Michael Arroyo] Updated $BaseDir to $Global:ToolsDirectory.  This changes now works with Importing the Module itself and not
                    running the BluGenie.exe if you don’t want to
                * [Michael Arroyo] Added Parameter called NoCleanUp.  This will leave all the SysInternal Tools that are downloaded and extracted.
                    If this flag isn’t set, only the items in the Config.JSON are kept and saved.  All other files will be removed to save space.

#>
#endregion Build Notes
[Alias('Update-Sysinternals')]
Param
(
    [string]$Source = "https://download.sysinternals.com/files/SysinternalsSuite.zip",

    [string]$Destination = $Global:ToolsDirectory,

    [string]$BaseDir = $Global:ToolsDirectory,

    [ValidateSet("MACTripleDES", "MD5", "RIPEMD160", "SHA1", "SHA256", "SHA384", "SHA512")]
    [string]$Algorithm = "MD5",

    [switch]$NoCleanUp,

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

#region Create Return Hash
    $HashReturn = @{}
    $HashReturn.SysInternals = @{}
    $StartTime = $(Get-Date -ErrorAction SilentlyContinue)
    $HashReturn.SysInternals.StartTime = $($StartTime).DateTime
    $HashReturn.SysInternals.StoredTools = @()
    $HashReturn.SysInternals.Comment = @()
#endregion Create Return Hash

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
#endregion Dynamic parameter update

#region Determine Filename
    $FileName = Split-Path -Path $Source -Leaf
#endregion Determine Filename

#region Remove older file is found
    If
    (
        Get-Item -Path $('{0}\{1}' -f $Destination, $FileName) -ErrorAction SilentlyContinue
    )
    {
        Remove-Item -Path $('{0}\{1}' -f $Destination, $FileName) -ErrorAction SilentlyContinue
    }
#endregion Remove older file is found

#region Directory Check
    If
    (
        -Not $(Get-Item -Path $Destination -ErrorAction SilentlyContinue)
    )
    {
        New-Item -Path $Destination -ItemType Directory -Force | Out-Null
    }
#endregion Directory Check

#region Download Archive
    If
    (
        $(Get-Item -Path $Destination -ErrorAction SilentlyContinue)
    )
    {
        $Error.Clear()
        Start-BitsTransfer -Source $Source -Destination $Destination -ErrorAction SilentlyContinue

        #region Expand Archive
            $FileInfo = Get-Item -Path $('{0}\{1}' -f $Destination, $FileName) -ErrorAction SilentlyContinue

            If
            (
                $FileInfo
            )
            {
                #region Check Results
                    $HashReturn.SysInternals.DataPull = @{
                        status = $true
                        comment = $null
                        timestamp =  $('{0}.{1}{2}' -f $(Get-Date -Format MM.dd.yyyy),$(Get-Date -UFormat %R).Replace(':','.'),$(Get-Date -Format .ss))
                    }
                #endregion Check Results

                #region Expand Archive
                    If
                    (
                        $IsPosh2
                    )
                    {
                        Expand-ArchivePS2 -Path $FileInfo.FullName -Destination $('{0}\{1}' -f $BaseDir, $FileInfo.Basename) -Force -NoProgressBar -NoErrorMsg -ReturnObject -ErrorAction SilentlyContinue
                    }
                    Else
                    {
                        Expand-Archive -LiteralPath $FileInfo.FullName -DestinationPath $('{0}\{1}' -f $BaseDir, $FileInfo.Basename) -Force -ErrorAction SilentlyContinue
                    }
                #endregion Expand Archive

                #region Copy Downloaded Tools
                    Write-VerboseMsg -Message 'Detecting Needed Project Files' -Status StartTask -Color Green -CheckFlag BGVerbose

                    Switch
                    (
                        $null
                    )
                    {
                        {Test-Path -Path $('{0}\SysinternalsSuite\{1}' -f $ToolsDirectory, 'Sysmon.exe') -ErrorAction SilentlyContinue}
                        {
                            $null = Copy-Item -Path $('{0}\SysinternalsSuite\{1}' -f $ToolsDirectory, 'Sysmon.exe') -Destination $ToolsDirectory\SysMon\ -Force -ErrorAction SilentlyContinue
                        }
                        {Test-Path -Path $('{0}\SysinternalsSuite\{1}' -f $ToolsDirectory, 'Sysmon64.exe') -ErrorAction SilentlyContinue}
                        {
                            $null = Copy-Item -Path $('{0}\SysinternalsSuite\{1}' -f $ToolsDirectory, 'Sysmon64.exe') -Destination $ToolsDirectory\SysMon\ -Force -ErrorAction SilentlyContinue
                        }
                    }
                #endregion Copy Downloaded Tools

                #region NoCleanUp
                    If
                    (
                        -Not $NoCleanUp
                    )
                    {
                        $null = Remove-Item -Path $('{0}\{1}' -f $Destination, $FileName) -ErrorAction SilentlyContinue

                        Get-ChildItem -Path $('{0}\{1}' -f $BaseDir, $FileInfo.Basename) | ForEach-Object `
                            -Process `
                            {
                                $CurSysInterFile = $_

                                If
                                (
                                    -Not $($ToolsConfig.SysinternalsSuite.Name -contains $CurSysInterFile.name) -and $ToolsConfig.SysinternalsSuite
                                )
                                {
                                    $Null = Remove-item -Path $CurSysInterFile.FullName -Force -ErrorAction SilentlyContinue
                                }
                                ElseIf
                                (
                                    $($ToolsConfig.SysinternalsSuite.Name -contains $CurSysInterFile.name) -and $ToolsConfig.SysinternalsSuite
                                )
                                {
                                    $HashReturn.SysInternals.StoredTools += $($CurSysInterFile.Name)
                                }
                            }
                    }
                #endregion NoCleanUp
            }
            Else
            {
                #region Check Results
                    $HashReturn.SysInternals.DataPull = @{
                        status = $false
                        comment = $Error[0]
                        timestamp =  $('{0}.{1}{2}' -f $(Get-Date -Format MM.dd.yyyy),$(Get-Date -UFormat %R).Replace(':','.'),$(Get-Date -Format .ss))
                    }
                #endregion Check Results

                Return $($HashReturn | ConvertTo-Json -Depth 3)
            }
        #endregion Expand Archive
    }
#endregion Download Archive

#region Output
    $EndTime = $(Get-Date -ErrorAction SilentlyContinue)
    $HashReturn.SysInternals.EndTime = $($($EndTime).DateTime)
    $HashReturn.SysInternals.ElapsedTime = $($(New-TimeSpan -Start $StartTime -End $EndTime -ErrorAction SilentlyContinue) | Select-Object -Property Days, Hours, Milliseconds, Minutes, Seconds)
    Return $($HashReturn | ConvertTo-Json -Depth 3)
#endregion Output
}
#endregion Update-BluGenieSysinternals