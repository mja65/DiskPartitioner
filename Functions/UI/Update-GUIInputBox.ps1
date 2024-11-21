function Update-GUIInputBox {
    param (
        $InputBox,
        $DropDownBox
    )

    # $InputBox = $WPF_DP_SelectedSize_Input
    # $DropDownBox = $WPF_DP_SelectedSize_Input_SizeScale_Dropdown

    if ($InputBox.InputEntry -eq  $true){
        if ($InputBox.InputEntryChanged -eq $true){
            if ((Get-IsValueNumber -TexttoCheck $InputBox.Text) -eq $false){
                Write-Host 'Invalid Text'
                $InputBox.InputEntryInvalid = $true
            }
            else {
                Write-Host 'Changing size based on input'
                if ((Set-GUIPartitionNewSize -ResizeBytes -PartitionName $Script:GUIActions.SelectedMBRPartition -SizeBytes (Get-ConvertedSize -Size $InputBox.Text -ScaleFrom $DropDownBox.SelectedItem -Scaleto 'B').size -PartitionType 'MBR' -ActiontoPerform 'MBR_ResizeFromRight') -eq $false){
                    
                }
                $InputBox.InputEntryChanged = $false
                $InputBox.InputEntry = $false
                $InputBox.InputEntryInvalid = $null
            }
        }
        $InputBox.InputEntry = $false
        $InputBox.InputEntryChanged = $false
        $InputBox.InputEntryInvalid = $null
    }
}
