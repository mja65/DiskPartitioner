$DropDownScaleOptions = @()

$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='TiB'}
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='GiB'}
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='MiB'}

foreach ($Option in $DropDownScaleOptions){
    $WPF_DP_Input_DiskSize_SizeScale_Dropdown.AddChild($Option.Scale)
}

$WPF_DP_Input_DiskSize_SizeScale_Dropdown.SelectedItem = 'GiB'

$WPF_DP_Input_DiskSize_SizeScale_Dropdown.add_selectionChanged({
    $WPF_DP_Input_DiskSize_Value.InputEntryScaleChanged = $true
   # Update-GUIInputBox -InputBox $WPF_DP_Input_DiskSize_Value -SetDiskValues -DiskType $WPF_DP_Disk_Type_DropDown.SelectedItem

 })

