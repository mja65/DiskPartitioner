function Get-RDBInformation {
    param (
        $DiskName
    )
    
    # $DiskName = $Script:GUIActions.SelectedPhysicalDisk

    $MBRPartitions = Get-HSTPartitionInfo -MBRInfo -Path $DiskName

    $RDBPartitionTable = [System.Collections.Generic.List[PSCustomObject]]::New()

    $MBRPartitions | ForEach-Object {
        if ($_.Type -match 'PiStorm RDB'){
            $RDBPartitionTable += Get-HSTPartitionInfo -RDBInfo -Path "$DiskName\mbr\$($_.Number)"
        }
    }
    
   return $RDBPartitionTable | Sort-Object MBRNumber,Number 
}