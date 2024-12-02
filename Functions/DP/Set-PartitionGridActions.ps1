function Set-PartitionGridActions {
    param (
    
    )
    
    $WPF_DP_DiskGrid_Amiga.add_MouseMove({
        if ($Script:GUIActions.PartitionHoveredOver){
            if ($Script:GUIActions.PartitionHoveredOver.ResizeZone){
                $WPF_Partition.Cursor = "SizeWE"
            }
            elseif ($Script:GUIActions.PartitionHoveredOver.PartitionName){
                $WPF_Partition.Cursor = "Hand"
            }
            #Set-ContextMenu -PartitionName $Script:GUIActions.PartitionHoveredOver.PartitionName -PartitionType 'Amiga'
        }
        else{
            $WPF_Partition.Cursor = ''
            #Set-ContextMenu -PartitionType 'Amiga'
        }
    })

    $WPF_DP_DiskGrid_MBR.add_MouseMove({
        #Write-Host "X: $($Script:GUIActions.CurrentMousePositionX) Y: $($Script:GUIActions.CurrentMousePositionY)"
        
        if ($Script:GUIActions.PartitionHoveredOver){
            if ($Script:GUIActions.PartitionHoveredOver.ResizeZone){
                $WPF_Partition.Cursor = "SizeWE"
            }
            elseif ($Script:GUIActions.PartitionHoveredOver.PartitionName){
                $WPF_Partition.Cursor = "Hand"
            }
            # Write-Host $Script:GUIActions.PartitionHoveredOver
            #Set-ContextMenu -PartitionName $Script:GUIActions.PartitionHoveredOver.PartitionName -PartitionType 'MBR'
        }
        else{
            $WPF_Partition.Cursor = ''
            #Set-ContextMenu -PartitionType 'MBR'
        }
    })

    $WPF_Partition.add_MouseMove({
        $MouseCoordinates = Get-MouseCoordinatesRelativetoWindow -Window $WPF_MainWindow -MainGrid $WPF_Partition
        $Script:GUIActions.CurrentMousePositionX = $MouseCoordinates.MousePositionRelativetoWindowX
        $Script:GUIActions.CurrentMousePositionY = $MouseCoordinates.MousePositionRelativetoWindowY
        $Script:GUIActions.MouseStatus = $MouseCoordinates.MouseButtons    
        $Script:GUIActions.PartitionHoveredOver = (Get-HighlightedGUIPartition -MouseX $Script:GUIActions.CurrentMousePositionX -MouseY $Script:GUIActions.CurrentMousePositionY)
        if (-not $Script:GUIActions.PartitionHoveredOver){
            $WPF_Partition.Cursor = ''
        }
                
        if ($Script:GUIActions.ActionToPerform -eq 'MBR_Move'){
            $WPF_Partition.Cursor = "Hand"
            $AmounttoMove = $Script:GUIActions.CurrentMousePositionX - $Script:GUIActions.MousePositionXatTimeofPress
            #Write-Host "$($Script:GUIActions.ActionToPerform) $AmounttoMove"
            if ((Set-GUIPartitionNewPosition -PartitionName $Script:GUIActions.SelectedMBRPartition -AmountMovedPixels $AmounttoMove -PartitionType 'MBR') -eq $false){
                Write-host "Cannot Move!"
            }
            $Script:GUIActions.MousePositionXatTimeofPress = $Script:GUIActions.CurrentMousePositionX 
            Update-UI -UpdateInputBoxes

        }
        elseif ($Script:GUIActions.ActionToPerform -eq 'Amiga_Move'){
            $AmounttoMove = $Script:GUIActions.CurrentMousePositionX - $Script:GUIActions.MousePositionXatTimeofPress
            #Write-Host "$($Script:GUIActions.ActionToPerform) $AmounttoMove"
            if ((Set-GUIPartitionNewPosition -PartitionName $Script:GUIActions.SelectedAmigaPartition -AmountMovedPixels $AmounttoMove -PartitionType 'Amiga') -eq $false){
                Write-host "Cannot Move!"
            }

            $Script:GUIActions.MousePositionXatTimeofPress = $Script:GUIActions.CurrentMousePositionX 
            Update-UI -UpdateInputBoxes
        }
        elseif (($Script:GUIActions.ActionToPerform -eq 'MBR_ResizeFromRight') -or ($Script:GUIActions.ActionToPerform -eq 'MBR_ResizeFromLeft')) {
            $AmounttoMove = $Script:GUIActions.CurrentMousePositionX - $Script:GUIActions.MousePositionXatTimeofPress
            #Write-Host "$($Script:GUIActions.ActionToPerform) $AmounttoMove"
            if ($AmounttoMove){
                if ((Set-GUIPartitionNewSize -ResizePixels -PartitionName $Script:GUIActions.SelectedMBRPartition -ActiontoPerform $Script:GUIActions.ActionToPerform -PartitionType 'MBR' -SizePixelstoChange $AmounttoMove) -eq $false){
    
                }
                $Script:GUIActions.MousePositionXatTimeofPress = $Script:GUIActions.CurrentMousePositionX 
                Update-UI -UpdateInputBoxes
            }
        }
        elseif (($Script:GUIActions.ActionToPerform -eq 'Amiga_ResizeFromRight') -or ($Script:GUIActions.ActionToPerform -eq 'Amiga_ResizeFromLeft')) {
            $WPF_Partition.Cursor = "SizeWE"
            $AmounttoMove = $Script:GUIActions.CurrentMousePositionX - $Script:GUIActions.MousePositionXatTimeofPress
            #Write-Host "$($Script:GUIActions.ActionToPerform) $AmounttoMove"
            if ($AmounttoMove){
                if ((Set-GUIPartitionNewSize -ResizePixels -PartitionName $Script:GUIActions.SelectedAmigaPartition -ActiontoPerform $Script:GUIActions.ActionToPerform -PartitionType 'Amiga' -SizePixelstoChange $AmounttoMove) -eq $false){
                    
                }
                $Script:GUIActions.MousePositionXatTimeofPress = $Script:GUIActions.CurrentMousePositionX
                Update-UI -UpdateInputBoxes             
            }
        }
        # Write-Host "X: $($Script:GUIActions.CurrentMousePositionX) Y: $($Script:GUIActions.CurrentMousePositionY)"
    })
    
    $WPF_Partition.add_MouseLeftButtonDown({

        If ($WPF_DP_SelectedSize_Input.InputEntry -eq $true){
            Update-GUIInputBox -InputBox $WPF_DP_SelectedSize_Input -DropDownBox $WPF_DP_SelectedSize_Input_SizeScale_Dropdown -MBRResize
        }
        if ($WPF_DP_SpaceatBeginning_Input.InputEntry -eq $true){
            Update-GUIInputBox -InputBox $WPF_DP_SpaceatBeginning_Input -DropDownBox $WPF_DP_SpaceatBeginning_Input_SizeScale_Dropdown -MBRMove_SpaceatBeginning
        }
        if ($WPF_DP_SpaceatEnd_Input.InputEntry -eq $true){
            Update-GUIInputBox -InputBox $WPF_DP_SpaceatEnd_Input -DropDownBox $WPF_DP_SpaceatEnd_Input_SizeScale_Dropdown -MBRMove_SpaceatEnd
        }
        $MouseCoordinates = Get-MouseCoordinatesRelativetoWindow -Window $WPF_MainWindow -MainGrid $WPF_Partition
        $Script:GUIActions.MousePositionXatTimeofPress = $MouseCoordinates.MousePositionRelativetoWindowX
        $Script:GUIActions.MousePositionYatTimeofPress = $MouseCoordinates.MousePositionRelativetoWindowY
        
        $HighlightedPartition = (Get-HighlightedGUIPartition -MouseX $Script:GUIActions.MousePositionXatTimeofPress -MouseY $Script:GUIActions.MousePositionYatTimeofPress)
        
        if (-not $HighlightedPartition){
            if ($Script:GUIActions.SelectedAmigaPartition){
                $Script:GUIActions.SelectedAmigaPartition = $null
            }
            elseif ($Script:GUIActions.SelectedMBRPartition){
                $Script:GUIActions.SelectedMBRPartition = $null
            } 
        }
        else{
            if ($HighlightedPartition.PartitionType -eq 'MBR'){
                if (-not $Script:GUIActions.SelectedMBRPartition){
                        $Script:GUIActions.SelectedMBRPartition = $HighlightedPartition.PartitionName
                        # Write-Host 'Move'
                        $Script:GUIActions.ActionToPerform = 'MBR_Move' 
                }           
                elseif ($Script:GUIActions.SelectedMBRPartition -eq $HighlightedPartition.PartitionName -and ($HighlightedPartition.ResizeZone)){
                    # Write-Host "MBR_$($HighlightedPartition.ResizeZone)"
                    $Script:GUIActions.ActionToPerform = "MBR_$($HighlightedPartition.ResizeZone)"
                }
                elseif ($Script:GUIActions.SelectedMBRPartition -eq $HighlightedPartition.PartitionName -and ( -not $HighlightedPartition.ResizeZone)){
                    # Write-Host 'MBR_Move'
                    $Script:GUIActions.ActionToPerform = 'MBR_Move' 
                }
                else {
                    $Script:GUIActions.SelectedMBRPartition = $HighlightedPartition.PartitionName
                }
            }
            elseif ($HighlightedPartition.PartitionType -eq 'Amiga'){
                if (-not $Script:GUIActions.SelectedAmigaPartition){
                    $Script:GUIActions.SelectedAmigaPartition = $HighlightedPartition.PartitionName
                    # Write-Host 'Move'
                    $Script:GUIActions.ActionToPerform = 'Amiga_Move' 
                }
                elseif ($Script:GUIActions.SelectedAmigaPartition -eq $HighlightedPartition.PartitionName -and ($HighlightedPartition.ResizeZone)){
                    # Write-Host "Amiga_$($HighlightedPartition.ResizeZone)"
                    $Script:GUIActions.ActionToPerform = "Amiga_$($HighlightedPartition.ResizeZone)"
                }
                elseif ($Script:GUIActions.SelectedAmigaPartition -eq $HighlightedPartition.PartitionName -and ( -not $HighlightedPartition.ResizeZone)){
                    # Write-Host 'Amiga_Move'
                    $Script:GUIActions.ActionToPerform = 'Amiga_Move' 
                }
                else {
                    $Script:GUIActions.SelectedAmigaPartition = $HighlightedPartition.PartitionName
                }
            }
        }

        Update-UI -All
    })

    $WPF_Partition.add_MouseLeftButtonUp({
        $Script:GUIActions.ActionToPerform = $null
    })
}
