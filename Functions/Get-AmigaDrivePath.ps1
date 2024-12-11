function Get-AmigaDrivePath {
    param (
        [Switch]$FullPath,
        [Switch]$DeviceName

    )
    $WorkbenchPartitionName = (Get-AllGUIPartitions -PartitionType 'Amiga' | Where-Object {$_.value.DefaultAmigaWorkbenchPartition -eq 'TRUE'}).Name

    if (-not($WorkbenchPartitionName)){
        return
    }
    else {
        $WorkbenchPartitionValue = (Get-AllGUIPartitions -PartitionType 'Amiga' | Where-Object {$_.value.DefaultAmigaWorkbenchPartition -eq 'TRUE'}).value
        
        if ($DeviceName){
            return $($WorkbenchPartitionValue.DeviceName)
        }
        else {
            $ID76ParentNameDelimiter = $WorkbenchPartitionName.indexof('_AmigaDisk_Partition_')
            $ID76ParentName = $WorkbenchPartitionName.Substring(0,$ID76ParentNameDelimiter)
            
            $MBRPartitions = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq 'MBR'}
            for ($i = 0; $i -lt $MBRPartitions.Count; $i++) {
                if ($MBRPartitions[$i].PartitionName -eq $ID76ParentName){
                    $PartitionCounter = $i + 1
                    break
                }
            }
            
            if ($FullPath){
                $PathtoReturn = "mbr\$PartitionCounter\rdb\$($WorkbenchPartitionValue.DeviceName)"
                return $PathtoReturn 
            }
        }
    }
}