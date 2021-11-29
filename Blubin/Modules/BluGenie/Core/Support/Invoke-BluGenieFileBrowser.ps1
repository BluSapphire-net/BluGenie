#region Invoke-BluGenieFileBrowser (Function)
    Function Invoke-BluGenieFileBrowser
    {
        <#
            .SYNOPSIS 
                Invoke-BluGenieFileBrowser will display a graphical user interface to select a file

            .DESCRIPTION
                Invoke-BluGenieFileBrowser will display a graphical user interface to select a file.

                By default all files are shown in the GUI

            .PARAMETER Filter
                Filter the list of files you would like shown in the dialog box

                Note:  The default is ( *.* )

                <Type>String<Type>

            .PARAMETER InitialDirectory
                Select the Initial directory to open the file select dialog box in.

                Note:  The default $env:Homedrive

                <Type>String<Type>

            .PARAMETER Multiselect
                Allow to select multple files

                Note:  The default is ( False )

                <Type>SwitchParameter<Type>

             .PARAMETER Description
                Description or Caption to be presented in the dialog box.

                <Type>String<Type>

            .PARAMETER Walkthrough
                An automated process to walk through the current function and all the parameters

                <Type>SwitchParameter<Type>

            .EXAMPLE
               $MyFile = Invoke-BluGenieFileBrowser

               This will display a GUI to select a single file.  The initial directory will be the root directory.

            .EXAMPLE
               $MyFile = Invoke-BluGenieFileBrowser -Filter *.json -initialDirectory C:\Temp

               This will dispaly a GUI to select a single JSON file.  The initial direcotry will be the C:\Temp directory.

            .EXAMPLE
               $MyFiles = Invoke-BluGenieFileBrowser -Filter *.json -initialDirectory C:\Temp -Multiselect

               This will dispaly a GUI to select multiple JSON files.  The initial direcotry will be the C:\Temp directory.

            .EXAMPLE
                Invoke-BluGenieFileBrowser -Help

                This will display the dynamical help to walk you through all the parameters for this function.
          
            .OUTPUTS
                    TypeName: System.String

            .NOTES
                    
                * Original Author           : Michael Arroyo
                * Original Build Version    : 1908.0501
                * Latest Author             : Michael Arroyo
                * Latest Build Version      : 20.06.0201
                * Comments                  : 
                * Dependencies              : 
                    ~
                * Build Version Details     : 
                    ~ 1908.0501: * [Michael Arroyo] Posted
                    ~ 20.06.0201:* [Michael Arroyo] Updated the Alias to point to the old name.
                                                   
        #>
        [Alias('Invoke-FileBrowser')]
        [CmdletBinding()]
        Param
        (
            [String]$Filter = '*.*',

            [String]$InitialDirectory = $('{0}\' -f $env:HOMEDRIVE),

            [Switch]$Multiselect = $false,

            [String]$Description = 'Select a File',

            [Alias('Help')]
            [Switch]$Walkthrough
        )
        Add-Type -AssemblyName System.Windows.Forms
        $FileBrowser = New-Object -TypeName System.Windows.Forms.OpenFileDialog
        $FileBrowser.FileName = $Filter
        $FileBrowser.Multiselect = $Multiselect
        $FileBrowser.InitialDirectory = $initialDirectory
        $FileBrowser.Title = $Description
        $FileBrowser.CheckFileExists = $true
    
        Switch
        (
            $FileBrowser.ShowDialog()
        )
        {
            'OK'
            {
                Return $($FileBrowser.FileName)
            }
            'Cancel'
            {
                Return
            }
        }
    }
#endregion Invoke-BluGenieFileBrowser (Function)