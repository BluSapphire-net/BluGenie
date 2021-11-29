<#
.Synopsis
   Registers RabbitMQ server.

.DESCRIPTION
   Register-RabbitMQ server cmdlet allows to add RabbitMQ server to the tab completition list for HostName.

.EXAMPLE
   Register-RabbitMQServer '127.0.0.1'

   Adds server 127.0.0.1 to auto completition list for HostName parameter.

.EXAMPLE
   Register-RabbitMQServer '127.0.0.1' 'My local PC'

   Adds server 127.0.0.1 to auto completition list for HostName parameter. The text 'My local PC' will be used as a tooltip.
#>
function Register-RabbitMQServer
{
    [CmdletBinding()]
    Param
    (
        # Name of the RabbitMQ server to be registered.
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        $BaseUri,

        # Description to be used in tooltip. If not provided then computer name will be used.
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true, Position=1)]
        $Description
    )

    Begin
    {
        if (-not $global:RabbitMQServers)
        { 
            $global:RabbitMQServers = @() 
        }
    }
    Process
    {
        $obj += $global:RabbitMQServers | ? ListItemText -eq $BaseUri
        if (-not $obj)
        {
            if (-not $Description) { $Description = $BaseUri }
            $escapedHostName = $BaseUri -replace '\[', '``[' -replace '\]', '``]'
            $global:RabbitMQServers += New-Object System.Management.Automation.CompletionResult $escapedHostName, $BaseUri, 'ParameterValue', $Description
        } else {
            Write-Warning "Server $BaseUri is already registered. If you want to update the entry you need to unregister the server and register it again"
        }
    }
    End
    {
    }
}