$WPF_DP_Input_DiskSize_Value | Add-Member -NotePropertyMembers @{
    EntryType = 'Numeric'
    EntryLength = $null
    InputEntry = $false # User clicked on box
    InputEntryChanged = $false # User actually changed something
    InputEntryInvalid = $false # Entry is not valid
    InputEntryScaleChanged = $false # Scale was changed
    ValueWhenEnterorButtonPushed = $null
}

$WPF_DP_Input_DiskSize_Value.add_GotFocus({
    if ($Script:Settings.DebugMode){
        Write-Host 'Got Focus - WPF_DP_Input_DiskSize_Value:'
    }
    $WPF_DP_Input_DiskSize_Value.InputEntry = $true
    $Script:GUICurrentStatus.TextBoxEntryFocus = 'WPF_DP_Input_DiskSize_Value'

})

$WPF_DP_Input_DiskSize_Value.add_LostFocus({
    
    if ($WPF_DP_Input_DiskSize_Value.ValueWhenEnterorButtonPushed -ne $WPF_DP_Input_DiskSize_Value.Text -and $WPF_DP_Input_DiskSize_Value.InputEntryChanged){
        if ($Script:Settings.DebugMode){
            Write-Host 'Lost Focus - Performing action for WPF_DP_Input_DiskSize_Value'
        }
        Update-GUIInputBox -InputBox $WPF_DP_Input_DiskSize_Value -SetDiskValues -DiskType $WPF_DP_Disk_Type_DropDown.SelectedItem
    }
    else {
        if ($Script:Settings.DebugMode){
            Write-Host 'Lost Focus - Not performing action for WPF_DP_Input_DiskSize_Value'
        }
    }
    $WPF_DP_Input_DiskSize_Value.ValueWhenEnterorButtonPushed = $null
    $Script:GUICurrentStatus.TextBoxEntryFocus = $null 

})
   
$WPF_DP_Input_DiskSize_Value.add_TextChanged({
    $WPF_DP_Input_DiskSize_Value.InputEntryChanged = $true
    if ($Script:Settings.DebugMode){
        Write-Host 'Text Changed'
    }
})

$WPF_DP_Input_DiskSize_Value.Add_KeyDown({
    if ($_.Key -eq 'Return'){       
        if ($Script:Settings.DebugMode){
            Write-Host "Key pressed was: $($_.Key)"
        }
        if ($WPF_DP_Input_DiskSize_Value.ValueWhenEnterorButtonPushed -ne $WPF_DP_Input_DiskSize_Value.Text){
            $WPF_DP_Input_DiskSize_Value.ValueWhenEnterorButtonPushed = $WPF_DP_Input_DiskSize_Value.Text
            if ($Script:Settings.DebugMode){
                Write-Host "WPF_DP_Input_DiskSize_Value: Recording value of: $($WPF_DP_Input_DiskSize_Value.ValueWhenEnterorButtonPushed) and actioning. EntryType is: $($WPF_DP_Input_DiskSize_Value.EntryType) InputEntry is: $($WPF_DP_Input_DiskSize_Value.InputEntry) InputEntryChanged is: $($WPF_DP_Input_DiskSize_Value.InputEntryChanged) InputEntryInvalid is: $($WPF_DP_Input_DiskSize_Value.InputEntryInvalid) InputEntryScaleChanged is: $($WPF_DP_Input_DiskSize_Value.InputEntryScaleChanged) ValueWhenEnterorButtonPushed is: $($WPF_DP_Input_DiskSize_Value.ValueWhenEnterorButtonPushed)" 
            }
            $WPF_DP_Input_DiskSize_Value.InputEntry = $true
            Update-GUIInputBox -InputBox $WPF_DP_Input_DiskSize_Value -SetDiskValues -DiskType $WPF_DP_Disk_Type_DropDown.SelectedItem
        }
        else {
            $WPF_DP_Input_DiskSize_Value.ValueWhenEnterorButtonPushed = $WPF_DP_Input_DiskSize_Value.Text
            if ($Script:Settings.DebugMode){
                Write-Host "WPF_DP_Input_DiskSize_Value: Recording value of: $($WPF_DP_Input_DiskSize_Value.ValueWhenEnterorButtonPushed)"
            }
        }
    }
})
