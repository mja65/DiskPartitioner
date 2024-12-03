$WPF_SD_BrowseforImage_Button.add_click({
    $Script:GUIActions.SelectedPhysicalDiskforImport = $null
    $Script:GUIActions.ImportedImagePath = Get-ImagePath
    if($Script:GUIActions.ImportedImagePath){
        $DatatoPopulate = Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.ImportedImagePath
        if ($DatatoPopulate -ne 'NotMBR'){
            $Script:GUIActions.ActionToPerform = 'ImportMBRPartitionfromMBRImage'
            $WPF_SD_MBR_DataGrid.ItemsSource = $DatatoPopulate
            $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.ImportedImagePath -PiStormDiskorImage
            $WPF_SD_MBR_DataGrid.Visibility = 'Visible'
            
        }
        else {
            $DatatoPopulate = Get-RDBInformation -DiskName $Script:GUIActions.ImportedImagePath -AmigaNativeDiskorImage
            if ($DatatoPopulate -ne 'NotRDB'){
                $Script:GUIActions.ActionToPerform = 'ImportMBRPartitionfromAmigaImage'
                $Script:RDBPartitionTable = $DatatoPopulate
                
                $FakeMBRLines = [System.Collections.Generic.List[PSCustomObject]]::New()
                $DatatoPopulate | ForEach-Object {
                    $FakeMBRLines += [PSCustomObject]@{
                        Name = 'RDB Amiga Image'
                        StartOffset = $_.StartOffset
                        EndOffset = $_.EndOffset
                        TotalBytes = $_.TotalBytes
                    }

                }                   
                $WPF_SD_MBR_DataGrid.ItemsSource = $FakeMBRLines
                $WPF_SD_MBR_DataGrid.Visibility = 'Visible'
                $WPF_SD_RDB_DataGrid.Visibility = 'Visible'
         
            }
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

