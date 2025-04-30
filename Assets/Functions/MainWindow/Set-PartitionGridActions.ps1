function Set-PartitionGridActions {
    param (
    )
    
    $WPF_Partition.add_MouseLeftButtonUp({
        if ($Script:GUICurrentStatus.CurrentWindow -eq 'DiskPartition'){
            $Script:GUICurrentStatus.ActionToPerform = $null
            $Script:GUICurrentStatus.LastCommandTime = $null
            $Script:GUICurrentStatus.MousePositionXatTimeofPress = $null
            $Script:GUICurrentStatus.MousePositionyatTimeofPress = $null
        }
    })
    
    $WPF_Window_Main.Add_MouseLeave({
        $WPF_Partition.Cursor = ''
        $Script:GUICurrentStatus.PartitionHoveredOver = $null
        $Script:GUICurrentStatus.ActionToPerform = $null
        $Script:GUICurrentStatus.LastCommandTime = $null
        $Script:GUICurrentStatus.MousePositionXatTimeofPress = $null
        $Script:GUICurrentStatus.MousePositionyatTimeofPress = $null
        if ($Script:Settings.DebugMode){
            Write-Host "Out of bounds"
        }
    })
    
    $WPF_Window_Main.add_MouseMove({
        if (($Script:GUICurrentStatus.CurrentWindow -eq 'DiskPartition') -and ($WPF_DP_GridGPTMBR.Visibility -eq 'Visible')){
            $MouseCoordinates = Get-MouseCoordinatesRelativetoWindow -Window $WPF_MainWindow -MainGrid $WPF_Window_Main -DiskPartitionGrid $WPF_Partition
            $Script:GUICurrentStatus.CurrentMousePositionX = $MouseCoordinates.MousePositionRelativetoWindowX
            $Script:GUICurrentStatus.CurrentMousePositionY = $MouseCoordinates.MousePositionRelativetoWindowY
            $Script:GUICurrentStatus.MouseStatus = $MouseCoordinates.MouseButtons 
            $Script:GUICurrentStatus.PartitionHoveredOver = (Get-HighlightedGUIPartition -MouseX $Script:GUICurrentStatus.CurrentMousePositionX -MouseY $Script:GUICurrentStatus.CurrentMousePositionY)
            if (-not ($Script:GUICurrentStatus.PartitionHoveredOver)){
                $WPF_Partition.Cursor = ''   
            }
            else {
                if ($Script:GUICurrentStatus.PartitionHoveredOver.PartitionName -eq $Script:GUICurrentStatus.SelectedGPTMBRPartition -or $Script:GUICurrentStatus.SelectedAmigaPartition){
                    if ($Script:GUICurrentStatus.PartitionHoveredOver.ResizeZone){
                        $WPF_Partition.Cursor = "SizeWE"
                    }
                    else {
                        $WPF_Partition.Cursor = "Hand"
                    }
                }
                else {
                    $WPF_Partition.Cursor = ''  
                }

            }
            if ($Script:Settings.DebugMode){
                Write-Host "X:$($MouseCoordinates.MousePositionRelativetoWindowX) Y:$($MouseCoordinates.MousePositionRelativetoWindowY) Buttons:$($MouseCoordinates.MouseButtons) MouseOverWindow:$($WPF_Window_Main.IsMouseOver) Hovered Over:$($Script:GUICurrentStatus.PartitionHoveredOver)"
                # X Not Window:$($MouseCoordinates.MousePositionX)
                # Y Not Window:$($MouseCoordinates.MousePositionY) 
            }
            if ($Script:GUICurrentStatus.ActionToPerform){
                $PerformAction = $false
                $CurrentTime = (Get-Date)
                if ($null -eq $Script:GUICurrentStatus.LastCommandTime){
                    $PerformAction = $true
                }
                else {
                    if ((($CurrentTime - $Script:GUICurrentStatus.LastCommandTime).TotalMilliseconds -ge 20) -and ($Script:GUICurrentStatus.MouseStatus -eq 'Left')){
                        $PerformAction = $true
                    }

                }
                if ($PerformAction -eq $true){
                    $Script:GUICurrentStatus.LastCommandTime = $CurrentTime
                    if ($Script:Settings.DebugMode){
                        write-host "Action: $($Script:GUICurrentStatus.ActionToPerform)"   
                    }
                    $AmounttoMove = $Script:GUICurrentStatus.CurrentMousePositionX - $Script:GUICurrentStatus.MousePositionXatTimeofPress
                    $Script:GUICurrentStatus.MousePositionXatTimeofPress = $Script:GUICurrentStatus.CurrentMousePositionX 

                    if (($Script:GUICurrentStatus.ActionToPerform -eq 'Amiga_ResizeFromRight') -or ($Script:GUICurrentStatus.ActionToPerform -eq 'Amiga_ResizeFromLeft')) {
                        $WPF_Partition.Cursor = "SizeWE"
                        if ($Script:Settings.DebugMode){
                            Write-Host "Amount to Resize:$AmounttoMove"
                        }
                        if ((Set-GUIPartitionNewSize -ResizePixels -PartitionName $Script:GUICurrentStatus.SelectedAmigaPartition -ActiontoPerform $Script:GUICurrentStatus.ActionToPerform -PartitionType 'Amiga' -SizePixelstoChange $AmounttoMove) -eq $false){
                            
                        }        
                    }

                    elseif (($Script:GUICurrentStatus.ActionToPerform -eq 'MBR_ResizeFromRight') -or ($Script:GUICurrentStatus.ActionToPerform -eq 'MBR_ResizeFromLeft')) {
                        $WPF_Partition.Cursor = "SizeWE"
                        if ($Script:Settings.DebugMode){
                            Write-Host "Amount to Resize:$AmounttoMove"
                        }
                        if ((Set-GUIPartitionNewSize -ResizePixels -PartitionName $Script:GUICurrentStatus.SelectedGPTMBRPartition -ActiontoPerform $Script:GUICurrentStatus.ActionToPerform -PartitionType 'MBR' -SizePixelstoChange $AmounttoMove) -eq $false){
            
                        }
                    }

                    elseif ($Script:GUICurrentStatus.ActionToPerform -eq 'MBR_Move'){
                        $WPF_Partition.Cursor = "Hand"
                        if ($Script:Settings.DebugMode){
                            Write-Host "Amount to Move:$AmounttoMove"
                        }                        
                        if ((Set-GUIPartitionNewPosition -PartitionName $Script:GUICurrentStatus.SelectedGPTMBRPartition -AmountMovedPixels $AmounttoMove -PartitionType 'MBR') -eq $false){
                            if ($Script:Settings.DebugMode){
                                Write-host "Cannot Move!"
                            }
                        }       
                    }

                    elseif ($Script:GUICurrentStatus.ActionToPerform -eq 'Amiga_Move'){
                        $WPF_Partition.Cursor = "Hand"
                        if ($Script:Settings.DebugMode){
                            Write-Host "Amount to Move:$AmounttoMove"
                        }
                        if ((Set-GUIPartitionNewPosition -PartitionName $Script:GUICurrentStatus.SelectedAmigaPartition -AmountMovedPixels $AmounttoMove -PartitionType 'Amiga') -eq $false){
                            if ($Script:Settings.DebugMode){
                                Write-host "Cannot Move!"
                            }
                        }                        
                    }
                    
                    Update-UI -UpdateInputBoxes
                 }
                elseif ($PerformAction -eq $false){
                    if ($Script:Settings.DebugMode){
                        Write-host "Action: $($Script:GUICurrentStatus.ActionToPerform) - Too Soon!"
                    }
                }  
            } 
        }
    })

    $WPF_Window_Main.add_MouseLeftButtonDown({
        if (($Script:GUICurrentStatus.CurrentWindow -eq 'DiskPartition') -and ($WPF_DP_GridGPTMBR.Visibility -eq 'Visible')){
            $MouseCoordinates = Get-MouseCoordinatesRelativetoWindow -Window $WPF_MainWindow -MainGrid $WPF_Window_Main -DiskPartitionGrid $WPF_Partition
            $Script:GUICurrentStatus.MousePositionXatTimeofPress = $MouseCoordinates.MousePositionRelativetoWindowX
            $Script:GUICurrentStatus.MousePositionYatTimeofPress = $MouseCoordinates.MousePositionRelativetoWindowY
            if ($Script:Settings.DebugMode){
                Write-Host "X (At time of Button press):$($Script:GUICurrentStatus.MousePositionXatTimeofPress) Y (At time of Button press):$($Script:GUICurrentStatus.MousePositionYatTimeofPress)"                       
            }            
            if ($Script:GUICurrentStatus.PartitionHoveredOver){
                if ($Script:GUICurrentStatus.PartitionHoveredOver.PartitionType -eq 'MBR'){
                    if ($Script:GUICurrentStatus.SelectedGPTMBRPartition -eq $Script:GUICurrentStatus.PartitionHoveredOver.PartitionName){
                        if ($Script:GUICurrentStatus.PartitionHoveredOver.ResizeZone){
                            $Script:GUICurrentStatus.ActionToPerform = "MBR_$($Script:GUICurrentStatus.PartitionHoveredOver.ResizeZone)"
                        }
                        else {
                            $Script:GUICurrentStatus.ActionToPerform = 'MBR_Move' 
                        }
                        if ($Script:Settings.DebugMode){
                            Write-Host $Script:GUICurrentStatus.ActionToPerform                      
                        }
                    } 
                    if ($Script:GUICurrentStatus.PartitionHoveredOver.PartitionName -ne $Script:GUICurrentStatus.SelectedGPTMBRPartition){
                        $Script:GUICurrentStatus.SelectedGPTMBRPartition = $Script:GUICurrentStatus.PartitionHoveredOver.PartitionName
                        $Script:GUICurrentStatus.ActionToPerform = $null
                        $Script:GUICurrentStatus.SelectedAmigaPartition = $null
                        if ($Script:Settings.DebugMode){
                            Write-Host "Selected MBR Partition:$($Script:GUICurrentStatus.SelectedGPTMBRPartition)"                       
                        }
                    }
                }
                elseif ($Script:GUICurrentStatus.PartitionHoveredOver.PartitionType -eq 'Amiga'){
                    if ($Script:GUICurrentStatus.SelectedAmigaPartition -eq $Script:GUICurrentStatus.PartitionHoveredOver.PartitionName){
                        if ($Script:GUICurrentStatus.PartitionHoveredOver.ResizeZone){
                            $Script:GUICurrentStatus.ActionToPerform = "Amiga_$($Script:GUICurrentStatus.PartitionHoveredOver.ResizeZone)"
                        }
                        else {
                            $Script:GUICurrentStatus.ActionToPerform = 'Amiga_Move' 
                        }
                        if ($Script:Settings.DebugMode){
                            Write-Host $Script:GUICurrentStatus.ActionToPerform                      
                        }
                    } 
                    $Script:GUICurrentStatus.SelectedAmigaPartition = $Script:GUICurrentStatus.PartitionHoveredOver.PartitionName
                    if ($Script:Settings.DebugMode){
                        Write-Host "Selected Amiga Partition:$($Script:GUICurrentStatus.SelectedAmigaPartition)"                       
                    }
                }
            }
            else {
                if($Script:GUICurrentStatus.SelectedGPTMBRPartition -or $Script:GUICurrentStatus.SelectedAmigaPartition){
                    if  ($Script:GUICurrentStatus.SelectedAmigaPartition){
                        $Script:GUICurrentStatus.SelectedAmigaPartition = $null
                        if ($Script:Settings.DebugMode){
                            Write-Host "Unselected Amiga Partition"                       
                        }
                    }
                    else {
                        $Script:GUICurrentStatus.SelectedGPTMBRPartition = $null
                        if ($Script:Settings.DebugMode){
                            Write-Host "Unselected MBR Partition"                       
                        }
                    }
                }
            }
        }

        Update-UI -All
    })
     
}

