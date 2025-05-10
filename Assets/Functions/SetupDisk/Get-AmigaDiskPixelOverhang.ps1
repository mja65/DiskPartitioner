function Get-AmigaDiskPixelOverhang {
    param (
        $AmigaDisk
    )

    # $AmigaDisk = $WPF_DP_Partition_MBR_2_AmigaDisk

    $DiskBytestoPixelFactor = $AmigaDisk.BytestoPixelFactor 
    
    $OverhangPixelTotal = 0
    
    Get-AllGUIPartitions -PartitionType 'Amiga' | ForEach-Object {
        $SizeBytes = $_.value.PartitionSizeBytes
        $SizePixels = Get-GUIPartitionWidth -Partition $_.value
        $ExpectedSizePixels = $SizeBytes/$DiskBytestoPixelFactor 
        $OverhangPixels = $SizePixels - $ExpectedSizePixels
        $OverhangPixelTotal +=  $OverhangPixels
        if ($Script:Settings.DebugMode){
            Write-host "Size of Partition:$SizeBytes Overhang:$OverhangPixels Size Pixels:$SizePixels Expected Size Pixels:$ExpectedSizePixels " 
        }
    }
    
    return $OverhangPixelTotal

}

