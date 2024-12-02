$DropDownOptions = @()
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Physical Disk'}
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Image File'}

foreach ($Option in $DropDownOptions){
    $WPF_TFRDB_PhysicalvsImage_Dropdown.AddChild($Option.Option)
}

$WPF_TFRDB_PhysicalvsImage_Dropdown.add_selectionChanged({
    If ($WPF_TFRDB_PhysicalvsImage_Dropdown.SelectedItem -eq 'Physical Disk'){
        Set-BrowseforDiskDropdown -TransferFiles  
        $WPF_TFRDB_Grid_ImageFile.Visibility = 'Hidden'
        $WPF_TFRDB_Grid_PhysicalDisk.Visibility = 'Visible'
    }
    elseIf ($WPF_TFRDB_PhysicalvsImage_Dropdown.SelectedItem -eq 'Image File'){
        $WPF_TFRDB_Grid_ImageFile.Visibility = 'Visible'
         $WPF_TFRDB_Grid_PhysicalDisk.Visibility = 'Hidden'
    }
})


                
       