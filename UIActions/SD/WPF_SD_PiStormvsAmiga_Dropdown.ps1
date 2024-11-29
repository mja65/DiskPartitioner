$DropDownOptions = @()
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='PiStorm Disk/Image'}
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Native Amiga Disk/Image'}

IF ($WPF_SD_PiStormvsAmiga_Dropdown){
    foreach ($Option in $DropDownOptions){
        $WPF_SD_PiStormvsAmiga_Dropdown.AddChild($Option.Option)
    }
    
    $WPF_SD_PiStormvsAmiga_Dropdown.SelectedItem = 'PiStorm Disk/Image'
}
