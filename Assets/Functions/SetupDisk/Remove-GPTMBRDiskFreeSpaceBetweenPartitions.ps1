function Remove-GPTMBRFreeSpaceBetweenPartitions {
    param (
       
    )
    
    $PartitionstoAdjust = $Script:GUICurrentStatus.GPTMBRPartitionsandBoundaries

    $ExpectedPartitionStartingPosition = 0
        
    
    $PartitionstoAdjust | ForEach-Object {
        $DifferencetoStartingPostition = $ExpectedPartitionStartingPosition - $_.StartingPositionBytes 
        if ($DifferencetoStartingPostition -lt 0){
            Set-GUIPartitionNewPosition -Partition $_.Partition -PartitionType 'MBR' -AmountMovedBytes $DifferencetoStartingPostition
        }
        $ExpectedPartitionStartingPosition += $_.Partition.PartitionSizeBytes
    }
    $WPF_DP_DiskGrid_GPTMBR.UpdateLayout()
    $Script:GUICurrentStatus.GPTMBRPartitionsandBoundaries = @(Get-AllGUIPartitionBoundaries -GPTMBR)


}