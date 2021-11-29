[![Build status](https://ci.appveyor.com/api/projects/status/ch6ow47f6bnpwrvx/branch/master?svg=true)](https://ci.appveyor.com/project/RamblingCookieMonster/rabbitmqtools/branch/master)

RabbitMQTools
=============

This module provides a set of cmdlets to manage RabbitMQ through the REST API. It was originally written by @mariuszwojcik, with [slight modifications](https://github.com/mariuszwojcik/RabbitMQTools/issues/1) from @ramblingcookiemonster.

A brief walk through on some basic components of this module are included in the [RabbitMQ and PowerShell](http://ramblingcookiemonster.github.io/RabbitMQ-Intro/) post.

## Instructions

[Download](https://github.com/RamblingCookieMonster/RabbitMQTools/archive/master.zip), unblock, and copy the module folder to a valid module path.

```PowerShell
# Download RabbitMqTools
# https://github.com/RamblingCookieMonster/RabbitMQTools/archive/master.zip
# Unblock the archive
# Copy the RabbitMQTools module to one of your module paths ($env:PSModulePath -split ";")

# Alternatively, with PowerShell 5, or PowerShellGet:
    Install-Module RabbitMQTools

#Import the module
    Import-Module RabbitMQTools -force

#Get commands from the module
    Get-Command -module RabbitMQTools

#Get help for a command
    Get-Help Get-RabbitMQOverview
   
#Can you hit the server?
    Get-RabbitMQOverview -BaseUri "https://rabbitmq.contoso.com:15671" -Credential (Get-Credential)
```

## Example

```PowerShell
#Import the module
    Import-Module RabbitMQTools -force

#Define some credentials.  You need an account on RabbitMQ server before we can do this
    $credRabbit = Get-Credential
 
#Convenience - tab completion support for BaseUri
    Register-RabbitMQServer -BaseUri "https://rabbitmq.contoso.com:15671"
 
#I don't want to keep typing those common parameters... we'll splat them
    $Params = @{
        BaseUri = "https://rabbitmq.contoso.com:15671"
        Credential = $credRabbit
    }
 
#Can you hit the server?
    Get-RabbitMQOverview @params
 
#This shows how to create an Exchange and a Queue
#Think of the Exchange as the Blue USPS boxes, and a queue as the individual mailboxes the Exchanges route messages to
    $ExchangeName = "TestFanExc"
    $QueueName = 'TestQueue'
 
#Create an exchange
    Add-RabbitMQExchange @params -name $ExchangeName -Type fanout -Durable -VirtualHost /
 
#Create a queue for the exchange - / is a vhost initialized with install
    Add-RabbitMQQueue @params -Name $QueueName -Durable -VirtualHost /
 
#Bind them
    Add-RabbitMQQueueBinding @params -ExchangeName $ExchangeName -Name $QueueName -VirtualHost / -RoutingKey TestQueue
 
#Add a message to the exchange
    $message = [pscustomobject]@{samaccountname='cmonster';home='\\server\cmonster$'} | ConvertTo-Json
    Add-RabbitMQMessage @params -VirtualHost / -ExchangeName $ExchangeName -RoutingKey TestQueue -Payload $Message
 
#View your changes:
    Get-RabbitMQExchange @params
    Get-RabbitMQQueue @params
    Get-RabbitMQQueueBinding @params -Name $QueueName
 
#View the message we added:
    Get-RabbitMQMessage @params -VirtualHost / -Name $QueueName
    <#
 
        # = the number in the queue
        Queue = name of the queue
        R = whether we've read it (blank when you first read it, * if something has read it)
        Payload = your content.  JSON is helpful here.
 
              # Queue                R Payload
            --- -----                - -------
              1 TestQueue            * {...
    #>
 
#View the payload for the message we added:
    Get-RabbitMQMessage @params -VirtualHost / -Name $QueueName | Select -ExpandProperty Payload

    <#
        JSON output:

        {
            "samaccountname":  "cmonster",
            "home":  "\\\\server\\cmonster$"
        }
    #>

#Example processing the message
    $Incoming = Get-RabbitMQMessage @params -VirtualHost / -Name $QueueName -count 1 -Remove
    $IncomingData = $Incoming.payload | ConvertFrom-Json
    #If something fails, add the message back, or handle with other logic...

    #It's gone
    Get-RabbitMQMessage @params -VirtualHost / -Name $QueueName -count 1
 
    #We have our original data back...
    $IncomingData
 
    #There are better ways to handle this, illustrative purposes only : )
 
#Remove the Queue
    Remove-RabbitMQQueue @params -Name $QueueName -VirtualHost /
 
#Remove the Exchange
    Remove-RabbitMQExchange @params -ExchangeName $ExchangeName -VirtualHost /
 
#Verify that the queueu and Exchange are gone:
    Get-RabbitMQExchange @params
    Get-RabbitMQQueue @params

```

## What can I do with it?

There is a set of cmdlets to manage the server, such as:

- Get-RabbitMQOverview
- Get-RabbitMQNode
- Get-RabbitMQConnection
- Get-RabbitMQChannel
- Get-RabbitMQVirtualHost, Add-RabbitMQVirtualHost, Remove-RabbitMQVirtualHost
- Get-RabbitMQExchage, Add-RabbitMQExchange, Remove-RabbitMQExchange
- Get-RabbitMQQueue, Add-RabbitMQQueue, Remove-RabbitMQQueue
- Get-RabbitMQMessage

To learn more about a cmdlet, or to see some examples run get-help cmdlet_name
