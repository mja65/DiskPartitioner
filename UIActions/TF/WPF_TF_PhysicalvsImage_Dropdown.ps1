$DropDownOptions = @()
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Amiga Physical Disk or Image File'}
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Local Drive'}

foreach ($Option in $DropDownOptions){
    $WPF_TF_PhysicalvsImage_Dropdown.AddChild($Option.Option)
}

$WPF_TF_PhysicalvsImage_Dropdown.SelectedItem = 'Local Drive'

# $WPF_TF_PhysicalvsImage_Dropdown.add_selectionChanged({
#     If ($WPF_TF_PhysicalvsImage_Dropdown.SelectedItem -eq 'Physical Disk'){
#         Set-BrowseforDiskDropdown  
#         $WPF_SD_Grid_ImageFile.Visibility = 'Hidden'
#         $WPF_SD_Grid_PhysicalDisk.Visibility = 'Visible'
#     }
#     elseIf ($WPF_TF_PhysicalvsImage_Dropdown.SelectedItem -eq 'Image File'){
#         $WPF_SD_Grid_ImageFile.Visibility = 'Visible'
#          $WPF_SD_Grid_PhysicalDisk.Visibility = 'Hidden'
#     }
# })

