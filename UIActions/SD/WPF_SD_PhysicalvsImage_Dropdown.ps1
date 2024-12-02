$DropDownOptions = @()
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Physical Disk'}
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Image File'}

foreach ($Option in $DropDownOptions){
    $WPF_SD_PhysicalvsImage_Dropdown.AddChild($Option.Option)
}

$WPF_SD_PhysicalvsImage_Dropdown.add_selectionChanged({
    If ($WPF_SD_PhysicalvsImage_Dropdown.SelectedItem -eq 'Physical Disk'){
        Set-BrowseforDiskDropdown -ImportPartition
        $WPF_SD_Grid_ImageFile.Visibility = 'Hidden'
        $WPF_SD_Grid_PhysicalDisk.Visibility = 'Visible'
    }
    elseIf ($WPF_SD_PhysicalvsImage_Dropdown.SelectedItem -eq 'Image File'){
        $WPF_SD_Grid_ImageFile.Visibility = 'Visible'
         $WPF_SD_Grid_PhysicalDisk.Visibility = 'Hidden'
    }
})


                
       