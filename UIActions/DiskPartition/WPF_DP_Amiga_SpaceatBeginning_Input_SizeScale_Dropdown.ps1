$DropDownScaleOptions = @()

$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='TiB'}
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='GiB'}
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='MiB'}
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='KiB'}
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='B'}

foreach ($Option in $DropDownScaleOptions){
    $WPF_DP_Amiga_SpaceatBeginning_Input_SizeScale_Dropdown.AddChild($Option.Scale)
    Update-GUIInputBox -InputBox $WPF_DP_Amiga_SpaceatBeginning_Input -DropDownBox $WPF_DP_Amiga_SpaceatBeginning_Input_SizeScale_Dropdown -AmigaMove_SpaceatBeginning
    Update-UI -UpdateInputBoxes
}