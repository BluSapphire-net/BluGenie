#Set Module Variables
$InvokeRestMethodKeepAlive = $True

#Capture PSEdition
$isPowershellCore = $false
If ($PSVersiontable.PSEdition -eq 'core') {
    $isPowershellCore = $true
} 

#Get public and private function definition files.
    $Public  = Get-ChildItem $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue 
    $Private = Get-ChildItem $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue 

#Dot source the files
    Foreach($import in @($Public + $Private))
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error "Failed to import function $($import.fullname)"
        }
    }

# Uri parser variables
if (-not $isPowershellCore) {
    if (-not $UnEscapeDotsAndSlashes) { Set-Variable -Scope Script -name UnEscapeDotsAndSlashes -value 0x2000000 }
    if (-not $defaultUriParserFlagsValue) { Set-Variable -Scope Script -name defaultUriParserFlagsValue -value (GetUriParserFlags) }
    if (-not $uriUnEscapesDotsAndSlashes) { Set-Variable -Scope Script -name uriUnEscapesDotsAndSlashes -value (($defaultUriParserFlagsValue -band $UnEscapeDotsAndSlashes) -eq $UnEscapeDotsAndSlashes) }
}


# Aliases
New-Alias -Name grvh -value Get-RabbitMQVirtualHost -Description "Gets RabbitMQ's Virutal Hosts"
New-Alias -Name getvhost -value Get-RabbitMQVirtualHost -Description "Gets RabbitMQ's Virutal Hosts"
New-Alias -Name arvh -value Add-RabbitMQVirtualHost -Description "Adds RabbitMQ's Virutal Hosts"
New-Alias -Name addvhost -value Add-RabbitMQVirtualHost -Description "Adds RabbitMQ's Virutal Hosts"
New-Alias -Name rrvh -value Remove-RabbitMQVirtualHost -Description "Removes RabbitMQ's Virutal Hosts"
New-Alias -Name delvhost -value Remove-RabbitMQVirtualHost -Description "Removes RabbitMQ's Virutal Hosts"

New-Alias -Name gre -value Get-RabbitMQExchange -Description "Gets RabbitMQ's Exchages"
New-Alias -Name addexchangebinding -value Add-RabbitMQExchangeBinding -Description "Adds bindings between RabbitMQ exchanges"

New-Alias -Name grq -value Get-RabbitMQQueue -Description "Gets RabbitMQ's Queues"
New-Alias -Name getqueue -value Get-RabbitMQQueue -Description "Gets RabbitMQ's Queues"
New-Alias -Name arq -value Add-RabbitMQQueue -Description "Adds RabbitMQ's Queues"
New-Alias -Name addqueue -value Add-RabbitMQQueue -Description "Adds RabbitMQ's Queues"
New-Alias -Name rrq -value Remove-RabbitMQQueue -Description "Removes RabbitMQ's Queues"
New-Alias -Name delqueue -value Remove-RabbitMQQueue -Description "Removes RabbitMQ's Queues"
New-Alias -Name getqueuebinding -value Get-RabbitMQQueueBinding -Description "Gets bindings for RabbitMQ Queues"
New-Alias -Name addqueuebinding -value Add-RabbitMQQueueBinding -Description "Adds bindings between RabbitMQ exchange and queue"

New-Alias -Name getmessage -value Get-RabbitMQMessage -Description "Gets messages from RabbitMQ queue"

# Modules
#Export-ModuleMember -Function $($Public | Select -ExpandProperty BaseName) -Alias *