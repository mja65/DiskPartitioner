$WPF_DP_Button_ImportFilesCancel.add_click({
        if ($Script:GUICurrentStatus.FileBoxOpen -eq $true){
        return
    }
    if ($Script:GUICurrentStatus.SelectedAmigaPartition){
        if ((get-variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).value.ImportedFilesPath){
            (get-variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).value.ImportedFilesPath = $null
            Update-UI -UpdateInputBoxes
        }
    }
})