$WPF_DP_Amiga_SelectedSize_Input | Add-Member -NotePropertyMembers @{
    InputEntry = $false # User clicked on box
    InputEntryChanged = $false # User actually changed something
    InputEntryInvalid = $false # Entry is not valid
    InputEntryScaleChanged = $false # Scale was changed
}

$WPF_DP_Amiga_SelectedSize_Input.add_GotFocus({
    Write-Host 'Got Focus'
    $WPF_DP_Amiga_SelectedSize_Input.InputEntry = $true
})

$WPF_DP_Amiga_SelectedSize_Input.add_LostFocus({
   if ($Script:Settings.DebugMode){
       Write-Host 'WPF_DP_Amiga_SelectedSize_Input - Lost Focus'
   }
   Update-GUIInputBox -InputBox $WPF_DP_Amiga_SelectedSize_Input -DropDownBox $WPF_DP_Amiga_SelectedSize_Input_SizeScale_Dropdown -AmigaResize
   Update-UI -UpdateInputBoxes
})

$WPF_DP_Amiga_SelectedSize_Input.add_TextChanged({
    if ($WPF_DP_Amiga_SelectedSize_Input.InputEntry -eq $true){
        if ($Script:Settings.DebugMode){
            Write-Host 'WPF_DP_Amiga_SelectedSize_Input -Text Changed'
        }
        $WPF_DP_Amiga_SelectedSize_Input.InputEntryChanged = $true
        $WPF_DP_Amiga_SelectedSize_Input.InputEntryInvalid = $null
    }
})
