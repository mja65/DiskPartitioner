$WPF_SD_OK_Button.Add_Click({
    if ($Script:GUIActions.ActionToPerform -eq 'ImportRDBPartition'){
        if ($WPF_SD_RDB_DataGrid.SelectedItem){
            Write-host "Importing RDB Partition"
            
            Add-GUIPartitiontoAmigaDisk -AmigaDiskName "$($Script:GUIActions.SelectedMBRPartition)_AmigaDisk" -SizeBytes $WPF_SD_RDB_DataGrid.SelectedItem.TotalBytes -AddType 'AtEnd' -ImportedPartition $true PathtoImportedPartition "$($Script:GUIActions.SelectedPhysicalDisk)\mbr\$($WPF_SD_MBR_DataGrid.SelectedItem.Number)\rdb\$($WPF_SD_RDB_DataGrid.SelectedItem.Number)" 
            
        }
    }
    elseif ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartition'){
        if ($WPF_SD_MBR_DataGrid.SelectedItem){
            if ($WPF_SD_MBR_DataGrid.SelectedItem.Type -match 'PiStorm RDB'){
                $PartitionType = 'ID76'
            }
            elseif ($WPF_SD_MBR_DataGrid.SelectedItem.Type -match 'FAT32'){
                $PartitionType = 'FAT32'
            }

            $PartitionName = "WPF_DP_Partition_ID76_$($WPF_DP_Disk_MBR.NextPartitionID76Number)" 
            Add-GUIPartitiontoMBRDisk -PathtoImportedPartition "$($Script:GUIActions.SelectedPhysicalDisk)\mbr\$($WPF_SD_MBR_DataGrid.SelectedItem.Number)" -PartitionType $PartitionType -SizeBytes $WPF_SD_MBR_DataGrid.SelectedItem.TotalBytes -AddType 'AtEnd' -ImportedPartition $true
            $ListofRDBPartitions = Get-HSTPartitionInfo -Path "$($Script:GUIActions.SelectedPhysicalDisk)\mbr\$($WPF_SD_MBR_DataGrid.SelectedItem.Number)" -RDBInfo
            Add-AmigaDisktoID76Partition -ID76PartitionName $PartitionName
            $ListofRDBPartitions |ForEach-Object {
                Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($PartitionName+'_AmigaDisk') -SizeBytes $_.TotalBytes -AddType 'AtEnd' -ImportedPartition $true -DerivedImportedPartition $true
            }
        }
    }
    $WPF_SelectDiskWindow.Close()
})

