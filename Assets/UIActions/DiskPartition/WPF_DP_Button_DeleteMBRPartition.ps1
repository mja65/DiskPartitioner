$WPF_DP_Button_DeleteMBRPartition.add_click({
    if ($Script:GUICurrentStatus.SelectedGPTMBRPartition){
        if ((Remove-MBRGUIPartition -PartitionName $Script:GUICurrentStatus.SelectedGPTMBRPartition) -eq $false){
            Show-WarningorError -Msg_Header 'Cannot Delete Partition' -Msg_Body 'MBR Partition is default partition. Cannot delete.' -BoxTypeError -ButtonType_OK
        }
    }
    else {
        Show-WarningorError -Msg_Header 'Cannot Delete Partition' -Msg_Body "No partititon is selected!" -BoxTypeError -ButtonType_OK
    }

})
