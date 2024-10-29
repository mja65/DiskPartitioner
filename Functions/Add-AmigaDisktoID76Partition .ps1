function Add-AmigaDisktoID76Partition {
    param (
        $ID76PartitionName
    )

    # $ID76PartitionName = 'WPF_UI_DiskPartition_Partition_ID76_1'
  
    Set-Variable -name ($ID76PartitionName+'_AmigaDisk') -Scope Script -value (New-GUIDisk -DiskType 'Amiga')
   
}

