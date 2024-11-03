function Set-PartitionWindowActions {
    param (
    )
    
    #$WindowName = $WPF_UI_DiskPartition_Window

    $WPF_UI_DiskPartition_Window.add_MouseLeftButtonDown({

        $DistancefromTop_MBR = ($WPF_UI_DiskPartition_PartitionGrid_MBR.Margin.Top+$WPF_UI_DiskPartition_Grid_MBR.Margin.Top)
        $DistancefromLeft_MBR = ($WPF_UI_DiskPartition_PartitionGrid_MBR.Margin.left+$WPF_UI_DiskPartition_Grid_MBR.Margin.Left)
        
        $DistancefromTop_Amiga = ($WPF_UI_DiskPartition_PartitionGrid_Amiga.Margin.Top+$WPF_UI_DiskPartition_Grid_Amiga.Margin.Top)
        $DistancefromLeft_Amiga = ($WPF_UI_DiskPartition_PartitionGrid_Amiga.Margin.left+$WPF_UI_DiskPartition_Grid_Amiga.Margin.Left)
        
        $OutofRangeMBRPartition = if(
                                    ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window).MousePositionRelativetoWindowY -lt $DistancefromTop_MBR) -or `
                                    ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window).MousePositionRelativetoWindowY -gt ($DistancefromTop_MBR + 100)) -or `
                                    ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window).MousePositionRelativetoWindowX -lt ($DistancefromLeft_MBR -10))
                                ){
                                    $true
                                }
                                else{
                                    $false
                                }
                                        
        $OutofRangeAmigaPartition =  if(
                                    ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window).MousePositionRelativetoWindowY -lt $DistancefromTop_Amiga) -or `
                                    ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window).MousePositionRelativetoWindowY -gt ($DistancefromTop_Amiga + 100)) -or `
                                    ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window).MousePositionRelativetoWindowX -lt ($DistancefromLeft_Amiga -10))
                                    ){
                                        $true
                                     }
                                    else{
                                        $false
                                    }                   

        # Write-Host "MBR out of range: $OutofRangeMBRPartition"
        # Write-Host "Amiga out of range: $OutofRangeAmigaPartition"     
        # Write-Host "Selected MBR partition: $($Script:GUIActions.SelectedMBRPartition)"
        # Write-Host "Selected Amiga partition: $($Script:GUIActions.SelectedAmigaPartition)"

        if ($OutofRangeMBRPartition -eq $true){
            if (($OutofRangeAmigaPartition -eq $true) -or (($OutofRangeAmigaPartition -eq $false) -and ($Script:GUIActions.IsAmigaPartitionShowing -eq $false))) {
                if ($Script:GUIActions.SelectedMBRPartition){
                    Set-MBRGUIPartitionAsSelectedUnSelected -Action 'MBRUnSelected'
                }    
            }
        }
                   
    })    
 
    $WPF_UI_DiskPartition_Window.add_MouseLeftButtonUp({
        Write-Host "Action is MouseLeftButtonUp"
        $Script:GUIActions.MouseStatus = $null
        $Script:GUIActions.ActionToPerform = $null
    })

}
