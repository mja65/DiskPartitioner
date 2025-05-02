$WPF_DP_ID_RDB_DataGrid.add_selectionChanged({
    
    if ($WPF_DP_ID_MBR_DataGrid.Visibility = 'Hidden'){
        $FreeSpaceRemaining = (Get-ConvertedSize -Size ($Script:GUICurrentStatus.AvailableSpaceforImportedMBRGPTPartitionBytes - $WPF_DP_ID_RDB_DataGrid.SelectedItem.SizeBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
        if ($FreeSpaceRemaining.Size -lt 0){
            $WPF_DP_ID_FreeSpaceRemaining_Value.Background = 'Red'        
        }
        else {
            $WPF_DP_ID_FreeSpaceRemaining_Value.Background = 'Transparent'
        }
        $WPF_DP_ID_FreeSpaceRemaining_Value.Text = "$($FreeSpaceRemaining.size)$($FreeSpaceRemaining.scale)"      
    }
    
})

$WPF_DP_ID_MBR_DataGrid.add_selectionChanged({

    if ($WPF_DP_ID_MBR_DataGrid.SelectedItem.PartitionType -eq 'Amiga MBR Partition'){
        $WPF_DP_ID_RDB_DataGrid.ItemsSource = $Script:GUICurrentStatus.RDBPartitionstoImportDataTable.DefaultView  | Where-Object {$_.'MBRPartitionNumber' -eq $WPF_DP_ID_MBR_DataGrid.SelectedItem.PartitionNumber}
        $WPF_DP_ID_RDB_DataGrid.Visibility = 'Visible'
    }
    else {
        $WPF_DP_ID_RDB_DataGrid.Visibility = 'Hidden'
    }

        $FreeSpaceRemaining = (Get-ConvertedSize -Size ($Script:GUICurrentStatus.AvailableSpaceforImportedMBRGPTPartitionBytes - $WPF_DP_ID_MBR_DataGrid.SelectedItem.SizeBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
        if ($FreeSpaceRemaining.Size -lt 0){
            $WPF_DP_ID_FreeSpaceRemaining_Value.Background = 'Red'        
        }
        else {
            $WPF_DP_ID_FreeSpaceRemaining_Value.Background = 'Transparent'
        }
        $WPF_DP_ID_FreeSpaceRemaining_Value.Text = "$($FreeSpaceRemaining.size)$($FreeSpaceRemaining.scale)"             
    
    })
    