# function Set-PartitionGridActions {
#     param (
    
#     )
    
#     $WPF_Window_Main.add_MouseMove({
#         if ($Script:GUICurrentStatus.CurrentWindow -eq 'DiskPartition'){
#             if ($Script:GUICurrentStatus.PartitionHoveredOver){
#                 if ($Script:GUICurrentStatus.PartitionHoveredOver.ResizeZone){
#                     $WPF_Partition.Cursor = "SizeWE"
#                 }
#                 elseif ($Script:GUICurrentStatus.PartitionHoveredOver.PartitionName){
#                     $WPF_Partition.Cursor = "Hand"
#                 }
#                 #Set-ContextMenu -PartitionName $Script:GUICurrentStatus.PartitionHoveredOver.PartitionName -PartitionType 'Amiga'
#             }
#             else{
#                 $WPF_Partition.Cursor = ''
#                 #Set-ContextMenu -PartitionType 'Amiga'
#             }
#         }
#     })


#     $WPF_Partition.add_MouseMove({
#         if ($Script:GUICurrentStatus.CurrentWindow -eq 'DiskPartition'){
#             $MouseCoordinates = Get-MouseCoordinatesRelativetoWindow -Window $WPF_MainWindow -MainGrid $WPF_Window_Main -DiskPartitionGrid $WPF_Partition
#             $Script:GUICurrentStatus.CurrentMousePositionX = $MouseCoordinates.MousePositionRelativetoWindowX
#             $Script:GUICurrentStatus.CurrentMousePositionY = $MouseCoordinates.MousePositionRelativetoWindowY
#             $Script:GUICurrentStatus.MouseStatus = $MouseCoordinates.MouseButtons    
#             $Script:GUICurrentStatus.PartitionHoveredOver = (Get-HighlightedGUIPartition -MouseX $Script:GUICurrentStatus.CurrentMousePositionX -MouseY $Script:GUICurrentStatus.CurrentMousePositionY)
#             if (-not $Script:GUICurrentStatus.PartitionHoveredOver){
#                 $WPF_Partition.Cursor = ''
#             }
                    
