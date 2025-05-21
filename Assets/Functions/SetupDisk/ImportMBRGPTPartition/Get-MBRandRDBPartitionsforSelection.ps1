function Get-MBRandRDBPartitionsforSelection  {
    param (
        [switch]$Image,
        [switch]$PhysicalDisk
    )
     
    # $Image = $true
    # $Script:GUICurrentStatus.ImportedImagePath = "C:\Users\Matt\OneDrive\Documents\DiskPartitioner\Emu68Workbench3.1.img"
    
    if ($Image){
        $Script:GUICurrentStatus.ImportedPartitionType = Confirm-IsMDBRorRDB -Path $Script:GUICurrentStatus.ImportedImagePath -Image
        $WPF_DP_ID_SourceofPartition_Value.Text = "Image `($($Script:GUICurrentStatus.ImportedImagePath)`)"
    }
    elseif ($PhysicalDisk){
        $Script:GUICurrentStatus.ImportedPartitionType = Confirm-IsMDBRorRDB -Path $Script:GUICurrentStatus.ImportedImagePath -PhysicalDisk
        $WPF_DP_ID_SourceofPartition_Value.Text = "Disk"        
    }

    $WPF_DP_ID_ImportText_Label.Visibility = 'Visible'
    $WPF_DP_ID_SourceofPartition_Label.Visibility = 'Visible'
    $WPF_DP_ID_SourceofPartition_Value.Visibility = 'Visible'
    $WPF_DP_ID_TypeofPartition_Value.Visibility = 'Visible'
     $WPF_DP_ID_TypeofPartition_Label.Visibility = 'Visible'
      
    if ($Script:GUICurrentStatus.ImportedPartitionType -eq 'MBR'){
        
        $WPF_DP_ID_TypeofPartition_Value.Text = "MBR Disk"
        $WPF_DP_ID_ImportText_Label.Text = 'Select MBR 0x76 Partition (PiStorm) to Import. Press OK to import disk or cancel'
        $WPF_DP_ID_ImportText_Label.Foreground = "#FF000000"

        $Script:GUICurrentStatus.MBRPartitionstoImportDataTable.Clear()

        if ($Image){
            $MBRPartitions = Get-HSTPartitionInfoMBR -Image -Path $Script:GUICurrentStatus.ImportedImagePath 

        }
        elseif ($PhysicalDisk){
            $MBRPartitions = Get-HSTPartitionInfoMBR -PhysicalDisk -Path $Script:GUICurrentStatus.SelectedPhysicalDiskforImport
        }

        $MBRPartitions | ForEach-Object {
            $SizetoUse = Get-ConvertedSize -Size $_.Sizebytes -AutoScale -ScaleFrom B -NumberofDecimalPlaces 2
            $NewRow = $Script:GUICurrentStatus.MBRPartitionstoImportDataTable.NewRow()
            $NewRow.PartitionNumber  = $_.PartitionNumber
            $NewRow.PartitionType = $_.PartitionTypeFriendlyName
            $NewRow.Size = "$($SizetoUse.Size) $($SizetoUse.Scale)"
            $NewRow.SizeBytes = $_.Sizebytes
            $Script:GUICurrentStatus.MBRPartitionstoImportDataTable.Rows.Add($NewRow)
        } 

        $Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Clear()
        foreach ($MBRPartition in $Script:GUICurrentStatus.MBRPartitionstoImportDataTable) {
            if ($MBRPartition.PartitionType -eq 'Amiga MBR Partition'){
                if ($Image){
                    $PathtoUse = $Script:GUICurrentStatus.ImportedImagePath
    
                }
                elseif ($PhysicalDisk){
                    $PathtoUse =  $Script:GUICurrentStatus.SelectedPhysicalDiskforImport
                }
                Get-HSTPartitionInfoRDB -Path $PathtoUse -MBRPartitionNumber $MBRPartition.PartitionNumber | ForEach-Object { 
                    $SizetoUse = Get-ConvertedSize -Size $_.SizeCalculated -AutoScale -ScaleFrom B -NumberofDecimalPlaces 2
                    $NewRow = $Script:GUICurrentStatus.RDBPartitionstoImportDataTable.NewRow()
                    $NewRow.MBRPartitionNumber =  $MBRPartition.PartitionNumber
                    $NewRow.DeviceName = $_.DeviceName
                    $NewRow.VolumeName = $_.VolumeName
                    $NewRow.LowCylinder = $_.LowCylinder
                    $NewRow.HighCylinder = $_.HighCylinder
                    $NewRow.Size = "$($SizetoUse.Size) $($SizetoUse.Scale)"
                    $NewRow.SizeBytes = [int64]$_.SizeCalculated
                   $NewRow.StartOffset = [int64]$_.StartOffset
                   $NewRow.EndOffset = [int64]$_.EndOffset
                   $NewRow.Buffers = $_.Buffers
                   $NewRow.DosType = $_.DosType
                   $NewRow.Mask = $_.Mask
                   $NewRow.MaxTransfer = $_.MaxTransfer
                   $NewRow.Bootable = $_.Bootable
                   $NewRow.NoMount = $_.NoMount
                   $NewRow.Priority = $_.Priority                    
                   $Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Rows.Add($NewRow)
                }
            }
        }

        $WPF_DP_ID_MBR_DataGrid.Visibility = 'Visible'
        $WPF_DP_ID_RDB_DataGrid.Visibility = 'Hidden'
        $WPF_DP_ID_RDB_DataGrid.IsHitTestVisible = ''
        
        #$WPF_DP_ID_Grid_RDB.Margin = [System.Windows.Thickness]"0,250,0,0"
          
        $WPF_DP_ID_MBR_DataGrid.ItemsSource = $Script:GUICurrentStatus.MBRPartitionstoImportDataTable.DefaultView 

    }

    elseif ($Script:GUICurrentStatus.ImportedPartitionType -eq 'RDB'){

        $WPF_DP_ID_TypeofPartition_Value.Text = "Amiga Disk"
        $WPF_DP_ID_ImportText_Label.Text = 'Amiga Disk partitions shown below. It is not possible to import individual partitions so importing will import ALL Amiga partitions on the disk. Press OK to import disk or cancel'
        $WPF_DP_ID_ImportText_Label.Foreground = "#FF000000"

        $Script:GUICurrentStatus.MBRPartitionstoImportDataTable.Clear()
        
        $WPF_DP_ID_MBR_DataGrid.Visibility = 'Hidden'
        $WPF_DP_ID_RDB_DataGrid.Visibility = 'Visible'
        
        $WPF_DP_ID_RDB_DataGrid.IsHitTestVisible = ''
        
        #$WPF_DP_ID_Grid_RDB.Margin = [System.Windows.Thickness]"0,120,0,0"

        if ($Image){
            $PathtoUse = $Script:GUICurrentStatus.ImportedImagePath

        }
        elseif ($PhysicalDisk){
            $PathtoUse =  $Script:GUICurrentStatus.SelectedPhysicalDiskforImport
        }                

        $Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Clear()
        Get-HSTPartitionInfoRDB -Path $PathtoUse | ForEach-Object {
            $SizetoUse = Get-ConvertedSize -Size $_.SizeCalculated -AutoScale -ScaleFrom B -NumberofDecimalPlaces 2
            $NewRow = $Script:GUICurrentStatus.RDBPartitionstoImportDataTable.NewRow()
            $NewRow.MBRPartitionNumber =  '0'
            $NewRow.DeviceName = $_.DeviceName
            $NewRow.VolumeName = $_.VolumeName
            $NewRow.LowCylinder = $_.LowCylinder
            $NewRow.HighCylinder = $_.HighCylinder
            $NewRow.Size = "$($SizetoUse.Size) $($SizetoUse.Scale)"
            $NewRow.SizeBytes = [int64]$_.SizeCalculated
            $NewRow.StartOffset = [int64]$_.StartOffset
            $NewRow.EndOffset = [int64]$_.EndOffset
            $NewRow.Buffers = $_.Buffers
            $NewRow.DosType = $_.DosType
            $NewRow.Mask = $_.Mask
            $NewRow.MaxTransfer = $_.MaxTransfer
            $NewRow.Bootable = $_.Bootable
            $NewRow.NoMount = $_.NoMount
            $NewRow.Priority = $_.Priority
            $Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Rows.Add($NewRow)
        }

        $WPF_DP_ID_RDB_DataGrid.ItemsSource = $Script:GUICurrentStatus.RDBPartitionstoImportDataTable.DefaultView       
        
        $SpaceforImport = ((Get-AmigaNearestSizeBytes -SizeBytes (($Script:GUICurrentStatus.RDBPartitionstoImportDataTable | Measure-Object -Property SizeBytes -Sum).Sum) -RoundUp )+(Get-AmigaRDBOverheadBytes)) 

        $FreeSpaceRemaining = (Get-ConvertedSize -Size ($Script:GUICurrentStatus.AvailableSpaceforImportedMBRGPTPartitionBytes - $SpaceforImport) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)       
        
        if ($FreeSpaceRemaining.Size -lt 0){
            $WPF_DP_ID_FreeSpaceRemaining_Value.Background = 'Red'        
        }
        else {
            $WPF_DP_ID_FreeSpaceRemaining_Value.Background = 'Transparent'
        }
        $WPF_DP_ID_FreeSpaceRemaining_Value.Text = "$($FreeSpaceRemaining.size)$($FreeSpaceRemaining.scale)"      
    }  

    else {
        if ($Image){
            $MsgHeader = 'Invalid Image' 
            $MsgBody = 'The file you have selected is not recognised as either a MBR or an Amiga image!'

        }
        
        elseif ($PhysicalDisk){
            $MsgHeader = 'Invalid Disk' 
            $MsgBody = 'The disk you have selected is not recognised as either  MBR or Amiga!'
        }
        $null = Show-WarningorError -Msg_Header $MsgHeader -Msg_Body $MsgBody -BoxTypeError -ButtonType_OK
        $Script:GUICurrentStatus.ImportedImagePath = $null
        $Script:GUICurrentStatus.SelectedPhysicalDiskforImport = $null
        return
    }
      
}