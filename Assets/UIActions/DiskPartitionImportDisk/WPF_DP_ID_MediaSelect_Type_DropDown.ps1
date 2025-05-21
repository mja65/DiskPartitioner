$DropDownOptions = @()

$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Disk'}
$DropDownOptions += New-Object -TypeName pscustomobject -Property @{Option='Image'}

foreach ($Option in $DropDownOptions){
    $WPF_DP_ID_MediaSelect_Type_DropDown.AddChild($Option.Option)
}

$WPF_DP_ID_MediaSelect_Type_DropDown.SelectedItem = ''

$WPF_DP_ID_MediaSelect_Type_DropDown.add_selectionChanged({
    if ($WPF_DP_ID_MediaSelect_Type_DropDown.SelectedItem -eq 'Image'){
        $WPF_DP_ID_BrowseforImage_Button.Visibility = "Visible"
        $WPF_DP_ID_BrowseforDisk_DropDown.Visibility = "Hidden"
        $WPF_DP_ID_BrowseforDisk_Label.Visibility = "Hidden"
        $WPF_DP_ID_MediaSelect_Refresh.Visibility = "Hidden"   
    }
    elseif ($WPF_DP_ID_MediaSelect_Type_DropDown.SelectedItem -eq 'Disk'){
        $WPF_DP_ID_BrowseforImage_Button.Visibility = "Hidden"
        $WPF_DP_ID_BrowseforDisk_DropDown.Visibility = "Visible"
        $WPF_DP_ID_BrowseforDisk_Label.Visibility = "Visible"
        $WPF_DP_ID_MediaSelect_Refresh.Visibility = "Visible"   
    }   

})



