$WPF_SD_MBR_DataGrid.add_selectionChanged({
    if ($WPF_SD_MBR_DataGrid.SelectedItem){           
            if ($WPF_SD_MBR_DataGrid.SelectedItem.Type -match 'PiStorm RDB'){                
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

            else {
                #Write-host 'Hiding RDB1'
                $WPF_SD_RDB_DataGrid.Visibility = 'Hidden'
            }

        }
        else {
            #Write-host 'Hiding RDB2'
            $WPF_SD_RDB_DataGrid.Visibility = 'Hidden'
        }
                
        $WPF_SD_FreeSpaceRemaining_Value.Text = "$((Get-ConvertedSize -Size ($Script:GUIActions.AvailableSpaceforImportedPartitionBytes - $WPF_SD_MBR_DataGrid.SelectedItem.TotalBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Size) $((Get-ConvertedSize -Size ($Script:GUIActions.AvailableSpaceforImportedPartitionBytes - $WPF_SD_MBR_DataGrid.SelectedItem.TotalBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Scale)" 
    
})

