function Set-PartitionWindowActions {
    param (
    )
    
    #$WindowName = $WPF_UI_DiskPartition_Window

    $WPF_UI_DiskPartition_Window.add_MouseLeftButtonDown({
        
        if (((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window).MousePositionRelativetoWindowY -lt $WPF_UI_DiskPartition_PartitionGrid_MBR.Margin.Top) -or `
        ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window).MousePositionRelativetoWindowY -gt $WPF_UI_DiskPartition_PartitionGrid_MBR.Margin.Top + 100)
        ){
            if ($Script:GUIActions.SelectedPartition){
                Set-GUIPartitionAsSelectedUnSelected -Action 'UnSelected'
            }    
        }
    })    
 
    $WPF_UI_DiskPartition_Window.add_MouseLeftButtonUp({
        Write-Host "Action is MouseLeftButtonUp"
        $Script:GUIActions.MouseStatus = $null
        $Script:GUIActions.ActionToPerform = $null
    })

}