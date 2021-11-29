$defaultComputerName = "http://localhost:15672"
$defaultVirtualhost = "/"
$defaultUserName = "guest"
$defaultPassword = "guest"

$defaultCredentials = New-Object System.Management.Automation.PSCredential ($defaultUserName, $(ConvertTo-SecureString $defaultPassword -AsPlainText -Force))
