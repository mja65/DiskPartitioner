$WPF_DP_Button_ImportFiles.add_click({
    if ($Script:GUIActions.SelectedAmigaPartition){
        Get-TransferredFiles
    }
    else{
        Show-WarningorError -Msg_Header 'No Partition Selected' -Msg_Body 'Cannot transfer files without selecting partition!' -BoxTypeError -ButtonType_OK
    }
})