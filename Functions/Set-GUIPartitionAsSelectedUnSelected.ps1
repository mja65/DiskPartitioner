function Set-GUIPartitionAsSelectedUnSelected {
    param (
        $Action

    )
    
    #$Script:GUIActions.SelectedPartition = 'WPF_UI_DiskPartition_Partition_ID76_1'
  
    $TotalChildren = ((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value).Children.Count-1
    
    for ($i = 0; $i -le $TotalChildren; $i++) {
        if  ((((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value).Children[$i].Name -eq 'TopBorder_Rectangle') -or `
            (((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value).Children[$i].Name -eq 'BottomBorder_Rectangle') -or `
            (((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value).Children[$i].Name -eq 'LeftBorder_Rectangle') -or `
            (((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value).Children[$i].Name -eq 'RightBorder_Rectangle'))
        {
            #Write-host $Partition.Children[$i].Name
            if ($Action -eq 'Selected'){
                ((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value).Children[$i].Stroke='Red'
            }
            if ($Action -eq 'UnSelected'){
                ((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value).Children[$i].Stroke='Black'
            }
        }
    }
    
    if ($Action -eq 'UnSelected'){
        ((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value).ContextMenu.IsOpen = ""
        ((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value).ContextMenu.IsEnabled = ""
        ((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value).ContextMenu.Visibility = "Collapsed"
        if ($Script:WPF_UI_DiskPartition_PartitionGrid_Amiga.Children){
                $Script:WPF_UI_DiskPartition_PartitionGrid_Amiga.Children.RemoveChild(((Get-Variable -Name ($PartitionName+'_AmigaDisk')).value))
            }
        $Script:GUIActions.SelectedPartition = $null            
    }
    elseif($Action -eq 'Selected'){
        ((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value).ContextMenu.IsOpen = ""
        ((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value).ContextMenu.IsEnabled = "True"
        ((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value).ContextMenu.Visibility = "Visible"
        if (((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value).PartitionType -eq 'ID76'){
            $Script:WPF_UI_DiskPartition_PartitionGrid_Amiga.AddChild(((Get-Variable -Name ($PartitionName+'_AmigaDisk')).value))
        }
    }       

}
