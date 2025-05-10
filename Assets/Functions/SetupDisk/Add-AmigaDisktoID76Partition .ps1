function Add-AmigaDisktoID76Partition {
    param (
        $ID76PartitionName,
        [Switch]$ImportedDisk
    )

    # $ID76PartitionName = 'WPF_DP_Partition_MBR_2'
  
    Set-Variable -name ($ID76PartitionName+'_AmigaDisk') -Scope Script -value (New-GUIDisk -DiskType 'Amiga')
    if ($ImportedDisk){
        (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.CanAddPartition = $false
    }
    else{
        (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.CanAddPartition = $true
    }
    (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.ID76PartitionParent = $ID76PartitionName   
    (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.LeftDiskBoundary = 0 
    (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.RightDiskBoundary = (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.Children[0].Width
    (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.DiskSizeBytes = Get-AmigaDiskSize -AmigaDisk (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value
    (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.DiskSizeAmigatoGPTMBROverhead = (Get-Variable -name $ID76PartitionName).value.PartitionSizeBytes - (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.DiskSizeBytes 
    (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.DiskSizePixels = (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.RightDiskBoundary - (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.LeftDiskBoundary
    (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.BytestoPixelFactor = (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.DiskSizeBytes / (Get-Variable -name ($ID76PartitionName+'_AmigaDisk')).value.DiskSizePixels
}

