function Remove-AmigaGUIPartition {
    param (
        $Partition
    )
    
    # $PartitionName = 'WPF_DP_Partition_ID76_1_AmigaDisk_Partition_1'
    $SuffixPosition = $PartitionName.IndexOf('_AmigaDisk_Partition_')

    $ParentID76PartitionName = $PartitionName.Substring(0,$SuffixPosition)
    $ParentAmigaDiskName = $PartitionName.Substring(0,$SuffixPosition+10)
    
    if ($Partition.CanDelete -eq $false) {
        return $false
    }
    else {
        (Get-Variable -Name $ParentID76PartitionName).Value.Children.Remove($Partition)
    
        (Get-Variable -Name $ParentAmigaDiskName).Value.Children.Remove($Partition)
    
        Remove-Variable -Scope Script -Name $PartitionName
        $Script:GUICurrentStatus.SelectedAmigaPartition = $null
        
        if ($WPF_DP_Amiga_GroupBox.Visibility -eq 'Visible'){      
            $WPF_DP_DiskGrid_Amiga.UpdateLayout()
            $Script:GUICurrentStatus.AmigaPartitionsandBoundaries = @(Get-AllGUIPartitionBoundaries -Amiga)
        }               

    }

}

