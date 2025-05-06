function Remove-MBRGUIPartition {
    param (
        $PartitionName
    )
    # $PartitionName = 'WPF_DP_Partition_MBR_2'
    if ((Get-Variable -name $PartitionName).Value.CanDelete -eq $false) {
        return $false
    }
    else{
        $WPF_DP_Disk_GPTMBR.NumberofPartitionsMBR -= 1   
        $WPF_DP_DiskGrid_GPTMBR.Children.Remove((Get-Variable -Name $PartitionName).Value)
        Remove-Variable -Scope Script -Name $PartitionName
        return $true
    }

}
