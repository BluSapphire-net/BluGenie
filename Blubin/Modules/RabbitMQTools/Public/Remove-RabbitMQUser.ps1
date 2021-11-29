<#
.Synopsis
   Removes user from RabbitMQ server.

.DESCRIPTION
   The Remove-RabbitMQUser cmdlet allows to delete users from RabbitMQ server.

   To remove a user from remote server you need to provide -HostName.

   The cmdlet is using REST Api provided by RabbitMQ Management Plugin. For more information go to: https://www.rabbitmq.com/management.html

   To support requests using default virtual host (/), the cmdlet will temporarily disable UnEscapeDotsAndSlashes flag on UriParser. For more information check get-help about_UnEsapingDotsAndSlashes.

.EXAMPLE
   Remove-RabbitMQUser -Name Admin

   Deletes user "Admin"from local RabbitMQ server.

.EXAMPLE
   Remove-RabbitMQUser -HostName rabbitmq.server.com Admin

   Deletes user "Admin" from rabbitmq.server.com server. This command uses positional parameters.

.INPUTS
   You can pipe Name and HostName to this cmdlet.

.LINK
    https://www.rabbitmq.com/management.html - information about RabbitMQ management plugin.
#>
function Remove-RabbitMQUser
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
    Param
    (
        # Name of user to delete.
        [parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [string]$Name,

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
        if ($pscmdlet.ShouldProcess("server: $BaseUri", "Delete user $Name"))
        {
            $url = Join-Parts $BaseUri "/api/users/$([System.Web.HttpUtility]::UrlEncode($Name))"
            $result = Invoke-RestMethod $url -Credential $Credentials -AllowEscapedDotsAndSlashes -DisableKeepAlive:$InvokeRestMethodKeepAlive -ErrorAction Continue -Method Delete -ContentType "application/json"

            Write-Verbose "Deleted user $User"
            $cnt++
        }
    }
    End
    {
        if ($cnt -gt 1) { Write-Verbose "Deleted $cnt users." }
    }
}