#             if ($Script:GUICurrentStatus.ActionToPerform -eq 'MBR_Move'){
#                 $WPF_Partition.Cursor = "Hand"
#                 $AmounttoMove = $Script:GUICurrentStatus.CurrentMousePositionX - $Script:GUICurrentStatus.MousePositionXatTimeofPress
#                 #Write-Host "$($Script:GUICurrentStatus.ActionToPerform) $AmounttoMove"
#                 if ((Set-GUIPartitionNewPosition -PartitionName $Script:GUICurrentStatus.SelectedGPTMBRPartition -AmountMovedPixels $AmounttoMove -PartitionType 'MBR') -eq $false){
#                     Write-host "Cannot Move!"
#                 }
#                 $Script:GUICurrentStatus.MousePositionXatTimeofPress = $Script:GUICurrentStatus.CurrentMousePositionX 
#                 Update-UI -UpdateInputBoxes
    
#             }
#             elseif ($Script:GUICurrentStatus.ActionToPerform -eq 'Amiga_Move'){
#                 $AmounttoMove = $Script:GUICurrentStatus.CurrentMousePositionX - $Script:GUICurrentStatus.MousePositionXatTimeofPress
#                 #Write-Host "$($Script:GUICurrentStatus.ActionToPerform) $AmounttoMove"
#                 if ((Set-GUIPartitionNewPosition -PartitionName $Script:GUICurrentStatus.SelectedAmigaPartition -AmountMovedPixels $AmounttoMove -PartitionType 'Amiga') -eq $false){
#                     Write-host "Cannot Move!"
#                 }
    
