function Update-GUIInputBox {
    param (
        $InputBox,
        $DropDownBox,
        [Switch]$MBRResize,
        [Switch]$AmigaResize,
        [Switch]$MBRMove_SpaceatBeginning,
        [Switch]$MBRMove_SpaceatEnd,
        [Switch]$AmigaMove_SpaceatBeginning,
        [Switch]$AmigaMove_SpaceatEnd,
        [Switch]$SetDiskValues
    )

    # $InputBox = $WPF_DP_SelectedSize_Input
    # $DropDownBox = $WPF_DP_SelectedSize_Input_SizeScale_Dropdown

    
    if ($InputBox.InputEntry -eq  $true){
        if ($InputBox.InputEntryChanged -eq $true){
            if ((Get-IsValueNumber -TexttoCheck $InputBox.Text) -eq $false){
                Write-Host 'Invalid Text'
                $InputBox.InputEntryInvalid = $true
                $InputBox.Background = 'Red'
            }
            else {
                if ($SetDiskValues){
                    if (-not $Script:GUIActions.DiskSizeSelected -eq $true){
                        Set-InitialDiskValues -SizeBytes ((Get-ConvertedSize -Size ($WPF_DP_Input_DiskSize_Value.Text) -ScaleFrom ($WPF_DP_Input_DiskSize_SizeScale_Dropdown.SelectedItem) -Scaleto 'B').Size)
                    }
                    else{
                       Set-RevisedDiskValues -SizeBytes ((Get-ConvertedSize -Size ($WPF_DP_Input_DiskSize_Value.Text) -ScaleFrom ($WPF_DP_Input_DiskSize_SizeScale_Dropdown.SelectedItem) -Scaleto 'B').Size)
                    }
                    Update-UI -UpdateInputBoxes
                }
                if (($MBRResize) -or ($AmigaResize)){
                    Write-Host 'Changing size based on input'
                    if ($MBRResize){
                        $ResizeCheck = (Set-GUIPartitionNewSize -ResizeBytes -PartitionName $Script:GUIActions.SelectedMBRPartition -SizeBytes (Get-ConvertedSize -Size $InputBox.Text -ScaleFrom $DropDownBox.SelectedItem -Scaleto 'B').size -PartitionType 'MBR' -ActiontoPerform 'MBR_ResizeFromRight')
                    }
                    elseif ($AmigaResize){
                        $ResizeCheck = (Set-GUIPartitionNewSize -ResizeBytes -PartitionName $Script:GUIActions.SelectedAmigaPartition -SizeBytes (Get-ConvertedSize -Size $InputBox.Text -ScaleFrom $DropDownBox.SelectedItem -Scaleto 'B').size -PartitionType 'Amiga' -ActiontoPerform 'Amiga_ResizeFromRight')
                    }
                    if ($ResizeCheck -eq $false){
                        Write-host "Invalid Size"
                        $InputBox.Background = 'Yellow'
                    }
                    else{
                        $InputBox.Background = 'White'
                    }
                }
                if (($MBRMove_SpaceatBeginning) -or ($MBRMove_SpaceatEnd) -or ($AmigaMove_SpaceatBeginning) -or ($AmigaMove_SpaceatEnd)){
                    if (($MBRMove_SpaceatBeginning) -or ($MBRMove_SpaceatEnd)){
                        $PartitiontoCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq 'MBR' -and $_.PartitionName -eq $Script:GUIActions.SelectedMBRPartition}
                    }
                    elseif (($AmigaMove_SpaceatBeginning) -or ($AmigaMove_SpaceatEnd)){
                        $PartitiontoCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq 'Amiga' -and $_.PartitionName -eq $Script:GUIActions.SelectedAmigaPartition}
                    }
                    if (($MBRMove_SpaceatBeginning) -or ($AmigaMove_SpaceatBeginning)){
                        $AmounttoMove = (Get-ConvertedSize -Size $InputBox.Text -ScaleFrom $DropDownBox.SelectedItem -Scaleto 'B').size-$PartitiontoCheck.BytesAvailableLeft
                    }
                    elseif (($MBRMove_SpaceatEnd) -or ($AmigaMove_SpaceatEnd)){
                        $AmounttoMove = (Get-ConvertedSize -Size $InputBox.Text -ScaleFrom $DropDownBox.SelectedItem -Scaleto 'B').size-$PartitiontoCheck.BytesAvailableRight
                        
                    }
                    Write-Host 'Moving partition based on input'
                    Write-Host "Amount to Move is: $AmounttoMove"
                    if (($AmounttoMove -gt 0 -and $AmounttoMove -gt $PartitiontoCheck.BytesAvailableRight) -or ($AmounttoMove -lt 0 -and ($AmounttoMove*-1) -gt $PartitiontoCheck.BytesAvailableLeft)){
                        Write-Host "Space available right is: $($PartitiontoCheck.BytesAvailableRight)"
                        Write-Host "Space available left is: $($PartitiontoCheck.BytesAvailableLeft)"
                        Write-host "Invalid Size"
                        $InputBox.Background = 'Yellow'
                    }
                    else {
                        $InputBox.Background = 'White'
                        Set-GUIPartitionNewPosition -PartitionName $Script:GUIActions.SelectedMBRPartition -AmountMovedBytes $AmounttoMove -PartitionType 'MBR'
                    }                                  
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
