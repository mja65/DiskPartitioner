$WPF_DP_Button_AmigaRemoveFreeSpace.add_click({
  
    $PartitionstoAdjust = Get-AllGUIPartitionBoundaries | Where-Object {$_.PartitionName -match $Script:GUICurrentStatus.SelectedGPTMBRPartition -and $_.PartitionType -eq 'Amiga'} 
    
    $EndingPositionBytesLastPartition = $null
   
    foreach ($Partition in $PartitionstoAdjust){        
        if ($null -ne $EndingPositionBytesLastPartition){
            $StartingPositiontoCheckAgainst = $EndingPositionBytesLastPartition 
        }
        else {
            $StartingPositiontoCheckAgainst = 0
        }
        $AmounttoMoveBytes = $StartingPositiontoCheckAgainst - $Partition.StartingPositionBytes 
        if ($AmounttoMoveBytes -ne 0){
            Set-GUIPartitionNewPosition -PartitionName $Partition.PartitionName -PartitionType 'Amiga' -AmountMovedBytes $AmounttoMoveBytes
        }
        $EndingPositionBytesLastPartition = (Get-Variable -Name $Partition.PartitionName).value.StartingPositionBytes + (Get-Variable -Name $Partition.PartitionName).value.PartitionSizeBytes
    }

})