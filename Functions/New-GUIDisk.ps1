function New-GUIDisk {
    param (
    $DiskType
    )

    $NewDisk_Grid = New-Object System.Windows.Controls.Grid

    $NewDisk = New-Object System.Windows.Shapes.Rectangle
    $NewDisk.HorizontalAlignment = "Left" 
    $NewDisk.VerticalAlignment = "Top"
    $NewDisk.Height="100" 
    $NewDisk.Stroke="Black"
    $NewDisk.Fill="White"
    $NewDisk.Width="759"

    if ($DiskType -eq 'MBR'){
        $NewDisk_Grid | Add-Member -NotePropertyName NumberofPartitionsFAT32 -NotePropertyValue 0
        $NewDisk_Grid | Add-Member -NotePropertyName NumberofPartitionsID76 -NotePropertyValue 0
        $NewDisk_Grid | Add-Member -NotePropertyName NextPartitionFAT32Number -NotePropertyValue 1
        $NewDisk_Grid| Add-Member -NotePropertyName NextPartitionID76Number -NotePropertyValue 1
    }
    
    if ($DiskType -eq 'Amiga'){
        $NewDisk_Grid | Add-Member -NotePropertyName ID76PartitionParent -NotePropertyValue $null
        $NewDisk_Grid | Add-Member -NotePropertyName NextPartitionNumber -NotePropertyValue 1
    }

    $NewDisk_Grid | Add-Member -NotePropertyName NumberofPartitionsTotal -NotePropertyValue 0
    $NewDisk_Grid | Add-Member -NotePropertyName DiskSizeBytes -NotePropertyValue $null  

    $NewDisk_Grid.AddChild($NewDisk)
    
    return $NewDisk_Grid

}




