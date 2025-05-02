$WPF_DP_Amiga_SpaceatBeginning_Input | Add-Member -NotePropertyMembers @{
    EntryType = 'Numeric'
    EntryLength = $null
    InputEntry = $false # User clicked on box
    InputEntryChanged = $false # User actually changed something
    InputEntryInvalid = $false # Entry is not valid
    InputEntryScaleChanged = $false # Scale was changed
    ValueWhenEnterorButtonPushed = $null
}

$WPF_DP_Amiga_SpaceatBeginning_Input.add_GotFocus({
    if ($Script:Settings.DebugMode){
        Write-Host 'Got Focus - WPF_DP_Amiga_SpaceatBeginning_Input:'
    }
    $WPF_DP_Amiga_SpaceatBeginning_Input.InputEntry = $true
    $Script:GUICurrentStatus.TextBoxEntryFocus = 'WPF_DP_Amiga_SpaceatBeginning_Input'

})

$WPF_DP_Amiga_SpaceatBeginning_Input.add_LostFocus({
    
    if ($WPF_DP_Amiga_SpaceatBeginning_Input.ValueWhenEnterorButtonPushed -ne $WPF_DP_Amiga_SpaceatBeginning_Input.Text -and $WPF_DP_Amiga_SpaceatBeginning_Input.InputEntryChanged){
        if ($Script:Settings.DebugMode){
            Write-Host 'Lost Focus - Performing action for WPF_DP_Amiga_SpaceatBeginning_Input'
        }
        Update-GUIInputBox -InputBox $WPF_DP_Amiga_SpaceatBeginning_Input -DropDownBox $WPF_DP_Amiga_SpaceatBeginning_Input_SizeScale_Dropdown -AmigaMove_SpaceatBeginning
    }
    else {
        if ($Script:Settings.DebugMode){
            Write-Host 'Lost Focus - Not performing action for WPF_DP_Amiga_SpaceatBeginning_Input'
        }
    }
    $WPF_DP_Amiga_SpaceatBeginning_Input.ValueWhenEnterorButtonPushed = $null
    $Script:GUICurrentStatus.TextBoxEntryFocus = $null 

})
   
$WPF_DP_Amiga_SpaceatBeginning_Input.add_TextChanged({
    $WPF_DP_Amiga_SpaceatBeginning_Input.InputEntryChanged = $true
    if ($Script:Settings.DebugMode){
        Write-Host 'Text Changed'
    }
})

$WPF_DP_Amiga_SpaceatBeginning_Input.Add_KeyDown({
    if ($_.Key -eq 'Return'){       
        if ($Script:Settings.DebugMode){
            Write-Host "Key pressed was: $($_.Key)"
        }
        if ($WPF_DP_Amiga_SpaceatBeginning_Input.ValueWhenEnterorButtonPushed -ne $WPF_DP_Amiga_SpaceatBeginning_Input.Text){
            $WPF_DP_Amiga_SpaceatBeginning_Input.ValueWhenEnterorButtonPushed = $WPF_DP_Amiga_SpaceatBeginning_Input.Text
            if ($Script:Settings.DebugMode){
                Write-Host "WPF_DP_Amiga_SpaceatBeginning_Input: Recording value of: $($WPF_DP_Amiga_SpaceatBeginning_Input.ValueWhenEnterorButtonPushed) and actioning. EntryType is: $($WPF_DP_Amiga_SpaceatBeginning_Input.EntryType) InputEntry is: $($WPF_DP_Amiga_SpaceatBeginning_Input.InputEntry) InputEntryChanged is: $($WPF_DP_Amiga_SpaceatBeginning_Input.InputEntryChanged) InputEntryInvalid is: $($WPF_DP_Amiga_SpaceatBeginning_Input.InputEntryInvalid) InputEntryScaleChanged is: $($WPF_DP_Amiga_SpaceatBeginning_Input.InputEntryScaleChanged) ValueWhenEnterorButtonPushed is: $($WPF_DP_Amiga_SpaceatBeginning_Input.ValueWhenEnterorButtonPushed)" 
            }
            $WPF_DP_Amiga_SpaceatBeginning_Input.InputEntry = $true
            Update-GUIInputBox -InputBox $WPF_DP_Amiga_SpaceatBeginning_Input -DropDownBox $WPF_DP_Amiga_SpaceatBeginning_Input_SizeScale_Dropdown -AmigaMove_SpaceatBeginning
        }
        else {
            $WPF_DP_Amiga_SpaceatBeginning_Input.ValueWhenEnterorButtonPushed = $WPF_DP_Amiga_SpaceatBeginning_Input.Text
            if ($Script:Settings.DebugMode){
                Write-Host "WPF_DP_Amiga_SpaceatBeginning_Input: Recording value of: $($WPF_DP_Amiga_SpaceatBeginning_Input.ValueWhenEnterorButtonPushed)"
            }
        }
    }
})
