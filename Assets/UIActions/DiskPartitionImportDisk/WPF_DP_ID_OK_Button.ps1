$WPF_DP_ID_OK_Button.Add_Click({
    
    if ($Script:GUICurrentStatus.ImportedImagePath){
        $PathtoPartition = $Script:GUICurrentStatus.ImportedImagePath

    }
    elseif ($Script:GUICurrentStatus.SelectedPhysicalDiskforImport){
        $PathtoPartition = $Script:GUICurrentStatus.SelectedPhysicalDiskforImport
    }

    if ($Script:GUICurrentStatus.ImportedPartitionType -eq 'MBR'){
        if ($WPF_DP_ID_MBR_DataGrid.SelectedItem){
            $PartitionNumber = $WPF_DP_ID_MBR_DataGrid.SelectedItem.PartitionNumber
            $PathforImport = "$PathtoPartition\MBR\$PartitionNumber" 

            $PartitionType = 'MBR'
            if ($WPF_DP_ID_MBR_DataGrid.SelectedItem.PartitionType -eq 'Amiga MBR Partition'){
                $PartitionSubType = 'ID76'
            }
            elseif ($WPF_DP_ID_MBR_DataGrid.SelectedItem.PartitionType -eq 'FAT32 Partition'){
                $PartitionSubType = 'FAT32'                
            }
            $PartitionName = "WPF_DP_Partition_MBR_$($WPF_DP_Disk_GPTMBR.NextPartitionMBRNumber)"
            $TotalPartitionSizeBytes = $WPF_DP_ID_MBR_DataGrid.SelectedItem.SizeBytes

            write-debug $PathforImport            
        } 
    }
    elseif ($Script:GUICurrentStatus.ImportedPartitionType -eq 'RDB'){
        $PathforImport = "$PathtoPartition\MBR\$PartitionNumber\RDB" 
        $PartitionType = 'MBR'
        $PartitionSubType = 'ID76'
        $PartitionName = "WPF_DP_Partition_MBR_$($WPF_DP_Disk_GPTMBR.NextPartitionMBRNumber)"
        
        $TotalPartitionSizeBytes = ($Script:GUICurrentStatus.RDBPartitionstoImportDataTable | Measure-Object -Property SizeBytes -Sum).Sum

        write-debug $PathforImport            

    }
    
    if (-not ($PathforImport)){
        $null = Show-WarningorError -Msg_Header'No Action' -Msg_Body 'You have not performed an action. Either cancel or select a partition for import' -BoxTypeError -ButtonType_OK
        return
    } 

    if (($Script:GUICurrentStatus.AvailableSpaceforImportedMBRGPTPartitionBytes - $TotalPartitionSizeBytes) -lt 0){
        Show-WarningorError -Msg_Header 'Insufficient Space' -Msg_Body 'You have insufficient space to import the partition! Either cancel or select a smaller partition' -BoxTypeError -ButtonType_OK
        return
    }

    if ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'At end of disk'){
        $AddType = 'AtEnd'        
    }
    elseif ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'Left of selected partition'){
        $AddType = 'Left'   
    }
    elseif ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'Right of selected partition'){
        $AddType = 'Right'   
    }

    if ($Script:GUICurrentStatus.ImportedPartitionType -eq 'MBR'){
        Add-GUIPartitiontoGPTMBRDisk -ImportedPartitionMethod 'Direct' -PathtoImportedPartition $PathforImport -PartitionType $PartitionType -PartitionSubType $PartitionSubType -SizeBytes $TotalPartitionSizeBytes -AddType $AddType -ImportedPartition
        if ($PartitionSubType -eq 'ID76'){
            Add-AmigaDisktoID76Partition -ID76PartitionName $PartitionName -ImportedDisk
            $Script:GUICurrentStatus.RDBPartitionstoImportDataTable |ForEach-Object {
                $StartPoint_MaxTransfer = 0
                $Length_MaxTransfer = $_.MaxTransfer.IndexOf(' ')
                $MaxTransfer = $_.MaxTransfer.Substring($StartPoint_MaxTransfer,$Length_MaxTransfer )
                
                $StartPoint_DosType = $_.DosType.IndexOf('(')+1
                $Length_DosType  = ($_.DosType.Length-1)-$StartPoint_DosType
                $DosType = $_.DosType.Substring($StartPoint_DosType,$Length_DosType)

                $StartPoint_Mask = 0
                $Length_Mask  = $_.Mask.IndexOf(' ')
                $Mask  = $_.Mask.Substring($StartPoint_Mask,$Length_Mask)                
            

              

                Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($PartitionName+'_AmigaDisk') -SizeBytes $_.SizeBytes -AddType 'AtEnd' -ImportedPartition -ImportedPartitionMethod 'Derived'  -VolumeName $_.VolumeName -DeviceName $_.DeviceName -Buffers $_.Buffers -DosType $DosType -MaxTransfer $MaxTransfer -Bootable $_.Bootable -NoMount $_.NoMount -Priority $_.Priority -Mask $mask
            }          
        }
    }
    elseif ($Script:GUICurrentStatus.ImportedPartitionType -eq 'RDB'){
        Add-GUIPartitiontoGPTMBRDisk -ImportedPartitionMethod 'Derived' -PathtoImportedPartition $PathforImport -PartitionType $PartitionType -PartitionSubType $PartitionSubType -SizeBytes $TotalPartitionSizeBytes -AddType $AddType -ImportedPartition
        Add-AmigaDisktoID76Partition -ID76PartitionName $PartitionName -ImportedDisk
        $Script:GUICurrentStatus.RDBPartitionstoImportDataTable |ForEach-Object {
            $StartPoint_MaxTransfer = 0
            $Length_MaxTransfer = $_.MaxTransfer.IndexOf(' ')
            $MaxTransfer = $_.MaxTransfer.Substring($StartPoint_MaxTransfer,$Length_MaxTransfer )
            
            $StartPoint_DosType = $_.DosType.IndexOf('(')+1
            $Length_DosType  = ($_.DosType.Length-1)-$StartPoint_DosType
            $DosType = $_.DosType.Substring($StartPoint_DosType,$Length_DosType)

            $StartPoint_Mask = $_.Mask.IndexOf('(')+1
            $Length_Mask  = $_.Mask.IndexOf(' ')
            $Mask  = $_.Mask.Substring($StartPoint_Mask,$Length_Mask)
        
            Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($PartitionName+'_AmigaDisk') -SizeBytes $_.SizeBytes -AddType 'AtEnd' -ImportedPartition -ImportedPartitionMethod 'Derived'  -VolumeName $_.VolumeName -DeviceName $_.DeviceName -Buffers $_.Buffers -DosType $DosType -MaxTransfer $MaxTransfer -Bootable $_.Bootable -NoMount $_.NoMount -Priority $_.Priority -Mask $mask
        }   
    }

    $Script:GUICurrentStatus.ImportedImagePath = $null
    $Script:GUICurrentStatus.ImportedPartitionType = $null
    $Script:GUICurrentStatus.SelectedPhysicalDiskforImport = $null

    $WPF_SelectDiskWindow.Close()
})
