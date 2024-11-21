$WPF_DP_MBRPartitionSelect_RightArrow.add_click({
    $Script:GUIActions.SelectedMBRPartition = (Get-NextGUIPartition -Side 'Right' -PartitionNametoCheck $Script:GUIActions.SelectedMBRPartition -PartitionType 'MBR')
    UUpdate-UI -All
})