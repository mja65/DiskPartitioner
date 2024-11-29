function Confirm-NumberMBRPartitions {
    param (

    )
    
    if (($Script:WPF_DP_Disk_MBR.NumberofPartitionsFAT32 + $Script:WPF_DP_Disk_MBR.NumberofPartitionsID76) -eq 4){
        #Write-host "Exceeded number of MBR Partitions"
        $null = Show-WarningorError -Msg_Header 'Error adding partition' -Msg_Body 'Maximum number of MBR partitions (4) has been reached!' -BoxTypeError -ButtonType_OK
        return $false
    }
    else{
        return $true
    }
}
