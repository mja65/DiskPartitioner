function Remove-AmigaGUIPartition {
    param (
        $PartitionName
    )
    
    # $PartitionName = 'WPF_DP_Partition_ID76_1_AmigaDisk_Partition_1'
    $SuffixPosition = $PartitionName.IndexOf('_AmigaDisk_Partition_')

    $ParentID76PartitionName = $PartitionName.Substring(0,$SuffixPosition)
    $ParentAmigaDiskName = $PartitionName.Substring(0,$SuffixPosition+10)
    
    if ((Get-Variable -name $PartitionName).Value.CanDelete -eq $false) {
        return $false
    }
    else {
        (Get-Variable -Name $ParentID76PartitionName).Value.Children.Remove((Get-Variable -Name $PartitionName).Value)
    
        (Get-Variable -Name $ParentAmigaDiskName).Value.Children.Remove((Get-Variable -Name $PartitionName).Value)
    
        Remove-Variable -Scope Script -Name $PartitionName
        $Script:GUIActions.SelectedAmigaPartition = $null

        return $true
    }

}
