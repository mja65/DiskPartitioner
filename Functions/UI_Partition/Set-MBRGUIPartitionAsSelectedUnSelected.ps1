function Set-MBRGUIPartitionAsSelectedUnSelected {
    param (
        $Action
    )
    
    #$Script:GUIActions.SelectedMBRPartition = 'WPF_UI_DiskPartition_Partition_ID76_1'
  
    $TotalChildren = ((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value).Children.Count-1
    
    for ($i = 0; $i -le $TotalChildren; $i++) {
        if  ((((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value).Children[$i].Name -eq 'TopBorder_Rectangle') -or `
            (((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value).Children[$i].Name -eq 'BottomBorder_Rectangle') -or `
            (((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value).Children[$i].Name -eq 'LeftBorder_Rectangle') -or `
            (((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value).Children[$i].Name -eq 'RightBorder_Rectangle'))
        {
            #Write-host $Partition.Children[$i].Name
            if ($Action -eq 'MBRSelected'){
                ((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value).Children[$i].Stroke='Red'
            }
            elseif ($Action -eq 'MBRUnSelected'){
                ((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value).Children[$i].Stroke='Black'
            }
        }
    }

    if ($Action -eq 'MBRUnSelected'){
        ((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value).ContextMenu.IsOpen = ""
        ((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value).ContextMenu.IsEnabled = ""
        ((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value).ContextMenu.Visibility = "Collapsed"
        $WPF_UI_DiskPartition_Grid_Amiga.Visibility = 'Hidden'
        if ($Script:WPF_UI_DiskPartition_PartitionGrid_Amiga.Children){
            $Script:WPF_UI_DiskPartition_PartitionGrid_Amiga.Children.Remove(((Get-Variable -Name ($Script:GUIActions.SelectedMBRPartition+'_AmigaDisk')).value))
                
        }
        $Script:GUIActions.IsAmigaPartitionShowing = $false
        $Script:GUIActions.SelectedMBRPartition = $null
        if ($Script:GUIActions.SelectedAmigaPartition){
            Set-AmigaGUIPartitionAsSelectedUnSelected -Action 'AmigaUnselected'            
        }
    }
    elseif($Action -eq 'MBRSelected'){
        ((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value).ContextMenu.IsOpen = ""
        ((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value).ContextMenu.IsEnabled = "True"
        ((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value).ContextMenu.Visibility = "Visible"
        if (((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value).PartitionType -eq 'ID76'){
            $WPF_UI_DiskPartition_Grid_Amiga.Visibility ='Visible'
            $Script:WPF_UI_DiskPartition_PartitionGrid_Amiga.AddChild(((Get-Variable -Name ($Script:GUIActions.SelectedMBRPartition+'_AmigaDisk')).value))
            $Script:GUIActions.IsAmigaPartitionShowing = $true
        }
        else{
            $WPF_UI_DiskPartition_Grid_Amiga.Visibility = 'Hidden'
        }
    }       

}
