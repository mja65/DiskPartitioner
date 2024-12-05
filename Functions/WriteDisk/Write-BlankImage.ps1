function Write-BlankImage {
    param (
        $Path,
        $SizeBytes
    )
    $Command = @()
    $Command += "blank $Path $SizeBytes`B"

    return $Command

}