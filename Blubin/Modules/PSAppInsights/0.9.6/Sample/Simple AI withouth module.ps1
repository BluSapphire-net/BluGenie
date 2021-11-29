$iKey = 'b437832d-a6b3-4bb4-b237-51308509747d'
<# 
$body = (New-Object PSObject `
    | Add-Member -PassThru NoteProperty name 'Microsoft.ApplicationInsights.Event' `
    | Add-Member -PassThru NoteProperty time $([System.dateTime]::UtcNow.ToString('o')) `
    | Add-Member -PassThru NoteProperty iKey $iKey `
    | Add-Member -PassThru NoteProperty tags (New-Object PSObject `
    | Add-Member -PassThru NoteProperty 'ai.cloud.roleInstance' $env:computername `
    | Add-Member -PassThru NoteProperty 'ai.internal.sdkVersion' 'one-line-ps:1.0.0') `
    | Add-Member -PassThru NoteProperty data (New-Object PSObject `
        | Add-Member -PassThru NoteProperty baseType 'EventData' `
        | Add-Member -PassThru NoteProperty baseData (New-Object PSObject `
            | Add-Member -PassThru NoteProperty ver 2 `
            | Add-Member -PassThru NoteProperty name 'Event from one line script' `
            | Add-Member -PassThru NoteProperty properties (New-Object PSObject `
                | Add-Member -PassThru NoteProperty propName 'propValue')))) `
    | ConvertTo-JSON -depth 5; 
#> 
$Body = ConvertFrom-Json @"
{
    "name":  "Microsoft.ApplicationInsights.Event",
    "time":  "{0}",
    "iKey":  "{1}",
    "tags":  {
                 "ai.cloud.roleInstance":  "{2}",
                 "ai.internal.sdkVersion":  "inline:1.0.0"
             },
    "data":  {
                 "baseType":  "EventData",
                 "baseData":  {
                                  "ver":  2,
                                  "name":  "{3}",
                                  "properties":  {
                                                     "Counter":  "1"
                                                 }
                              }
             }
}
"@ 

$Message = "Just a log"

$Body.time =  (get-date).ToString('o')
$Body.iKey = $iKey
$Body.tags.'ai.cloud.roleInstance' =  $env:computername,
$Body.data.baseData.name = $Message


$rsp = Invoke-WebRequest -Uri 'https://dc.services.visualstudio.com/v2/track' -Method 'POST' -UseBasicParsing -body (Convertto-json -InputObject $body) 

$rsp
