function GetItemsFromRabbitMQApi
{
    [CmdletBinding()]
    Param
    (
        [parameter(Mandatory=$true, Position = 0)]
        [alias("HostName", "cn")]
        [string]$BaseUri = $defaultComputerName,

        [parameter(Mandatory=$true, Position = 1)]
        [PSCredential]$cred = $defaultCredentials,
        
        [parameter(Mandatory=$true, Position = 2)]
        [string]$function,

        [int]$Port = 15672
    )

    Add-Type -AssemblyName System.Web
    #Add-Type -AssemblyName System.Net
                
    $url = Join-Parts $BaseUri "/api/$function"
    Write-Verbose "Invoking REST API: $url"
    
    return Invoke-RestMethod $url -Credential $cred -DisableKeepAlive -AllowEscapedDotsAndSlashes
}
