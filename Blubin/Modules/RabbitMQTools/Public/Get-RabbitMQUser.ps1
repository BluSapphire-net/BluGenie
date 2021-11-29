﻿<#
.Synopsis
   Gets list of users.

.DESCRIPTION
   The Get-RabbitMQUser gets list of users registered in RabbitMQ server.

   The result may be zero, one or many RabbitMQ.User objects.

   To get users from remote server you need to provide -HostName.

   The cmdlet is using REST Api provided by RabbitMQ Management Plugin. For more information go to: https://www.rabbitmq.com/management.html

.EXAMPLE
   Get-RabbitMQUser

   Gets list of all users in local RabbitMQ server.

.EXAMPLE
   Get-RabbitMQUser -HostName myrabbitmq.servers.com

   Gets list of all users in myrabbitmq.servers.com server.

.EXAMPLE
   Get-RabbitMQUser gu*

   Gets list of all users whose name starts with "gu".

.EXAMPLE
   Get-RabbitMQUser guest, admin

   Gets data for users guest and admin.

.EXAMPLE
   Get-RabbitMQUser -View Flat

   Gets flat list of all users. This view doesn't group users by HostName as the default view do.

.INPUTS
   You can pipe Names and HostNames to filter results.

.OUTPUTS
   By default, the cmdlet returns list of RabbitMQ.User objects which describe user. 

.LINK
    https://www.rabbitmq.com/management.html - information about RabbitMQ management plugin.
#>
function Get-RabbitMQUser
{
    [CmdletBinding(SupportsShouldProcess=$true, PositionalBinding=$false)]
    Param
    (
        # Name of the computer hosting RabbitMQ server. Defalut value is localhost.
        [parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [string[]]$Name,

        # Name of the computer hosting RabbitMQ server. Defalut value is localhost.
        [parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias("cn", "HostName")]
        [string]$BaseUri = $defaultComputerName,
        
        [ValidateSet("Default", "Flat")]
        [string]$View,

        [Parameter(Mandatory=$false)]
        [PSCredential]$Credentials = $defaultCredentials
    )

    Begin
    {
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("server $BaseUri", "Get user(s)"))
        {
            $result = GetItemsFromRabbitMQApi -BaseUri $BaseUri $Credentials "users"
            $result = ApplyFilter $result 'name' $Name
            $result | Add-Member -NotePropertyName "HostName" -NotePropertyValue $BaseUri
 
            if (-not $View) { SendItemsToOutput $result "RabbitMQ.User" }
            else { SendItemsToOutput $result "RabbitMQ.User" | ft -View $View }
        }
    }
    End
    {
    }
}