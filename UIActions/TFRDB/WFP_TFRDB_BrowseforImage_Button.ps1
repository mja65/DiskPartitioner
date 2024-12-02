$WPF_TFRDB_BrowseforImage_Button.add_click({
    $Script:GUIActions.ImportedImagePath = Get-ImagePath

    $MBRDatatoPopulate = (Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.ImportedImagePath) 
    if ($MBRDatatoPopulate -eq 'NotMBR'){
        $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.ImportedImagePath -AmigaNativeDiskorImage
    }
    else {
        $WPF_TFRDB_MBR_DataGrid.ItemsSource = $MBRDatatoPopulate
        $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.ImportedImagePath -PiStormDiskorImage
        $WPF_TFRDB_MBR_DataGrid.Visibility = 'Visible'   

    }
    $TabletoPopulate = [System.Collections.Generic.List[PSCustomObject]]::New()

    $Script:RDBPartitionTable | ForEach-Object {
        $TabletoPopulate += $_                
    }

    if ($TabletoPopulate){
        $WPF_TFRDB_RDB_DataGrid.ItemsSource = $TabletoPopulate
    }
    $WPF_TFRDB_RDB_DataGrid.Visibility = 'Visible'
})
    # if($Script:GUIActions.ImportedImagePath){
    #     if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartition'){
    #         $WPF_TFRDB_MBR_DataGrid.ItemsSource = Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.ImportedImagePath
    #     }
    #     elseif ($Script:GUIActions.ActionToPerform -eq 'ImportRDBPartition'){
    #         if ($WPF_TFRDB_PiStormvsAmiga_Dropdown.SelectedItem  -eq 'PiStorm Disk/Image'){
    #             $WPF_TFRDB_MBR_DataGrid.ItemsSource = Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.ImportedImagePath
    #             $WPF_TFRDB_MBR_DataGrid.Visibility = 'Visible'        
    #             $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.ImportedImagePath -PiStormDiskorImage
    #         }
    #         elseif ($WPF_TFRDB_PiStormvsAmiga_Dropdown.SelectedItem  -eq 'Native Amiga Disk/Image') {
    #             $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.ImportedImagePath -AmigaNativeDiskorImage
    #         }
 