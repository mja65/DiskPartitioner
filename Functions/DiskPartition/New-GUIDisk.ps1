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
    $NewDisk.Width="900"
    
    if ($DiskType -eq 'MBR'){

        $NewDisk_Grid | Add-Member -NotePropertyMembers @{
            DiskType = 'MBR'
            NumberofPartitionsFAT32 = 0
            NumberofPartitionsID76 = 0
            NextPartitionFAT32Number = 1
            NextPartitionID76Number = 1
        }
    }
    
    if ($DiskType -eq 'Amiga'){
        $NewDisk_Grid | Add-Member -NotePropertyMembers @{
            DiskType = 'Amiga'
            ID76PartitionParent = $null
            NextPartitionNumber = 1
        }

    }
    $NewDisk_Grid | Add-Member -NotePropertyMembers @{
        NumberofPartitionsTotal = 0
        DiskSizeBytes = 0
        DiskSizePixels = 0
        BytestoPixelFactor = 0
        LeftDiskBoundary = $null
        RightDiskBoundary = $null
    }
    
    $NewDisk_Grid.AddChild($NewDisk)
    
    return $NewDisk_Grid

}
