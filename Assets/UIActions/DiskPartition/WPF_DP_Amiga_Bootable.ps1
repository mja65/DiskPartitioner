$WPF_DP_Amiga_Bootable.add_checked({
    if ($Script:GUICurrentStatus.SelectedAmigaPartition){
        if ((Get-Variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).Value.bootable -eq $false){
            (Get-Variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).Value.bootable = $true
        }
    }

})

$WPF_DP_Amiga_Bootable.add_unchecked({
    if ($Script:GUICurrentStatus.SelectedAmigaPartition){
        if ((Get-Variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).Value.bootable -eq $true){
            (Get-Variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).Value.bootable = $false
        }
    }

})