function Set-PartitionGridActions {
    param (
    
    )
    
    $WPF_DP_DiskGrid_MBR.add_MouseMove({
        #Write-Host "X: $($Script:GUIActions.CurrentMousePositionX) Y: $($Script:GUIActions.CurrentMousePositionY)"
        $PartitionHoveredOver = (Get-HighlightedGUIPartition -MouseX $Script:GUIActions.CurrentMousePositionX -MouseY $Script:GUIActions.CurrentMousePositionY)
        if ($PartitionHoveredOver){
            if ($PartitionHoveredOver.ResizeZone){
                $WPF_Partition.Cursor = "SizeWE"
            }
            else{
                $WPF_Partition.Cursor = "Hand"
            }
            Set-ContextMenu -PartitionName $PartitionHoveredOver.PartitionName -PartitionType 'MBR'
        }
        else{
            $WPF_Partition.Cursor = ''
            Set-ContextMenu -PartitionType 'MBR'
        }
    })

    $WPF_Partition.add_MouseMove({
        $MouseCoordinates = Get-MouseCoordinatesRelativetoWindow -Window $WPF_MainWindow -MainGrid $WPF_Partition
        $Script:GUIActions.CurrentMousePositionX = $MouseCoordinates.MousePositionRelativetoWindowX
        $Script:GUIActions.CurrentMousePositionY = $MouseCoordinates.MousePositionRelativetoWindowY
        $Script:GUIActions.MouseStatus = $MouseCoordinates.MouseButtons    

                
        if ($Script:GUIActions.ActionToPerform -eq 'MBR_Move'){
            $WPF_Partition.Cursor = "Hand"
            $AmounttoMove = $Script:GUIActions.CurrentMousePositionX - $Script:GUIActions.MousePositionXatTimeofPress
            #Write-Host "$($Script:GUIActions.ActionToPerform) $AmounttoMove"
            if ((Set-GUIPartitionNewPosition -PartitionName $Script:GUIActions.SelectedMBRPartition -AmountMovedPixels $AmounttoMove -PartitionType 'MBR') -eq $false){
                Write-host "Cannot Move!"
            }
            $Script:GUIActions.MousePositionXatTimeofPress = $Script:GUIActions.CurrentMousePositionX 

        }
        elseif ($Script:GUIActions.ActionToPerform -eq 'Amiga_Move'){
            $AmounttoMove = $Script:GUIActions.CurrentMousePositionX - $Script:GUIActions.MousePositionXatTimeofPress
            #Write-Host "$($Script:GUIActions.ActionToPerform) $AmounttoMove"
            if ((Set-GUIPartitionNewPosition -PartitionName $Script:GUIActions.SelectedAmigaPartition -AmountMovedPixels $AmounttoMove -PartitionType 'Amiga') -eq $false){
                Write-host "Cannot Move!"
            }

            $Script:GUIActions.MousePositionXatTimeofPress = $Script:GUIActions.CurrentMousePositionX 
        }
        elseif (($Script:GUIActions.ActionToPerform -eq 'MBR_ResizeFromRight') -or ($Script:GUIActions.ActionToPerform -eq 'MBR_ResizeFromLeft')) {
            $AmounttoMove = $Script:GUIActions.CurrentMousePositionX - $Script:GUIActions.MousePositionXatTimeofPress
            #Write-Host "$($Script:GUIActions.ActionToPerform) $AmounttoMove"
            if ((Set-GUIPartitionNewSize -ResizePixels -PartitionName $Script:GUIActions.SelectedMBRPartition -ActiontoPerform $Script:GUIActions.ActionToPerform -PartitionType 'MBR' -SizePixelstoChange $AmounttoMove) -eq $false){

            }
            $Script:GUIActions.MousePositionXatTimeofPress = $Script:GUIActions.CurrentMousePositionX 
        }
        elseif (($Script:GUIActions.ActionToPerform -eq 'Amiga_ResizeFromRight') -or ($Script:GUIActions.ActionToPerform -eq 'Amiga_ResizeFromLeft')) {
            $WPF_Partition.Cursor = "SizeWE"
            $AmounttoMove = $Script:GUIActions.CurrentMousePositionX - $Script:GUIActions.MousePositionXatTimeofPress
            #Write-Host "$($Script:GUIActions.ActionToPerform) $AmounttoMove"
            if ((Set-GUIPartitionNewSize -ResizePixels -PartitionName $Script:GUIActions.SelectedAmigaPartition -ActiontoPerform $Script:GUIActions.ActionToPerform -PartitionType 'Amiga' -SizePixelstoChange $AmounttoMove) -eq $false){
                
            }
            $Script:GUIActions.MousePositionXatTimeofPress = $Script:GUIActions.CurrentMousePositionX             
        }
        # Write-Host "X: $($Script:GUIActions.CurrentMousePositionX) Y: $($Script:GUIActions.CurrentMousePositionY)"
        Update-UI
    })
    
    $WPF_Partition.add_MouseLeftButtonDown({
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
                        Write-Host 'Move'
                        $Script:GUIActions.ActionToPerform = 'MBR_Move' 
                }           
                elseif ($Script:GUIActions.SelectedMBRPartition -eq $HighlightedPartition.PartitionName -and ($HighlightedPartition.ResizeZone)){
                    Write-Host "MBR_$($HighlightedPartition.ResizeZone)"
                    $Script:GUIActions.ActionToPerform = "MBR_$($HighlightedPartition.ResizeZone)"
                }
                elseif ($Script:GUIActions.SelectedMBRPartition -eq $HighlightedPartition.PartitionName -and ( -not $HighlightedPartition.ResizeZone)){
                    Write-Host 'MBR_Move'
                    $Script:GUIActions.ActionToPerform = 'MBR_Move' 
                }
                else {
                    $Script:GUIActions.SelectedMBRPartition = $HighlightedPartition.PartitionName
                }
            }
            elseif ($HighlightedPartition.PartitionType -eq 'Amiga'){
                if (-not $Script:GUIActions.SelectedAmigaPartition){
                    $Script:GUIActions.SelectedAmigaPartition = $HighlightedPartition.PartitionName
                    Write-Host 'Move'
                    $Script:GUIActions.ActionToPerform = 'Amiga_Move' 
                }
                elseif ($Script:GUIActions.SelectedAmigaPartition -eq $HighlightedPartition.PartitionName -and ($HighlightedPartition.ResizeZone)){
                    Write-Host "Amiga_$($HighlightedPartition.ResizeZone)"
                    $Script:GUIActions.ActionToPerform = "Amiga_$($HighlightedPartition.ResizeZone)"
                }
                elseif ($Script:GUIActions.SelectedAmigaPartition -eq $HighlightedPartition.PartitionName -and ( -not $HighlightedPartition.ResizeZone)){
                    Write-Host 'Amiga_Move'
                    $Script:GUIActions.ActionToPerform = 'Amiga_Move' 
                }
                else {
                    $Script:GUIActions.SelectedAmigaPartition = $HighlightedPartition.PartitionName
                }
            }
        }

        Update-UI
    })

    $WPF_Partition.add_MouseLeftButtonUp({
        $Script:GUIActions.ActionToPerform = $null
    })
}

