$WPF_SD_BrowseforImage_Button.add_click({
    $Script:GUIActions.ImportedImagePath = Get-ImagePath
    if($Script:GUIActions.ImportedImagePath){
        if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartition'){
            $WPF_SD_MBR_DataGrid.ItemsSource = Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.ImportedImagePath
            $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.ImportedImagePath -PiStormDiskorImage
        }
        
        $TabletoPopulate = [System.Collections.Generic.List[PSCustomObject]]::New()

        $Script:RDBPartitionTable | ForEach-Object {
            $TabletoPopulate += $_                
        }

        if ($TabletoPopulate){
            $WPF_SD_RDB_DataGrid.ItemsSource = $TabletoPopulate
        }
        #$WPF_SD_RDB_DataGrid.Visibility = 'Visible'
          
    }
})

