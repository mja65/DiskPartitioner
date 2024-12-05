$WPF_DP_AmigaPartitionSelect_RightArrow.add_click({
    $Script:GUIActions.SelectedAmigaPartition = (Get-NextGUIPartition -Side 'Right' -PartitionNametoCheck $Script:GUIActions.SelectedAmigaPartition -PartitionType 'Amiga')
    Update-UI -All
})

