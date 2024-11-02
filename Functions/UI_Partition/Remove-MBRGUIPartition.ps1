function Remove-MBRGUIPartition {
    param (
        $PartitionName
    )
    # $PartitionName = 'WPF_UI_DiskPartition_Partition_FAT32_1'

    if ((Get-Variable -name $PartitionName).Value.PartitionType -eq 'FAT32'){
        $Script:WPF_UI_DiskPartition_Disk_MBR.NumberofPartitionsFAT32 -= 1
    }
    elseif ((Get-Variable -name $PartitionName).Value.PartitionType -eq 'ID76'){
        $Script:WPF_UI_DiskPartition_Disk_MBR.NumberofPartitionsID76 -=1        
    }

    $WPF_UI_DiskPartition_PartitionGrid_MBR.Children.Remove((Get-Variable -Name $PartitionName).Value)
    Remove-Variable -Scope Script -Name $PartitionName
    $Script:GUIActions.SelectedMBRPartition = $null
}
