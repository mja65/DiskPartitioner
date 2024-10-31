function Remove-AmigaPartition {
    param (
        $PartitionName
    )
    
    # $PartitionName = 'WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk_Partition_2'
    $SuffixPosition = $PartitionName.IndexOf('_AmigaDisk_Partition_')
    $ParentID76PartitionName = $PartitionName.Substring(0,$SuffixPosition)
    $ParentAmigaDiskName = $PartitionName.Substring(0,$SuffixPosition+10)
    

    (Get-Variable -Name $ParentID76PartitionName).Value.Children.Remove((Get-Variable -Name $PartitionName).Value)

    (Get-Variable -Name $ParentAmigaDiskName).Value.Children.Remove((Get-Variable -Name $PartitionName).Value)

    Remove-Variable -Scope Script -Name $PartitionName
    $Script:GUIActions.SelectedAmigaPartition = $null

}