#                 $Script:GUICurrentStatus.MousePositionXatTimeofPress = $Script:GUICurrentStatus.CurrentMousePositionX 
#                 Update-UI -UpdateInputBoxes
#             }
#             elseif (($Script:GUICurrentStatus.ActionToPerform -eq 'MBR_ResizeFromRight') -or ($Script:GUICurrentStatus.ActionToPerform -eq 'MBR_ResizeFromLeft')) {
#                 $AmounttoMove = $Script:GUICurrentStatus.CurrentMousePositionX - $Script:GUICurrentStatus.MousePositionXatTimeofPress
#                 #Write-Host "$($Script:GUICurrentStatus.ActionToPerform) $AmounttoMove"
#                 if ($AmounttoMove){
#                     if ((Set-GUIPartitionNewSize -ResizePixels -PartitionName $Script:GUICurrentStatus.SelectedGPTMBRPartition -ActiontoPerform $Script:GUICurrentStatus.ActionToPerform -PartitionType 'MBR' -SizePixelstoChange $AmounttoMove) -eq $false){
        
#                     }
#                     $Script:GUICurrentStatus.MousePositionXatTimeofPress = $Script:GUICurrentStatus.CurrentMousePositionX 
#                     Update-UI -UpdateInputBoxes
#                 }
#             }
#             elseif (($Script:GUICurrentStatus.ActionToPerform -eq 'Amiga_ResizeFromRight') -or ($Script:GUICurrentStatus.ActionToPerform -eq 'Amiga_ResizeFromLeft')) {
#                 $WPF_Partition.Cursor = "SizeWE"
#                 $AmounttoMove = $Script:GUICurrentStatus.CurrentMousePositionX - $Script:GUICurrentStatus.MousePositionXatTimeofPress
#                 #Write-Host "$($Script:GUICurrentStatus.ActionToPerform) $AmounttoMove"
#                 if ($AmounttoMove){
#                     if ((Set-GUIPartitionNewSize -ResizePixels -PartitionName $Script:GUICurrentStatus.SelectedAmigaPartition -ActiontoPerform $Script:GUICurrentStatus.ActionToPerform -PartitionType 'Amiga' -SizePixelstoChange $AmounttoMove) -eq $false){
                        
