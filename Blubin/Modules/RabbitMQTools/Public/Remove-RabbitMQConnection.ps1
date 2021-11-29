﻿<#
.Synopsis
   Closes connection to RabbitMQ server.

.DESCRIPTION
   The Remove-RabbitMQConnection allows for closing connection to the RabbitMQ server. This cmdlet is marked with High impact.

   To close connections to the remote server you need to provide -HostName parameter.

   You may pipe an object with names and, optionally, with computer names to close multiple connection. For more information how to do that see Examples.

   The cmdlet is using REST Api provided by RabbitMQ Management Plugin. For more information go to: https://www.rabbitmq.com/management.html

.EXAMPLE
   Remove-RabbitMQConnection conn1

   This command closes connection  to local RabbitMQ server named "conn1".

.EXAMPLE
   Remove-RabbitMQConnection c1, c1

   This command closes connections  to local RabbitMQ server named "c1" and "c2".

.EXAMPLE
   Remove-RabbitMQConnection c1 -HostName myrabbitmq.servers.com

   This command closes connection c1 to myrabbitmq.servers.com server.

.EXAMPLE
   @("c1", "c2") | Remove-RabbitMQConnection

   This command pipes list of connection to be closed. In the above example two connections named "c1" and "c2" will be closed.

.EXAMPLE
    $a = $(
        New-Object -TypeName psobject -Prop @{"HostName" = "localhost"; "Name" = "c1"}
        New-Object -TypeName psobject -Prop @{"HostName" = "localhost"; "Name" = "c2"}
        New-Object -TypeName psobject -Prop @{"HostName" = "127.0.0.1"; "Name" = "c3"}
    )


   $a | Remove-RabbitMQConnection

   Above example shows how to pipe both connection name and Computer Name to specify server.
   
   The above example will close two connection named "c1" and "c2" to local server, and one connection named "c3" to the server 127.0.0.1.

.INPUTS
   You can pipe connection names and optionally HostNames to this cmdlet.

.LINK
    https://www.rabbitmq.com/management.html - information about RabbitMQ management plugin.
#>
function Remove-RabbitMQConnection
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    Param
    (
        # Name of RabbitMQ connection.
        [parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [Alias("ConnectionName")]
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
        $cnt = 0
    }
    Process
    {
        if (-not $pscmdlet.ShouldProcess("server: $BaseUri", "Close connection(s): $(NamesToString $Name '(all)')")) {
            foreach ($qn in $Name)
            { 
                Write "Closing connection $qn to server=$BaseUri"
                $cnt++
            }
            return
        }

        foreach($n in $Name)
        {
            $url = Join-Parts $BaseUri "/api/connections/$([System.Web.HttpUtility]::UrlEncode($n))"
            $result = Invoke-RestMethod $url -Credential $Credentials -DisableKeepAlive:$InvokeRestMethodKeepAlive -ErrorAction Continue -Method Delete

            Write-Verbose "Closed connection $n to server $BaseUri"
            $cnt++
        }
    }
    End
    {
        if ($cnt > 1) { Write-Verbose "Closed $cnt connection(s)." }
    }
}
