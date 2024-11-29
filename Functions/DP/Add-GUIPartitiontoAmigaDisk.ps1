function Add-GUIPartitiontoAmigaDisk {
    param (
        $AmigaDiskName,
        $AddType,
        $PartitionNameNextto, 
        $SizeBytes,
        $PartitionTypeAmiga,
        $ImportedPartition,
        [Switch]$DerivedImportedPartition,
        $PathtoImportedPartition,
        $DeviceName,
        $VolumeName,
        $Buffers,
        $DosType,
        $MaxTransfer,
        $Bootable,
        $NoMount,
        $Priority
    )
    
    # $AmigaDiskName = 'WPF_DP_Partition_ID76_2_AmigaDisk'
    # $WPF_DP_Partition_ID76_1_AmigaDisk_Partition_1
    # $PartitionNameNextto = 'WPF_DP_Partition_ID76_1_AmigaDisk_Partition_1'
    # $AddType = 'AtEnd'
   
    if ($PartitionTypeAmiga){
        $DefaultPartition = $true
    }

    if ($ImportedPartition -eq $true){
        Write-host "Importing Amiga Partition $PathtoImportedPartition"
   }

    $SizePixels = $SizeBytes / ((Get-Variable -name  $AmigaDiskName).value.BytestoPixelFactor)
    if ($SizePixels -gt 4){
        $SizePixels -= 4
    }

    if ($AddType -eq 'AtEnd'){
        $LeftMargin = (Get-GUIPartitionStartEnd -PartitionType 'Amiga' -AmigaDiskName $AmigaDiskName).EndingPositionPixels
        $StartingPositionBytes = (Get-GUIPartitionStartEnd -PartitionType 'Amiga' -AmigaDiskName $AmigaDiskName).EndingPositionBytes
        Write-host "Left Margin is: $LeftMargin. Starting Position Bytes is: $StartingPositionBytes"
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

    Write-Host "New Partition Name is: $NewPartitionName "

    Set-Variable -name $NewPartitionName -Scope script -value (New-GUIPartition -DefaultPartition $DefaultPartition -PartitionType 'Amiga' -PartitionTypeAmiga $PartitionTypeAmiga -ImportedPartition $ImportedPartition  -DerivedImportedPartition $DerivedImportedPartition)

    (Get-Variable -Name $NewPartitionName).Value.Margin = [System.Windows.Thickness]"$LeftMargin,0,0,0"
    (Get-Variable -Name $NewPartitionName).Value.PartitionSizeBytes = $SizeBytes
    (Get-Variable -Name $NewPartitionName).Value.StartingPositionBytes = $StartingPositionBytes
    
    (Get-Variable -Name $NewPartitionName).Value.DeviceName = $DeviceName
    (Get-Variable -Name $NewPartitionName).Value.VolumeName = $VolumeName
    (Get-Variable -Name $NewPartitionName).Value.Buffers = $Buffers
    (Get-Variable -Name $NewPartitionName).Value.DosType = $DosType
    (Get-Variable -Name $NewPartitionName).Value.MaxTransfer = $MaxTransfer
    (Get-Variable -Name $NewPartitionName).Value.Bootable = $Bootable
    (Get-Variable -Name $NewPartitionName).Value.NoMount = $NoMount
    (Get-Variable -Name $NewPartitionName).Value.Priority = $Priority


    if ($ImportedPartition -eq $true){
        (Get-Variable -Name $NewPartitionName).Value.ImportedPartition = $true
        if ($DerivedImportedPartition){
            (Get-Variable -Name $NewPartitionName).Value.ImportedPartitionType = 'Derived'
        }
        else {
            (Get-Variable -Name $NewPartitionName).Value.ImportedPartitionType = 'Direct'
            (Get-Variable -Name $NewPartitionName).Value.ImportedPartitionPath = $PathtoImportedPartition
        }
    }


    $TotalColumns = (Get-Variable -Name $NewPartitionName).Value.ColumnDefinitions.Count-1
    for ($i = 0; $i -le $TotalColumns; $i++) {
        if  ((Get-Variable -Name $NewPartitionName).Value.ColumnDefinitions[$i].Name -eq 'FullSpace'){
            (Get-Variable -Name $NewPartitionName).Value.ColumnDefinitions[$i].Width = $SizePixels
        } 
    }

    (Get-Variable -Name $AmigaDiskName).Value.AddChild(((Get-Variable -name $NewPartitionName).value))

    (Get-Variable -Name $AmigaDiskName).Value.NextPartitionNumber += 1
       
}
