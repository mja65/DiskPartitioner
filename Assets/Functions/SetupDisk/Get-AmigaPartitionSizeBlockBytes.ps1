function Get-AmigaPartitionSizeBlockBytes {
    param (
    )
    $Heads = 16
    $Sectors = 63
    $BlockSize = 512

    return $Heads*$Sectors*$BlockSize
}