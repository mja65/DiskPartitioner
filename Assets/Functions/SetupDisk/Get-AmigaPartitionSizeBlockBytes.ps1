function Get-AmigaPartitionSizeBlockBytes {
    param (
    )

    return ($Script:Settings.AmigaRDBHeads * $Script:Settings.AmigaRDBSectors * $Script:Settings.AmigaRDBBlockSize)
    
}