#                     }
#                     $Script:GUICurrentStatus.MousePositionXatTimeofPress = $Script:GUICurrentStatus.CurrentMousePositionX
#                     Update-UI -UpdateInputBoxes             
#                 }
#             }
#             # Write-Host "X: $($Script:GUICurrentStatus.CurrentMousePositionX) Y: $($Script:GUICurrentStatus.CurrentMousePositionY)"
#         }
#     })
    
#     $WPF_Window_Main.add_MouseLeftButtonDown({
#         if ($Script:GUICurrentStatus.CurrentWindow -eq 'DiskPartition'){
#             If ($WPF_DP_SelectedSize_Input.InputEntry -eq $true){
#                 Update-GUIInputBox -InputBox $WPF_DP_SelectedSize_Input -DropDownBox $WPF_DP_SelectedSize_Input_SizeScale_Dropdown -MBRResize
#             }
#             if ($WPF_DP_SpaceatBeginning_Input.InputEntry -eq $true){
#                 Update-GUIInputBox -InputBox $WPF_DP_SpaceatBeginning_Input -DropDownBox $WPF_DP_SpaceatBeginning_Input_SizeScale_Dropdown -MBRMove_SpaceatBeginning
#             }
#             if ($WPF_DP_SpaceatEnd_Input.InputEntry -eq $true){
#                 Update-GUIInputBox -InputBox $WPF_DP_SpaceatEnd_Input -DropDownBox $WPF_DP_SpaceatEnd_Input_SizeScale_Dropdown -MBRMove_SpaceatEnd
#             }
#             if ($WPF_DP_Input_DiskSize_Value.InputEntry -eq $true){
#                 Update-GUIInputBox -InputBox $WPF_DP_Input_DiskSize_Value -SetDiskValues
#             }
#             $MouseCoordinates = Get-MouseCoordinatesRelativetoWindow -Window $WPF_MainWindow -MainGrid $WPF_Window_Main -DiskPartitionGrid $WPF_Partition
#             $Script:GUICurrentStatus.MousePositionXatTimeofPress = $MouseCoordinates.MousePositionRelativetoWindowX
#             $Script:GUICurrentStatus.MousePositionYatTimeofPress = $MouseCoordinates.MousePositionRelativetoWindowY
            
