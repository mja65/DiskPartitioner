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
        $WPF_DP_ID_Grid_RDB.Visibility = "Visible"
        $WPF_DP_ID_RDB_DataGrid.Visibility = 'Visible'
    }
    else {
        $WPF_DP_ID_Grid_RDB.Visibility = "Hidden"
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
    

        

    #$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns

    # $WPF_DP_ID_RDB_DataGrid.ItemsSource | Where-Object {$_.'MBR Partition Number' -eq $WPF_DP_ID_MBR_DataGrid.SelectedItem.'Partition Number'}
    # if ($WPF_DP_ID_MBR_DataGrid.SelectedItem.Type -eq 'ID 0x76 (Pistorm)'){



    # if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionFromMBRDisk' -or $Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionFromMBRImage'){
    #     if ($WPF_DP_ID_MBR_DataGrid.SelectedItem){           
    #             if ($WPF_DP_ID_MBR_DataGrid.SelectedItem.Type -eq 'ID 0x76 (Pistorm)'){
    #                 $WPF_DP_ID_RDB_DataGrid.Visibility = 'Visible'
    #                 $TabletoPopulate = [System.Collections.Generic.List[PSCustomObject]]::New()
    #                 $Script:RDBPartitionTable | ForEach-Object {
    #                     if ($_.MBRNumber -eq $WPF_DP_ID_MBR_DataGrid.SelectedItem.Number){
    #                         $TabletoPopulate += $_
    #                     }
    #                 }
            
    #                 if ($TabletoPopulate){
    #                     $WPF_DP_ID_RDB_DataGrid.ItemsSource = $TabletoPopulate
    #                     for ($i = 0; $i -lt $WPF_DP_ID_RDB_DataGrid.Columns.Count; $i++) {
    #                         if ($WPF_DP_ID_RDB_DataGrid.Columns[$i].Header -eq 'TotalBytes'){
    #                             $WPF_DP_ID_RDB_DataGrid.Columns[$i].Visibility = 'Hidden'
    #                         }
    #                         if ($WPF_DP_ID_RDB_DataGrid.Columns[$i].Header -eq 'MBRNumber'){
    #                             $WPF_DP_ID_RDB_DataGrid.Columns[$i].Visibility = 'Hidden'
    #                         }
    #                     }
    #                 }
    #                 else {
    #                     $WPF_DP_ID_RDB_DataGrid.Visibility = 'Hidden'
    #                 }
    #             }
    
    #             else {
    #                 #Write-host 'Hiding RDB1'
    #                 $WPF_DP_ID_RDB_DataGrid.Visibility = 'Hidden'
    #             }
    
    #         }
    #         else {
    #             #Write-host 'Hiding RDB2'
    #             $WPF_DP_ID_RDB_DataGrid.Visibility = 'Hidden'
    #         }
    #     }               
        
    #     $FreeSpaceRemaining = "$((Get-ConvertedSize -Size ($Script:GUIActions.AvailableSpaceforImportedPartitionBytes - $WPF_DP_ID_MBR_DataGrid.SelectedItem.TotalBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Size) $((Get-ConvertedSize -Size ($Script:GUIActions.AvailableSpaceforImportedPartitionBytes - $WPF_DP_ID_MBR_DataGrid.SelectedItem.TotalBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Scale)" 
    #     if ($FreeSpaceRemaining -lt 0){
    #         $WPF_DP_ID_FreeSpaceRemaining_Value.Background = 'Red'        
    #     }
    #     else {
    #         $WPF_DP_ID_FreeSpaceRemaining_Value.Background = 'Transparent'
    #     }
    #     $WPF_DP_ID_FreeSpaceRemaining_Value.Text = $FreeSpaceRemaining        

