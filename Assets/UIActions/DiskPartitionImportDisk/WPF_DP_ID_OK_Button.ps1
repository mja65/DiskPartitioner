$WPF_DP_ID_OK_Button.Add_Click({
    
    If ($WPF_DP_ID_ImportText_Label.text -eq "Error! You cannot import a FAT32 Partition! If needed, copy the files accross in Windows Explorer"){
        $null = Show-WarningorError -Msg_Header "Invalid Partition selected" -Msg_Body "You have selected a FAT32 partition for import. This cannot be imported. Press OK to return to import selection" -ButtonType_OK
        return
    }
    if (-not ($PathforImport)){
        $null = Show-WarningorError -Msg_Header'No Action' -Msg_Body 'You have not performed an action. Either cancel or select a partition for import' -BoxTypeError -ButtonType_OK
        return
    } 
    if (($Script:GUICurrentStatus.AvailableSpaceforImportedMBRGPTPartitionBytes - $TotalPartitionSizeBytes) -lt 0){
        Show-WarningorError -Msg_Header 'Insufficient Space' -Msg_Body 'You have insufficient space to import the partition! Either cancel or select a smaller partition' -BoxTypeError -ButtonType_OK
        return
    }

    $Script:GUICurrentStatus.ProcessImportedPartition = $true
    $WPF_SelectDiskWindow.Close()
    
      
})
