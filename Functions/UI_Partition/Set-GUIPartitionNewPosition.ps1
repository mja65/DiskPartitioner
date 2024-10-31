function Set-GUIPartitionNewPosition {
    param (
        $Partition,
        $AmountMoved,
        $PartitionType
    )
    
    $AmounttoSetLeft = $Partition.Margin.Left + $AmountMoved   
    $PartitionBoundaries = (Get-GUIPartitionBoundaries -PartitionType $PartitionType -Prefix 'WPF_UI_DiskPartition_Partition_' -ObjecttoCheck $Partition)

    #Write-host "Right boundary is: $($PartitionBoundaries.RightBoundary)"

    if ($AmounttoSetLeft -lt $PartitionBoundaries.LeftBoundary){
        $AmounttoSetLeft = $PartitionBoundaries.LeftBoundary
    }
    if (($AmounttoSetLeft + (Get-GUIPartitionWidth -Partition $Partition)) -gt $PartitionBoundaries.RightBoundary){
        $AmounttoSetLeft = $PartitionBoundaries.RightBoundary - (Get-GUIPartitionWidth -Partition $Partition)
    } 
    
    $Partition.Margin = [System.Windows.Thickness]"$AmounttoSetLeft,0,0,0"

}
