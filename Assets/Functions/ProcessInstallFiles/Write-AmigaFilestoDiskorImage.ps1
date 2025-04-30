function Write-AmigaFilestoDiskorImage {
    param (
        $OutputLocationType 
    )
    
    if ($OutputLocationType -eq 'Physical Disk'){
        $PowershellDiskNumber = $Script:GUIActions.OutputPath.Substring(5,($Script:GUIActions.OutputPath.length-5))
        Add-PartitionAccessPath -DiskNumber $PowershellDiskNumber -PartitionNumber 1 -AssignDriveLetter 
        $Emu68BootPath = ((Get-Partition -DiskNumber $PowershellDiskNumber -PartitionNumber 1).DriveLetter)+':\'
    }
    elseif ($OutputLocationType -eq 'Local'){
        
    }

    $DiskIconsPath = [System.IO.Path]::GetFullPath("$($Script:Settings.TempFolder)\IconFiles")

    $Script:Settings.CurrentTaskNumber += 1
    $Script:Settings.CurrentTaskName = "Copying Files to Emu68 Boot Partition"
    
    Write-StartTaskMessage

    $null = Copy-Item "$($Script:Settings.InterimAmigaDrives)\Emu68Boot\*" -Destination $Emu68BootPath -Recurse
    $null = Copy-Item "$DiskIconsPath\Emu68Disk.info" -Destination "$Emu68BootPath\disk.info"

    $Script:Settings.CurrentTaskNumber += 1
    $Script:Settings.CurrentTaskName = "Copying Files to Amiga Partitions"
    
    Write-StartTaskMessage

    $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk.Clear()

    $HashTableforPathstoRDBPartitions = @{} # Clear Hash
    $Script:GUICurrentStatus.PathstoRDBPartitions | ForEach-Object {
        $HashTableforPathstoRDBPartitions[$_.VolumeName] = @($_.RDBPartitionNumber,$_.DeviceName,$_.MBRPartitionNumber) 
    }
    
    $AmigaDiskstoWrite =  Get-InputCSVs -Diskdefaults | Where-Object {$_.DeviceName -ne ""} | Select-Object 'Disk','DeviceName','VolumeName' 

    $AmigaDiskstoWrite | ForEach-Object {
        if ($HashTableforPathstoRDBPartitions.ContainsKey($_.VolumeName)){
            $MBRNumber = $HashTableforPathstoRDBPartitions.($_.VolumeName)[2]
           # $RDBNumber = $HashTableforPathstoRDBPartitions.($_.VolumeName)[0]
            $RDBDeviceName = $HashTableforPathstoRDBPartitions.($_.VolumeName)[1]
            $DestinationPath = "$($Script:GUIActions.OutputPath)\MBR\$MBRNumber\rdb\$RDBDeviceName"
        }
        $SourcePath = [System.IO.Path]::GetFullPath("$($Script:Settings.InterimAmigaDrives)\$($_.Disk)\`*")
        if (Test-Path -Path $SourcePath){
            $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk += "fs copy `"$SourcePath`" `"$DestinationPath`"" 
        }
    }
   
    $HashTableforAmigaDiskstoWrite = @{} # Clear Hash
    $AmigaDiskstoWrite  | ForEach-Object {
        $HashTableforAmigaDiskstoWrite[$_.VolumeName] = @($_.Disk) 
    }

    $Script:GUICurrentStatus.PathstoRDBPartitions | ForEach-Object {
        if ($HashTableforAmigaDiskstoWrite.ContainsKey($_.VolumeName)){
            $SourcePath = "$DiskIconsPath\$($HashTableforAmigaDiskstoWrite.($_.VolumeName)[0])Disk.info"
        }
        else {
            $SourcePath = "$DiskIconsPath\WorkDisk.info"
        }
        $DestinationPath = "$($Script:GUIActions.OutputPath)\MBR\$($_.MBRPartitionNumber)\rdb\$($_.DeviceName)\disk.info"
        $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk  += "fs copy $SourcePath $DestinationPath"
    }
    
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
    
    Write-TaskCompleteMessage
   
}
