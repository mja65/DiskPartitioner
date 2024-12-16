$WPF_SD_BrowseforDisk_DropDown.add_selectionChanged({
    $Script:GUIActions.ImportedImagePath = $null
    $Script:GUIActions.ListofRemovableMedia | ForEach-Object{
        if ($WPF_SD_BrowseforDisk_DropDown.SelectedItem -eq $_.FriendlyName){
            $Script:GUIActions.SelectedPhysicalDiskforImport = $_.HSTDiskName
            $Script:GUIActions.ActionToPerform = 'ImportMBRPartitionFromMBRDisk'
            $WPF_SD_TypeofPartition_Label.Text = 'Select MBR Partition to Import. If 0x76 Partition is selected, all RDB partitions will be imported'
            $WPF_SD_TypeofPartition_Label.Visibility = 'Visible'
            $WPF_SD_SourceofPartition_Label.Visibility = 'Visible'
            $WPF_SD_SourceofPartition_Value.Visibility = 'Visible'
            $WPF_SD_SourceofPartition_Value.Text = "Disk `($($Script:GUIActions.SelectedPhysicalDiskforImport)`)"
            $WPF_SD_MBR_DataGrid.ItemsSource = Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.SelectedPhysicalDiskforImport
            for ($i = 0; $i -lt $WPF_SD_MBR_DataGrid.Columns.Count; $i++) {
                if ($WPF_SD_MBR_DataGrid.Columns[$i].Header -eq 'TotalBytes'){
                    $WPF_SD_MBR_DataGrid.Columns[$i].Visibility = 'Hidden'
                }
            }

            $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.SelectedPhysicalDiskforImport -PiStormDiskorImage
            
            $TabletoPopulate = [System.Collections.Generic.List[PSCustomObject]]::New()

            $Script:RDBPartitionTable | ForEach-Object {
                $TabletoPopulate += $_                
            }
    
            if ($TabletoPopulate){
                $WPF_SD_RDB_DataGrid.ItemsSource = $TabletoPopulate
                
            }
            
        }
    }
    if ($WPF_SD_BrowseforDisk_DropDown.SelectedItem){
        $WPF_SD_MBR_DataGrid.Visibility = 'Visible'
        #$WPF_SD_RDB_DataGrid.Visibility = 'Visible'        
    } 
    else {
        $WPF_SD_MBR_DataGrid.Visibility = 'Hidden'
        #$WPF_SD_RDB_DataGrid.Visibility = 'Hidden'
    }
})

#if $WPF_SD_PiStormvsAmiga_Dropdown.SelectedItem  -eq 'PiStorm Disk/Image'

