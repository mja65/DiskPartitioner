function Set-DiskForImport {
    param (

    )
    
    Remove-Variable -Name 'WPF_DP_ID_*'
    $Script:GUICurrentStatus.ImportedPartitionType = $null
    $Script:GUICurrentStatus.SelectedPhysicalDiskforImport = $null
    $Script:GUICurrentStatus.ImportedImagePath = $null 
    $Script:GUICurrentStatus.ProcessImportedPartition = $false
    $WPF_SelectDiskWindow = Get-XAML -WPFPrefix 'WPF_DP_ID_' -XMLFile '.\Assets\WPF\ImportDisk\Window_SelectDiskMBR.xaml' -ActionsPath '.\Assets\UIActions\DiskPartitionImportDisk\' -AddWPFVariables

    if ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'At end of disk'){
        $AddType = 'AtEnd'
    }
    elseif ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'Left of selected partition'){
        $AddType = 'Left'   
    }
    elseif ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'Right of selected partition'){
        $AddType = 'Right'   
    }
        
    $Script:GUICurrentStatus.AvailableSpaceforImportedMBRGPTPartitionBytes = (Get-MBRDiskFreeSpace -Disk $WPF_DP_Disk_GPTMBR -Position $AddType -PartitionNameNextto $Script:GUICurrentStatus.SelectedGPTMBRPartition)

    $WPF_DP_ID_FreeSpace_Value.Text = "$((Get-ConvertedSize -Size $Script:GUICurrentStatus.AvailableSpaceforImportedMBRGPTPartitionBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Size) $((Get-ConvertedSize -Size $Script:GUICurrentStatus.AvailableSpaceforImportedMBRGPTPartitionBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Scale)"
    $WPF_DP_ID_FreeSpaceRemaining_Value.Text = $WPF_DP_ID_FreeSpace_Value.Text

    $WPF_DP_ID_SourceofPartition_Label.Visibility = 'Hidden'
    $WPF_DP_ID_SourceofPartition_Value.Visibility = 'Hidden'
    $WPF_DP_ID_ImportText_Label.Visibility = 'Hidden'
    $WPF_DP_ID_MBR_DataGrid.Visibility = 'Hidden'
    $WPF_DP_ID_RDB_DataGrid.Visibility = 'Hidden'

    $WPF_SelectDiskWindow.ShowDialog() | out-null
    #  $WPF_SelectDiskWindow.Close()
    
    if ($Script:GUICurrentStatus.ProcessImportedPartition -eq $false) {
        return
    }

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
        $PathforImport = "$PathtoPartition" 
        $PartitionType = 'MBR'
        $PartitionSubType = 'ID76'
        $PartitionName = "WPF_DP_Partition_MBR_$($WPF_DP_Disk_GPTMBR.NextPartitionMBRNumber)"
        
        $TotalPartitionSizeBytes = (Get-AmigaNearestSizeBytes -SizeBytes (($Script:GUICurrentStatus.RDBPartitionstoImportDataTable | Measure-Object -Property SizeBytes -Sum).Sum) -RoundUp )+(Get-AmigaRDBOverheadBytes) 
                
        write-debug $PathforImport            
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
            
            $StartPoint_Mask = 0
            $Length_Mask  = $_.Mask.IndexOf(' ')
            $Mask  = $_.Mask.Substring($StartPoint_Mask,$Length_Mask)    
        
            Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($PartitionName+'_AmigaDisk') -SizeBytes $_.SizeBytes -AddType 'AtEnd' -ImportedPartition -ImportedPartitionMethod 'Derived' -VolumeName $_.VolumeName -DeviceName $_.DeviceName -Buffers $_.Buffers -DosType $DosType -MaxTransfer $MaxTransfer -Bootable $_.Bootable -NoMount $_.NoMount -Priority $_.Priority -Mask $mask -ImportedPartitionOffsetBytes $_.StartOffset -ImportedPartitionEndBytes $_.EndOffset
        }   
    }

    $Script:GUICurrentStatus.ImportedImagePath = $null
    $Script:GUICurrentStatus.ImportedPartitionType = $null
    $Script:GUICurrentStatus.SelectedPhysicalDiskforImport = $null
    $Script:GUICurrentStatus.ProcessImportedPartition = $false

}
