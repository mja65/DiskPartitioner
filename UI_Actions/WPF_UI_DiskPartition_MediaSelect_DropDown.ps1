$Script:RemovableMediaList = Get-RemovableMedia

$WPF_UI_DiskPartition_MediaSelect_DropDown.add_DropDownOpened({
    Update-MediaSelectDropDown
})

$WPF_UI_DiskPartition_MediaSelect_DropDown.Add_selectionChanged({
    $WPF_UI_DiskPartition_Input_DiskSizeScale_Dropdown.SelectedItem = 'GiB'
    $WPF_UI_DiskPartition_Input_DiskSize_Value.Text = Get-ConvertedSize -ScaleFrom 'B' -Scaleto 'GiB' -Size (Get-DiskSizefromRemovableMedia -DisktoFind $WPF_UI_DiskPartition_MediaSelect_DropDown.SelectedItem) -NumberofDecimalPlaces 3 -Truncate 'TRUE'
})


