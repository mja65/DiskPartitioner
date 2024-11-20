$WPF_DP_SelectedSize_Input.add_LostFocus({
    if ($WPF_DP_SelectedSize_Input.Text){
        if ((Set-GUIPartitionNewSize -ResizeBytes -PartitionName $Script:GUIActions.SelectedMBRPartition -ActiontoPerform 'MBR_ResizeFromRight' -PartitionType 'MBR' -SizeBytes (Get-ConvertedSize -Size $WPF_DP_SelectedSize_Input.Text -ScaleFrom $WPF_DP_SelectedSize_Input_DiskSizeScale_Dropdown.Text -Scaleto 'B').Size) -eq $false){
            
        }
    }
})
