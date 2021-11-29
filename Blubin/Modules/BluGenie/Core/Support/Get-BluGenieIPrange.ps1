#region Get-BluGenieIPrange (Function)
function Get-BluGenieIPrange
{
<#
  .SYNOPSIS
        Get the IP addresses in a range
  .EXAMPLE
        Get-BluGenieIPrange -start 192.168.8.2 -end 192.168.8.20
  .EXAMPLE
        Get-BluGenieIPrange -ip 192.168.8.2 -mask 255.255.255.0
  .EXAMPLE
        Get-BluGenieIPrange -ip 192.168.8.3 -cidr 24
#>
    [Alias('Get-IPrange')]
    param
    (
      [string]$start,

      [string]$end,

      [string]$ip,

      [string]$mask,

      [int]$cidr
    )

    Function IP-toINT64
    {
      Param
        (
            $IP
        )

      $octets = $IP.split(".")
      Return [long]([long]$octets[0]*16777216 +[long]$octets[1]*65536 +[long]$octets[2]*256 +[long]$octets[3])
    }

    Function INT64-toIP
    {
      param
        (
            [long]$Int
        )

        Return (([math]::truncate($int/16777216)).tostring()+"."+([math]::truncate(($int%16777216)/65536)).tostring()+"."+([math]::truncate(($int%65536)/256)).tostring()+"."+([math]::truncate($int%256)).tostring() )
    }

    If
    (
        $ip
    )
    {
        $ipaddr = [ipaddress]::Parse($ip)
    }

    If
    (
        $cidr
    )
    {
        $maskaddr = [ipaddress]::Parse((INT64-toIP -int ([convert]::ToInt64(("1"*$cidr+"0"*(32-$cidr)),2))))
    }

    If
    (
        $mask
    )
    {
        $maskaddr = [ipaddress]::Parse($mask)
    }

    If
    (
        $ip
    )
    {
        $networkaddr = new-object net.ipaddress ($maskaddr.address -band $ipaddr.address)
    }

    if
    (
        $ip
    )
    {
        $broadcastaddr = new-object net.ipaddress (([ipaddress]::parse("255.255.255.255").address -bxor $maskaddr.address -bor $networkaddr.address))
    }

    if
    (
        $ip
    )
    {
        $startaddr = IP-toINT64 -ip $networkaddr.ipaddresstostring
        $endaddr = IP-toINT64 -ip $broadcastaddr.ipaddresstostring
    }
    else
    {
        $startaddr = IP-toINT64 -ip $start
        $endaddr = IP-toINT64 -ip $end
    }


    for
    (
        $i = $startaddr; $i -le $endaddr; $i++
    )
    {
      INT64-toIP -int $i
    }

}
#endregion Get-BluGenieIPrange (Function)