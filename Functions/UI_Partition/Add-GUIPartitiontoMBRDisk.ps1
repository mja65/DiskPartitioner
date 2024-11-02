function Add-GUIPartitiontoMBRDisk {
    param (
        $Prefix,
        $PartitionType,
        $AddType,
        $SizePixels,
        $DefaultPartition
    )
    
    # $Prefix = 'WPF_UI_DiskPartition_Partition_'
    # $PartitionType = 'FAT32'
    # $PartitionType = 'ID76'
    # $NewPartitionNumber = '1'
    # $SizePixels = 100
    # $LeftMargin = 0
    
    $PrefixtoUse = ($Prefix+$PartitionType)

    if (($Script:WPF_UI_DiskPartition_Disk_MBR.NumberofPartitionsFAT32 + $Script:WPF_UI_DiskPartition_Disk_MBR.NumberofPartitionsID76) -eq 4){
        Write-host "Exceeded number of MBR Partitions"
        return $false
    }
    if ($AddType -eq 'Initial'){
        if ((Get-FreeSpace -Prefix $Prefix -PartitionType 'MBR') -lt $SizePixels){
            Write-host "Insufficient free space"
            return $false
        }
    }
    if ($PartitionType -eq 'FAT32'){
        $NewPartitionNumber = $Script:WPF_UI_DiskPartition_Disk_MBR.NextPartitionFAT32Number
        $Script:WPF_UI_DiskPartition_Disk_MBR.NextPartitionFAT32Number += 1
        $Script:WPF_UI_DiskPartition_Disk_MBR.NumberofPartitionsFAT32 += 1
    }
    elseif ($PartitionType -eq 'ID76'){
        $NewPartitionNumber = $Script:WPF_UI_DiskPartition_Disk_MBR.NextPartitionID76Number
        $Script:WPF_UI_DiskPartition_Disk_MBR.NextPartitionID76Number += 1
        $Script:WPF_UI_DiskPartition_Disk_MBR.NumberofPartitionsID76 += 1
    }
        
    $NewPartitionName = ($PrefixtoUse+'_'+$NewPartitionNumber) 
    
    if ($PartitionType -eq 'FAT32'){
        $MinimumSize = $Script:PistormSDCard.FAT32MinimumSizePixels
    }
    elseif ($PartitionType -eq 'ID76'){
        $MinimumSize = $Script:PistormSDCard.ID76MinimumSizePixels
    }

    if ($AddType -eq 'Initial'){
        $LeftMargin = (Get-GUIPartitionStartEnd -PartitionType 'MBR' -Prefix $Prefix).EndingPosition
    }
    elseif ($AddType -eq 'Right'){
        $CoordinatestoCheck = Get-GUIPartitionBoundaries -PartitionType 'MBR' -Prefix 'WPF_UI_DiskPartition_Partition_' -ObjecttoCheck (Get-Variable -name $Script:GUIActions.SelectedMBRPartition).value 
        if ($CoordinatestoCheck.RightBoundary - $CoordinatestoCheck.RightEdgeofObject -gt $MinimumSize){
            Write-Host $MinimumSize
            Write-Host $CoordinatestoCheck
            $LeftMargin = $CoordinatestoCheck.RightEdgeofObject
        }
        else{
            return
        }
    }
    elseif ($AddType -eq 'Left'){
        $CoordinatestoCheck = Get-GUIPartitionBoundaries -PartitionType 'MBR' -Prefix 'WPF_UI_DiskPartition_Partition_' -ObjecttoCheck (Get-Variable -name $Script:GUIActions.SelectedMBRPartition).value 
        if ($CoordinatestoCheck.LeftEdgeofObject - $CoordinatestoCheck.LeftBoundary -gt $MinimumSize){
            $LeftMargin = $CoordinatestoCheck.LeftEdgeofObject-$MinimumSize
        }
        else{
            return
        }
    }

    
    $NewPartition = New-GUIPartition -DefaultPartition $DefaultPartition -PartitionType $PartitionType -SizePixels $SizePixels -LeftMargin $LeftMargin  -TopMargin 0 -RightMargin 0 -BottomMargin 0
    
    if ($NewPartition.DefaultPartition -eq 'TRUE'){
        for ($i = 0; $i -le $NewPartition.ContextMenu.Items.Count-1; $i++) {
            if ($NewPartition.ContextMenu.Items[$i].Name -eq 'DeletePartition'){
                if ($NewPartition.CanDelete -eq $false){
                    $NewPartition.ContextMenu.Items[1].IsEnabled = ""
                }
            }
        }
        for ($i = 0; $i -le $NewPartition.ContextMenu.Items.Items.Count-1; $i++) {    
            if ($NewPartition.ContextMenu.Items.Items[$i].Name -eq 'CreateID76Left'){
                if ($NewPartition.CanResizeLeft -eq $false){
                    $NewPartition.ContextMenu.Items.Items[$i].IsEnabled = ""
                }
            }
            if ($NewPartition.ContextMenu.Items.Items[$i].Name -eq 'CreateFAT32Left'){
                if ($NewPartition.CanResizeLeft -eq $false){
                    $NewPartition.ContextMenu.Items.Items[$i].IsEnabled = ""
                }
            }
        }
    }

    Set-Variable -name $NewPartitionName -Scope Script -Value ((Get-Variable -Name NewPartition).Value)
    (Get-Variable -Name $NewPartitionName).Value.Name = $NewPartitionName
 
    $PSCommand = @"

        `$Script:WPF_UI_DiskPartition_PartitionGrid_MBR.AddChild(`$$NewPartitionName)
        `$$NewPartitionName.ContextMenu.add_Opened({
            if (-not `$Script:GUIActions.SelectedMBRPartition){
                `$$NewPartitionName.ContextMenu.IsOpen = ""
            }
        })
"@

    Invoke-Expression $PSCommand  

    $PSCommand = @"

    for (`$i = 0; `$i -le `$$NewPartitionName.ContextMenu.Items.Count-1; `$i++) {
        if (`$$NewPartitionName.ContextMenu.Items[`$i].Name -eq 'DeletePartition'){
            `$$NewPartitionName.ContextMenu.Items[`$i].add_click({
                Remove-MBRGUIPartition -PartitionName '$NewPartitionName'
            })
        }
    }
"@

    Invoke-Expression $PSCommand  

    $PSCommand = @"

    for (`$i = 0; `$i -le `$$NewPartitionName.ContextMenu.Items.Items.Count-1; `$i++) {    
        if (`$$NewPartitionName.ContextMenu.Items.Items[`$i].Name -eq 'CreateID76Right'){
            `$$NewPartitionName.ContextMenu.Items.Items[`$i].add_click({
                Add-GUIPartitiontoMBRDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionType 'ID76' -AddType 'Right' -SizePixels `$Script:PistormSDCard.ID76MinimumSizePixels                
            })
        }
    }
"@

    Invoke-Expression $PSCommand 
    
    $PSCommand = @"

    for (`$i = 0; `$i -le `$$NewPartitionName.ContextMenu.Items.Items.Count-1; `$i++) {    
        if (`$$NewPartitionName.ContextMenu.Items.Items[`$i].Name -eq 'CreateFAT32Left'){
            `$$NewPartitionName.ContextMenu.Items.Items[`$i].add_click({
                Add-GUIPartitiontoMBRDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionType 'FAT32' -AddType 'Left' -SizePixels `$Script:PistormSDCard.FAT32MinimumSizePixels   
            })
        }
    }
"@

    Invoke-Expression $PSCommand  

    $PSCommand = @"

    for (`$i = 0; `$i -le `$$NewPartitionName.ContextMenu.Items.Items.Count-1; `$i++) {    
        if (`$$NewPartitionName.ContextMenu.Items.Items[`$i].Name -eq 'CreateFAT32Right'){
            `$$NewPartitionName.ContextMenu.Items.Items[`$i].add_click({
                Add-GUIPartitiontoMBRDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionType 'FAT32' -AddType 'Right' -SizePixels `$Script:PistormSDCard.FAT32MinimumSizePixels        
            })
        }
    }
"@

    Invoke-Expression $PSCommand  

    $PSCommand = @"

    for (`$i = 0; `$i -le `$$NewPartitionName.ContextMenu.Items.Items.Count-1; `$i++) {    
        if (`$$NewPartitionName.ContextMenu.Items.Items[`$i].Name -eq 'CreateID76Left'){
            `$$NewPartitionName.ContextMenu.Items.Items[`$i].add_click({
                Add-GUIPartitiontoMBRDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionType 'ID76' -AddType 'Left' -SizePixels `$Script:PistormSDCard.ID76MinimumSizePixels     
            })
        }

    }


"@

    Invoke-Expression $PSCommand  

    $PSCommand = @"
    
    `$$NewPartitionName.add_MouseMove({
        if (Get-IsResizeZoneGUIPartition -ObjectName `$Script:GUIActions.SelectedMBRPartition -MouseX ((Get-MouseCoordinatesRelativetoWindow -Window `$WPF_UI_DiskPartition_Window -Disk `$WPF_UI_DiskPartition_Disk_MBR -Grid `$WPF_UI_DiskPartition_PartitionGrid_MBR).MousePositionRelativetoWindowX)){
            `$$NewPartitionName.Cursor = "SizeWE"
        }
        else{
            `$$NewPartitionName.Cursor = "Hand"
        }    
    })
"@
    
    Invoke-Expression $PSCommand  

    If ($PartitionType -eq 'ID76'){
        Add-AmigaDisktoID76Partition -ID76PartitionName $NewPartitionName
        Set-DiskCoordinates -prefix 'WPF_UI_DiskPartition_' -PartitionPrefix 'Partition_' -PartitionType 'Amiga' -AmigaDisk ((Get-Variable -name ($NewPartitionName+'_AmigaDisk')).value)
    }
    
    $Script:WPF_UI_DiskPartition_Disk_MBR.NumberofPartitionsTotal += 1
    return $true
}


