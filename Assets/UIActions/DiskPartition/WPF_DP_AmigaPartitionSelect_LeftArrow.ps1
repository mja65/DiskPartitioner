$WPF_DP_AmigaPartitionSelect_LeftArrow.add_click({
    $Script:GUICurrentStatus.SelectedAmigaPartition = (Get-NextGUIPartition -Side 'Left' -PartitionNametoCheck $Script:GUICurrentStatus.SelectedAmigaPartition -PartitionType 'Amiga')
    Update-UI -All
})

