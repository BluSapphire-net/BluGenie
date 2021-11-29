﻿<#
.Synopsis
   Gets bindings for given RabbitMQ Queue.

.DESCRIPTION
   The Get-RabbitMQQueueBinding cmdlet gets bindings for given RabbitMQ Queue.

   The cmdlet allows you to show all Bindings for given RabbitMQ Queue.
   The result may be zero, one or many RabbitMQ.Connection objects.

   To get Connections from remote server you need to provide -HostName parameter.

   The cmdlet is using REST Api provided by RabbitMQ Management Plugin. For more information go to: https://www.rabbitmq.com/management.html

.EXAMPLE
   Get-RabbitMQQueueBinding vh1 q1

   This command gets a list of bindings for queue named "q1" on virtual host "vh1".

.EXAMPLE
   Get-RabbitMQQueueBinding -VirtualHost vh1 -Name q1 -HostName myrabbitmq.servers.com

   This command gets a list of bindings for queue named "q1" on virtual host "vh1" and server myrabbitmq.servers.com.

.EXAMPLE
   Get-RabbitMQQueueBinding vh1 q1,q2,q3

   This command gets a list of bindings for queues named "q1", "q2" and "q3" on virtual host "vh1".

.INPUTS
   You can pipe Name, VirtualHost and HostName to this cmdlet.

.OUTPUTS
   By default, the cmdlet returns list of RabbitMQ.QueueBinding objects which describe connections. 

.LINK
    https://www.rabbitmq.com/management.html - information about RabbitMQ management plugin.
#>
function Get-RabbitMQQueueBinding
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='None')]
    Param
    (
        # Name of RabbitMQ Queue.
        [parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [Alias("queue", "QueueName")]
        [string[]]$Name = "",

        # Name of the virtual host to filter channels by.
        [parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [Alias("vh", "vhost")]
        [string]$VirtualHost,

        # Name of the computer hosting RabbitMQ server. Defalut value is localhost.
        [parameter(ValueFromPipelineByPropertyName=$true, Position=2)]
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
        if (-not $VirtualHost)
        {
            # figure out the Virtual Host value
            $p = @{}
            $p.Add("Credentials", $Credentials)
            if ($BaseUri) { $p.Add("BaseUri", $BaseUri) }
            
            $queues = Get-RabbitMQQueue @p | ? Name -eq $Name

            if (-not $queues) { return; }

            if (-not $queues.GetType().IsArray)
            {
                $VirtualHost = $queues.vhost
            } else {
                $vhosts = $queues | select vhost
                $s = $vhosts -join ','
                Write-Error "Queue $Name exists in multiple Virtual Hosts: $($queues.vhost -join ', '). Please specify Virtual Host to use."
            }
        }

        if ($pscmdlet.ShouldProcess("server $BaseUri", "Get bindings for queue(s): $(NamesToString $Name '(all)')"))
        {
            foreach ($n in $Name)
            {
                $result = GetItemsFromRabbitMQApi -BaseUri $BaseUri $Credentials "queues/$([System.Web.HttpUtility]::UrlEncode($VirtualHost))/$([System.Web.HttpUtility]::UrlEncode($n))/bindings"

                $result | Add-Member -NotePropertyName "HostName" -NotePropertyValue $BaseUri

                SendItemsToOutput $result "RabbitMQ.QueueBinding"
            }
        }
    }
    End
    {
    }
}
