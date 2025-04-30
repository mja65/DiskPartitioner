function Get-MBRandRDBPartitionsforSelection  {
    param (
        [switch]$Image,
        [switch]$PhysicalDisk
    )
    
    if ($Image){
        $Script:GUICurrentStatus.ImportedPartitionType = Confirm-IsMDBRorRDB -Path $Script:GUICurrentStatus.ImportedImagePath -Image

    }
    elseif ($PhysicalDisk){
        $Script:GUICurrentStatus.ImportedPartitionType = Confirm-IsMDBRorRDB -Path $Script:GUICurrentStatus.ImportedImagePath -PhysicalDisk
    }

    if ($Script:GUICurrentStatus.ImportedPartitionType -eq 'MBR'){
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
                    $NewRow.SizeBytes = $_.SizeCalculated
                    $NewRow.StartOffset = $_.StartOffset
                    $NewRow.EndOffset = $_.EndOffset
                    $NewRow.Buffers = $_.Buffers
                    $NewRow.DosType = $_.DosType
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
        
        $WPF_DP_ID_Grid_RDB.Margin = [System.Windows.Thickness]"0,250,0,0"

        $WPF_DP_ID_TypeofPartition_Label.Text = 'Select MBR Partition to Import. If 0x76 Partition is selected, all RDB partitions will be imported'
        $WPF_DP_ID_TypeofPartition_Label.Visibility = 'Visible'
        $WPF_DP_ID_SourceofPartition_Label.Visibility = 'Visible'
        $WPF_DP_ID_SourceofPartition_Value.Visibility = 'Visible'
        $WPF_DP_ID_SourceofPartition_Value.Text = "Image `($($Script:GUICurrentStatus.ImportedImagePath)`)"
           
        $WPF_DP_ID_MBR_DataGrid.ItemsSource = $Script:GUICurrentStatus.MBRPartitionstoImportDataTable.DefaultView 

    }

    elseif ($Script:GUICurrentStatus.ImportedPartitionType -eq 'RDB'){
   
        $WPF_DP_ID_Grid_MBR.Visibility = "Hidden"
        $WPF_DP_ID_Grid_RDB.Visibility = "Visible"
        $WPF_DP_ID_RDB_DataGrid.Visibility = 'Visible'
        $WPF_DP_ID_RDB_DataGrid.IsHitTestVisible = 'TRUE'
        
        $WPF_DP_ID_Grid_RDB.Margin = [System.Windows.Thickness]"0,120,0,0"

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
            $NewRow.SizeBytes = $_.SizeCalculated
            $NewRow.StartOffset = $_.StartOffset
            $NewRow.EndOffset = $_.EndOffset
            $NewRow.Buffers = $_.Buffers
            $NewRow.DosType = $_.DosType
            $NewRow.MaxTransfer = $_.MaxTransfer
            $NewRow.Bootable = $_.Bootable
            $NewRow.NoMount = $_.NoMount
            $NewRow.Priority = $_.Priority
            $Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Rows.Add($NewRow)
        }

        $WPF_DP_ID_RDB_DataGrid.ItemsSource = $Script:GUICurrentStatus.RDBPartitionstoImportDataTable.DefaultView                                 

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