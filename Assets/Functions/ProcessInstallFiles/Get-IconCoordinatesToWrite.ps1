function Get-IconCoordinatesToWrite {
    param (
        $CoordinateValue
    )
    $valueBytes = [BitConverter]::GetBytes([UInt16]$CoordinateValue)
    if ([BitConverter]::IsLittleEndian) {
        [Array]::Reverse($valueBytes)
    }
    return $valueBytes 
}