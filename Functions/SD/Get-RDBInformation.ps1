function Get-RDBInformation {
    param (
        $DiskName,
        [Switch]$PiStormDiskorImage,
        [Switch]$AmigaNativeDiskorImage
    )
    
    # $DiskName = $Script:GUIActions.SelectedPhysicalDisk
    $RDBPartitionTable = [System.Collections.Generic.List[PSCustomObject]]::New()

    if ($PiStormDiskorImage){
        $MBRPartitions = Get-HSTPartitionInfo -MBRInfo -Path $DiskName
        $MBRPartitions | ForEach-Object {
            if ($_.Type -eq 'ID 0x76 (Pistorm)'){
                $RDBPartitionTable += Get-HSTPartitionInfo -RDBInfo -Path "$DiskName\mbr\$($_.Number)"
            }
        }
        
        return $RDBPartitionTable | Sort-Object MBRNumber,Number 
    }
    
    elseif ($AmigaNativeDiskorImage){
        Get-HSTPartitionInfo -RDBInfo -Path $DiskName | ForEach-Object {
            $_.PSObject.properties.Remove('MBRNumber')
            $RDBPartitionTable += $_
        }
        
        return $RDBPartitionTable | Sort-Object Number
    }
   
}

