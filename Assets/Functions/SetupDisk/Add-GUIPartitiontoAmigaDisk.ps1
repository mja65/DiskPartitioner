function Add-GUIPartitiontoAmigaDisk {
    param (
        [Switch]$LoadSettings,
        $NewPartitionNameFromSettings,
        $AmigaDiskName,
        $AddType,
        $PartitionNameNextto, 
        $SizeBytes,
        $PartitionTypeAmiga,
        [Switch]$ImportedPartition,
        $ImportedPartitionMethod,
        $ImportedFilesPath,
        $ImportedPartitionOffsetBytes,
        $ImportedPartitionEndBytes,
        $ImportedFilesSpaceBytes,
        $PathtoImportedPartition,
        $DeviceName,
        $VolumeName,
        $Buffers,
        $DosType,
        $MaxTransfer,
        $Bootable,
        $NoMount,
        $Priority,
        $Mask
    )
    
    # $AmigaDiskName = 'WPF_DP_Partition_ID76_2_AmigaDisk'
    # $WPF_DP_Partition_ID76_1_AmigaDisk_Partition_1
    # $PartitionNameNextto = 'WPF_DP_Partition_ID76_1_AmigaDisk_Partition_1'
    # $AddType = 'AtEnd'
   
    if ($PartitionTypeAmiga){
        $DefaultPartition = $true
    }

    if ($ImportedPartition){
        # Write-debug "Importing Amiga Partition $PathtoImportedPartition"
   }

    $SizePixels = $SizeBytes / ((Get-Variable -name  $AmigaDiskName).value.BytestoPixelFactor)
    if ($SizePixels -gt 4){
        $SizePixels -= 4
    }

    if ($AddType -eq 'AtEnd'){
        $LeftMargin = (Get-GUIPartitionStartEnd -PartitionType 'Amiga' -AmigaDiskName $AmigaDiskName).EndingPositionPixels
        $StartingPositionBytes = (Get-GUIPartitionStartEnd -PartitionType 'Amiga' -AmigaDiskName $AmigaDiskName).EndingPositionBytes
        # Write-debug "Left Margin is: $LeftMargin. Starting Position Bytes is: $StartingPositionBytes"
    }
    else{
        $PartitionNameNexttoDetails = (Get-AllGUIPartitionBoundaries | Where-Object {$_.PartitionName -eq $PartitionNameNextto}) 
        if ($AddType -eq 'Right'){
            $LeftMargin = $PartitionNameNexttoDetails.RightMargin
            $StartingPositionBytes = $PartitionNameNexttoDetails.EndingPositionBytes
        }
        elseif ($AddType -eq 'Left'){
            $LeftMargin = $PartitionNameNexttoDetails.LeftMargin - ($SizeBytes/((Get-Variable -Name $AmigaDiskName).Value.BytestoPixelFactor))
            $StartingPositionBytes = $PartitionNameNexttoDetails.StartingPositionBytes - $SizeBytes
        }
    }

    if ($LoadSettings){
        $NewPartitionName = $NewPartitionNameFromSettings
    }
    else {
        $PartitionNumber = (Get-Variable -Name $AmigaDiskName).Value.NextPartitionNumber
        $NewPartitionName = ($AmigaDiskName+'_Partition_'+$PartitionNumber)
    }

    # Write-debug "New Partition Name is: $NewPartitionName "

    if ($DefaultPartition -eq $true){
        Set-Variable -name $NewPartitionName -Scope script -value (New-GUIPartition -DefaultPartition -PartitionType 'Amiga' -PartitionTypeAmiga $PartitionTypeAmiga)
    }
    elseif ($ImportedPartition){
        Set-Variable -name $NewPartitionName -Scope script -value (New-GUIPartition -PartitionType 'Amiga' -ImportedPartition -ImportedPartitionMethod $ImportedPartitionMethod)
    }
    else {
        Set-Variable -name $NewPartitionName -Scope script -value (New-GUIPartition -PartitionType 'Amiga')
    }

    if ($ImportedFilesPath){
        (Get-Variable -Name $NewPartitionName).Value.ImportedFilesPath = $ImportedFilesPath
        (Get-Variable -Name $NewPartitionName).Value.ImportedFilesSpaceBytes = [int]$ImportedFilesSpaceBytes
    }

    (Get-Variable -Name $NewPartitionName).Value.Margin = [System.Windows.Thickness]"$LeftMargin,0,0,0"
    (Get-Variable -Name $NewPartitionName).Value.PartitionSizeBytes = $SizeBytes
    (Get-Variable -Name $NewPartitionName).Value.StartingPositionBytes = $StartingPositionBytes
    
    (Get-Variable -Name $NewPartitionName).Value.DeviceName = $DeviceName
    (Get-Variable -Name $NewPartitionName).Value.VolumeName = $VolumeName
    (Get-Variable -Name $NewPartitionName).Value.Buffers = $Buffers
    (Get-Variable -Name $NewPartitionName).Value.DosType = $DosType
    (Get-Variable -Name $NewPartitionName).Value.Mask = $Mask
    (Get-Variable -Name $NewPartitionName).Value.MaxTransfer = $MaxTransfer
    (Get-Variable -Name $NewPartitionName).Value.Bootable = $Bootable
    (Get-Variable -Name $NewPartitionName).Value.NoMount = $NoMount
    (Get-Variable -Name $NewPartitionName).Value.Priority = $Priority


    if ($ImportedPartition){
        (Get-Variable -Name $NewPartitionName).Value.ImportedPartition = $true
        (Get-Variable -Name $NewPartitionName).Value.ImportedPartitionMethod = $ImportedPartitionMethod
        (Get-Variable -Name $NewPartitionName).Value.ImportedPartitionPath = $PathtoImportedPartition
        (Get-Variable -Name $NewPartitionName).Value.DeviceNameOriginalImportedValue = $DeviceName
        (Get-Variable -Name $NewPartitionName).Value.VolumeNameOriginalImportedValue = $VolumeName
        (Get-Variable -Name $NewPartitionName).Value.BuffersOriginalImportedValue = $Buffers
        (Get-Variable -Name $NewPartitionName).Value.DosTypeOriginalImportedValue = $DosType
        (Get-Variable -Name $NewPartitionName).Value.MaskOriginalImportedValue = $Mask
        (Get-Variable -Name $NewPartitionName).Value.MaxTransferOriginalImportedValue = $MaxTransfer
        (Get-Variable -Name $NewPartitionName).Value.BootableOriginalImportedValue = $Bootable
        (Get-Variable -Name $NewPartitionName).Value.NoMountOriginalImportedValue = $NoMount
        (Get-Variable -Name $NewPartitionName).Value.PriorityOriginalImportedValue = $Priority
        (Get-Variable -Name $NewPartitionName).Value.ImportedPartitionOffsetBytes = $ImportedPartitionOffsetBytes
        (Get-Variable -Name $NewPartitionName).Value.ImportedPartitionEndBytes = $ImportedPartitionEndBytes
    }


    $TotalColumns = (Get-Variable -Name $NewPartitionName).Value.ColumnDefinitions.Count-1
    for ($i = 0; $i -le $TotalColumns; $i++) {
        if  ((Get-Variable -Name $NewPartitionName).Value.ColumnDefinitions[$i].Name -eq 'FullSpace'){
            (Get-Variable -Name $NewPartitionName).Value.ColumnDefinitions[$i].Width = $SizePixels
        } 
    }

    (Get-Variable -Name $AmigaDiskName).Value.AddChild(((Get-Variable -name $NewPartitionName).value))

    if (-not ($LoadSettings)){
        (Get-Variable -Name $AmigaDiskName).Value.NextPartitionNumber ++
    }
       
}
