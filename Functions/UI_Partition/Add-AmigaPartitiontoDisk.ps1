function Add-AmigaPartitiontoDisk {
    param (
        $Prefix,
        $AmigaDiskName,
        $SizePixels,
        $AddType,
        $DefaultPartition
    )
    
    # $Prefix = 'WPF_UI_DiskPartition_Partition_'
    # $AmigaDiskName = 'WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk'
    # $SizePixels = 100
    
    if ($AddType -eq 'Initial'){
        if ((Get-FreeSpace -Prefix $Prefix -PartitionType 'Amiga' -AmigaDiskName $AmigaDiskName) -lt $SizePixels){
            Write-host "Insufficient free space"
            return $false
        }
        $LeftMargin = (Get-GUIPartitionStartEnd -PartitionType 'Amiga' -Prefix $AmigaDiskName).EndingPosition
    }

    elseif ($AddType -eq 'Right'){
        $CoordinatestoCheck = Get-GUIPartitionBoundaries -PartitionType 'Amiga' -Prefix 'WPF_UI_DiskPartition_Partition_' -ObjecttoCheck (Get-Variable -name $Script:GUIActions.SelectedAmigaPartition).value 
        if ($CoordinatestoCheck.RightBoundary - $CoordinatestoCheck.RightEdgeofObject -gt $Script:PistormSDCard.AmigaMinimumSizePixels){
            # Write-Host $Script:PistormSDCard.AmigaMinimumSizePixels
            # Write-Host $CoordinatestoCheck
            $LeftMargin = $CoordinatestoCheck.RightEdgeofObject
        }
        else{
            return
        }
    }
    elseif ($AddType -eq 'Left'){
        $CoordinatestoCheck = Get-GUIPartitionBoundaries -PartitionType 'Amiga' -Prefix 'WPF_UI_DiskPartition_Partition_' -ObjecttoCheck (Get-Variable -name $Script:GUIActions.SelectedAmigaPartition).value 
        Write-Host $CoordinatestoCheck
        if ($CoordinatestoCheck.LeftEdgeofObject - $CoordinatestoCheck.LeftBoundary -gt$Script:PistormSDCard.AmigaMinimumSizePixels){
            $LeftMargin = $CoordinatestoCheck.LeftEdgeofObject-$Script:PistormSDCard.AmigaMinimumSizePixels
        }
        else{
            return
        }
    }


    $PartitionNumber = (Get-Variable -Name $AmigaDiskName).Value.NextPartitionNumber

    $NewPartitionName = ($AmigaDiskName+'_Partition_'+$PartitionNumber)

    Set-Variable -name $NewPartitionName -Scope script -value (New-GUIPartition -DefaultPartition $DefaultPartition -PartitionType 'Amiga' -SizePixels $SizePixels -LeftMargin $LeftMargin -TopMargin 0 -RightMargin 0 -BottomMargin 0)

    (Get-Variable -Name $AmigaDiskName).Value.AddChild(((Get-Variable -name $NewPartitionName).value))

    (Get-Variable -Name $AmigaDiskName).Value.NextPartitionNumber += 1

    if ($DefaultPartition -eq 'TRUE'){
        for ($i = 0; $i -le (Get-Variable -name $NewPartitionName).Value.ContextMenu.Items.Count-1; $i++) {
            if ((Get-Variable -name $NewPartitionName).Value.ContextMenu.Items[$i].Name -eq 'DeletePartition'){
                if ((Get-Variable -name $NewPartitionName).Value.CanDelete -eq $false){
                    (Get-Variable -name $NewPartitionName).Value.ContextMenu.Items[1].IsEnabled = ""
                }
            }
        }
    }

    $PSCommand = @"

    `$$NewPartitionName.add_MouseMove({
        if(Get-IsResizeZoneGUIPartition -ObjectName `$Script:GUIActions.SelectedAmigaPartition -MouseX ((Get-MouseCoordinatesRelativetoWindow -Window `$WPF_UI_DiskPartition_Window -Disk `$WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk  -MainGrid `$WPF_UI_DiskPartition_Grid_Amiga -Grid `$WPF_UI_DiskPartition_PartitionGrid_Amiga).MousePositionRelativetoWindowX)){
            `$$NewPartitionName.Cursor = "SizeWE"
        }
        else{
            `$$NewPartitionName.Cursor = "Hand"
        }
    })

"@
    Invoke-Expression $PSCommand

    $PSCommand = @"

    for (`$i = 0; `$i -le `$$NewPartitionName.ContextMenu.Items.Count-1; `$i++) {
        if (`$$NewPartitionName.ContextMenu.Items[`$i].Name -eq 'DeletePartition'){
            `$$NewPartitionName.ContextMenu.Items[`$i].add_click({
                Remove-AmigaPartition -PartitionName '$NewPartitionName'
            })
        }
    }
"@

    Invoke-Expression $PSCommand  

    $PSCommand = @"

    for (`$i = 0; `$i -le `$$NewPartitionName.ContextMenu.Items.Items.Count-1; `$i++) {    
        if (`$$NewPartitionName.ContextMenu.Items.Items[`$i].Name -eq 'CreatePartitionLeft'){
            `$$NewPartitionName.ContextMenu.Items.Items[`$i].add_click({
                Add-AmigaPartitiontoDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -AmigaDiskName (`$Script:GUIActions.SelectedMBRPartition+'_AmigaDisk') -PartitionType 'Amiga' -AddType 'Left' -SizePixels `$Script:PistormSDCard.AmigaMinimumSizePixels   
            })
        }
    }
"@

    Invoke-Expression $PSCommand  

    $PSCommand = @"

    for (`$i = 0; `$i -le `$$NewPartitionName.ContextMenu.Items.Items.Count-1; `$i++) {    
        if (`$$NewPartitionName.ContextMenu.Items.Items[`$i].Name -eq 'CreatePartitionRight'){
            `$$NewPartitionName.ContextMenu.Items.Items[`$i].add_click({
                Add-AmigaPartitiontoDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -AmigaDiskName (`$Script:GUIActions.SelectedMBRPartition+'_AmigaDisk') -PartitionType 'Amiga' -AddType 'Right' -SizePixels `$Script:PistormSDCard.AmigaMinimumSizePixels        
            })
        }
    }
"@

    Invoke-Expression $PSCommand  


}

