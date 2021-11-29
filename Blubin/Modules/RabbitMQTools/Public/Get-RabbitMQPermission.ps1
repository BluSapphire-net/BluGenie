﻿<#
.Synopsis
   Gets Permissions for VirtualHost and/or user.

.DESCRIPTION
   The Get-RabbitMQPermission cmdlet shows permissions users have to work with virtual hosts.

   The cmdlet allows you to show all permissions or filter them by VirtualHost and/or User using wildcards.
   The result may be zero, one or many RabbitMQ.Permission objects.

   To get permissions from remote server you need to provide -HostName.

   The cmdlet is using REST Api provided by RabbitMQ Management Plugin. For more information go to: https://www.rabbitmq.com/management.html

.EXAMPLE
   Get-RabbitMQPermission

   Show permissions of all users and all virtual hosts from the local RabbitMQ server.

.EXAMPLE
   Get-RabbitMQPermission -HostName myrabbitmq.servers.com

   Show permissions of all users and all virtual hosts from the myrabbitmq.servers.com server RabbitMQ server.

.EXAMPLE
    Get-RabbitMQPermission -VirtualHost / -User guest

    List user guest permissions to virtual host /.

.EXAMPLE
   Get-RabbitMQPermission private*

   Show permissions of all users in virtual hosts which name starts with "private".

.EXAMPLE
   Get-RabbitMQPermission private*, public*

   This command gets a list of all Virtual Hosts which name starts with "private" or "public".

.INPUTS
   You can pipe Virtual Host and User names to filter results.

.OUTPUTS
   By default, the cmdlet returns list of RabbitMQ.Permission objects. 

.LINK
    https://www.rabbitmq.com/management.html - information about RabbitMQ management plugin.
#>
function Get-RabbitMQPermission
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='None')]
    Param
    (
        # Name of RabbitMQ Virtual Host.
        [parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position = 0)]
        [Alias("vh")]
        [string[]]$VirtualHost = "",

        # Name of RabbitMQ Virtual Host.
        [parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position = 1)]
        [string[]]$User = "",

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
        if ($pscmdlet.ShouldProcess("server $BaseUri", "Get permission(s) for VirtualHost = $(NamesToString $VirtualHost '(all)') and User = $(NamesToString $User '(all)')"))
        {
            $result = GetItemsFromRabbitMQApi -BaseUri $BaseUri $Credentials "permissions"
            $result = ApplyFilter $result "vhost" $VirtualHost
            $result = ApplyFilter $result "user" $User


            foreach($i in $result)
            {
                $i | Add-Member -NotePropertyName "HostName" -NotePropertyValue $BaseUri
            }

            SendItemsToOutput $result "RabbitMQ.Permission"
        }
    }
    End
    {
    }
}
