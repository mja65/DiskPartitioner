$WPF_DP_AmigaPartitionSelect_LeftArrow.add_click({
    $Script:GUICurrentStatus.SelectedAmigaPartition = (Get-NextGUIPartition -Side 'Left' -PartitiontoCheck $Script:GUICurrentStatus.SelectedAmigaPartition -PartitionType 'Amiga')
    update-ui -HighlightSelectedPartitions
}) 

