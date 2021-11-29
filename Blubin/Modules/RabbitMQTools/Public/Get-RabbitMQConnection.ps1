<#
.Synopsis
   Gets Connections to the server.

.DESCRIPTION
   The Get-RabbitMQConnection cmdlet gets connections to the RabbitMQ server.

   The cmdlet allows you to show all Connections or filter them by name using wildcards.
   The result may be zero, one or many RabbitMQ.Connection objects.

   To get Connections from remote server you need to provide -HostName parameter.

   The cmdlet is using REST Api provided by RabbitMQ Management Plugin. For more information go to: https://www.rabbitmq.com/management.html

.EXAMPLE
   Get-RabbitMQConnection

   This command gets a list of all connections to local RabbitMQ server.

.EXAMPLE
   Get-RabbitMQConnection -HostName myrabbitmq.servers.com

   This command gets a list of all connections myrabbitmq.servers.com server.

.EXAMPLE
   Get-RabbitMQConnection con1*

   This command gets a list of all Connections with name starting with "con1".

.EXAMPLE
   Get-RabbitMQConnection private*, public*

   This command gets a list of all Connections with name starting with either "private" or "public".


.EXAMPLE
   @("private*", "*public") | Get-RabbitMQConnection

   This command pipes name filters to Get-RabbitMQConnection cmdlet.

.INPUTS
   You can pipe Name to filter the results.

.OUTPUTS
   By default, the cmdlet returns list of RabbitMQ.Connection objects which describe connections. 

.LINK
    https://www.rabbitmq.com/management.html - information about RabbitMQ management plugin.
#>
function Get-RabbitMQConnection
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='None')]
    Param
    (
        # Name of RabbitMQ Connection.
        [parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias("Connection", "ConnectionName")]
        [string[]]$Name = "",
               
        # Name of the computer hosting RabbitMQ server. Defalut value is localhost.
        [parameter(ValueFromPipelineByPropertyName=$true)]
        [Alias("HostName", "hn", "cn")]
        [string]$BaseUri = $defaultComputerName,

        # Credentials to use when logging to RabbitMQ server.
        [Parameter(Mandatory=$false)]
        [PSCredential]$Credentials = $defaultCredentials
    )

    Begin
    {
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("server $BaseUri", "Get connection(s): $(NamesToString $Name '(all)')"))
        {
            $result = GetItemsFromRabbitMQApi -BaseUri $BaseUri $Credentials "connections"
            
            $result = ApplyFilter $result 'name' $Name

            $result | Add-Member -NotePropertyName "HostName" -NotePropertyValue $BaseUri

            SendItemsToOutput $result "RabbitMQ.Connection"
        }
    }
    End
    {
    }
}
