$DropDownOptions = @()

$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='PiStorm - MBR'}
# $DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='PiStorm - GPT'}
# $DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Amiga - RDB'}

foreach ($Option in $DropDownOptions){
    $WPF_DP_Disk_Type_DropDown.AddChild($Option.Option)
}

$WPF_DP_Disk_Type_DropDown.SelectedItem = 'PiStorm - MBR'

$WPF_DP_Disk_Type_DropDown.add_selectionChanged({
    
})