#             $HighlightedPartition = (Get-HighlightedGUIPartition -MouseX $Script:GUICurrentStatus.MousePositionXatTimeofPress -MouseY $Script:GUICurrentStatus.MousePositionYatTimeofPress)
            
#             if (-not $HighlightedPartition){
#                 if ($Script:GUICurrentStatus.SelectedAmigaPartition){
#                     $Script:GUICurrentStatus.SelectedAmigaPartition = $null
#                 }
#                 elseif ($Script:GUICurrentStatus.SelectedGPTMBRPartition){
#                     Write-Host "Unselecting GPTMBRPartition"
#                     $Script:GUICurrentStatus.SelectedGPTMBRPartition = $null
#                 } 
#             }
#             else{
#                 if ($HighlightedPartition.PartitionType -eq 'MBR'){
#                     if (-not $Script:GUICurrentStatus.SelectedGPTMBRPartition){
#                             Write-host "Selecting GPTMBRPartition"
#                             $Script:GUICurrentStatus.SelectedGPTMBRPartition = $HighlightedPartition.PartitionName
#                             # Write-Host 'Move'
#                             $Script:GUICurrentStatus.ActionToPerform = 'MBR_Move' 
#                     }           
#                     elseif ($Script:GUICurrentStatus.SelectedGPTMBRPartition -eq $HighlightedPartition.PartitionName -and ($HighlightedPartition.ResizeZone)){
#                         # Write-Host "MBR_$($HighlightedPartition.ResizeZone)"
#                         $Script:GUICurrentStatus.ActionToPerform = "MBR_$($HighlightedPartition.ResizeZone)"
#                     }
#                     elseif ($Script:GUICurrentStatus.SelectedGPTMBRPartition -eq $HighlightedPartition.PartitionName -and ( -not $HighlightedPartition.ResizeZone)){
#                         # Write-Host 'MBR_Move'
#                         $Script:GUICurrentStatus.ActionToPerform = 'MBR_Move' 
#                     }
#                     else {
#                         Write-host "Selecting GPTMBRPartition"
#                         $Script:GUICurrentStatus.SelectedGPTMBRPartition = $HighlightedPartition.PartitionName
#                     }
#                 }
#                 elseif ($HighlightedPartition.PartitionType -eq 'Amiga'){
#                     if (-not $Script:GUICurrentStatus.SelectedAmigaPartition){
#                         $Script:GUICurrentStatus.SelectedAmigaPartition = $HighlightedPartition.PartitionName
#                         # Write-Host 'Move'
#                         $Script:GUICurrentStatus.ActionToPerform = 'Amiga_Move' 
#                     }
#                     elseif ($Script:GUICurrentStatus.SelectedAmigaPartition -eq $HighlightedPartition.PartitionName -and ($HighlightedPartition.ResizeZone)){
#                         # Write-Host "Amiga_$($HighlightedPartition.ResizeZone)"
#                         $Script:GUICurrentStatus.ActionToPerform = "Amiga_$($HighlightedPartition.ResizeZone)"
#                     }
#                     elseif ($Script:GUICurrentStatus.SelectedAmigaPartition -eq $HighlightedPartition.PartitionName -and ( -not $HighlightedPartition.ResizeZone)){
#                         # Write-Host 'Amiga_Move'
#                         $Script:GUICurrentStatus.ActionToPerform = 'Amiga_Move' 
#                     }
#                     else {
#                         $Script:GUICurrentStatus.SelectedAmigaPartition = $HighlightedPartition.PartitionName
#                     }
#                 }
#             }
    
#             Update-UI -All

#         }
#     })

#     $WPF_Partition.add_MouseLeftButtonUp({
#         if ($Script:GUICurrentStatus.CurrentWindow -eq 'DiskPartition'){
#             $Script:GUICurrentStatus.ActionToPerform = $null
#         }
#     })
# }

