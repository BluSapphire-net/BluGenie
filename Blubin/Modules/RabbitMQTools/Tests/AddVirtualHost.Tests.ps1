$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\TestSetup.ps1"
. "$here\..\Public\Add-RabbitMQVirtualHost.ps1"

function TearDownTest() {
    
    $vhosts = Get-RabbitMQVirtualHost -BaseUri $server -Name vh3, vh4

    ($vhosts) | Remove-RabbitMQVirtualHost -BaseUri $server -ErrorAction Continue -Confirm:$false
}

Describe -Tags "Example" "Add-RabbitMQVirtualHost" {
    It "should create new Virtual Host" {
    
        Add-RabbitMQVirtualHost -BaseUri $server -Name "vh3"
        
        $actual = Get-RabbitMQVirtualHost -BaseUri $server -Name "vh3" | select -ExpandProperty name 
        
        $actual | Should Be "vh3"
    
        TearDownTest
    }
    
    It "should do nothing when VirtualHost already exists" {
    
        Add-RabbitMQVirtualHost -BaseUri $server "vh3"
        Add-RabbitMQVirtualHost -BaseUri $server "vh3"
    
        $actual = Get-RabbitMQVirtualHost -BaseUri $server "vh3" | select -ExpandProperty name 
        
        $actual | Should Be "vh3"
    
        TearDownTest
    }
    
    It "should create many Virtual Hosts" {
    
        Add-RabbitMQVirtualHost -BaseUri $server "vh3", "vh4"
    
        $actual = Get-RabbitMQVirtualHost -BaseUri $server "vh3", "vh4" | select -ExpandProperty name 
    
        $expected = $("vh3", "vh4")
    
        AssertAreEqual $actual $expected
    
        TearDownTest
    }
    
    It "should get VirtualHost to be created from the pipe" {
    
        $("vh3", "vh4") | Add-RabbitMQVirtualHost -BaseUri $server
        
        $actual = $($("vh3", "vh4") | Get-RabbitMQVirtualHost -BaseUri $server) | select -ExpandProperty name 
    
        $expected = $("vh3", "vh4")
    
        AssertAreEqual $actual $expected
    
        TearDownTest
    }
    
    It "should get VirtualHost with BaseUri to be created from the pipe" {
    
        $pipe = $(
            New-Object -TypeName psobject -Prop @{"BaseUri" = $server; "Name" = "vh3" }
            New-Object -TypeName psobject -Prop @{"BaseUri" = $server; "Name" = "vh4" }
        )
    
        $pipe | Add-RabbitMQVirtualHost
    
        $actual = $($pipe | Get-RabbitMQVirtualHost -BaseUri $server) | select -ExpandProperty name 
    
        $expected = $("vh3", "vh4")
    
        AssertAreEqual $actual $expected
    
        TearDownTest
    }
}

