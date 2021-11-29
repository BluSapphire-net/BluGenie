$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\TestSetup.ps1"
. "$here\..\Public\Remove-RabbitMQVirtualHost.ps1"

function SetUpTest($vhosts = ("vh1","vh2")) {
    
    Add-RabbitMQVirtualHost -BaseUri $server -Name $vhosts

}

function TearDownTest($vhosts = ("vh1","vh2")) {
    
    foreach($vhost in $vhosts){
        Remove-RabbitMQVirtualHost -BaseUri $server -Name $vhost -ErrorAction Continue -Confirm:$false
    }
}

Describe -Tags "Example" "Remove-RabbitMQVirtualHost" {
    It "should remove existing Virtual Host" {

        SetUpTest

        Add-RabbitMQVirtualHost -BaseUri $server "vh3"
        Remove-RabbitMQVirtualHost -BaseUri $server "vh3" -Confirm:$false
        
        $actual = Get-RabbitMQVirtualHost -BaseUri $server "vh*" | select -ExpandProperty name 
        
        $actual | Should Be $("vh1", "vh2")

        TearDownTest
    }
}