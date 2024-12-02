$WPF_TFRDB_MBR_DataGrid.add_selectionChanged({
    if ($WPF_TFRDB_MBR_DataGrid.SelectedItem){
        $WPF_TFRDB_RDB_DataGrid.Visibility = 'Visible'

        $TabletoPopulate = [System.Collections.Generic.List[PSCustomObject]]::New()

        $Script:RDBPartitionTable | ForEach-Object {
            if ($_.MBRNumber -eq $WPF_TFRDB_MBR_DataGrid.SelectedItem.Number){
                $TabletoPopulate += $_
            }
        }

        if ($TabletoPopulate){
            $WPF_TFRDB_RDB_DataGrid.ItemsSource = $TabletoPopulate
        }     
                
    }
    else {
        $WPF_TFRDB_RDB_DataGrid.Visibility = 'Hidden'
    }
})
