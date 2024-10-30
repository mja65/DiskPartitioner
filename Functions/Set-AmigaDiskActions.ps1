
function Set-AmigaDiskActions {
    param (
        
    )

    $WPF_UI_DiskPartition_PartitionGrid_Amiga.add_MouseLeftButtonDown({
        Write-Host $Script:GUIActions.SelectedMBRPartition
        If ($Script:GUIActions.SelectedMBRPartition){
            $Script:GUIActions.MouseStatus = 'AmigaLeftButtonDown'
            $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress = (Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk -Grid $WPF_UI_DiskPartition_PartitionGrid_Amiga).MousePositionRelativetoWindowX
            Write-host $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress 
            $Script:GUIActions.MousePositionRelativetoWindowYatTimeofPress = (Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk -Grid $WPF_UI_DiskPartition_PartitionGrid_Amiga).MousePositionRelativetoWindowY
        
            $RezizeAction = (Get-IsResizeZoneGUIPartition -ObjectName $Script:GUIActions.SelectedAmigaPartition -MouseX $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress)
        
            if ($RezizeAction){
                $Script:GUIActions.ActionToPerform = ('Amiga_'+$RezizeAction)
            }
            else{
                if ($Script:GUIActions.SelectedAmigaPartition){
                    Set-AmigaGUIPartitionAsSelectedUnSelected -Action 'AmigaUnSelected'
                }
                $Script:GUIActions.SelectedAmigaPartition = (Get-SelectedGUIPartition -PartitionType 'Amiga' -Prefix 'WPF_UI_DiskPartition_Partition_' -MouseX $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress)
                if ($Script:GUIActions.SelectedAmigaPartition){
                    Set-AmigaGUIPartitionAsSelectedUnSelected -Action 'AmigaSelected'
                    $Script:GUIActions.ActionToPerform = 'Amiga_Move'
                } 
            }
        }
    })
    
    $WPF_UI_DiskPartition_PartitionGrid_Amiga.add_MouseLeftButtonUp({
        If ($Script:GUIActions.SelectedMBRPartition){
            Write-Host "Action is MouseLeftButtonUp"
            $Script:GUIActions.MouseStatus = $null
            $Script:GUIActions.ActionToPerform = $null
        }
    })
    
    $WPF_UI_DiskPartition_PartitionGrid_Amiga.add_MouseMove({
        if ($Script:GUIActions.SelectedAmigaPartition){
            Start-Sleep -Milliseconds 5
            $AmountMoved = ((Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk -Grid $WPF_UI_DiskPartition_PartitionGrid_Amiga).MousePositionRelativetoWindowX) - $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress
            if ($Script:GUIActions.ActionToPerform -eq 'Amiga_Move'){
                Set-GUIPartitionNewPosition -PartitionType 'Amiga' -Partition ((Get-Variable -Name $Script:GUIActions.SelectedAmigaPartition).Value) -AmountMoved $AmountMoved 
            }
            elseif ($Script:GUIActions.ActionToPerform -match 'Amiga_Resize'){            
                Set-GUIPartitionNewSize -PartitionType 'Amiga' -Partition ((Get-Variable -Name $Script:GUIActions.SelectedAmigaPartition).Value) -AmountMoved $AmountMoved -ActiontoPerform $Script:GUIActions.ActionToPerform 
            }
              
         
            $Script:GUIActions.MousePositionRelativetoWindowXatTimeofPress = (Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk -Grid $WPF_UI_DiskPartition_PartitionGrid_Amiga).MousePositionRelativetoWindowX
            $Script:GUIActions.MousePositionRelativetoWindowYatTimeofPress = (Get-MouseCoordinatesRelativetoWindow -Window $WPF_UI_DiskPartition_Window -Disk $WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk -Grid $WPF_UI_DiskPartition_PartitionGrid_Amiga).MousePositionRelativetoWindowY
        } 
    })

}
