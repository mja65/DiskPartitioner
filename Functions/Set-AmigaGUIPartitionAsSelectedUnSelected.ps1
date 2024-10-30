function Set-AmigaGUIPartitionAsSelectedUnSelected {
    param (
        $Action
    )
 
    $TotalChildren = ((Get-Variable -Name $Script:GUIActions.SelectedAmigaPartition).Value).Children.Count-1
    
    for ($i = 0; $i -le $TotalChildren; $i++) {
        if  ((((Get-Variable -Name $Script:GUIActions.SelectedAmigaPartition).Value).Children[$i].Name -eq 'TopBorder_Rectangle') -or `
            (((Get-Variable -Name $Script:GUIActions.SelectedAmigaPartition).Value).Children[$i].Name -eq 'BottomBorder_Rectangle') -or `
            (((Get-Variable -Name $Script:GUIActions.SelectedAmigaPartition).Value).Children[$i].Name -eq 'LeftBorder_Rectangle') -or `
            (((Get-Variable -Name $Script:GUIActions.SelectedAmigaPartition).Value).Children[$i].Name -eq 'RightBorder_Rectangle'))
        {
           # Write-host ((Get-Variable -Name $Script:GUIActions.SelectedAmigaPartition).Value).Children[$i].Name
            if ($Action -eq 'AmigaSelected'){
                ((Get-Variable -Name $Script:GUIActions.SelectedAmigaPartition).Value).Children[$i].Stroke='Red'
            }
            elseif ($Action -eq 'AmigaUnSelected'){
                ((Get-Variable -Name $Script:GUIActions.SelectedAmigaPartition).Value).Children[$i].Stroke='Black'
            }
        }
    }

    if ($Action -eq 'AmigaUnSelected'){
        $Script:GUIActions.SelectedAmigaPartition = $null            
    }
    elseif($Action -eq 'AmigaSelected'){
        
    }
    
}