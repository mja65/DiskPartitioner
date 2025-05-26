function Remove-GPTMBRFreeSpaceBetweenPartitions {
    param (
       
    )
    
    $PartitionstoAdjust = Get-AllGUIPartitionBoundaries -GPTMBR -Amiga | Where-Object {$_.PartitionType -eq 'MBR'} 

    $ExpectedPartitionStartingPosition = 0
        
    
    $PartitionstoAdjust | ForEach-Object {
        $DifferencetoStartingPostition = $ExpectedPartitionStartingPosition - $_.StartingPositionBytes 
        if ($DifferencetoStartingPostition -lt 0){
            Set-GUIPartitionNewPosition -PartitionName $_.PartitionName -PartitionType 'MBR' -AmountMovedBytes $DifferencetoStartingPostition
        }
        $ExpectedPartitionStartingPosition += (Get-Variable -Name $_.PartitionName).value.PartitionSizeBytes
    }
    $WPF_DP_DiskGrid_GPTMBR.UpdateLayout()
    $Script:GUICurrentStatus.GPTMBRPartitionsandBoundaries =  Get-AllGUIPartitionBoundaries -GPTMBR


}