$WPF_DP_Amiga_MaxTransfer_Input | Add-Member -NotePropertyMembers @{
    EntryType = 'Hexadecimal'
    EntryLength = 8
    InputEntry = $null
    InputEntryChanged = $null
    ValueWhenEnterorButtonPushed = $null
}

$WPF_DP_Amiga_MaxTransfer_Input.add_GotFocus({
    if ($Script:Settings.DebugMode){
        Write-Host 'Got Focus - WPF_DP_Amiga_MaxTransfer_Input:'
    }
    $WPF_DP_Amiga_MaxTransfer_Input.InputEntry = $true
})

$WPF_DP_Amiga_MaxTransfer_Input.add_LostFocus({
    
    if ($WPF_DP_Amiga_MaxTransfer_Input.ValueWhenEnterorButtonPushed -ne $WPF_DP_Amiga_MaxTransfer_Input.Text -and $WPF_DP_Amiga_MaxTransfer_Input.InputEntryChanged){
        if ($Script:Settings.DebugMode){
            Write-Host 'Lost Focus - Performing action for WPF_DP_Amiga_MaxTransfer_Input'
        }       
        (get-variable -name $script:GUICurrentStatus.SelectedAmigaPartition).value.MaxTransfer = $WPF_DP_Amiga_MaxTransfer_Input.Text
        Update-UITextbox -NameofPartition $script:GUICurrentStatus.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_MaxTransfer_Input -Value 'MaxTransfer' -CanChangeParameter 'CanChangeMaxTransfer'


    }
    else {
        if ($Script:Settings.DebugMode){
            Write-Host 'Lost Focus - Not performing action for WPF_DP_Amiga_MaxTransfer_Input'
        }
    }
    $WPF_DP_Amiga_MaxTransfer_Input.ValueWhenEnterorButtonPushed = $null

})
   
$WPF_DP_Amiga_MaxTransfer_Input.add_TextChanged({
    $WPF_DP_Amiga_MaxTransfer_Input.InputEntryChanged = $true
    if ($Script:Settings.DebugMode){
        Write-Host 'Text Changed'
    }
})

$WPF_DP_Amiga_MaxTransfer_Input.Add_KeyDown({
    if ($_.Key -eq 'Return'){       
        if ($Script:Settings.DebugMode){
            Write-Host "Key pressed was: $($_.Key)"
        }
        if ($WPF_DP_Amiga_MaxTransfer_Input.ValueWhenEnterorButtonPushed -ne $WPF_DP_Amiga_MaxTransfer_Input.Text){
            $WPF_DP_Amiga_MaxTransfer_Input.ValueWhenEnterorButtonPushed = $WPF_DP_Amiga_MaxTransfer_Input.Text
            if ($Script:Settings.DebugMode){
                Write-Host "WPF_DP_Amiga_MaxTransfer_Input: Recording value of: $($WPF_DP_Amiga_MaxTransfer_Input.ValueWhenEnterorButtonPushed) and actioning. EntryType is: $($WPF_DP_Amiga_MaxTransfer_Input.EntryType) InputEntry is: $($WPF_DP_Amiga_MaxTransfer_Input.InputEntry) InputEntryChanged is: $($WPF_DP_Amiga_MaxTransfer_Input.InputEntryChanged) InputEntryInvalid is: $($WPF_DP_Amiga_MaxTransfer_Input.InputEntryInvalid) InputEntryScaleChanged is: $($WPF_DP_Amiga_MaxTransfer_Input.InputEntryScaleChanged) ValueWhenEnterorButtonPushed is: $($WPF_DP_Amiga_MaxTransfer_Input.ValueWhenEnterorButtonPushed)" 
            }
            $WPF_DP_Amiga_MaxTransfer_Input.InputEntry = $true
            (get-variable -name $script:GUICurrentStatus.SelectedAmigaPartition).value.MaxTransfer = $WPF_DP_Amiga_MaxTransfer_Input.Text
            Update-UITextbox -NameofPartition $script:GUICurrentStatus.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_MaxTransfer_Input -Value 'MaxTransfer' -CanChangeParameter 'CanChangeMaxTransfer'

        }
        else {
            $WPF_DP_Amiga_MaxTransfer_Input.ValueWhenEnterorButtonPushed = $WPF_DP_Amiga_MaxTransfer_Input.Text
            if ($Script:Settings.DebugMode){
                Write-Host "WPF_DP_Amiga_MaxTransfer_Input: Recording value of: $($WPF_DP_Amiga_MaxTransfer_Input.ValueWhenEnterorButtonPushed)"
            }
        }
    }
})