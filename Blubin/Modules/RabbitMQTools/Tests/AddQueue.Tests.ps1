$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$here\TestSetup.ps1"
. "$here\..\Public\Add-RabbitMQQueue.ps1"

function TearDownTest($VirtualHost = "/", $Queues) {
    
    foreach($queue in $queues){
        Remove-RabbitMQQueue -BaseUri $server -name $queue -ErrorAction Continue -Confirm:$false
    }
}

Describe -Tags "Example" "Add-RabbitMQQueue" {

    It "should create new Queue" {
    
        Add-RabbitMQQueue -BaseUri $server -Name q1
        
        $actual = Get-RabbitMQQueue -BaseUri $server -Name q1 | select -ExpandProperty name 
        
        $actual | Should Be "q1"
    
        TearDownTest -Queues q1
    }
	
	## do we need a test to create a queue on a non-default vhost?

    It "should create Durable new Queue" {
    
        Add-RabbitMQQueue -BaseUri $server -Name q1 -Durable
        
        $actual = Get-RabbitMQQueue -BaseUri $server -Name q1 | select -ExpandProperty durable
        
        $actual | Should Be $true
    
        TearDownTest -Queues q1
    }

    It "should create AutoDelete new Queue" {
    
        Add-RabbitMQQueue -BaseUri $server -Name q1 -AutoDelete
        
        $actual = Get-RabbitMQQueue -BaseUri $server -Name q1 | select -ExpandProperty auto_delete
        
        $actual | Should Be $true
    
        TearDownTest -Queues q1
    }

    It "should create Durable, AutoDelete new Queue" {
    
        Add-RabbitMQQueue -BaseUri $server -Name q1 -Durable -AutoDelete

        $actual = Get-RabbitMQQueue -BaseUri $server -Name q1 | select -ExpandProperty durable
        $actual | Should Be $true
        
        $actual = Get-RabbitMQQueue -BaseUri $server -Name q1 | select -ExpandProperty auto_delete
        $actual | Should Be $true
    
        TearDownTest -Queues q1
    }

    It "should do nothing when Queue already exists" {
    
        Add-RabbitMQQueue -BaseUri $server -Name q1
        Add-RabbitMQQueue -BaseUri $server -Name q1
    
        $actual = Get-RabbitMQQueue -BaseUri $server -Name q1 | select -ExpandProperty name 
        $actual | Should Be "q1"
    
        TearDownTest -Queues q1
    }

    It "should create many Queues" {
    
        Add-RabbitMQQueue -BaseUri $server -Name q1,q2,q3
    
        $actual = Get-RabbitMQQueue -BaseUri $server -Name "q*" | select -ExpandProperty name 
    
        $expected = $("q1", "q2", "q3")
        AssertAreEqual $actual $expected
    
        TearDownTest -Queues q1,q2,q3
    }

    It "should get queue names from the pipe" {
    
        $pipe = $("q1", "q1") 
        
        $pipe| Add-RabbitMQQueue -BaseUri $server
        
        $actual = $($pipe | Get-RabbitMQQueue -BaseUri $server) | select -ExpandProperty name 
    
        $expected = $pipe
    
        AssertAreEqual $actual $expected
    
        TearDownTest -Queues q1
    }

    It "should get queue definitions from the pipe" {
    
        $pipe = $(
            New-Object -TypeName psobject -Prop @{"BaseUri" = $server; "VirtualHost" = "/" ; "Name" = "q1" }
            New-Object -TypeName psobject -Prop @{"BaseUri" = $server; "VirtualHost" = "/" ; "Name" = "q2"; "Durable" = $true }
            New-Object -TypeName psobject -Prop @{"BaseUri" = $server; "VirtualHost" = "/" ; "Name" = "q3"; "AutoDelete" = $true }
            New-Object -TypeName psobject -Prop @{"BaseUri" = $server; "VirtualHost" = "/" ; "Name" = "q4"; "Durable" = $true; "AutoDelete" = $true }
        )
    
        $pipe | Add-RabbitMQQueue
    
        $actual = $pipe | Get-RabbitMQQueue -BaseUri $server
        
        foreach ($e in $pipe)
        {
            $a = $actual | ? name -eq $e.Name

            $a | Should Not Be $null
            $a.vhost | Should Be $e.VirtualHost
            if ($e.Durable) { $a.durable | Should Be $true }
            if ($e.AutoDelete) { $a.auto_delete | Should Be $true }
        }
    
        TearDownTest -Queues q1,q2,q3,q4
    }

}