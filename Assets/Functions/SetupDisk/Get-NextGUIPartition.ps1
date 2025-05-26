function Get-NextGUIPartition {
    param (
        $PartitionNametoCheck,
        $PartitionType,
        $Side
    )
    
    # $PartitionType = 'MBR'

    if ($PartitionType -eq 'Amiga'){
        if ($PartitionNametoCheck){
            $AmigaDiskName = ($PartitionNametoCheck.Substring(0,($PartitionNametoCheck.IndexOf('_AmigaDisk_Partition_')+10)))    
        }
        else{
            $AmigaDiskName = ($Script:GUICurrentStatus.SelectedGPTMBRPartition+'_AmigaDisk')
        }
        $PartitionstoCheck = $Script:GUICurrentStatus.AmigaPartitionsandBoundaries | Where-Object {$_.PartitionName -match $AmigaDiskName }
    }
    elseif ($PartitionType -eq 'MBR'){
        $PartitionstoCheck = $Script:GUICurrentStatus.GPTMBRPartitionsandBoundaries
    }
    
    if ($PartitionNametoCheck){
        for ($i = 0; $i -lt $PartitionstoCheck.Count; $i++) {
            if ($PartitionNametoCheck -eq $PartitionstoCheck[$i].PartitionName){
                if ($Side -eq "Left"){
                    if ($i -eq 0){
                        $NextPartitionName = $PartitionstoCheck[$PartitionstoCheck.Count-1].PartitionName
                    }
                    else{
                        $NextPartitionName = $PartitionstoCheck[$i-1].PartitionName
                    }
                }
                elseif ($Side -eq "Right"){
                    if ($i -eq $PartitionstoCheck.Count-1){
                        $NextPartitionName = $PartitionstoCheck[0].PartitionName
                    }
                    else{
                        $NextPartitionName = $PartitionstoCheck[$i+1].PartitionName
                    }
                }
                return $NextPartitionName
            }
        }
    }
    else{
        if ($Side -eq 'Right'){
            $NextPartitionName = $PartitionstoCheck[0].PartitionName
        }
        elseif ($Side -eq 'Left'){
            $NextPartitionName = $PartitionstoCheck[$PartitionstoCheck.Count-1].PartitionName
        }
    }

    return $NextPartitionName

}