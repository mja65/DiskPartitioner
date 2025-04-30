$DropDownOptions = @()

$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='FAT32'}
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='0x76 (Amiga Partition)'}
foreach ($Option in $DropDownOptions){
    $WPF_DP_AddNewGPTMBRPartition_Type_DropDown.AddChild($Option.Option)
}
$WPF_DP_AddNewGPTMBRPartition_Type_DropDown.SelectedItem = '0x76 (Amiga Partition)'
