
$WPF_DP_ID_BrowseforDisk_DropDown.add_selectionChanged({
    $Script:GUICurrentStatus.ImportedImagePath = $null
    $Script:GUIActions.ListofRemovableMedia | ForEach-Object{
        if ($WPF_DP_ID_BrowseforDisk_DropDown.SelectedItem -eq $_.FriendlyName){
            $Script:GUICurrentStatus.SelectedPhysicalDiskforImport = $_.HSTDiskName

            Get-MBRandRDBPartitionsforSelection -PhysicalDisk

            
        }
    }
})

#if $WPF_DP_ID_PiStormvsAmiga_Dropdown.SelectedItem  -eq 'PiStorm Disk/Image'


# if ($WPF_DP_ID_BrowseforDisk_DropDown.SelectedItem){
#     $WPF_DP_ID_MBR_DataGrid.Visibility = 'Visible'
#     #$WPF_DP_ID_RDB_DataGrid.Visibility = 'Visible'        
# } 
# else {
#     $WPF_DP_ID_MBR_DataGrid.Visibility = 'Hidden'
#     #$WPF_DP_ID_RDB_DataGrid.Visibility = 'Hidden'
# }