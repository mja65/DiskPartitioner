$WPF_TFRDB_BrowseforDisk_DropDown.add_selectionChanged({
    $Script:GUIActions.ListofRemovableMedia | ForEach-Object{
        if ($WPF_TFRDB_BrowseforDisk_DropDown.SelectedItem -eq $_.FriendlyName){
            $Script:GUIActions.SelectedPhysicalDisk = $_.HSTDiskName
            $MBRDatatoPopulate = (Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.SelectedPhysicalDisk) 
            if ($MBRDatatoPopulate -eq 'NotMBR'){
                $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.SelectedPhysicalDisk -AmigaNativeDiskorImage
            }
            else {
                $WPF_TFRDB_MBR_DataGrid.ItemsSource = $MBRDatatoPopulate
                $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.SelectedPhysicalDisk -PiStormDiskorImage

            }
           
        }
    }
    if ($WPF_TFRDB_BrowseforDisk_DropDown.SelectedItem){
        $WPF_TFRDB_MBR_DataGrid.Visibility = 'Visible'        
    } 
    else {
        $WPF_TFRDB_MBR_DataGrid.Visibility = 'Hidden'
    }
})

# #if $WPF_TFRDB_PiStormvsAmiga_Dropdown.SelectedItem  -eq 'PiStorm Disk/Image'