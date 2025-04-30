$WPF_DP_Input_DiskSize_Value | Add-Member -NotePropertyMembers @{
    InputEntry = $false # User clicked on box
    InputEntryChanged = $false # User actually changed something
    InputEntryInvalid = $false # Entry is not valid
    InputEntryScaleChanged = $false # Scale was changed
}

$WPF_DP_Input_DiskSize_Value.add_GotFocus({
    Write-Host 'Got Focus - Diskvalue'
    $WPF_DP_Input_DiskSize_Value.InputEntry = $true
})

$WPF_DP_Input_DiskSize_Value.add_LostFocus({
    Write-Host 'Lost Focus'
    Update-GUIInputBox -InputBox $WPF_DP_Input_DiskSize_Value -SetDiskValues -DiskType $WPF_DP_Disk_Type_DropDown.SelectedItem

})
   
$WPF_DP_Input_DiskSize_Value.add_TextChanged({
    if ($WPF_DP_Input_DiskSize_Value.InputEntry -eq $true){
        $WPF_DP_Input_DiskSize_Value.InputEntryChanged = $true
    }
})
