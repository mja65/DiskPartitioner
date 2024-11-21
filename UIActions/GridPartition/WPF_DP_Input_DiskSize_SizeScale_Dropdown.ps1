$ScaleOptions = @()

$ScaleOptions  += New-Object -TypeName pscustomobject -Property @{Scale='TiB'}
$ScaleOptions  += New-Object -TypeName pscustomobject -Property @{Scale='GiB'}
$ScaleOptions  += New-Object -TypeName pscustomobject -Property @{Scale='MiB'}

foreach ($Option in $ScaleOptions){
    $WPF_DP_Input_DiskSize_SizeScale_Dropdown.AddChild($Option.Scale)
}

$WPF_DP_Input_DiskSize_SizeScale_Dropdown.SelectedItem = 'GiB'

$WPF_DP_Input_DiskSize_SizeScale_Dropdown.add_selectionChanged({
    if ($Script:GUIActions.DiskSizeSelected -eq $true){
        #     $WPF_DP_Disk_MBR.DiskSizeBytes = Get-ConvertedSize -ScaleFrom $WPF_UI_DiskPartition_Input_SizeScale_Dropdown.SelectedItem -Scaleto 'B' -size $WPF_UI_DiskPartition_Input_DiskSize_Value.Text
        #     $WPF_DP_TotalSize_Value.Text = Get-ConvertedSize -ScaleFrom $WPF_UI_DiskPartition_Input_SizeScale_Dropdown.SelectedItem -Scaleto 'GiB' -size  $WPF_UI_DiskPartition_Input_DiskSize_Value.Text
        # #    $Script:DiskMinimums = Get-MinimumPartitionSizes -SizeofDiskBytes $WPF_UI_DiskPartition_Disk_MBR.DiskSizeBytes
    }
 })

