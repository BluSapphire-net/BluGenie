#region Convert-BluGenieUTCtoLocal (Function)
    function Convert-BluGenieUTCtoLocal
    {
        [Alias('Convert-UTCtoLocal')]
        param(
        [String] $UTCTime
        )

        $strCurrentTimeZone = (Get-WmiObject win32_timezone).StandardName
        $TZ = [TimeZoneInfo]::FindSystemTimeZoneById($strCurrentTimeZone)
        $LocalTime = [TimeZoneInfo]::ConvertTimeFromUtc($UTCTime, $TZ)

        Return $LocalTime
    }
#endregion