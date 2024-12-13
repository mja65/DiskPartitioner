$WPF_Window_Button_Run.Add_Click({
    if ((Confirm-NetworkLocalorDisk -PathtoCheck $Script:GUIActions.OutputPath) -eq 'Physical Disk'){
        Repair-MBRDisk -Path $Script:GUIActions.OutputPath
        $PowershellDiskNumber = $Script:GUIActions.OutputPath.Substring(6,($Script:GUIActions.OutputPath.Length-6))
    }
    else {
        $null = Dismount-DiskImage -ImagePath $Script:GUIActions.OutputPath
        if (Test-Path $Script:GUIActions.OutputPath){
            Write-InformationMessage -Message "Removing previous image: $($Script:GUIActions.OutputPath)"
            Remove-Item -Path $Script:GUIActions.OutputPath -Force
        }
        New-DiskImage -PathforImage $Script:GUIActions.OutputPath -SizeBytes $WPF_DP_Disk_MBR.DiskSizeBytes
        $DeviceDetails = Mount-DiskImage -ImagePath $Script:GUIActions.OutputPath -NoDriveLetter
        $PowershellDiskNumber = $DeviceDetails.Number
    }
    
    Initialize-MBR -DiskNumber $PowershellDiskNumber 
    
    $MBRPartitionstoAddtoDisk = Get-AllGUIPartitionBoundaries | Where-Object {$_.PartitionType -eq 'MBR'}
    $RDBPartitionstoAddtoDisk = Get-AllGUIPartitions -PartitionType 'Amiga' 
    
    $MBRPartitionCounter = 1
    $EndPreviousPartitionBytes = $null
    
    foreach ($MBRPartition in $MBRPartitionstoAddtoDisk) {
        Write-InformationMessage -Message "MBR Partition: $MBRPartitionCounter Creating Partition: $($MBRPartition.PartitionName)"
        if (($EndPreviousPartitionBytes) -and ($MBRPartition.StartingPositionBytes -ne $EndPreviousPartitionBytes)){
            $OffsetBytes = $MBRPartition.StartingPositionBytes
            Write-InformationMessage -Message "Setting $($MBRPartition.PartitionName) offset of: $OffsetBytes"
        }
        else {
            $null = $OffsetBytes
        }
        if ((Get-Variable -Name $MBRPartition.PartitionName).Value.PartitionType -eq 'FAT32'){
            Write-InformationMessage -Message 'Adding FAT32 Partition'
            Add-MBRPartitiontoDisk -DiskNumber $PowershellDiskNumber -FAT32 -SizeBytes $MBRPartition.PartitionSizeBytes -OffsetBytes $OffsetBytes -VolumeName (Get-Variable -Name $MBRPartition.PartitionName).Value.VolumeName -ImportedPartition (Get-Variable -Name $MBRPartition.PartitionName).Value.ImportedPartition
        }
        elseif ((Get-Variable -Name $MBRPartition.PartitionName).Value.PartitionType -eq 'ID76'){
            Write-InformationMessage -Message 'Adding ID76 Partition'
            Add-MBRPartitiontoDisk -DiskNumber $PowershellDiskNumber -ID76 -PartitionNumber $MBRPartitionCounter -SizeBytes $MBRPartition.PartitionSizeBytes -OffsetBytes $OffsetBytes -VolumeName (Get-Variable -Name $MBRPartition.PartitionName).Value.VolumeName -ImportedPartition (Get-Variable -Name $MBRPartition.PartitionName).Value.ImportedPartition
        }

        $EndPreviousPartitionBytes = $_.EndingPositionBytes
        $MBRPartitionCounter ++
    }

    $null = Dismount-DiskImage -ImagePath $Script:GUIActions.OutputPath
    $MBRPartitionCounter = 1
    
    $HSTScript = @()

    foreach ($MBRPartition in $MBRPartitionstoAddtoDisk) {
        if ((Get-Variable -Name $MBRPartition.PartitionName).Value.PartitionType -eq 'ID76'){
            if ((Get-Variable -Name $MBRPartition.PartitionName).Value.ImportedPartition -ne $True){
                $RDBPartitionstoAddtoPartition = $RDBPartitionstoAddtoDisk | Where-Object {$_.name -match $MBRPartition.Value.PartitionName}
                $HSTScript += Initialize-RDB -Path "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter"               
                $RDBPartitionstoAddtoPartition.value.DosType | Select-Object $_  -Unique | ForEach-Object {
                    $HSTScript += Add-RDBFileSystem -Path "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter" -DosType $_                  
                }
                $RDBPartitionCounter = 1 
                foreach ($RDBPartition in $RDBPartitionstoAddtoPartition) {               
                    $HSTScript += Add-RDBPartitiontoDisk -Path "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter" -Name $RDBPartition.value.DeviceName -DosType $RDBPartition.value.DosType -SizeBytes $RDBPartition.value.PartitionSizeBytes
                    $HSTScript += Format-RDBPartition -Path "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter" -PartitionNumber $RDBPartitionCounter -Name $RDBPartition.value.VolumeName
                    if ($RDBPartition.Value.ImportedFiles){
                        foreach ($File in $RDBPartition.Value.ImportedFiles) {
                            $HSTScript += Copy-FileToRDBPartition -SourcePath $File.FullPath -DestinationPath "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter\rdb\$($RDBPartition.value.DeviceName)"
                            
                        }
                    }
                    
                    $RDBPartitionCounter ++
                }
            }
            else{
                $HSTScript += Copy-MBRPartitiontoDisk -SourcePath $MBRPartition.value.ImportedPartitionPath -SourcePartitionNumber $MBRPartition.value.ImportedPartitionPath.ImportedMBRPartitionNumber -DestinationPath $Script:GUIActions.OutputPath -DestinationPartitionNumber $MBRPartitionCounter -SizeBytes $MBRPartition.value.PartitionSizeBytes
            }
        }
        $MBRPartitionCounter ++
    }
    
    Start-HSTImagerScript -Script $HSTScript 

})   


