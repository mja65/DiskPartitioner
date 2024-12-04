$WPF_TFRDB_BrowseforImage_Button.add_click({
    $Script:GUIActions.TransferFilesImagePath = Get-ImagePath

    $MBRDatatoPopulate = (Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.TransferFilesImagePath) 
    if ($MBRDatatoPopulate -eq 'NotMBR'){
        $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.TransferFilesImagePath -AmigaNativeDiskorImage
        $Script:GUIActions.TransferAmigaSourceType = 'RDB'
    }
    else {
        $Script:GUIActions.TransferAmigaSourceType = 'MBR'
        $WPF_TFRDB_MBR_DataGrid.ItemsSource = $MBRDatatoPopulate
        $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.TransferFilesImagePath -PiStormDiskorImage
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
