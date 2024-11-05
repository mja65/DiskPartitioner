$ScaleOptions = @()

$ScaleOptions  += New-Object -TypeName pscustomobject -Property @{Scale='TiB'}
$ScaleOptions  += New-Object -TypeName pscustomobject -Property @{Scale='GiB'}
$ScaleOptions  += New-Object -TypeName pscustomobject -Property @{Scale='MiB'}

foreach ($Option in $ScaleOptions){
    $WPF_UI_DiskPartition_Input_DiskSizeScale_Dropdown.AddChild($Option.Scale)
}

$WPF_UI_DiskPartition_Input_DiskSizeScale_Dropdown.SelectedItem = 'GiB'

$WPF_UI_DiskPartition_Input_DiskSizeScale_Dropdown.add_selectionChanged({
    $WPF_UI_DiskPartition_Disk_MBR.DiskSizeBytes = Get-ConvertedSize -ScaleFrom $WPF_UI_DiskPartition_Input_DiskSizeScale_Dropdown.SelectedItem -Scaleto 'B' -size $WPF_UI_DiskPartition_Input_DiskSize_Value.Text
    $WPF_UI_DiskPartition_TotalSize_Value.Text = Get-ConvertedSize -ScaleFrom $WPF_UI_DiskPartition_Input_DiskSizeScale_Dropdown.SelectedItem -Scaleto 'GiB' -size  $WPF_UI_DiskPartition_Input_DiskSize_Value.Text
    $Script:DiskMinimums = Get-MinimumPartitionSizes -SizeofDiskBytes $WPF_UI_DiskPartition_Disk_MBR.DiskSizeBytes
})