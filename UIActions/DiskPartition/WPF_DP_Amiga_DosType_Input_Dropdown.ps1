$DropDownOptions = @()

$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='PFS\3'}
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='PDS\3'}
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='DOS\3'}
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='DOS\7'}

foreach ($Option in $DropDownOptions){
    $WPF_DP_Amiga_DosType_Input_Dropdown.AddChild($Option.Option)
}

