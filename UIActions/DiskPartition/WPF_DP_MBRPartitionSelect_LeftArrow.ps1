$WPF_DP_MBRPartitionSelect_LeftArrow.add_click({
    $Script:GUIActions.SelectedMBRPartition = (Get-NextGUIPartition -Side 'Left' -PartitionNametoCheck $Script:GUIActions.SelectedMBRPartition -PartitionType 'MBR')
    Update-UI -All
})