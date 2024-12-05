$DropDownOptions = @()

$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='At end of disk'}
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Left of selected partition'}
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Right of selected partition'}

foreach ($Option in $DropDownOptions){
    $WPF_DP_ImportMBRPartition_DropDown.AddChild($Option.Option)
}

$WPF_DP_ImportMBRPartition_DropDown.SelectedItem = 'At end of disk'

