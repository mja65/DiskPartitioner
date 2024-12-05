$WPF_DP_AmigaPartitionSelect_LeftArrow.add_click({
    $Script:GUIActions.SelectedAmigaPartition = (Get-NextGUIPartition -Side 'Left' -PartitionNametoCheck $Script:GUIActions.SelectedAmigaPartition -PartitionType 'Amiga')
    Update-UI -All
})

