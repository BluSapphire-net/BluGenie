<#
.Synopsis
   Unregisters RabbitMQ server.

.DESCRIPTION
   Unregister-RabbitMQ server cmdlet allows to remove RabbitMQ server from tab completition list for HostName.

.EXAMPLE
   Unregister-RabbitMQServer '127.0.0.1'

   Removes server 127.0.0.1 from auto completition list for HostName parameter.
#>
function Unregister-RabbitMQServer
{
    [CmdletBinding()]
    Param
    (
        # Name of the RabbitMQ server to be unregistered.
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        $BaseUri
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

        if ($obj)
        {
            $global:RabbitMQServers = $global:RabbitMQServers | ? ListItemText -ne $BaseUri
        }
    }
    End
    {
    }
}