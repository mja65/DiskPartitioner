function Get-IconCoordinates {
    param (
        $PathtoIcon
    )

    # $PathtoIcon = "C:\Users\Matt\OneDrive\Documents\DiskPartitioner\Temp\InterimAmigaDrives\System\PiStorm\Documentation.info" 

    $OutputtoReturn  = [PSCustomObject]@{
        IconX = $null
        IconY = $null
        IconWidth = $null
        IconHeight = $null
        DrawerX = $null
        DrawerY = $null
        DrawerWidth = $null
        DrawerHeight = $null
    }

    $bytes = [System.IO.File]::ReadAllBytes($PathtoIcon)

    $OutputtoReturn.IconX = Get-HexPairDecimal -BytePair1 $bytes[60] -BytePair2 $bytes[61] 
    $OutputtoReturn.IconY = Get-HexPairDecimal -BytePair1 $bytes[64] -BytePair2 $bytes[65]
    $OutputtoReturn.IconWidth= Get-HexPairDecimal -BytePair1 $bytes[12] -BytePair2 $bytes[13]
    $OutputtoReturn.IconHeight = Get-HexPairDecimal -BytePair1 $bytes[14] -BytePair2 $bytes[15] 
    $OutputtoReturn.DrawerX = Get-HexPairDecimal -BytePair1 $bytes[78] -BytePair2 $bytes[79]
    $OutputtoReturn.DrawerY = Get-HexPairDecimal -BytePair1 $bytes[80] -BytePair2 $bytes[81]
    $OutputtoReturn.DrawerWidth= Get-HexPairDecimal -BytePair1 $bytes[82] -BytePair2 $bytes[83]
    $OutputtoReturn.DrawerHeight = Get-HexPairDecimal -BytePair1 $bytes[84] -BytePair2 $bytes[85]

    return $OutputtoReturn
 
}

