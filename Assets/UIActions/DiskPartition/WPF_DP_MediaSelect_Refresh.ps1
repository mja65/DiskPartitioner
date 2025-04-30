$WPF_DP_MediaSelect_Refresh.Add_Click({
    $Script:GUIActions.ListofRemovableMedia = Get-RemovableMedia
    $WPF_DP_MediaSelect_Dropdown.Items.Clear()
    foreach ($Disk in $Script:GUIActions.ListofRemovableMedia){
        $WPF_DP_MediaSelect_DropDown.AddChild($Disk.FriendlyName)       
    }
})
