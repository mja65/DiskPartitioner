$WPF_UI_DiskPartition_Button_AddNewAmigaPartition.add_click({
    Add-AmigaPartitiontoDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -AmigaDiskName ($Script:GUIActions.SelectedMBRPartition+'_AmigaDisk') -AddType 'Initial' -SizePixels 100
})
