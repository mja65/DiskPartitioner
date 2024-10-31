function Add-AmigaPartitiontoDisk {
    param (
        $DiskName,
        $SizePixels,
        $AddType,
        $DefaultPartition
    )
    
    # $DiskName = 'WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk'
    # $SizePixels = 100


    if ($AddType -eq 'Initial'){
        $LeftMargin = (Get-GUIPartitionStartEnd -PartitionType 'Amiga' -Prefix $DiskName).EndingPosition
    }

    $PartitionNumber = (Get-Variable -Name $DiskName).Value.NextPartitionNumber

    $NewPartitionName = ($DiskName+'_Partition_'+$PartitionNumber)

    Set-Variable -name $NewPartitionName -Scope script -value (New-GUIPartition -DefaultPartition $DefaultPartition -PartitionType 'Amiga' -SizePixels $SizePixels -LeftMargin $LeftMargin -TopMargin 0 -RightMargin 0 -BottomMargin 0)

    (Get-Variable -Name $DiskName).Value.AddChild(((Get-Variable -name $NewPartitionName).value))

    (Get-Variable -Name $DiskName).Value.NextPartitionNumber += 1

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
        if(Get-IsResizeZoneGUIPartition -ObjectName `$Script:GUIActions.SelectedAmigaPartition -MouseX ((Get-MouseCoordinatesRelativetoWindow -Window `$WPF_UI_DiskPartition_Window -Disk `$WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk  -Grid `$WPF_UI_DiskPartition_PartitionGrid_Amiga).MousePositionRelativetoWindowX)){
            `$$NewPartitionName.Cursor = "SizeWE"
        }
        else{
            `$$NewPartitionName.Cursor = "Hand"
        }
    })

"@
    Invoke-Expression $PSCommand

}


