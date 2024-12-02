if (-not $Script:GUIActions.ListofRemovableMedia){
    $Script:GUIActions.ListofRemovableMedia = Get-RemovableMedia
    foreach ($Disk in $Script:GUIActions.ListofRemovableMedia){
        $WPF_DP_MediaSelect_DropDown.AddChild($Disk.FriendlyName)       
    }
}
