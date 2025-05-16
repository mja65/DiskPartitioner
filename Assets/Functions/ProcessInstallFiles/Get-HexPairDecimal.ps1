function Get-HexPairDecimal {
    param (
        $BytePair1,
        $BytePair2
    )
    
        $HexValue1 = "0$("{0:X}" -f $BytePair1)"
        $HexValue2 = "0$("{0:X}" -f $BytePair2)"

        $CombinedHex = "$($HexValue1.Substring($HexValue1.Length-2))$($HexValue2.Substring($HexValue2.Length-2))"
        $ValuetoReturn = Convert-HexToDecimal $CombinedHex
        return $ValuetoReturn 
}