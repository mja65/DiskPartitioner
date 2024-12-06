$WPF_Window_Button_Run.Add_Click({
    Initialize-Disk -Path $Script:GUIActions.OutputPath
    Initialize-MBR -Path $Script:GUIActions.OutputPath
    $MBRPartitionCounter = 1
    $MBRPartitionstoAddtoDisk = Get-AllGUIPartitions -PartitionType 'MBR'
    $RDBPartitionstoAddtoDisk = Get-AllGUIPartitions -PartitionType 'Amiga' 

    foreach ($MBRPartition in $MBRPartitionstoAddtoDisk) {
        if ($MBRPartition.Value.PartitionType -eq 'FAT32'){
            Add-MBRPartitiontoDisk -Path $Script:GUIActions.OutputPath -FAT32 -SizeBytes $MBRPartition.Value.PartitionSizeBytes
            if ($MBRPartition.value.ImportedPartition -ne $True){
                Format-MBRPartition -Path $Script:GUIActions.OutputPath -PartitionNumber $MBRPartitionCounter -Name $MBRPartition.value.VolumeName
            }
        }
        elseif ($MBRPartition.Value.PartitionType -eq 'ID76'){
            if ($MBRPartition.value.ImportedPartition -ne $True){
                Add-MBRPartitiontoDisk -Path $Script:GUIActions.OutputPath -ID76 -SizeBytes $MBRPartition.Value.PartitionSizeBytes
                $RDBPartitionstoAddtoPartition = $RDBPartitionstoAddtoDisk | Where-Object {$_.name -match $MBRPartition.Value.PartitionName}
                Initialize-RDB -Path "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter"               
                $RDBPartitionstoAddtoPartition.value.DosType | Select-Object $_  -Unique | ForEach-Object {
                    Add-RDBFileSystem -Path "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter" -DosType $_                  
                }
                $RDBPartitionCounter = 1 
                foreach ($RDBPartition in $RDBPartitionstoAddtoPartition) {               
                    Add-RDBPartitiontoDisk -Path "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter" -Name $RDBPartition.value.DeviceName -DosType $RDBPartition.value.DosType -SizeBytes $RDBPartition.value.PartitionSizeBytes
                    Format-RDBPartition -Path "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter" -PartitionNumber $RDBPartitionCounter -Name $RDBPartition.value.VolumeName
                    if ($RDBPartition.Value.ImportedFiles){
                        foreach ($File in $RDBPartition.Value.ImportedFiles) {
                            Copy-FileToRDBPartition -SourcePath $File.FullPath -DestinationPath "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter\rdb\$($RDBPartition.value.DeviceName)"
                            
                        }
                    }
                    $RDBPartitionCounter ++
                }                
            }
            elseif ($MBRPartition.value.ImportedPartition -eq $True){
                Copy-MBRPartitiontoDisk -SourcePath $MBRPartition.value.ImportedPartitionPath -SourcePartitionNumber $MBRPartition.value.ImportedPartitionPath.ImportedMBRPartitionNumber -DestinationPath $Script:GUIActions.OutputPath -DestinationPartitionNumber $MBRPartitionCounter -SizeBytes $MBRPartition.value.PartitionSizeBytes
            }
    
        }
        $MBRPartitionCounter ++
    }
  
})
