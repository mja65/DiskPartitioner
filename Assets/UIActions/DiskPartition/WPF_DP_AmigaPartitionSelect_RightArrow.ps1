$WPF_DP_AmigaPartitionSelect_RightArrow.add_click({
    $Script:GUICurrentStatus.SelectedAmigaPartition = (Get-NextGUIPartition -Side 'Right' -PartitionNametoCheck $Script:GUICurrentStatus.SelectedAmigaPartition -PartitionType 'Amiga')
    update-ui -DiskPartitionWindow
})

