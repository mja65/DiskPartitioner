function Remove-MBRGUIPartition {
    param (
        $PartitionName
    )
    # $PartitionName = 'WPF_DP_Partition_FAT32_1'
    if ((Get-Variable -name $PartitionName).Value.CanDelete -eq $false) {
        return $false
    }
    else{
        if ((Get-Variable -name $PartitionName).Value.PartitionType -eq 'FAT32'){
            $WPF_DP_Disk_MBR.NumberofPartitionsFAT32 -= 1
        }
        elseif ((Get-Variable -name $PartitionName).Value.PartitionType -eq 'ID76'){
            $WPF_DP_Disk_MBR.NumberofPartitionsID76 -=1        
        }
    
        $WPF_DP_DiskGrid_MBR.Children.Remove((Get-Variable -Name $PartitionName).Value)
        Remove-Variable -Scope Script -Name $PartitionName
        $Script:GUIActions.SelectedMBRPartition = $null
        return $true
    }

}
