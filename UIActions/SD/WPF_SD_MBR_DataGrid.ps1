$WPF_SD_MBR_DataGrid.add_selectionChanged({
    if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionFromMBRDisk' -or $Script:GUIActions.ActionToPerform -eq 'ImportMBRPartitionFromMBRImage'){
        if ($WPF_SD_MBR_DataGrid.SelectedItem){           
                if ($WPF_SD_MBR_DataGrid.SelectedItem.Type -eq 'ID 0x76 (Pistorm)'){
                    $WPF_SD_RDB_DataGrid.Visibility = 'Visible'
                    $TabletoPopulate = [System.Collections.Generic.List[PSCustomObject]]::New()
                    $Script:RDBPartitionTable | ForEach-Object {
                        if ($_.MBRNumber -eq $WPF_SD_MBR_DataGrid.SelectedItem.Number){
                            $TabletoPopulate += $_
                        }
                    }
            
                    if ($TabletoPopulate){
                        $WPF_SD_RDB_DataGrid.ItemsSource = $TabletoPopulate
                        for ($i = 0; $i -lt $WPF_SD_RDB_DataGrid.Columns.Count; $i++) {
                            if ($WPF_SD_RDB_DataGrid.Columns[$i].Header -eq 'TotalBytes'){
                                $WPF_SD_RDB_DataGrid.Columns[$i].Visibility = 'Hidden'
                            }
                            if ($WPF_SD_RDB_DataGrid.Columns[$i].Header -eq 'MBRNumber'){
                                $WPF_SD_RDB_DataGrid.Columns[$i].Visibility = 'Hidden'
                            }
                        }
                    }
                    else {
                        $WPF_SD_RDB_DataGrid.Visibility = 'Hidden'
                    }
                }
    
                else {
                    #Write-host 'Hiding RDB1'
                    $WPF_SD_RDB_DataGrid.Visibility = 'Hidden'
                }
    
            }
            else {
                #Write-host 'Hiding RDB2'
                $WPF_SD_RDB_DataGrid.Visibility = 'Hidden'
            }
        }               
        
        $FreeSpaceRemaining = "$((Get-ConvertedSize -Size ($Script:GUIActions.AvailableSpaceforImportedPartitionBytes - $WPF_SD_MBR_DataGrid.SelectedItem.TotalBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Size) $((Get-ConvertedSize -Size ($Script:GUIActions.AvailableSpaceforImportedPartitionBytes - $WPF_SD_MBR_DataGrid.SelectedItem.TotalBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Scale)" 
        if ($FreeSpaceRemaining -lt 0){
            $WPF_SD_FreeSpaceRemaining_Value.Background = 'Red'        
        }
        else {
            $WPF_SD_FreeSpaceRemaining_Value.Background = 'Transparent'
        }
        $WPF_SD_FreeSpaceRemaining_Value.Text = $FreeSpaceRemaining        
})

