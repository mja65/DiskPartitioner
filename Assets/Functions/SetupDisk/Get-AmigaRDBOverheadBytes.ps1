function Get-AmigaRDBOverheadBytes {
    return ($Script:Settings.AmigaRDBHeads * $Script:Settings.AmigaRDBSectors * $Script:Settings.AmigaRDBBlockSize * $Script:Settings.AmigaRDBSides)
}
