function Update-MBRDiskSizes{
    param (
    )
    
    $WPF_UI_DiskPartition_Disk_MBR.DiskSizeBytes =  Get-ConvertedSize -ScaleFrom 'GiB' -Scaleto 'B' -Size $WPF_UI_DiskPartition_Input_DiskSize_Value.Text -NumberofDecimalPlaces '0' -Truncate 'TRUE' 
    $WPF_UI_DiskPartition_Disk_MBR.BytestoPixelFactor = $WPF_UI_DiskPartition_Disk_MBR.DiskSizeBytes/$WPF_UI_DiskPartition_Disk_MBR.DiskSizePixels
    $WPF_UI_DiskPartition_TotalSize_Value.Text = Get-ConvertedSize -ScaleFrom $WPF_UI_DiskPartition_Input_DiskSizeScale_Dropdown.SelectedItem -Scaleto 'GiB' -Size $WPF_UI_DiskPartition_Input_DiskSize_Value.Text -NumberofDecimalPlaces 3 -Truncate 'TRUE' 
    $Script:DiskMinimums = Get-MinimumPartitionSizes -SizeofDiskBytes $WPF_UI_DiskPartition_Disk_MBR.DiskSizeBytes
}

