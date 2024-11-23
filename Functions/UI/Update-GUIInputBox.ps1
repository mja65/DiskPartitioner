function Update-GUIInputBox {
    param (
        $InputBox,
        $DropDownBox,
        [Switch]$MBRResize,
        [Switch]$MBRMove_SpaceatBeginning,
        [Switch]$MBRMove_SpaceatEnd
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
                if ($MBRResize){
                    Write-Host 'Changing size based on input'
                    if ((Set-GUIPartitionNewSize -ResizeBytes -PartitionName $Script:GUIActions.SelectedMBRPartition -SizeBytes (Get-ConvertedSize -Size $InputBox.Text -ScaleFrom $DropDownBox.SelectedItem -Scaleto 'B').size -PartitionType 'MBR' -ActiontoPerform 'MBR_ResizeFromRight') -eq $false){
                        Write-host "Invalid Size"
                        $InputBox.Background = 'Yellow'
                    }
                    else{
                        $InputBox.Background = 'White'
                    }
                }
                elseif (($MBRMove_SpaceatBeginning) -or ($MBRMove_SpaceatEnd)){
                    $PartitiontoCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq 'MBR' -and $_.PartitionName -eq $Script:GUIActions.SelectedMBRPartition}
                    if ($MBRMove_SpaceatBeginning){
                        $AmounttoMove = (Get-ConvertedSize -Size $InputBox.Text -ScaleFrom $DropDownBox.SelectedItem -Scaleto 'B').size-$PartitiontoCheck.BytesAvailableLeft
                    }
                    elseif ($MBRMove_SpaceatEnd){
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
