function Get-CopyFilestoAmigaDiskCommands {
    param (
        $OutputLocationType 
    )
    
    $Script:Settings.CurrentTaskNumber += 1
    $Script:Settings.CurrentTaskName = "Copying Files to Amiga Partitions"
    
    Write-StartTaskMessage

    $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk.Clear()

    if ($OutputLocationType -eq 'VHDImage'){
        $IsMounted = (Get-DiskImage -ImagePath $Script:GUIActions.OutputPath -ErrorAction Ignore).Attached
        if ($IsMounted -eq $true){
            Write-InformationMessage -Message "Dismounting existing image: $($Script:GUIActions.OutputPath)"
            $null = Dismount-DiskImage -ImagePath $Script:GUIActions.OutputPath 
        }
    }

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

    $Script:GUICurrentStatus.PathstoRDBPartitions | ForEach-Object {
        if ($HashTableforAmigaDiskstoWrite.ContainsKey($_.VolumeName)){
            $SourcePath = "$DiskIconsPath\$($HashTableforAmigaDiskstoWrite.($_.VolumeName)[0])Disk.info"
        }
        else {
            $SourcePath = "$DiskIconsPath\WorkDisk.info"
        }
        $DestinationPath = "$($Script:GUIActions.OutputPath)\MBR\$($_.MBRPartitionNumber)\rdb\$($_.DeviceName)\disk.info"
        $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk += [PSCustomObject]@{
            Command = "fs copy $SourcePath $DestinationPath"
            Sequence = 6
        }
       
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
