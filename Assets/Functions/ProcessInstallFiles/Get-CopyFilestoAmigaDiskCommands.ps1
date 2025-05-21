function Get-CopyFilestoAmigaDiskCommands {
    param (
        $OutputLocationType 
    )
    
    $Script:Settings.CurrentSubTaskNumber ++
    $Script:Settings.CurrentSubTaskName = "Getting commands for copying Files to Amiga Partitions" 
    
    Write-StartSubTaskMessage
    
    $HashTableforPathstoRDBPartitions = @{} # Clear Hash

    $Script:GUICurrentStatus.PathstoRDBPartitions | ForEach-Object {
        $HashTableforPathstoRDBPartitions[$_.VolumeName] = @($_.RDBPartitionNumber,$_.DeviceName,$_.MBRPartitionNumber) 
    }
    
    $AmigaDiskstoWrite =  Get-InputCSVs -Diskdefaults | Where-Object {$_.Disk -ne "EMU68BOOT"} | Select-Object 'Disk','DeviceName','VolumeName' 

    $AmigaDiskstoWrite | ForEach-Object {
        if ($HashTableforPathstoRDBPartitions.ContainsKey($_.VolumeName)){
            $MBRNumber = $HashTableforPathstoRDBPartitions.($_.VolumeName)[2]
           # $RDBNumber = $HashTableforPathstoRDBPartitions.($_.VolumeName)[0]
            $RDBDeviceName = $HashTableforPathstoRDBPartitions.($_.VolumeName)[1]
            $DestinationPath = "$($Script:GUIActions.OutputPath)\MBR\$MBRNumber\rdb\$RDBDeviceName"
        }
        $SourcePath = "$([System.IO.Path]::GetFullPath($Script:Settings.InterimAmigaDrives))\$($_.Disk)\`*"
        if (Test-path (Split-Path -Path $SourcePath -Parent)){
            Write-InformationMessage -Message "Adding commands for copying file(s) to $RDBDeviceName for Drive $($_.Disk)"
            $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk += [PSCustomObject]@{
                Command = "fs copy `"$SourcePath`" `"$DestinationPath`"" 
                Sequence = 5
            }
        }
    }

    $HashTableforAmigaDiskstoWrite = @{} # Clear Hash
    $AmigaDiskstoWrite  | ForEach-Object {
        $HashTableforAmigaDiskstoWrite[$_.VolumeName] = @($_.Disk) 
    }

    $DiskIconsPath = [System.IO.Path]::GetFullPath("$($Script:Settings.TempFolder)\IconFiles")
    
    $Script:GUICurrentStatus.PathstoRDBPartitions | ForEach-Object {
        if ($HashTableforAmigaDiskstoWrite.ContainsKey($_.VolumeName)){
            $SourcePath = "$DiskIconsPath\$($HashTableforAmigaDiskstoWrite.($_.VolumeName)[0])Drive\disk.info"
        }
        else {
            $SourcePath = "$DiskIconsPath\WorkDrive\disk.info"
        }
        $DestinationPath = "$($Script:GUIActions.OutputPath)\MBR\$($_.MBRPartitionNumber)\rdb\$($_.DeviceName)"
        Write-InformationMessage -Message "Adding commands for copying icon file(s) to $($_.DeviceName)"
        $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk += [PSCustomObject]@{
            Command = "fs copy $SourcePath $DestinationPath"
            Sequence = 6
        }
       
    }
    
   
}
