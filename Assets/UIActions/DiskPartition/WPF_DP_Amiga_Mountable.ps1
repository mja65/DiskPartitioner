$WPF_DP_Amiga_Mountable.add_checked({
    if ($Script:GUICurrentStatus.SelectedAmigaPartition){
        if ($Script:GUICurrentStatus.SelectedAmigaPartition.NoMount -eq $false){
            $Script:GUICurrentStatus.SelectedAmigaPartition.NoMount = $false
        }
    }

})

$WPF_DP_Amiga_Mountable.add_unchecked({
    if ($Script:GUICurrentStatus.SelectedAmigaPartition){
        if ($Script:GUICurrentStatus.SelectedAmigaPartition.NoMount -eq $true){
            $Script:GUICurrentStatus.SelectedAmigaPartition.NoMount = $true
        }
    }

})

