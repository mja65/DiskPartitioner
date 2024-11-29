$WPF_DP_Button_DeleteAmigaPartition.add_click({
    if ($Script:GUIActions.SelectedAmigaPartition){
        if ((Remove-AmigaGUIPartition -PartitionName $Script:GUIActions.SelectedAmigaPartition) -eq $false){
            Show-WarningorError -Msg_Header 'Cannot Delete Partition' -Msg_Body 'Amiga Partition is default partition. Cannot delete.' -BoxTypeError -ButtonType_OK
        }
    }
})