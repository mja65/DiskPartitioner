function Set-MBRDiskActions {
    param (
     
    )
    
    $WPF_UI_DiskPartition_PartitionGrid_MBR.add_MouseLeftButtonDown({

        $Script:GUIActions.MouseStatus = 'LeftButtonDown'
        $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress = (Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Disk_MBR -Grid $WPF_UI_DiskPartition_PartitionGrid_MBR).MousePositionRelativetoWindowX
        $Script:GUIActions.MousePositionRelativetoWindowYatTimeofPress = (Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Disk_MBR -Grid $WPF_UI_DiskPartition_PartitionGrid_MBR).MousePositionRelativetoWindowY
        
        $RezizeAction = (Get-IsResizeZoneGUIPartition -ObjectName $Script:GUIActions.SelectedMBRPartition -MouseX $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress)

        if ($RezizeAction){
            $Script:GUIActions.ActionToPerform = ('MBR_'+$RezizeAction)
        }
        else{
            if ($Script:GUIActions.SelectedMBRPartition){
                Set-MBRGUIPartitionAsSelectedUnSelected -Action 'MBRUnSelected'
            }
            $Script:GUIActions.SelectedMBRPartition = (Get-SelectedGUIPartition -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionType 'MBR' -MouseX $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress)
            if ($Script:GUIActions.SelectedMBRPartition){
                Set-MBRGUIPartitionAsSelectedUnSelected -Action 'MBRSelected'
                $Script:GUIActions.ActionToPerform = 'MBR_Move'
            } 
        }
             
    })
    
    $WPF_UI_DiskPartition_PartitionGrid_MBR.add_MouseLeftButtonUp({
        Write-Host "Action is MouseLeftButtonUp"
        $Script:GUIActions.MouseStatus = $null
        $Script:GUIActions.ActionToPerform = $null
    })

    $WPF_UI_DiskPartition_PartitionGrid_MBR.add_MouseMove({
        if ($Script:GUIActions.SelectedMBRPartition){
            Start-Sleep -Milliseconds 5
            $AmountMoved = ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Disk_MBR -Grid $WPF_UI_DiskPartition_PartitionGrid_MBR).MousePositionRelativetoWindowX) - $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress
            if ($Script:GUIActions.ActionToPerform -eq 'MBR_Move'){
                Set-GUIPartitionNewPosition -PartitionType 'MBR' -Partition ((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value) -AmountMoved $AmountMoved 
            }
            elseif ($Script:GUIActions.ActionToPerform -match 'Resize'){            
                Set-GUIPartitionNewSize -PartitionType 'MBR' -Partition ((Get-Variable -Name $Script:GUIActions.SelectedMBRPartition).Value) -AmountMoved $AmountMoved -ActiontoPerform $Script:GUIActions.ActionToPerform 
            }
              
         
            $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress = (Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Disk_MBR -Grid $WPF_UI_DiskPartition_PartitionGrid_MBR).MousePositionRelativetoWindowX
            $Script:GUIActions.MousePositionRelativetoWindowYatTimeofPress = (Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Disk_MBR -Grid $WPF_UI_DiskPartition_PartitionGrid_MBR).MousePositionRelativetoWindowY
            
        }       

    })

}       

