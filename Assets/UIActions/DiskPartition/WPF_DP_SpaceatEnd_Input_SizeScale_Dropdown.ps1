$DropDownScaleOptions = @()

$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='TiB'}
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='GiB'}
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='MiB'}
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='KiB'}
$DropDownScaleOptions += New-Object -TypeName pscustomobject -Property @{Scale='B'}

foreach ($Option in $DropDownScaleOptions){
    # Write-debug "SpaceatEndDropdown"

    $WPF_DP_SpaceatEnd_Input_SizeScale_Dropdown.AddChild($Option.Scale)
    
    $WPF_DP_SpaceatEnd_Input_SizeScale_Dropdown.add_selectionChanged({
        $WPF_DP_SpaceatEnd_Input.InputEntryScaleChanged = $true
#        Update-GUIInputBox -InputBox $WPF_DP_SpaceatEnd_Input -DropDownBox $WPF_DP_SpaceatEnd_Input_SizeScale_Dropdown -MBRMove_SpaceatEnd
    
     })
    
}