
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
   Update-GUIInputBox -InputBox $WPF_DP_SelectedSize_Input -DropDownBox $WPF_DP_SelectedSize_Input_SizeScale_Dropdown
})

$WPF_DP_SelectedSize_Input.add_TextChanged({
    if ($WPF_DP_SelectedSize_Input.InputEntry -eq $true){
        Write-Host 'Text Changed'
        $WPF_DP_SelectedSize_Input.InputEntryChanged = $true
    }
})

# $WPF_DP_SelectedSize_Input.add_MouseEnter({
#     Write-host "MouseEnter"

# })

# $WPF_DP_SelectedSize_Input.add_MouseLeave({
#     Write-host "MouseLeave"

# })


# if ($WPF_DP_SelectedSize_Input.Text){
#     if ((Set-GUIPartitionNewSize -ResizeBytes -PartitionName $Script:GUIActions.SelectedMBRPartition -ActiontoPerform 'MBR_ResizeFromRight' -PartitionType 'MBR' -SizeBytes (Get-ConvertedSize -Size $WPF_DP_SelectedSize_Input.Text -ScaleFrom $WPF_DP_SelectedSize_Input_SizeScale_Dropdown.Text -Scaleto 'B').Size) -eq $false){
        
#     }
# }

