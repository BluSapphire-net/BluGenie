#region ConvertTo-BluGenieDate (Function)
    Function ConvertTo-BluGenieDate {
        [Alias('ConvertTo-Date')]
        Param (
            $accountExpires
        )

        process {
            $lngValue = $accountExpires
            if(($lngValue -eq 0) -or ($lngValue -gt [DateTime]::MaxValue.Ticks)) {
                $AcctExpires = "Never"
            } else {
                $Date = [DateTime]$lngValue
                $AcctExpires = $Date.AddYears(1600).ToLocalTime()
            }
            $AcctExpires
        }
    }
#endregion ConvertTo-BluGenieDate (Function)