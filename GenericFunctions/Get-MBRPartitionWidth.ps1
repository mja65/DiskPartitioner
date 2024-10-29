function Get-MBRPartitionWidth {
    param (
        $MBRPartition
    )
    
    #$MBRPartition = $WPF_UI_DiskPartition_Partition_ID76_1
    $WidthtoReturn = 0
    foreach ($Column in $MBRPartition.ColumnDefinitions){
        $WidthtoReturn += $Column.Width.Value
    }
    
    return $WidthtoReturn

}