# if ($PartitionHoveredOver.PartitionType -eq 'MBR'){
    # if ($Script:GUIActions.MBRPartitionContextMenuEnabled -eq $false){
    #     $WPF_DP_DiskGrid_MBR.ContextMenu.IsOpen = ''
    #     $WPF_DP_DiskGrid_MBR.ContextMenu.IsEnabled = 'True'
    #     $WPF_DP_DiskGrid_MBR.ContextMenu.Visibility = 'Visible'
    #     $Script:GUIActions.MBRPartitionContextMenuEnabled = $true
    # }
#}
# elseif ($PartitionHoveredOver.PartitionType -eq 'Amiga'){
#     if ($Script:GUIActions.AmigaPartitionContextMenuEnabled -eq $false){                    
#         $WPF_DP_DiskGrid_Amiga.ContextMenu.IsOpen = ''
#         $WPF_DP_DiskGrid_Amiga.ContextMenu.IsEnabled = 'True'
#         $WPF_DP_DiskGrid_Amiga.ContextMenu.Visibility = 'Visible'
#         $Script:GUIActions.AmigaPartitionContextMenuEnabled = $true
#     }
# }

            # $Script:GUIActions.AmigaPartitionContextMenuEnabled = $false
            # $Script:GUIActions.MBRPartitionContextMenuEnabled = $false
            # $WPF_DP_DiskGrid_Amiga.ContextMenu.IsOpen = ''
            # $WPF_DP_DiskGrid_Amiga.ContextMenu.IsEnabled = ''
            # $WPF_DP_DiskGrid_Amiga.ContextMenu.Visibility = 'Collapsed'
            # $WPF_DP_DiskGrid_MBR.ContextMenu.IsOpen = ''
            # $WPF_DP_DiskGrid_MBR.ContextMenu.IsEnabled = ''
            # $WPF_DP_DiskGrid_MBR.ContextMenu.Visibility = 'Collapsed'