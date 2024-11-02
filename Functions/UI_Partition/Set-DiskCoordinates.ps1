function Set-DiskCoordinates {
    param (
        $Prefix,
        $PartitionPrefix,
        $PartitionType,
        $AmigaDisk

    )
    # $Prefix = 'WPF_UI_DiskPartition_'
    # $PartitionPrefix = 'Partition_'

    if ($PartitionType -eq 'MBR'){
        $Script:WPF_UI_DiskPartition_Disk_MBR | Add-Member -force -NotePropertyMembers @{
            LeftDiskBoundary = $null
            RightDiskBoundary = $null
        }
    }
    elseif ($PartitionType -eq 'Amiga'){
        $AmigaDisk | Add-Member -force -NotePropertyMembers @{
            LeftDiskBoundary = $null
            RightDiskBoundary = $null
        }
    }   
   
    if ($PartitionType -eq 'MBR'){
        $Script:WPF_UI_DiskPartition_Disk_MBR.LeftDiskBoundary = 0 
        $Script:WPF_UI_DiskPartition_Disk_MBR.RightDiskBoundary = $LeftDiskBoundary + (Get-Variable -name ($Prefix+'Disk_MBR') -ValueOnly).Children[0].Width
    }
    elseif ($PartitionType -eq 'Amiga'){
        $AmigaDisk.LeftDiskBoundary = 0 
        $AmigaDisk.RightDiskBoundary = $LeftDiskBoundary + $AmigaDisk.Children[0].Width
    }

}

