$WPF_DP_Button_DeleteMBRPartition.add_click({
    if ($Script:GUIActions.SelectedMBRPartition){
        if ((Remove-MBRGUIPartition -PartitionName $Script:GUIActions.SelectedMBRPartition) -eq $false){
            Show-WarningorError -Msg_Header 'Cannot Delete Partition' -Msg_Body 'MBR Partition is default partition. Cannot delete.' -BoxTypeError -ButtonType_OK
        }
    }

})
