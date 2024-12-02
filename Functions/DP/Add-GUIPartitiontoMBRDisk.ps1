function Add-GUIPartitiontoMBRDisk {
    param (
        $PartitionType,
        $AddType,
        $PartitionNameNextto, 
        $SizeBytes,
        $DefaultPartition,
        $ImportedPartition,
        $DerivedImportedPartition,
        $PathtoImportedPartition
    )

    # $PartitionType = 'FAT32'
    # $PartitionType = 'ID76'
    # $NewPartitionNumber = '1'
    # $SizePixels = 100
    # $LeftMargin = 0
    # $PartitionNameNextto = 'WPF_DP_Partition_ID76_1'

    if ($ImportedPartition -eq $true){
         Write-host "Importing MBR Partition $PathtoImportedPartition"
    }
    
    $SizePixels = $SizeBytes/$Script:WPF_DP_Disk_MBR.BytestoPixelFactor
    if ($SizePixels -gt 4){
        $SizePixels -= 4
    }
    

    if ($PartitionType -eq 'FAT32'){
        $NewPartitionNumber = $Script:WPF_DP_Disk_MBR.NextPartitionFAT32Number
    }
    elseif ($PartitionType -eq 'ID76'){
        $NewPartitionNumber = $Script:WPF_DP_Disk_MBR.NextPartitionID76Number       
    }
        
    $NewPartitionName = ($Script:DP_Settings.PartitionPrefix+$PartitionType+'_'+$NewPartitionNumber)  
  
    if ($AddType -eq 'AtEnd' -or $AddType -eq 'Initial'){
        $LeftMargin = (Get-GUIPartitionStartEnd -PartitionType 'MBR').EndingPositionPixels
        $StartingPositionBytes = (Get-GUIPartitionStartEnd -PartitionType 'MBR').EndingPositionBytes
    }
    else{
        $PartitionNameNexttoDetails = (Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionName -eq $PartitionNameNextto}) 
        if ($AddType -eq 'Right'){
            $LeftMargin = $PartitionNameNexttoDetails.RightMargin
            $StartingPositionBytes = $PartitionNameNexttoDetails.EndingPositionBytes
        }
        elseif ($AddType -eq 'Left'){
            $LeftMargin = $PartitionNameNexttoDetails.LeftMargin - ($SizeBytes/$WPF_DP_Disk_MBR.BytestoPixelFactor)
            $StartingPositionBytes = $PartitionNameNexttoDetails.StartingPositionBytes - $SizeBytes
        }
    }
    
    $NewPartition = New-GUIPartition -PartitionType $PartitionType -DefaultPartition $DefaultPartition -ImportedPartition $ImportedPartition -DerivedImportedPartition $DerivedImportedPartition
    $NewPartition.PartitionSizeBytes = $SizeBytes
    $NewPartition.StartingPositionBytes = $StartingPositionBytes

    if ($ImportedPartition -eq $true){
        $NewPartition.ImportedPartition = $true
        $NewPartition.ImportedPartitionType = 'Direct'
        $NewPartition.ImportedPartitionPath = $PathtoImportedPartition
    }

    $NewPartition.Margin = [System.Windows.Thickness]"$LeftMargin,0,0,0"
    
    $TotalColumns = $NewPartition.ColumnDefinitions.Count-1
    for ($i = 0; $i -le $TotalColumns; $i++) {
        if  ($NewPartition.ColumnDefinitions[$i].Name -eq 'FullSpace'){
            $NewPartition.ColumnDefinitions[$i].Width = $SizePixels
        } 
    }

    Set-Variable -name $NewPartitionName -Scope Script -Value ((Get-Variable -Name NewPartition).Value)
    (Get-Variable -Name $NewPartitionName).Value.Name = $NewPartitionName
 
    $PSCommand = @"
    
        `$Script:WPF_DP_DiskGrid_MBR.AddChild(`$$NewPartitionName)

"@

    Invoke-Expression $PSCommand  

    
    If ($PartitionType -eq 'ID76' -and (-not $ImportedPartition -eq $true)){
       
        Add-AmigaDisktoID76Partition -ID76PartitionName $NewPartitionName
        if ($DefaultPartition -eq $true){
            Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($NewPartitionName+'_AmigaDisk') -SizeBytes $Script:SDCardMinimumsandMaximums.WorkbenchDefault -AddType 'AtEnd' -PartitionTypeAmiga 'Workbench' -DeviceName 'SDH0' -VolumeName 'Workbench' -Buffers '300' -MaxTransfer '0xffffff' -DosType 'PFS\3' -Bootable $true -NoMount $false -Priority 1
            
            $NumberofPartitions = [math]::Ceiling(($SizeBytes-$Script:SDCardMinimumsandMaximums.WorkbenchDefault)/$Script:SDCardMinimumsandMaximums.PFS3Maximum)
            $SpacetoAllocatetoAmigaWorkPartition = ($SizeBytes-$Script:SDCardMinimumsandMaximums.WorkbenchDefault)/$NumberofPartitions 
                       
            for ($i = 1; $i -le $NumberofPartitions; $i++) {
                If ($NumberofPartitions -eq 1){
                    $WorkVolumeName = 'Work'
                    $DeviceName = 'SDH1'
                }
                else{
                    $WorkVolumeName = "Work_$i"
                    $DeviceName = "SDH$i"
                }

                Add-GUIPartitiontoAmigaDisk -AmigaDiskName ($NewPartitionName+'_AmigaDisk') -SizeBytes $SpacetoAllocatetoAmigaWorkPartition -PartitionTypeAmiga 'Work' -AddType 'AtEnd' -VolumeName $WorkVolumeName -DeviceName $DeviceName -Buffers '300' -MaxTransfer '0xffffff' -DosType 'PFS\3' -Bootable $false -NoMount $false -Priority 99
                
            }
            
        }
       # Set-DiskCoordinates -prefix 'WPF_UI_DiskPartition_' -PartitionPrefix 'Partition_' -PartitionType 'Amiga' -AmigaDisk ((Get-Variable -name ($NewPartitionName+'_AmigaDisk')).value)
        #Set-AmigaDiskSizeBytes -ID76PartitionName $NewPartitionName -AmigaDisk ((Get-Variable -name ($NewPartitionName+'_AmigaDisk')).value)
    }
    
    if ($PartitionType -eq 'FAT32'){
        $NewPartitionNumber = $Script:WPF_DP_Disk_MBR.NextPartitionFAT32Number
        $Script:WPF_DP_Disk_MBR.NextPartitionFAT32Number += 1
        $Script:WPF_DP_Disk_MBR.NumberofPartitionsFAT32 += 1
    }
    elseif ($PartitionType -eq 'ID76'){
        $NewPartitionNumber = $Script:WPF_DP_Disk_MBR.NextPartitionID76Number
        $Script:WPF_DP_Disk_MBR.NextPartitionID76Number += 1
        $Script:WPF_DP_Disk_MBR.NumberofPartitionsID76 += 1
        
    }

}
