function Get-FormattedPathforGUI {
    param (
        $PathtoTruncate,
        $Length
    )
    if ($Length){
        $LengthofString = $Length
    }
    else{
        $LengthofString = 37 #Maximum supported by label less three for the ...
    }
    if ($PathtoTruncate.Length -gt $LengthofString){
        $Output = ('...'+($PathtoTruncate.Substring($PathtoTruncate.Length -$LengthofString,$LengthofString)))
    }
    else{
        $Output = $PathtoTruncate
    }
    return $Output
}