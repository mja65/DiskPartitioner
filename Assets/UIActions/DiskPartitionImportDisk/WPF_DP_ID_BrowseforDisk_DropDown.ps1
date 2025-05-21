if (-not ($Script:GUIActions.ListofRemovableMedia)){
    $Script:GUIActions.ListofRemovableMedia = Get-RemovableMedia
}

foreach ($Disk in $Script:GUIActions.ListofRemovableMedia){
    if ($Disk.HSTDiskName -ne $Script:GUIActions.OutputPath){
        $WPF_DP_ID_BrowseforDisk_DropDown.AddChild($Disk.FriendlyName)       
    }
}

$WPF_DP_ID_BrowseforDisk_DropDown.add_selectionChanged({
    $Script:GUICurrentStatus.ImportedImagePath = $null
    $Script:GUIActions.ListofRemovableMedia | ForEach-Object{
        if ($WPF_DP_ID_BrowseforDisk_DropDown.SelectedItem -eq $_.FriendlyName){
            $Script:GUICurrentStatus.SelectedPhysicalDiskforImport = $_.HSTDiskName

            Get-MBRandRDBPartitionsforSelection -PhysicalDisk

            
        }
    }
})