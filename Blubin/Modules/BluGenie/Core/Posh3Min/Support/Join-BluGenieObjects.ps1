#Requires -Version 3
#region Join-BluGenieObjects (Function)
    Function Join-BluGenieObjects
    {
    <#
        .SYNOPSIS
            Combine 2 Object into 1 Super Object

        .DESCRIPTION
            Combine 2 Object into 1 Super Object

        .PARAMETER Object1
            The Source for the first Object

            <Type>String<Type>


        .PARAMETER Object2
            The Source for the second Object

            <Type>String<Type>

        .PARAMETER Walkthrough
            An automated process to walk through the current function and all the parameters

            <Type>SwitchParameter<Type>

        .EXAMPLE
            $SuperObject = Join-BluGenieObjects -Object1 $FirstObject -Object2 $SecondObject

            This will create a new object called $SuperObject and both Object1 and Object2 are now combined into it

        .OUTPUTS
           System.Management.Automation.PSCustomObject

        .NOTES

            * Original Author           : Michael Arroyo
            * Original Build Version    : 1902.1501
            * Latest Author             : Michael Arroyo
            * Latest Build Version      : 20.05.2101
            * Comments                  :
            * Dependencies              :
                                            ~
            * Build Version Details     :
                                            ~ 1902.1501: * [Michael Arroyo] Posted
                                            ~ 20.05.2101:* [Michael Arroyo] Forced requirments to Posh 3.0

    #>
        [Alias('Combine-Objects')]
        Param
        (
            [Parameter(Mandatory=$true,
                        Position=1)]
            [Object]$Object1,

            [Parameter(mandatory=$true,
                        Position=2)]
            [Object]$Object2
        )

        $Arguments = [Pscustomobject]@()

        #region Parse the First Objects Properties
            $Object1.psobject.Properties | ForEach-Object `
            -Process `
            {
                $CurObjPro = $_
                $Arguments += @{$CurObjPro.Name = $CurObjPro.value}

            }
        #endregion

        #region Parse the Second Objects Properties
            $Object2.psobject.Properties | ForEach-Object `
            -Process `
            {
                $CurObjPro = $_
                $Arguments += @{$CurObjPro.Name = $CurObjPro.value}
            }
        #endregion

        #region Build the new combined Object
            $CompiledObject = [Pscustomobject]$arguments
        #endregion

        Return $CompiledObject
    }
#endregion Join-BluGenieObjects (Function)