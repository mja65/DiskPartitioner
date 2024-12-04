$WPF_TFRDB_OK_Button.Add_Click({
    if ($WPF_TFRDB_RDB_DataGrid.SelectedItem){
        if ($Script:GUIActions.TransferFilesImagePath){
            if ($Script:GUIActions.TransferAmigaSourceType -eq 'RDB'){
                $Script:GUIActions.TransferSourceLocation = "$($Script:GUIActions.TransferFilesImagePath)\rdb\$($WPF_TFRDB_RDB_DataGrid.SelectedItem.Name)"                
            }
            elseif ($Script:GUIActions.TransferAmigaSourceType -eq 'MBR'){
                $Script:GUIActions.TransferSourceLocation = "$($Script:GUIActions.TransferFilesImagePath)\mbr\$($WPF_TFRDB_MBR_DataGrid.SelectedItem.Number)\rdb\$($WPF_TFRDB_RDB_DataGrid.SelectedItem.Name)"  
            }
        }
        elseif ($Script:GUIActions.SelectedPhysicalDiskforTransfer){
            if ($Script:GUIActions.TransferAmigaSourceType -eq 'RDB'){
                $Script:GUIActions.TransferSourceLocation = $Script:GUIActions.SelectedPhysicalDiskforTransfer
            }
            elseif ($Script:GUIActions.TransferAmigaSourceType -eq 'MBR'){
                $Script:GUIActions.TransferSourceLocation = "$($Script:GUIActions.SelectedPhysicalDiskforTransfer)\mbr\$($WPF_TFRDB_MBR_DataGrid.SelectedItem.Number)\rdb\$($WPF_TFRDB_RDB_DataGrid.SelectedItem.Name)"
            }
        }
        $Script:GUIActions.TransferSourceType = 'Amiga'
        $Script:GUIActions.TransferFilesImagePath = $null
        $Script:GUIActions.SelectedPhysicalDiskforTransfer = $null
        $Script:GUIActions.TransferAmigaSourceType = $null

        $WPF_SelectRDBSourceWindow.Close()

    }
    else {
        Show-WarningorError -Msg_Header 'No partition selected' -Msg_Body 'You have not selected a partition from which to transfer files. Either select a partition or cancel.' -BoxTypeError -ButtonType_OK
    }
    
})
