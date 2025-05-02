$DropDownOptions = @()

$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Disk'}
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Image'}

foreach ($Option in $DropDownOptions){
    $WPF_DP_MediaSelect_Type_DropDown.AddChild($Option.Option)
}

$WPF_DP_MediaSelect_Type_DropDown.SelectedItem = ''

$WPF_DP_MediaSelect_Type_DropDown.add_selectionChanged({
    if ($WPF_DP_MediaSelect_Type_DropDown.SelectedItem -eq 'Image'){
        $Script:GUIActions.OutputType = "Image"
    }
    elseif ($WPF_DP_MediaSelect_Type_DropDown.SelectedItem -eq 'Disk'){
        $Script:GUIActions.OutputType = "Disk"        
    }

    update-ui -PhysicalvsImage

})
