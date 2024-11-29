$WPF_SD_MBR_DataGrid.add_selectionChanged({
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
                
        $WPF_SD_FreeSpaceRemaining_Value.Text = "$((Get-ConvertedSize -Size ($Script:GUIActions.AvailableSpaceforImportedPartitionBytes - $WPF_SD_MBR_DataGrid.SelectedItem.TotalBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Size) $((Get-ConvertedSize -Size ($Script:GUIActions.AvailableSpaceforImportedPartitionBytes - $WPF_SD_MBR_DataGrid.SelectedItem.TotalBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Scale)" 

    }
    else {
        $WPF_SD_RDB_DataGrid.Visibility = 'Hidden'
    }
})
