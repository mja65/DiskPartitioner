$WPF_DP_Amiga_Mountable.add_checked({
    if ($Script:GUICurrentStatus.SelectedAmigaPartition){
        if ((Get-Variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).Value.NoMount -eq $false){
            (Get-Variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).Value.NoMount = $false
        }
    }

})

$WPF_DP_Amiga_Mountable.add_unchecked({
    if ($Script:GUICurrentStatus.SelectedAmigaPartition){
        if ((Get-Variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).Value.NoMount -eq $true){
            (Get-Variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).Value.NoMount = $true
        }
    }

})

