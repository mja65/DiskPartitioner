$WPF_TFRDB_OK_Button.Add_Click({
    if ($WPF_TFRDB_RDB_DataGrid.SelectedItem){
        if ($Script:GUIActions.ImportedImagePath){
            $Script:GUIActions.TransferSourceType = 'Amiga'
            if ($WPF_TFRDB_MBR_DataGrid.SelectedItem){

            }
            else{
                $Script:GUIActions.TransferSourceLocation = "$($Script:GUIActions.ImportedImagePath)\rdb\$($WPF_TFRDB_RDB_DataGrid.SelectedItem.Name)"                
            }
            $Script:GUIActions.ImportedImagePath = $null
            $Script:GUIActions.SelectedPhysicalDiskforTransfer = $null
        }
        elseif ($Script:GUIActions.SelectedPhysicalDiskforTransfer){
            $Script:GUIActions.TransferSourceType = 'Amiga'
            $Script:GUIActions.TransferSourceLocation = $Script:GUIActions.SelectedPhysicalDiskforTransfer
            $Script:GUIActions.SelectedPhysicalDiskforTransfer = $null
            $Script:GUIActions.ImportedImagePath = $null
        }

        $WPF_SelectRDBSourceWindow.Close()
        

    }
    
})
