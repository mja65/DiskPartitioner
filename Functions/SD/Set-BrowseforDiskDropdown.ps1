function Set-BrowseforDiskDropdown {
    param (
    )   
    
    $Script:GUIActions.ListofRemovableMedia = Get-RemovableMedia

    foreach ($Disk in $Script:GUIActions.ListofRemovableMedia){
        $WPF_SD_BrowseforDisk_DropDown.AddChild($Disk.FriendlyName)       
    }
}
