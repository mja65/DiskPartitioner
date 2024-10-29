function Remove-GUIPartition {
    param (
        $PartitionName
    )
    #$PartitionName = 'WPF_UI_DiskPartition_Partition_FAT32_1'
    $WPF_UI_DiskPartition_PartitionGrid_MBR.Children.Remove((Get-Variable -Name $PartitionName).Value)
    Remove-Variable -Scope Script -Name $PartitionName
    $Script:GUIActions.SelectedPartition = $null
}
