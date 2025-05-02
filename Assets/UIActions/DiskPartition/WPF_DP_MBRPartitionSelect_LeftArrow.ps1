$WPF_DP_MBRPartitionSelect_LeftArrow.add_click({
    $Script:GUICurrentStatus.SelectedGPTMBRPartition = (Get-NextGUIPartition -Side 'Left' -PartitionNametoCheck $Script:GUICurrentStatus.SelectedGPTMBRPartition -PartitionType 'MBR')
    update-ui -DiskPartitionWindow
})