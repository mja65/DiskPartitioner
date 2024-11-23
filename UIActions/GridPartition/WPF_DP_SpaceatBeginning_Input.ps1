$WPF_DP_SpaceatBeginning_Input | Add-Member -NotePropertyMembers @{
    InputEntry = $false
    InputEntryChanged = $false
    InputEntryInvalid= $false
}

$WPF_DP_SpaceatBeginning_Input.add_GotFocus({
    Write-Host 'Got Focus'
    $WPF_DP_SpaceatBeginning_Input.InputEntry = $true
})

$WPF_DP_SpaceatBeginning_Input.add_LostFocus({
   Write-Host 'Lost Focus'
   Update-GUIInputBox -InputBox $WPF_DP_SpaceatBeginning_Input -DropDownBox $WPF_DP_SpaceatBeginning_Input_SizeScale_Dropdown -MBRMove_SpaceatBeginning
   Update-UI -UpdateInputBoxes
})

$WPF_DP_SpaceatBeginning_Input.add_TextChanged({
    if ($WPF_DP_SpaceatBeginning_Input.InputEntry -eq $true){
        Write-Host 'Text Changed'
        $WPF_DP_SpaceatBeginning_Input.InputEntryChanged = $true
        $WPF_DP_SpaceatBeginning_Input.InputEntryInvalid = $null
    }
})

