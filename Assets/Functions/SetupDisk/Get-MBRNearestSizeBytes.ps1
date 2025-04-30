function Get-MBRNearestSizeBytes {
    param (
        $SizeBytes,
        [Switch]$RoundUp,
        [Switch]$RoundDown
    )
    
    $SizeBytesBlock = 1*1024*1024

    if ($RoundDown){
        $NumberofBlocks = [math]::Floor($SizeBytes/$SizeBytesBlock)
    }
    elseif ($RoundUp){
        $NumberofBlocks = [math]::Ceiling($SizeBytes/$SizeBytesBlock )
    }

    $BytestoReturn = $NumberofBlocks * $SizeBytesBlock 

    return $BytestoReturn
}
