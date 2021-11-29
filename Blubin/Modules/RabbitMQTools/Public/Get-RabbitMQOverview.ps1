<#
.Synopsis
   Get overview information about RabbitMQ server.

.DESCRIPTION
   The Get-RabbitMQOverview gets overview information about one or more RabbitMQ servers.

   Returned object contains information about RabbitMQ server such as its version, Erlang version, node name, number of exchanges, queues, messages, consumers, connection and channels. It also contains object with server statistics.

   The cmdlet is using REST Api provided by RabbitMQ Management Plugin. For more information go to: https://www.rabbitmq.com/management.html

.INPUTS
   You can pipe HostName to the cmdlet.

.OUTPUTS
   By default, the cmdlet returns list of RabbitMQ.ServerOverview objects which describe RabbitMQ server. 

.EXAMPLE
   Get-RabbitMQOverview

   Gets overview information about local RabbitMQ server.

.EXAMPLE
   Get-RabbitMQOverview localhost, 127.0.0.1

   Gets overview information about following servers: localhost and 127.0.0.1. This command can be used to compare different instances.

.EXAMPLE
   @('localhost', '127.0.0.1') | Get-RabbitMQOverview

   This example shows how to pipe list of servers for which to get overview information. In the above example the cmdlet will show information about following servers: localhost and 127.0.0.1.

.LINK
    https://www.rabbitmq.com/management.html - information about RabbitMQ management plugin.
#>
function Get-RabbitMQOverview
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='None')]
    Param
    (
        # Name of the computer hosting RabbitMQ server. Defalut value is localhost.
        [parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [Alias("cn", "HostName", "ComputerName")]
        [string[]]$BaseUri = $defaultComputerName,

        # Credentials to use when logging to RabbitMQ server.
        [Parameter(Mandatory=$false)]
        [PSCredential]$Credentials = $defaultCredentials
    )

    Begin
    {
    }
    Process
    {
        if (-not $pscmdlet.ShouldProcess("server $BaseUri", "Get overview: $(NamesToString $Name '(all)')"))
        {
            foreach ($cn in $BaseUri)
            {
                Write-Host "Getting overview for server: $cn"
            }
            return;
        }

        foreach ($cn in $BaseUri)
        {
            $overview = GetItemsFromRabbitMQApi -BaseUri $cn $Credentials "overview"
            $overview | Add-Member -NotePropertyName "HostName" -NotePropertyValue $cn
            $overview.PSObject.TypeNames.Insert(0, "RabbitMQ.ServerOverview")

            Write-Output $overview
        }
    }
    End
    {
    }
}
