function Add-GUIPartitiontoAmigaDisk {
    param (
        $AmigaDiskName,
        $AddType,
        $PartitionNameNextto, 
        $SizeBytes,
        $DefaultPartition
    )
    
    # $AmigaDiskName = 'WPF_DP_Partition_ID76_1_AmigaDisk'
    # $WPF_DP_Partition_ID76_1_AmigaDisk_Partition_1
    # $PartitionNameNextto = 'WPF_DP_Partition_ID76_1_AmigaDisk_Partition_1'
   
    $SizePixels = $SizeBytes / ((Get-Variable -name  $AmigaDiskName).value.BytestoPixelFactor)
    if ($SizePixels -gt 4){
        $SizePixels -= 4
    }

    $AvailableFreeSpace = (Confirm-DiskFreeSpace -Disk (Get-Variable -Name $AmigaDiskName).Value -Position $AddType -PartitionNameNextto $PartitionNameNextto)
    if ($AvailableFreeSpace -lt $SizeBytes){
        # Write-host "Insufficient free Space!"
        return 2
    }

    if ($AddType -eq 'AtEnd'){
        $LeftMargin = (Get-GUIPartitionStartEnd -PartitionType 'Amiga' -Prefix $AmigaDiskName).EndingPositionPixels
        $StartingPositionBytes = (Get-GUIPartitionStartEnd -PartitionType 'Amiga' -Prefix $AmigaDiskName).EndingPositionBytes
    }
    else{
        $PartitionNameNexttoDetails = (Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionName -eq $PartitionNameNextto}) 
        if ($AddType -eq 'Right'){
            $LeftMargin = $PartitionNameNexttoDetails.RightMargin
            $StartingPositionBytes = $PartitionNameNexttoDetails.EndingPositionBytes
        }
        elseif ($AddType -eq 'Left'){
            $LeftMargin = $PartitionNameNexttoDetails.LeftMargin - ($SizeBytes/((Get-Variable -Name $AmigaDiskName).Value.BytestoPixelFactor))
            $StartingPositionBytes = $PartitionNameNexttoDetails.StartingPositionBytes - $SizeBytes
        }
    }

    $PartitionNumber = (Get-Variable -Name $AmigaDiskName).Value.NextPartitionNumber

    $NewPartitionName = ($AmigaDiskName+'_Partition_'+$PartitionNumber)

    Set-Variable -name $NewPartitionName -Scope script -value (New-GUIPartition -DefaultPartition $DefaultPartition -PartitionType 'Amiga')

    (Get-Variable -Name $NewPartitionName).Value.Margin = [System.Windows.Thickness]"$LeftMargin,0,0,0"
    (Get-Variable -Name $NewPartitionName).Value.PartitionSizeBytes = $SizeBytes
    (Get-Variable -Name $NewPartitionName).Value.StartingPositionBytes = $StartingPositionBytes

    $TotalColumns = (Get-Variable -Name $NewPartitionName).Value.ColumnDefinitions.Count-1
    for ($i = 0; $i -le $TotalColumns; $i++) {
        if  ((Get-Variable -Name $NewPartitionName).Value.ColumnDefinitions[$i].Name -eq 'FullSpace'){
            (Get-Variable -Name $NewPartitionName).Value.ColumnDefinitions[$i].Width = $SizePixels
        } 
    }

    (Get-Variable -Name $AmigaDiskName).Value.AddChild(((Get-Variable -name $NewPartitionName).value))

    (Get-Variable -Name $AmigaDiskName).Value.NextPartitionNumber += 1
    
    return
    
}
