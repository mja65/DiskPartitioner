$DropDownOptions = @()

$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Disk'}
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Image'}

foreach ($Option in $DropDownOptions){
    $WPF_DP_MediaSelect_Type_DropDown.AddChild($Option.Option)
}

$WPF_DP_MediaSelect_Type_DropDown.SelectedItem = 'Image'

$WPF_DP_MediaSelect_Type_DropDown.add_selectionChanged({
    if ($WPF_DP_MediaSelect_Type_DropDown.SelectedItem -eq 'Image'){
        $WPF_DP_MediaSelect_DropDown.Visibility = 'Hidden'
        $WPF_DP_MediaSelect_Label.Visibility = 'Hidden'
        $WPF_DP_MediaSelect_Refresh.Visibility = 'Hidden'
        $WPF_DP_Input_DiskSize_SizeScale_Dropdown.Visibility = 'Visible'
        $WPF_DP_Input_DiskSize_Value.Visibility = 'Visible'
        $WPF_DP_Button_SaveImage.Visibility = 'Visible'
    }
    elseif ($WPF_DP_MediaSelect_Type_DropDown.SelectedItem -eq 'Disk'){
        $WPF_DP_MediaSelect_DropDown.Visibility = 'Visible'
        $WPF_DP_MediaSelect_Label.Visibility = 'Visible'
        $WPF_DP_MediaSelect_Refresh.Visibility = 'Visible'
        $WPF_DP_Input_DiskSize_SizeScale_Dropdown.Visibility = 'Hidden'
        $WPF_DP_Input_DiskSize_Value.Visibility = 'Hidden'
        $WPF_DP_Button_SaveImage.Visibility = 'Hidden'
    }
})

