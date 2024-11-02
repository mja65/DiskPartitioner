$WPF_UI_DiskPartition_MBRPartitionSelect_LeftArrow.add_click({
    if ($Script:GUIActions.SelectedMBRPartition){
        $NewPartitionName = (Get-NextGUIMBRPartition -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionNametoCheck $Script:GUIActions.SelectedMBRPartition -Side 'Left')
        Set-MBRGUIPartitionAsSelectedUnSelected -Action 'MBRUnSelected'
        $Script:GUIActions.SelectedMBRPartition = $NewPartitionName 
        Set-MBRGUIPartitionAsSelectedUnSelected -Action 'MBRSelected'
    }    
})


