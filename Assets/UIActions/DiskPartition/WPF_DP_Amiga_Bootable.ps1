$WPF_DP_Amiga_Bootable.add_checked({
    if ($Script:GUICurrentStatus.SelectedAmigaPartition){
        if ($Script:GUICurrentStatus.SelectedAmigaPartition.bootable -eq $false){
            $Script:GUICurrentStatus.SelectedAmigaPartition.bootable = $true
        }
    }

})

$WPF_DP_Amiga_Bootable.add_unchecked({
    if ($Script:GUICurrentStatus.SelectedAmigaPartition){
        if ($Script:GUICurrentStatus.SelectedAmigaPartition.bootable -eq $true){
            $Script:GUICurrentStatus.SelectedAmigaPartition.bootable = $false
        }
    }

})