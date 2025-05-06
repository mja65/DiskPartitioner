function New-GUIDisk {
    param (
    $DiskType
    )

    if (-not ($DiskType)){
        Write-Host "Error in coding - New-GUIDisk!"
        $WPF_MainWindow.Close()
        exit
    } 

    $NewDisk_Grid = New-Object System.Windows.Controls.Grid

    $NewDisk = New-Object System.Windows.Shapes.Rectangle
    $NewDisk.HorizontalAlignment = "Left" 
    $NewDisk.VerticalAlignment = "Top"
    $NewDisk.Height="100" 
    $NewDisk.Stroke="Black"
    $NewDisk.Fill="White"
    $NewDisk.Width="1000"
    
    if ($DiskType -eq 'MBR'){

        $NewDisk_Grid | Add-Member -NotePropertyMembers @{
            CanAddPartition = $null
            DiskType = 'MBR'
            MBROverheadBytes = $Script:Settings.MBROverheadBytes
            GPTOverheadBytes = 0
            NumberofPartitionsMBR = 0
            NumberofPartitionsGPT = 0
            NextPartitionMBRNumber = 1
            NextPartitionGPTNumber = 1
        }
    }

    elseif ($DiskType -eq 'Amiga'){
        $NewDisk_Grid | Add-Member -NotePropertyMembers @{
            CanAddPartition = $null
            RDBOverheadBytes = 16*63*512*2
            DiskType = 'Amiga'
            ID76PartitionParent = $null
            NextPartitionNumber = 1
        }

    }
    elseif ($DiskType -eq 'GPT'){
        # NOT BUILT!
    }
    
    $NewDisk_Grid | Add-Member -NotePropertyMembers @{
        DiskSizeBytes = 0
        DiskSizeAmigatoGPTMBROverhead = 0
        DiskSizePixels = 0
        BytestoPixelFactor = 0
        LeftDiskBoundary = $null
        RightDiskBoundary = $null
    }
    
    $NewDisk_Grid.AddChild($NewDisk)
    
    return $NewDisk_Grid

}
