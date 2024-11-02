$WPF_UI_DiskPartition_PartitionSelect_RightArrow.add_click({
    if ($Script:GUIActions.SelectedMBRPartition){
        $NewPartitionName = (Get-NextGUIMBRPartition -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionNametoCheck $Script:GUIActions.SelectedMBRPartition -Side 'Right')
        Set-MBRGUIPartitionAsSelectedUnSelected -Action 'MBRUnSelected'
        $Script:GUIActions.SelectedMBRPartition = $NewPartitionName 
        Set-MBRGUIPartitionAsSelectedUnSelected -Action 'MBRSelected'
    }    
})