$WPF_UI_DiskPartition_Button_AddNewMBRPartition.add_click({
    Add-GUIPartitiontoMBRDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionType 'ID76' -AddType 'Initial' -SizePixels 100
})