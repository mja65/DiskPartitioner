$WPF_DP_SelectedSize_Input | Add-Member -NotePropertyMembers @{
    InputEntry = $false
    InputEntryChanged = $false
    InputEntryInvalid= $false
}

$WPF_DP_SelectedSize_Input.add_GotFocus({
    Write-Host 'Got Focus'
    $WPF_DP_SelectedSize_Input.InputEntry = $true
})

$WPF_DP_SelectedSize_Input.add_LostFocus({
   Write-Host 'Lost Focus'
   Update-GUIInputBox -InputBox $WPF_DP_SelectedSize_Input -DropDownBox $WPF_DP_SelectedSize_Input_SizeScale_Dropdown -MBRResize
   Update-UI -UpdateInputBoxes
})

$WPF_DP_SelectedSize_Input.add_TextChanged({
    if ($WPF_DP_SelectedSize_Input.InputEntry -eq $true){
        Write-Host 'Text Changed'
        $WPF_DP_SelectedSize_Input.InputEntryChanged = $true
        $WPF_DP_SelectedSize_Input.InputEntryInvalid = $null
    }
})
