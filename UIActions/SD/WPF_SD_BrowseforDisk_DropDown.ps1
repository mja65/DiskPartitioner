$WPF_SD_BrowseforDisk_DropDown.add_selectionChanged({
    $Script:GUIActions.ImportedImagePath = $null
    $Script:GUIActions.ListofRemovableMedia | ForEach-Object{
        if ($WPF_SD_BrowseforDisk_DropDown.SelectedItem -eq $_.FriendlyName){
            $Script:GUIActions.SelectedPhysicalDiskforImport = $_.HSTDiskName
            $Script:GUIActions.ActionToPerform = 'ImportMBRPartitionFromMBRDisk'
            $WPF_SD_MBR_DataGrid.ItemsSource = Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.SelectedPhysicalDiskforImport
            $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.SelectedPhysicalDiskforImport -PiStormDiskorImage
            
            $TabletoPopulate = [System.Collections.Generic.List[PSCustomObject]]::New()

            $Script:RDBPartitionTable | ForEach-Object {
                $TabletoPopulate += $_                
            }
    
            if ($TabletoPopulate){
                $WPF_SD_RDB_DataGrid.ItemsSource = $TabletoPopulate
            }
            
        }
    }
    if ($WPF_SD_BrowseforDisk_DropDown.SelectedItem){
        $WPF_SD_MBR_DataGrid.Visibility = 'Visible'
        #$WPF_SD_RDB_DataGrid.Visibility = 'Visible'        
    } 
    else {
        $WPF_SD_MBR_DataGrid.Visibility = 'Hidden'
        #$WPF_SD_RDB_DataGrid.Visibility = 'Hidden'
    }
})

#if $WPF_SD_PiStormvsAmiga_Dropdown.SelectedItem  -eq 'PiStorm Disk/Image'