$WPF_DP_Button_ImportFilesCancel.add_click({
        if ($Script:GUICurrentStatus.FileBoxOpen -eq $true){
        return
    }
    if ($Script:GUICurrentStatus.SelectedAmigaPartition){
        if ($Script:GUICurrentStatus.SelectedAmigaPartition.ImportedFilesPath){
            $Script:GUICurrentStatus.SelectedAmigaPartition.ImportedFilesPath = $null
            Update-UI -UpdateInputBoxes
        }
    }
})