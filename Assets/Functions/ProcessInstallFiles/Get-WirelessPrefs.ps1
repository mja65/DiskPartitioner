function Get-WirelessPrefs {
    param (
       $SSID,
       $WifiPassword
    )
    
    $WirelessPrefs = "network={",
    "   ssid=""$SSID""",
    "   psk=""$WifiPassword""",
    "}"
    
    return $WirelessPrefs
}