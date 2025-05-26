$WPF_DP_Amiga_Mask_Input | Add-Member -NotePropertyMembers @{
    EntryType = 'Hexadecimal'
    EntryLength = 10
    InputEntry = $null
    InputEntryChanged = $null
    ValueWhenEnterorButtonPushed = $null
}

$WPF_DP_Amiga_Mask_Input.add_GotFocus({
    # Write-debug 'Got Focus - WPF_DP_Amiga_Mask_Input:'
    $WPF_DP_Amiga_Mask_Input.InputEntry = $true
})

$WPF_DP_Amiga_Mask_Input.add_LostFocus({
    
    if ($WPF_DP_Amiga_Mask_Input.ValueWhenEnterorButtonPushed -ne $WPF_DP_Amiga_Mask_Input.Text -and $WPF_DP_Amiga_Mask_Input.InputEntryChanged){
        # Write-debug 'Lost Focus - Performing action for WPF_DP_Amiga_Mask_Input'   
        $Script:GUICurrentStatus.SelectedAmigaPartition.Mask = $WPF_DP_Amiga_Mask_Input.Text
        Update-UITextbox -NameofPartition $script:GUICurrentStatus.SelectedAmigaPartition.PartitionName -TextBoxControl $WPF_DP_Amiga_Mask_Input -Value 'Mask' -CanChangeParameter 'CanChangeMask'


    }
    else {
        # Write-debug 'Lost Focus - Not performing action for WPF_DP_Amiga_Mask_Input'
    }
    $WPF_DP_Amiga_Mask_Input.ValueWhenEnterorButtonPushed = $null

})
   
$WPF_DP_Amiga_Mask_Input.add_TextChanged({
    $WPF_DP_Amiga_Mask_Input.InputEntryChanged = $true
    # Write-debug 'Text Changed'
})

$WPF_DP_Amiga_Mask_Input.Add_KeyDown({
    if ($_.Key -eq 'Return'){       
        # Write-debug "Key pressed was: $($_.Key)"
        if ($WPF_DP_Amiga_Mask_Input.ValueWhenEnterorButtonPushed -ne $WPF_DP_Amiga_Mask_Input.Text){
            $WPF_DP_Amiga_Mask_Input.ValueWhenEnterorButtonPushed = $WPF_DP_Amiga_Mask_Input.Text
            # Write-debug "WPF_DP_Amiga_Mask_Input: Recording value of: $($WPF_DP_Amiga_Mask_Input.ValueWhenEnterorButtonPushed) and actioning. EntryType is: $($WPF_DP_Amiga_Mask_Input.EntryType) InputEntry is: $($WPF_DP_Amiga_Mask_Input.InputEntry) InputEntryChanged is: $($WPF_DP_Amiga_Mask_Input.InputEntryChanged) InputEntryInvalid is: $($WPF_DP_Amiga_Mask_Input.InputEntryInvalid) InputEntryScaleChanged is: $($WPF_DP_Amiga_Mask_Input.InputEntryScaleChanged) ValueWhenEnterorButtonPushed is: $($WPF_DP_Amiga_Mask_Input.ValueWhenEnterorButtonPushed)" 
            $WPF_DP_Amiga_Mask_Input.InputEntry = $true
            $Script:GUICurrentStatus.SelectedAmigaPartition.Mask = $WPF_DP_Amiga_Mask_Input.Text
            Update-UITextbox -NameofPartition $script:GUICurrentStatus.SelectedAmigaPartition.PartitionName -TextBoxControl $WPF_DP_Amiga_Mask_Input -Value 'Mask' -CanChangeParameter 'CanChangeMask'

        }
        else {
            $WPF_DP_Amiga_Mask_Input.ValueWhenEnterorButtonPushed = $WPF_DP_Amiga_Mask_Input.Text
            # Write-debug "WPF_DP_Amiga_Mask_Input: Recording value of: $($WPF_DP_Amiga_Mask_Input.ValueWhenEnterorButtonPushed)"
        }
    }
})