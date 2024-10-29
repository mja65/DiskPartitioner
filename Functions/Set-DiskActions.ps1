function Set-DiskActions {
    param (
     
    )
    
    $WPF_UI_DiskPartition_PartitionGrid_MBR.add_MouseLeftButtonDown({

        $Script:GUIActions.MouseStatus = 'LeftButtonDown'
        $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress = (Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Disk_MBR -Grid $WPF_UI_DiskPartition_PartitionGrid_MBR).MousePositionRelativetoWindowX
        $Script:GUIActions.MousePositionRelativetoWindowYatTimeofPress = (Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Disk_MBR -Grid $WPF_UI_DiskPartition_PartitionGrid_MBR).MousePositionRelativetoWindowY
        
        $RezizeAction = (Get-IsResizeZoneGUIPartition -ObjectName $Script:GUIActions.SelectedPartition -MouseX $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress)

        if ($RezizeAction){
            $Script:GUIActions.ActionToPerform = $RezizeAction
        }
        else{
            if ($Script:GUIActions.SelectedPartition){
                Set-GUIPartitionAsSelectedUnSelected -Action 'UnSelected' -Partition (Get-Variable -Name $Script:GUIActions.SelectedPartition).Value 
            }
            $Script:GUIActions.SelectedPartition = (Get-SelectedGUIPartition -Prefix 'WPF_UI_DiskPartition_Partition_' -MouseX $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress)
            if ($Script:GUIActions.SelectedPartition){
                Set-GUIPartitionAsSelectedUnSelected -Action 'Selected' -Partition (Get-Variable -Name $Script:GUIActions.SelectedPartition).Value 
                $Script:GUIActions.ActionToPerform = 'Move'
            } 
        }
             
    })
    
    $WPF_UI_DiskPartition_PartitionGrid_MBR.add_MouseLeftButtonUp({
        Write-Host "Action is MouseLeftButtonUp"
        $Script:GUIActions.MouseStatus = $null
        $Script:GUIActions.ActionToPerform = $null
    })

    $WPF_UI_DiskPartition_PartitionGrid_MBR.add_MouseMove({
        if ($Script:GUIActions.SelectedPartition){
            Start-Sleep -Milliseconds 5
            $AmountMoved = ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Disk_MBR -Grid $WPF_UI_DiskPartition_PartitionGrid_MBR).MousePositionRelativetoWindowX) - $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress
            if ($Script:GUIActions.ActionToPerform -eq 'Move'){
                Set-GUIPartitionNewPosition -Partition ((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value) -AmountMoved $AmountMoved 
            }
            elseif ($Script:GUIActions.ActionToPerform -match 'Resize'){            
                Set-GUIPartitionNewSize -Partition ((Get-Variable -Name $Script:GUIActions.SelectedPartition).Value) -AmountMoved $AmountMoved -ActiontoPerform $Script:GUIActions.ActionToPerform 
            }
              
         
            $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress = (Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Disk_MBR -Grid $WPF_UI_DiskPartition_PartitionGrid_MBR).MousePositionRelativetoWindowX
            $Script:GUIActions.MousePositionRelativetoWindowYatTimeofPress = (Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Disk_MBR -Grid $WPF_UI_DiskPartition_PartitionGrid_MBR).MousePositionRelativetoWindowY
            
        }       

    })

}       
