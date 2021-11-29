<#
.Synopsis
   Removes Virtual Hosts from RabbitMQ server.

.DESCRIPTION
   The Remove-RabbitMQVirtualHost allows for removing Virtual Hosts in given RabbitMQ server. This cmdlet is marked with High impact.

   To remove Virtual Hosts from remote server you need to provide -HostName.

   You may pipe an object with names and, optionally, with computer names to remove multiple VirtualHosts. For more information how to do that see Examples.

   The cmdlet is using REST Api provided by RabbitMQ Management Plugin. For more information go to: https://www.rabbitmq.com/management.html

   To support requests using default virtual host (/), the cmdlet will temporarily disable UnEscapeDotsAndSlashes flag on UriParser. For more information check get-help about_UnEsapingDotsAndSlashes.

.EXAMPLE
   Remove-RabbitMQVirtualHost testHost

   This command removes Virtual Host named "testHost" from local RabbitMQ server.

.EXAMPLE
   Remove-RabbitMQVirtualHost VHost1, VHost2

   This command removes Virtual Hosts named "VHost1" and "VHost2" from local RabbitMQ server.

.EXAMPLE
   Remove-RabbitMQVirtualHost testHost -HostName myrabbitmq.servers.com

   This command removes Virtual Host named "testHost" from myrabbitmq.servers.com server.

.EXAMPLE
   @("VHost1", "VHost2") | Remove-RabbitMQVirtualHost

   This command pipes list of Virtual Hosts to be removed from the RabbitMQ server. In the above example two Virtual Hosts named "VHost1" and "VHost2" will be removed from local RabbitMQ server.

.EXAMPLE
    $a = $(
        New-Object -TypeName psobject -Prop @{"HostName" = "localhost"; "Name" = "vh1"}
        New-Object -TypeName psobject -Prop @{"HostName" = "localhost"; "Name" = "vh2"}
        New-Object -TypeName psobject -Prop @{"HostName" = "127.0.0.1"; "Name" = "vh3"}
    )


   $a | Remove-RabbitMQVirtualHost

   Above example shows how to pipe both Virtual Host name and Computer Name to specify server from which the Virtual Host should be removed.
   
   In the above example two Virtual Hosts named "vh1" and "vh2" will be removed from RabbitMQ local server, and one Virtual Host named "vh3" will be removed from the server 127.0.0.1.

.INPUTS
   You can pipe VirtualHost names and optionally HostNames to this cmdlet.

.LINK
    https://www.rabbitmq.com/management.html - information about RabbitMQ management plugin.
#>
function Remove-RabbitMQVirtualHost
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    Param
    (
        # Name of RabbitMQ Virtual Host.
        [parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [Alias("vh", "VirtualHost")]
        [string[]]$Name = "",

        # Name of the computer hosting RabbitMQ server. Defalut value is localhost.
        [parameter(ValueFromPipelineByPropertyName=$true, Position=1)]
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
        if (-not $pscmdlet.ShouldProcess("server: $BaseUri", "Remove vhost(s): $(NamesToString $Name '(all)')")) {
            foreach ($qn in $Name)
            { 
                Write "Deleting Virtual Host(s) $qn (server=$BaseUri)" 
                $cnt++
            }
            return
        }

        foreach($n in $Name)
        {
            $url = Join-Parts $BaseUri "/api/vhosts/$([System.Web.HttpUtility]::UrlEncode($n))"
            $result = Invoke-RestMethod $url -Credential $Credentials -AllowEscapedDotsAndSlashes -DisableKeepAlive:$InvokeRestMethodKeepAlive -ErrorAction Continue -Method Delete -ContentType "application/json"

            Write-Verbose "Removed Virtual Host $n on server $BaseUri"
            $cnt++
        }
    }
    End
    {
        Write-Verbose "Removed $cnt Virtual Host(s)."
    }
}
