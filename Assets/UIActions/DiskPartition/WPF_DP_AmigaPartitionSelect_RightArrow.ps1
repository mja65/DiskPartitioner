$WPF_DP_AmigaPartitionSelect_RightArrow.add_click({
    $Script:GUICurrentStatus.SelectedAmigaPartition = (Get-NextGUIPartition -Side 'Right' -PartitionType 'Amiga' -PartitionNametoCheck $Script:GUICurrentStatus.SelectedAmigaPartition )
    update-ui -HighlightSelectedPartitions
})

