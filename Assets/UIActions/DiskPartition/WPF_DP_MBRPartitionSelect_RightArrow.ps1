$WPF_DP_MBRPartitionSelect_RightArrow.add_click({
    $Script:GUICurrentStatus.SelectedGPTMBRPartition = (Get-NextGUIPartition -Side 'Right' -PartitiontoCheck $Script:GUICurrentStatus.SelectedGPTMBRPartition -PartitionType 'MBR')
    update-ui -HighlightSelectedPartitions
})