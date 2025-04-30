function Get-GUIPartitionWidth {
    param (
        $Partition
    )
    
    # $Partition = $WPF_UI_DiskPartition_Partition_ID76_1
    # $Partition = $WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk_Partition_2
    $WidthtoReturn = 0
    foreach ($Column in $Partition.ColumnDefinitions){
        $WidthtoReturn += $Column.Width.Value
    }
    
    return $WidthtoReturn

}