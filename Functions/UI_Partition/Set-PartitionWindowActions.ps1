function Set-PartitionWindowActions {
    param (
    )
    
    #$WindowName = $WPF_UI_DiskPartition_Window

    $WPF_UI_DiskPartition_Window.add_MouseLeftButtonDown({

        $OutofRangeMBRPartition = if(
                                    ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window).MousePositionRelativetoWindowY -lt $WPF_UI_DiskPartition_PartitionGrid_MBR.Margin.Top) -or `
                                    ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window).MousePositionRelativetoWindowY -gt ($WPF_UI_DiskPartition_PartitionGrid_MBR.Margin.Top + 100)) -or `
                                    ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window).MousePositionRelativetoWindowX -lt ($WPF_UI_DiskPartition_PartitionGrid_MBR.Margin.left -10))
                                ){
                                    $true
                                }
                                else{
                                    $false
                                }
                                        
        $OutofRangeAmigaPartition =  if(
                                    ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window).MousePositionRelativetoWindowY -lt $WPF_UI_DiskPartition_PartitionGrid_Amiga.Margin.Top) -or `
                                    ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window).MousePositionRelativetoWindowY -gt ($WPF_UI_DiskPartition_PartitionGrid_Amiga.Margin.Top + 100)) -or `
                                    ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window).MousePositionRelativetoWindowX -lt ($WPF_UI_DiskPartition_PartitionGrid_Amiga.Margin.left -10))
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
