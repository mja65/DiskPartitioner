function Set-GUIPartitionNewPosition {
    param (
        $Partition,
        $AmountMoved
    )
    
    $AmounttoSetLeft = $Partition.Margin.Left + $AmountMoved   
    $PartitionBoundaries = (Get-GUIPartitionBoundaries -Prefix 'WPF_UI_DiskPartition_Partition_' -ObjecttoCheck $Partition)

    if ($AmounttoSetLeft -lt $PartitionBoundaries.LeftBoundary){
        $AmounttoSetLeft = $PartitionBoundaries.LeftBoundary
    }
    if (($AmounttoSetLeft + (Get-MBRPartitionWidth -MBRPartition ((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value))) -gt $PartitionBoundaries.RightBoundary){
        $AmounttoSetLeft = $PartitionBoundaries.RightBoundary - (Get-MBRPartitionWidth -MBRPartition ((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value))
    } 
    
    $Partition.Margin = [System.Windows.Thickness]"$AmounttoSetLeft,0,0,0"

}
