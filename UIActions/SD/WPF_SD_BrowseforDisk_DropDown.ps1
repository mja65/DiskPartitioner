$WPF_SD_BrowseforDisk_DropDown.add_selectionChanged({
    $Script:GUIActions.ListofRemovableMedia | ForEach-Object{
        if ($WPF_SD_BrowseforDisk_DropDown.SelectedItem -eq $_.FriendlyName){
            $Script:GUIActions.SelectedPhysicalDisk = $_.HSTDiskName
            $WPF_SD_MBR_DataGrid.ItemsSource = Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.SelectedPhysicalDisk
            if ($Script:GUIActions.ActionToPerform -eq 'ImportRDBPartition'){
                $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.SelectedPhysicalDisk
            }
        }
    }
    if ($WPF_SD_BrowseforDisk_DropDown.SelectedItem){
        $WPF_SD_MBR_DataGrid.Visibility = 'Visible'        
    } 
    else {
        $WPF_SD_MBR_DataGrid.Visibility = 'Hidden'
    }
})
