$WPF_UI_DiskPartition_Input_DiskSize.add_LostFocus({
    if ($WPF_UI_DiskPartition_Input_DiskSize.Text){
        $WPF_UI_DiskPartition_Disk_MBR.DiskSizeBytes = Get-ConvertedSize -ScaleFrom 'GiB' -Scaleto 'Bytes' -size $WPF_UI_DiskPartition_Input_DiskSize.Text
        $Script:DiskMinimums = Get-MinimumPartitionSizes -SizeofDiskBytes $WPF_UI_DiskPartition_Disk_MBR.DiskSizeBytes
    }
})
