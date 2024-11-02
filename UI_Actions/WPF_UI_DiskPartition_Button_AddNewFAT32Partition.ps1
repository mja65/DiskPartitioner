$WPF_UI_DiskPartition_Button_AddNewFAT32Partition.add_click({
    Add-GUIPartitiontoMBRDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionType 'FAT32' -AddType 'Initial' -SizePixels 100
})