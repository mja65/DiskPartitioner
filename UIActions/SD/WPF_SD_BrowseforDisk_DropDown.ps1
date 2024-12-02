$WPF_SD_BrowseforDisk_DropDown.add_selectionChanged({
    $Script:GUIActions.ListofRemovableMedia | ForEach-Object{
        if ($WPF_SD_BrowseforDisk_DropDown.SelectedItem -eq $_.FriendlyName){
            $Script:GUIActions.SelectedPhysicalDisk = $_.HSTDiskName
            if ($Script:GUIActions.ActionToPerform -eq 'ImportMBRPartition'){
                $WPF_SD_MBR_DataGrid.ItemsSource = Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.SelectedPhysicalDisk
                $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.SelectedPhysicalDisk -PiStormDiskorImage
            }

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