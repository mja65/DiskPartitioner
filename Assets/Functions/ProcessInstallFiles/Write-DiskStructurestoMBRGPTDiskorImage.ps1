function Write-DiskStructurestoMBRGPTDiskorImage {
    param (
        $OutputLocationType 
    )

    New-DiskorImage
    
    $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures.Clear()
    
    if ($OutputLocationType -eq 'Local'){}
    elseif ($OutputLocationType -eq 'Physical Disk'){
        $PowershellDiskNumber = $Script:GUIActions.OutputPath.Substring(5,($Script:GUIActions.OutputPath.length-5))
    }

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

    $MBRPartitionCounter = 1
    
    $Script:Settings.CurrentTaskNumber += 1
    $Script:Settings.CurrentTaskName = "Setting up Disk or Image"
    
    Write-StartTaskMessage
    
    $Script:Settings.TotalNumberofSubTasks = 3
    
    $Script:Settings.CurrentSubTaskNumber = 1
    $Script:Settings.CurrentSubTaskName = "Initialising Image"
    
    Write-StartSubTaskMessage
    
    #Initialize-Disk -Number $PowershellDiskNumber -PartitionStyle MBR -ErrorAction Ignore
    
    $EndPreviousPartitionBytes = $null
    
    $Script:Settings.CurrentSubTaskNumber = 2
    $Script:Settings.CurrentSubTaskName = "Creating MBR Partitions"
    
    Write-StartSubTaskMessage
    
    foreach ($MBRPartition in $MBRPartitionstoAddtoDisk) {
        if ($MBRPartition.PartitionSubType -eq 'FAT32'){
            $PartitionTypetoUse = "0xb"
    
        }
        elseif ($MBRPartition.PartitionSubType -eq 'ID76'){
            $PartitionTypetoUse = "0x76"            
        }
    
        $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures += "mbr part add $($Script:GUIActions.OutputPath) $PartitionTypetoUse $($MBRPartition.partitionsizebytes)"
    }
    
    $Script:Settings.CurrentSubTaskNumber = 3
    $Script:Settings.CurrentSubTaskName = "Importing MBR Partitions"
    
    Write-StartSubTaskMessage

    $MBRPartitionCounter = 1
    
    foreach ($MBRPartition in $MBRPartitionstoAddtoDisk) {
        if ($MBRPartition.ImportedPartition -eq 'TRUE' -and $MBRPartition.ImportedPartitionMethod -eq 'Direct'){
            $Startpoint = $MBRPartition.ImportedPartitionPath.IndexOf("\MBR\")
            $SubstringLength = $MBRPartition.ImportedPartitionPath.length-($Startpoint+5)
            $MBRPartitionNumbertoImport = $MBRPartition.ImportedPartitionPath.Substring(($Startpoint+5),$SubstringLength)
            $PathofImage = $MBRPartition.ImportedPartitionPath.Substring(0,$Startpoint)
            $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures += "mbr part clone $PathofImage $MBRPartitionNumbertoImport $($Script:GUIActions.OutputPath) $MBRPartitionCounter"
        }
        $MBRPartitionCounter ++   
    }

    $Script:Settings.CurrentSubTaskNumber = 4
    $Script:Settings.CurrentSubTaskName = "Creating RDB Partitions"

    Write-StartSubTaskMessage
    
    $FileSystemstoAdd = [System.Collections.Generic.List[PSCustomObject]]::New()

    Write-InformationMessage -Message "Determining Filesystems to add to disk"

    foreach ($RDBPartition in $RDBPartitionstoAddtoDisk){        
        $FileSystemstoAdd  += [PSCustomObject]@{
            GPTMBRPartition = $RDBPartition.name.Substring(0,($RDBPartition.name.IndexOf('_AmigaDisk_Partition_')))
            DosType = $RDBPartition.Value.DosType
            FileSystemPath = $null
        }
    }
   
   $FileSystemstoAdd = $FileSystemstoAdd | Select-Object 'GPTMBRPartition','DosType','FileSystemPath' -Unique

   $HashTableforFileSystemPath = @{} # Clear Hash
   Get-AvailableAmigaFileSystems -FilesystemsbyDosTypesFLAG | ForEach-Object {
       $HashTableforFileSystemPath[$_.DosType] = @($_.Filesystempath)
   }
    
   $FileSystemstoAdd | ForEach-Object {
       if ($HashTableforFileSystemPath.ContainsKey($_.DosType)){
           $_.FileSystemPath = $HashTableforFileSystemPath.($_.DosType)[0]
       }
   }

    Write-InformationMessage -Message "Preparing HST Commands to run"
  
   $Script:GUICurrentStatus.PathstoRDBPartitions.Clear()
   
   $MBRPartitionCounter = 1
  
   foreach ($MBRPartition in $MBRPartitionstoAddtoDisk) {
       if ($MBRPartition.PartitionSubType -eq 'ID76'){
           $RDBPartitionCounter = 1       
           Write-InformationMessage -Message "Preparing commands for $($MBRPartition.PartitionName) - MBR Partition Number: $MBRPartitionCounter"
           if ($MBRPartition.ImportedPartition -ne 'True'){
               $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures += "rdb init $($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter"
               foreach ($FileSystem in $FileSystemstoAdd){
                   if ($FileSystem.GPTMBRPartition -eq $MBRPartition.PartitionName){
                    $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures += "rdb fs add `"$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter`" $($FileSystem.FileSystemPath) $DosTypetoUse"                                                                      
                   }               
               }
               foreach ($RDBPartition in $RDBPartitionstoAddtoDisk) {
                    if (($RDBPartition.Name -split '_AmigaDisk_')[0] -eq $MBRPartition.PartitionName){
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
                           if (test-path ($RDBPartition.value.ImportedFilesPath)){
                               $Script:GUICurrentStatus.HSTCommandstoProcess.CopyImportedFiles += "fs copy $($RDBPartition.value.ImportedFilesPath) $($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter\rdb\$($RDBPartition.value.DeviceName)"
                           }                                                   
                           $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures += "rdb part add `"$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter`" $($RDBPartition.value.DeviceName) $DosTypetoUse $($RDBPartition.value.PartitionSizeBytes) --buffers $bufferstouse --max-transfer $maxtransfertouse --mask $masktouse$nomountflagtouse $bootableflagtouse--boot-priority $BootPrioritytouse"
                           $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures += "rdb part format `"$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter`" $RDBPartitionCounter $($RDBPartition.value.VolumeName)"
                           $RDBPartitionCounter++   
                    }   
                }
           }
        }  
       $MBRPartitionCounter ++
    }    

}






    #     $IsMounted = (Get-DiskImage -ImagePath $Script:GUIActions.OutputPath -ErrorAction Ignore).Attached
    #     if ($IsMounted -eq $false){
    #         Write-InformationMessage -Message "Mounting image: $($Script:GUIActions.OutputPath)"
    #         $DeviceDetails = Mount-DiskImage -ImagePath $Script:GUIActions.OutputPath -NoDriveLetter
    #         $PowershellDiskNumber = $DeviceDetails.Number
    #     }
     

    


#    if ($HSTCommandstoProcess) {
#        $HSTCommandstoProcess | Out-File -FilePath $HSTCommandScriptPath -Force
#        $Logoutput = "$($Script:Settings.TempFolder)\LogOutputTemp.txt"
#        Write-InformationMessage -Message "Creating new RDB disk and partitions"
#        & $Script:ExternalProgramSettings.HSTImagerPath script $HSTCommandScriptPath >$Logoutput
#        if ((Confirm-HSTNoErrors -PathtoLog $Logoutput -HSTImager) -eq $false){
#            exit
#        }
#        $null = Remove-Item $HSTCommandScriptPath -Force
#    }
  
#     if ($OutputLocationType -eq 'Local'){
#         $IsMounted = (Get-DiskImage -ImagePath $Script:GUIActions.OutputPath -ErrorAction Ignore).Attached
#         if ($IsMounted -eq $true){
#             Write-InformationMessage -Message "Dismounting existing image: $($Script:GUIActions.OutputPath)"
#             $null = Dismount-DiskImage -ImagePath $Script:GUIActions.OutputPath 
#         }
#     }

 #   Write-TaskCompleteMessage
#}

# if ($HSTCommandstoProcess) {
#     $HSTCommandstoProcess | Out-File -FilePath $HSTCommandScriptPath -Force
#     $Logoutput = "$($Script:Settings.TempFolder)\LogOutputTemp.txt"
#     Write-InformationMessage -Message "Creating new RDB disk and partitions"
#     & $Script:ExternalProgramSettings.HSTImagerPath script $HSTCommandScriptPath >$Logoutput
#     if ((Confirm-HSTNoErrors -PathtoLog $Logoutput -HSTImager) -eq $false){
#         exit
#     }
#     $null = Remove-Item $HSTCommandScriptPath -Force
# }



#    #     if ($MBRPartition.ImportedPartition -ne 'TRUE' -and $MBRPartition.ImportedPartitionMethod -ne 'Direct'){
#     Write-InformationMessage -Message "MBR Partition: $MBRPartitionCounter Creating Partition: $($MBRPartition.PartitionName) of type $($MBRPartition.PartitionSubType)"
#     if (($EndPreviousPartitionBytes) -and ($MBRPartition.StartingPositionBytes -ne $EndPreviousPartitionBytes)){
#         $OffsetBytes = $MBRPartition.StartingPositionBytes
#         Write-InformationMessage -Message "Setting $($MBRPartition.PartitionName) offset of: $OffsetBytes"
#         $Script:GUICurrentStatus.HSTCommandstoProcess += "mbr part add $($Script:GUIActions.OutputPath)"
#     }
#     else {
#         $null = $OffsetBytes
#     }
#     if ((Get-Variable -Name $MBRPartition.PartitionName).Value.PartitionType -eq 'MBR'){
#         Write-InformationMessage -Message 'Adding MBR Partition'
#         Add-MBRPartitiontoDisk -DiskNumber $PowershellDiskNumber -MBRPartitionType $MBRPartition.PartitionSubtype -SizeBytes $MBRPartition.PartitionSizeBytes -OffsetBytes $OffsetBytes -VolumeName (Get-Variable -Name $MBRPartition.PartitionName).Value.VolumeName -ImportedPartition (Get-Variable -Name $MBRPartition.PartitionName).Value.ImportedPartition
#     }
# #      }
# $EndPreviousPartitionBytes = $_.EndingPositionBytes
# $MBRPartitionCounter ++            
# }


# $WPF_DP_Partition_MBR_2_AmigaDisk_Partition_2

#         if ($RDBPartition.value.name -match $_.value.PartitionName){

#         foreach ($RDBPartition in $RDBPartitionstoAddtoDisk) {
#             if $RDBPartition.name
#         }
#     }

#     foreach ($MBRPartition in $MBRPartitionstoAddtoDisk | where  ) {
#         foreach ($RDBPartition in $RDBPartitionstoAddtoDisk) {
#             $HSTCommandstoProcess += "rdb part add `"$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter`" $($RDBPartition.value.DeviceName) $($RDBPartition.value.DosType.replace('\','')) $($RDBPartition.value.PartitionSizeBytes)"
#         }         
#     }

# }

# $RDBPartitionstoAddtoPartition = $RDBPartitionstoAddtoDisk | Where-Object {$_.name -match $MBRPartition.Value.PartitionName}


# elseif ($OutputLocationType -eq 'Physical Disk') {
#     $HSTCommandstoProcess = @()
    
#     if (Test-Path $HSTCommandScriptPath){
#         $null = Remove-Item -Path $HSTCommandScriptPath
#     }

#     foreach ($MBRPartition in $MBRPartitionstoAddtoDisk) {
#         if ((Get-Variable -Name $MBRPartition.PartitionName).Value.PartitionSubType -eq 'ID76'){
#             if ((Get-Variable -Name $MBRPartition.PartitionName).Value.ImportedPartition -ne $True){
#                 $RDBPartitionstoAddtoPartition = $RDBPartitionstoAddtoDisk | Where-Object {$_.name -match $MBRPartition.Value.PartitionName}
#                 $HSTCommandstoProcess += Initialize-RDB -Path "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter"               
#                 $RDBPartitionstoAddtoPartition.value.DosType | Select-Object $_  -Unique | ForEach-Object {
#                     $HSTCommandstoProcess += Add-RDBFileSystem -Path "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter" -DosType $_                  
#                 }
#                 $RDBPartitionCounter = 1 
#                 foreach ($RDBPartition in $RDBPartitionstoAddtoPartition) {               
#                     $HSTCommandstoProcess += Add-RDBPartitiontoDisk -Path "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter" -Name $RDBPartition.value.DeviceName -DosType $RDBPartition.value.DosType -SizeBytes $RDBPartition.value.PartitionSizeBytes
#                     $HSTCommandstoProcess += Format-RDBPartition -Path "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter" -PartitionNumber $RDBPartitionCounter -Name $RDBPartition.value.VolumeName
#                     if ($RDBPartition.Value.ImportedFiles){
#                         foreach ($File in $RDBPartition.Value.ImportedFiles) {
#                             $HSTCommandstoProcess += Copy-FileToRDBPartition -SourcePath $File.FullPath -DestinationPath "$($Script:GUIActions.OutputPath)\mbr\$MBRPartitionCounter\rdb\$($RDBPartition.value.DeviceName)"
                            
#                         }
#                     }
                    
#                     $RDBPartitionCounter ++
#                 }
#             }
#             else{
#                 $HSTCommandstoProcess += Copy-MBRPartitiontoDisk -SourcePath $MBRPartition.value.ImportedPartitionPath -SourcePartitionNumber $MBRPartition.value.ImportedPartitionPath.ImportedMBRPartitionNumber -DestinationPath $Script:GUIActions.OutputPath -DestinationPartitionNumber $MBRPartitionCounter -SizeBytes $MBRPartition.value.PartitionSizeBytes
#             }
#         }
#         $MBRPartitionCounter ++
#     }
    
#     if ($HSTCommandstoProcess) {
#         $HSTCommandstoProcess | Out-File -FilePath $HSTCommandScriptPath -Force
#         $Logoutput = "$($Script:Settings.TempFolder)\LogOutputTemp.txt"
#         if ($OutputLocationType -eq 'Local'){
#             Write-InformationMessage -Message "Creating new disk image at: $($Script:GUIActions.OutputPath) of size(bytes): $($DiskSizeBytestouse)"
#         }
#         Write-InformationMessage -Message "Running HST Imager to set up disk"
#         & $Script:ExternalProgramSettings.HSTImagerPath script $HSTCommandScriptPath >$Logoutput
#         if ((Confirm-HSTNoErrors -PathtoLog $Logoutput -HSTImager) -eq $false){
#             exit
#         }
#         $null = Remove-Item $HSTCommandScriptPath -Force
#     }
# }    