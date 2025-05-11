$DropDownScaleOptions = @()
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='TiB'}
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='GiB'}
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='MiB'}
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='KiB'}
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='B'}

foreach ($Option in $DropDownScaleOptions){
    $WPF_NewPartitionWindow_Input_PartitionSize_SizeScale_Dropdown.AddChild($Option.Scale)
}

$WPF_NewPartitionWindow_Input_PartitionSize_SizeScale_Dropdown.SelectedItem = $Script:GUICurrentStatus.NewPartitionDefaultScale

$WPF_NewPartitionWindow_Input_PartitionSize_SizeScale_Dropdown.add_selectionChanged({
    $WPF_NewPartitionWindow_Input_PartitionSize_Value.InputEntryScaleChanged = $true
 })
