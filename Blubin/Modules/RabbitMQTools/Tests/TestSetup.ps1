$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$server = "192.168.232.129"
$server = "http://localhost:15672"

. "$here\..\Private\Constants.ps1"
. "$here\..\Private\Invoke-RestMethod.ps1"
. "$here\..\Private\NamesToString.ps1"
. "$here\..\Private\PreventUnEscapeDotsAndSlashesOnUri.ps1"
. "$here\..\Private\SendItemsToOutput.ps1"
. "$here\..\Private\Join-Parts.ps1"
. "$here\..\Private\GetItemsFromRabbitMQApi.ps1"
. "$here\..\Private\ApplyFilter.ps1"


function AssertAreEqual($actual, $expected) {

    if ($actual -is [System.Array]) {
        if ($expected -isnot [System.Array]) { throw "Expected {$expected} to be an array, but it is not." }

        if ($actual.Length -ne $expected.Length)
        { 
            $al = $actual.Length
            $el = $expected.Length
            throw "Expected $el elements but were $al"
        }

        for ($i = 0; $i -lt $actual.Length; $i++)
        {
            $a = $actual[$i]
            $e = $expected[$i]
            if ($a -ne $e) 
            { 
                throw "Expected element at position $i to be {$e} but was {$a}" 
            }
        }
    } else {
		if($actual -ne $expected) {
			throw "Expected $actual to be $expected"
		}
	}
}