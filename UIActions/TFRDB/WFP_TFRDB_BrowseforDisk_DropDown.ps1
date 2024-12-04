$WPF_TFRDB_BrowseforDisk_DropDown.add_selectionChanged({
    $Script:GUIActions.ListofRemovableMedia | ForEach-Object{
        if ($WPF_TFRDB_BrowseforDisk_DropDown.SelectedItem -eq $_.FriendlyName){
            $Script:GUIActions.SelectedPhysicalDiskforTransfer = $_.HSTDiskName
            $MBRDatatoPopulate = (Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.SelectedPhysicalDiskforTransfer) 
            if ($MBRDatatoPopulate -eq 'NotMBR'){
                $Script:GUIActions.TransferAmigaSourceType = 'RDB'
                $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.SelectedPhysicalDiskforTransfer -AmigaNativeDiskorImage
            }
            else {
                $Script:GUIActions.TransferAmigaSourceType = 'MBR'
                $WPF_TFRDB_MBR_DataGrid.ItemsSource = $MBRDatatoPopulate
                $Script:RDBPartitionTable = Get-RDBInformation -DiskName $Script:GUIActions.SelectedPhysicalDiskforTransfer -PiStormDiskorImage

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