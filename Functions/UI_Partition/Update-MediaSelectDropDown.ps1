function Update-MediaSelectDropDown {
    param (
    )
    if (-not $WPF_UI_DiskPartition_MediaSelect_DropDown.Items){
        if (-not $Script:RemovableMediaList){
            $Script:RemovableMediaList = Get-RemovableMedia
        }
        foreach ($Disk in $Script:RemovableMediaList){
            $WPF_UI_DiskPartition_MediaSelect_DropDown.AddChild($Disk.FriendlyName)
        }        
    }
}
