<#
.Synopsis
   Gets RabbitMQ Nodes.

.DESCRIPTION
   The Get-RabbitMQNode cmdlet gets nodes in RabbitMQ cluster.

   The cmdlet allows you to show list of cluster nodes or filter them by name using wildcards.
   The result may be zero, one or many RabbitMQ.Node objects.

   To get Nodes from remote server you need to provide -HostName parameter.

   The cmdlet is using REST Api provided by RabbitMQ Management Plugin. For more information go to: https://www.rabbitmq.com/management.html

.EXAMPLE
   Get-RabbitMQNode

   This command gets a list of nodes in RabbitMQ cluster.

.EXAMPLE
   Get-RabbitMQNode -HostName myrabbitmq.servers.com

   This command gets a list of nodes in the cluster on myrabbitmq.servers.com server.

.EXAMPLE
   Get-RabbitMQNode second*

   This command gets a list of nodes in a cluster which name starts with "second".

.EXAMPLE
   Get-RabbitMQNode secondary*, primary

   This command gets cluster nodes which name is either "primary" or starts with "secondary".


.EXAMPLE
   @("primary", "secondary") | Get-RabbitMQNode

   This command pipes node name filters to Get-RabbitMQNode cmdlet.

.INPUTS
   You can pipe Name to filter the results.

.OUTPUTS
   By default, the cmdlet returns list of RabbitMQ.Node objects which describe cluster nodes.

.LINK
    https://www.rabbitmq.com/management.html - information about RabbitMQ management plugin.
#>
function Get-RabbitMQNode
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='None')]
    Param
    (
        # Name of RabbitMQ Node.
        [parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias("Node", "NodeName")]
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
        if ($pscmdlet.ShouldProcess("server $BaseUri", "Get node(s): $(NamesToString $Name '(all)')"))
        {
            $result = GetItemsFromRabbitMQApi -BaseUri $BaseUri $Credentials "nodes"
            
            $result = ApplyFilter $result 'name' $Name

            $result | Add-Member -NotePropertyName "HostName" -NotePropertyValue $BaseUri

            SendItemsToOutput $result "RabbitMQ.Node"
        }
    }
    End
    {
    }
}
