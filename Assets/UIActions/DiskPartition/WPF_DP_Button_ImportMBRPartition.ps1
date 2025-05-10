$WPF_DP_Button_ImportMBRPartition.Add_Click({
    if ((Get-AllGUIPartitions -PartitionType 'MBR').count -eq $Script:Settings.MBRPartitionsMaximum){
        $null = Show-WarningorError -Msg_Header 'Maximum Number of Partitions' -Msg_Body 'You have reached the maximum number of primary partitions allowed. Cannot create partition!' -BoxTypeError -ButtonType_OK
    }
    else {
        Set-DiskForImport
    }
})