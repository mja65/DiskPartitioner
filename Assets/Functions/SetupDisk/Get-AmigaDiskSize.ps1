function Get-AmigaDiskSize {
    param (
        $AmigaDisk
    )
    
    # $AmigaDisk = $WPF_DP_Partition_MBR_2_AmigaDisk

    $ID76PartitionSizeBytes = (Get-Variable -name $AmigaDisk.ID76PartitionParent).Value.PartitionSizeBytes

    # $NumberofCylinders_RDB = 2
    # $Size_RDB = $NumberofCylinders_RDB*(Get-AmigaPartitionSizeBlockBytes)

    $TotalNumberofCylinders = [math]::Floor(($ID76PartitionSizeBytes-$AmigaDisk.RDBOverheadBytes)/(Get-AmigaPartitionSizeBlockBytes))
    
    $RemainingCylinders = $TotalNumberofCylinders - $NumberofCylinders_RDB 

    $TotalSpaceAmigaDiskBytes  = $RemainingCylinders * (Get-AmigaPartitionSizeBlockBytes)

    return $TotalSpaceAmigaDiskBytes

}

