$WPF_SD_BrowseforImage_Button.add_click({
    $Script:GUIActions.ImportedImagePath = Get-ImagePath
    if($Script:GUIActions.ImportedImagePath){
        if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartition'){
            $WPF_SD_MBR_DataGrid.ItemsSource = Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.ImportedImagePath
        }
        elseif ($Script:GUIActions.ActionToPerform -eq 'ImportRDBPartition'){
            if ($WPF_SD_PiStormvsAmiga_Dropdown.SelectedItem  -eq 'PiStorm Disk/Image'){
                $WPF_SD_MBR_DataGrid.ItemsSource = Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.ImportedImagePath
                $WPF_SD_MBR_DataGrid.Visibility = 'Visible'        
                $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.ImportedImagePath -PiStormDiskorImage
            }
            elseif ($WPF_SD_PiStormvsAmiga_Dropdown.SelectedItem  -eq 'Native Amiga Disk/Image') {
                $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.ImportedImagePath -AmigaNativeDiskorImage
            }
            $TabletoPopulate = [System.Collections.Generic.List[PSCustomObject]]::New()

            $Script:RDBPartitionTable | ForEach-Object {
                $TabletoPopulate += $_                
            }
    
            if ($TabletoPopulate){
                $WPF_SD_RDB_DataGrid.ItemsSource = $TabletoPopulate
            }
            $WPF_SD_RDB_DataGrid.Visibility = 'Visible'
        }
    }
})

