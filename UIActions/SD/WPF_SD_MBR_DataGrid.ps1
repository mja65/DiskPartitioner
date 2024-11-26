$WPF_SD_MBR_DataGrid.add_selectionChanged({
    Write-Host 'Wibble'
    if ($WPF_SD_MBR_DataGrid.SelectedItem){
        if ($Script:GUIActions.ActionToPerform -eq 'ImportRDBPartition'){
            $WPF_SD_RDB_DataGrid.Visibility = 'Visible'
    
            $TabletoPopulate = [System.Collections.Generic.List[PSCustomObject]]::New()
    
            $Script:RDBPartitionTable | ForEach-Object {
                if ($_.MBRNumber -eq $WPF_SD_MBR_DataGrid.SelectedItem.Number){
                    $TabletoPopulate += $_
                }
            }
    
            if ($TabletoPopulate){
                $WPF_SD_RDB_DataGrid.ItemsSource = $TabletoPopulate
            }
        }
    }
    else {
        $WPF_SD_RDB_DataGrid.Visibility = 'Hidden'
    }
})
