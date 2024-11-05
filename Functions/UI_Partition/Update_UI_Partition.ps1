function Update_UI_Partition {
    param (
        $Action
    )
    if ($Script:GUIActions.SelectedMBRPartition){
       $WPF_UI_DiskPartition_SelectedSize_Value.Text = Get-ConvertedSize -ScaleFrom 'B' -Scaleto 'GiB' -Size $WPF_UI_DiskPartition_Disk_MBR.BytestoPixelFactor*(Get-GUIPartitionWidth -Partition ((Get-Variable -name $Script:GUIActions.SelectedMBRPartition).value)) -NumberofDecimalPlaces 3
    }
}
