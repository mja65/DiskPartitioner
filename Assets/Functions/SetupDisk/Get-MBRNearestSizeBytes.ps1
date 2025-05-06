function Get-MBRNearestSizeBytes {
    param (
        $SizeBytes,
        [Switch]$RoundUp,
        [Switch]$RoundDown
    )
    
    # $RoundDown = $true
    # $SizeBytes = 106954240
    
    $SizeBytesBlock = $Script:Settings.MBRSectorSizeBytes

    if ($RoundDown){
        $NumberofBlocks = [math]::Floor($SizeBytes/$SizeBytesBlock)
    }
    elseif ($RoundUp){
        $NumberofBlocks = [math]::Ceiling($SizeBytes/$SizeBytesBlock )
    }

    $BytestoReturn = $NumberofBlocks * $SizeBytesBlock 

    return $BytestoReturn
}
