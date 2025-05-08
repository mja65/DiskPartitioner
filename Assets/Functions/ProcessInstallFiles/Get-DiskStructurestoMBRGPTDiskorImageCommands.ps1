function Get-DiskStructurestoMBRGPTDiskorImageCommands {
    param (
        
    )

    
    $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures = [System.Collections.Generic.List[PSCustomObject]]::New()
    $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk = [System.Collections.Generic.List[PSCustomObject]]::New()

    if ($Script:GUIActions.DiskTypeSelected -eq 'PiStorm - MBR'){
        $MBRPartitionstoAddtoDisk = Get-AllGUIPartitions -partitiontype 'MBR'
        $RDBPartitionstoAddtoDisk = Get-AllGUIPartitions -PartitionType 'Amiga' 
    }
    elseif ($Script:GUIActions.DiskTypeSelected -eq 'PiStorm - GPT'){
        Write-host "Error in Coding - WPF_Window_Button_Run !"
        $WPF_MainWindow.Close()
        exit
    }
    elseif ($Script:GUIActions.DiskTypeSelected -eq 'Amiga - RDB'){
        Write-host "Error in Coding - WPF_Window_Button_Run !"
        $WPF_MainWindow.Close()
        exit
    }
        
    $Script:Settings.CurrentSubTaskNumber ++
    $Script:Settings.CurrentSubTaskName = "Getting commands to create MBR Partitions"
    
    Write-StartSubTaskMessage

    $MBRPartitionCounter = 1
    
    $StartingSector = $Script:Settings.MBRFirstPartitionStartSector

    foreach ($MBRPartition in $MBRPartitionstoAddtoDisk) {
        if ($MBRPartition.value.PartitionSubType -eq 'FAT32'){
            $PartitionTypetoUse = "0xb"
    
        }
        elseif ($MBRPartition.value.PartitionSubType -eq 'ID76'){
            $PartitionTypetoUse = "0x76"            
        }
        Write-InformationMessage -Message "Adding command to create partition #$MBRPartitionCounter of type $PartitionTypetoUse"

        $MBRPartitionStartSector = $MBRPartition.value.StartingPositionSector + $StartingSector
    
        $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures += [PSCustomObject]@{
            Command = "mbr part add $($Script:GUIActions.OutputPath) $PartitionTypetoUse $($MBRPartition.value.partitionsizebytes) --start-sector $MBRPartitionStartSector"
            Sequence = 1      
        }  
        if ($MBRPartition.value.PartitionSubType -eq 'FAT32'){
            Write-InformationMessage -Message "Adding command to format FAT32 partition for partition #$MBRPartitionCounter"
            $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures += [PSCustomObject]@{
                Command = "mbr part format $($Script:GUIActions.OutputPath) $MBRPartitionCounter $($MBRPartition.value.VolumeName)"
                Sequence = 1      
            }  
        }
        if ($MBRPartition.value.ImportedPartition -eq $true -and $MBRPartition.value.ImportedPartitionMethod -eq 'Direct'){
            $Startpoint = $MBRPartition.value.ImportedPartitionPath.IndexOf("\MBR\")
            $SubstringLength = $MBRPartition.value.ImportedPartitionPath.length-($Startpoint+5)
            $MBRPartitionNumbertoImport = $MBRPartition.value.ImportedPartitionPath.Substring(($Startpoint+5),$SubstringLength)
            $PathofImage = $MBRPartition.value.ImportedPartitionPath.Substring(0,$Startpoint)
            $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures += [PSCustomObject]@{
                Command = "mbr part clone $PathofImage $MBRPartitionNumbertoImport $($Script:GUIActions.OutputPath) $MBRPartitionCounter"
                Sequence = 2      
            }  
        }

        $MBRPartitionCounter ++
    }

    $Script:Settings.CurrentSubTaskNumber ++
    $Script:Settings.CurrentSubTaskName = "Getting commands to create RDB Partitions"

    Write-StartSubTaskMessage
    
    $FileSystemstoAdd = [System.Collections.Generic.List[PSCustomObject]]::New()

    Write-InformationMessage -Message "Determining Filesystems to add to disk"

    foreach ($RDBPartition in $RDBPartitionstoAddtoDisk){        
        $FileSystemstoAdd  += [PSCustomObject]@{
            GPTMBRPartition = $RDBPartition.name.Substring(0,($RDBPartition.name.IndexOf('_AmigaDisk_Partition_')))
            DosType = $RDBPartition.Value.DosType
            FileSystemPath = $null
            FileSystemName = $null
        }
    }
   
   $FileSystemstoAdd = $FileSystemstoAdd | Select-Object 'GPTMBRPartition','DosType','FileSystemPath','FileSystemName'  -Unique

   $HashTableforFileSystemPath = @{} # Clear Hash
   Get-AvailableAmigaFileSystems -FilesystemsbyDosTypesFLAG | ForEach-Object {
       $HashTableforFileSystemPath[$_.DosType] = @($_.Filesystempath)
   }
    
   $FileSystemstoAdd | ForEach-Object {
       if ($HashTableforFileSystemPath.ContainsKey($_.DosType)){
           $_.FileSystemPath = $HashTableforFileSystemPath.($_.DosType)[0]
           $_.FileSystemName = split-path -Path $_.FileSystemPath -Leaf
       }
   }

    Write-InformationMessage -Message "Preparing HST Commands to run"
  
   $Script:GUICurrentStatus.PathstoRDBPartitions = [System.Collections.Generic.List[PSCustomObject]]::New()
   
   $MBRPartitionCounter = 1
  
   foreach ($MBRPartition in $MBRPartitionstoAddtoDisk) {
       if ($MBRPartition.value.PartitionSubType -eq 'FAT32'){
           Write-InformationMessage -Message "Skipping Partition $($MBRPartition.Name) - MBR Partition Number: $MBRPartitionCounter"
       }       
       elseif ($MBRPartition.value.PartitionSubType -eq 'ID76'){
           $RDBPartitionCounter = 1       
           Write-InformationMessage -Message "Preparing commands to set up Amiga Disk for $($MBRPartition.Name) - MBR Partition Number: $MBRPartitionCounter"
           if ($MBRPartition.value.ImportedPartition -ne $true){
               $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures += [PSCustomObject]@{
                   Command = "rdb init $($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter"
                   Sequence = 3    
               }  
               foreach ($FileSystem in $FileSystemstoAdd){
                   if ($FileSystem.GPTMBRPartition -eq $MBRPartition.Name){
                    $DosTypetoUse = $FileSystem.DosType.Replace("\","")
                    Write-InformationMessage -Message "Adding filesystem `"$($FileSystem.FileSystemName)`" to Disk"
                       $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures += [PSCustomObject]@{
                           Command = "rdb filesystem add `"$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter`" $($FileSystem.FileSystemPath) $DosTypetoUse"    
                           Sequence = 3      
                       }            
                   }               
               }
               foreach ($RDBPartition in $RDBPartitionstoAddtoDisk) {
                    if (($RDBPartition.Name -split '_AmigaDisk_')[0] -eq $MBRPartition.Name){
                        $Script:GUICurrentStatus.PathstoRDBPartitions  += [PSCustomObject]@{
                            MBRPartitionNumber = $MBRPartitionCounter
                            RDBPartitionNumber = $RDBPartitionCounter
                            DeviceName = $($RDBPartition.value.DeviceName)
                            VolumeName = $($RDBPartition.value.VolumeName)
                        }               
                           $DosTypetoUse = $RDBPartition.value.DosType.replace('\','')
                           $MasktoUse = $RDBPartition.value.mask
                           $MaxTransfertoUse = $RDBPartition.value.MaxTransfer 
                           $BufferstoUse = $RDBPartition.value.Buffers
                           if ($RDBPartition.value.NoMount -eq 'True'){
                               $NoMountflagtouse = "--no-mount " #Need space in case some partitions don't have flag
                           }
                           else {
                               $NoMountflagtouse = ""
                           }
                           if ($RDBPartition.value.Bootable -eq 'True'){
                               $bootableflagtouse = "--bootable " #Need space in case some partitions don't have flag
                           }
                           else {
                               $bootableflagtouse = ""
                           }
                           $BootPrioritytouse = $RDBPartition.value.Priority
                           If ($RDBPartition.value.ImportedFilesPath){
                               if (test-path ($RDBPartition.value.ImportedFilesPath)){
                                Write-InformationMessage -Message "Adding command to import files from $($RDBPartition.value.ImportedFilesPath) to RDB Partition $($RDBPartition.value.DeviceName)"
                                   $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk += [PSCustomObject]@{
                                       Command = "fs copy $($RDBPartition.value.ImportedFilesPath) $($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter\rdb\$($RDBPartition.value.DeviceName)"
                                       Sequence = 5      
                                   }  
                               }
                           }
                           Write-InformationMessage -Message "Adding command to create partition for Device:$($RDBPartition.value.DeviceName) of size(bytes):$($RDBPartition.value.PartitionSizeBytes)"
                           $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures += [PSCustomObject]@{
                               Command = "rdb part add `"$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter`" $($RDBPartition.value.DeviceName) $DosTypetoUse $($RDBPartition.value.PartitionSizeBytes) --buffers $bufferstouse --max-transfer $maxtransfertouse --mask $masktouse$nomountflagtouse $bootableflagtouse--boot-priority $BootPrioritytouse"
                               Sequence = 4      
                            }
                            Write-InformationMessage -Message "Adding command to format Device:$($RDBPartition.value.DeviceName) with volume name:$($RDBPartition.value.VolumeName)"
                            $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures += [PSCustomObject]@{
                                Command = "rdb part format `"$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter`" $RDBPartitionCounter $($RDBPartition.value.VolumeName)"
                                Sequence = 4      
                            }
                           $RDBPartitionCounter++   
                    }   
                }
           }
        }  
       $MBRPartitionCounter ++
    }    

}