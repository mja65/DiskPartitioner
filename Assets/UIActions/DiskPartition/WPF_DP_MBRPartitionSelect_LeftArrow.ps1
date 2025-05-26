$WPF_DP_MBRPartitionSelect_LeftArrow.add_click({
    $Script:GUICurrentStatus.SelectedGPTMBRPartition = (Get-NextGUIPartition -Side 'Left' -PartitionNametoCheck $Script:GUICurrentStatus.SelectedGPTMBRPartition.PartitionName -PartitionType 'MBR')
    update-ui -HighlightSelectedPartitions
})