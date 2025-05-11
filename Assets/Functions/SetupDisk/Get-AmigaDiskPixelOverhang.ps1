function Get-AmigaDiskPixelOverhang {
    param (
        $AmigaDiskName
    )

    # $AmigaDiskName = "WPF_DP_Partition_MBR_3_AmigaDisk"

    $DiskBytestoPixelFactor = (get-variable -name $AmigaDiskName).value.BytestoPixelFactor 
    
    $OverhangPixelTotal = 0
    
    Get-AllGUIPartitions -PartitionType 'Amiga' | Where-Object {$_.Name -match $AmigaDiskName} | ForEach-Object {
        $SizeBytes = $_.value.PartitionSizeBytes
        $SizePixels = Get-GUIPartitionWidth -Partition $_.value
        $ExpectedSizePixels = $SizeBytes/$DiskBytestoPixelFactor 
        $OverhangPixels = $SizePixels - $ExpectedSizePixels
        $OverhangPixelTotal +=  $OverhangPixels
        write-host "Size of Partition (bytes):$SizeBytes Overhang:$OverhangPixels Size Pixels:$SizePixels Expected Size Pixels:$ExpectedSizePixels " 
    }
    
    return $OverhangPixelTotal

}

# Get-AmigaDiskPixelOverhang -AmigaDiskName WPF_DP_Partition_MBR_3_AmigaDisk
