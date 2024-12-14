function Get-WirelessPrefs {
    param (
        $AmigaTempDrivetoUse
    )
    $WirelessPrefs = "network={",
    "   ssid=""$($Script:GUIActions.SSID)""",
    "   psk=""$($Script:GUIActions.WifiPassword)""",
    "}"
    
Export-TextFileforAmiga -ExportFile "$AmigaTempDrivetoUse\Prefs\Env-Archive\Sys\wireless.prefs" -DatatoExport $WirelessPrefs -AddLineFeeds 'TRUE'                

}