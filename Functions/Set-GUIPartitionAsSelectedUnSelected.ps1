function Set-GUIPartitionAsSelectedUnSelected {
    param (
        $Partition,
        $Action

    )
    
    $TotalChildren = $Partition.Children.Count-1
    
    for ($i = 0; $i -le $TotalChildren; $i++) {
        if  (($Partition.Children[$i].Name -eq 'TopBorder_Rectangle') -or `
            ($Partition.Children[$i].Name -eq 'BottomBorder_Rectangle') -or `
            ($Partition.Children[$i].Name -eq 'LeftBorder_Rectangle') -or `
            ($Partition.Children[$i].Name -eq 'RightBorder_Rectangle'))
        {
            #Write-host $Partition.Children[$i].Name
            if ($Action -eq 'Selected'){
                $Partition.Children[$i].Stroke='Red'
            }
            if ($Action -eq 'UnSelected'){
                $Partition.Children[$i].Stroke='Black'
            }
        }
    }
    
    if ($Action -eq 'UnSelected'){
        $Script:GUIActions.SelectedPartition = $null
        $Partition.ContextMenu.IsOpen = ""
        $Partition.ContextMenu.IsEnabled = ""
        $Partition.ContextMenu.Visibility = "Collapsed"
    }
    elseif($Action -eq 'Selected'){
        $Partition.ContextMenu.IsOpen = ""
        $Partition.ContextMenu.IsEnabled = "True"
        $Partition.ContextMenu.Visibility = "Visible"
    }       

}
