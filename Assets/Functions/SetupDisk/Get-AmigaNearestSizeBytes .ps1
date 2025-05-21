function Get-AmigaNearestSizeBytes {
    param (
        $SizeBytes,
        [Switch]$RoundUp,
        [Switch]$RoundDown
    )
    
    $CylinderSizeBytes = (Get-AmigaPartitionSizeBlockBytes)

    if ($RoundDown){
        $NumberofCylinders = [math]::Floor($SizeBytes/$CylinderSizeBytes)
    }
    elseif ($RoundUp){
        $NumberofCylinders = [math]::Ceiling($SizeBytes/$CylinderSizeBytes)
    }

    $BytestoReturn = $NumberofCylinders * $CylinderSizeBytes

    return $BytestoReturn
}
