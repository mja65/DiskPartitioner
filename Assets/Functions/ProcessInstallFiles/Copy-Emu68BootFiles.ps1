function Copy-EMU68BootFiles {
    param (
        $OutputLocationType
    )
       
    $Script:Settings.CurrentTaskNumber ++

    if ($OutputLocationType -ne 'ImgImage'){
        $Script:Settings.CurrentTaskName = "Copying Files to Emu68 Boot Partition"
    }
    else {
        $Script:Settings.CurrentTaskName = "Getting commands for copying Files to Emu68 Boot Partition"
    }
    
    Write-StartTaskMessage

    $DiskIconsPath = [System.IO.Path]::GetFullPath("$($Script:Settings.TempFolder)\IconFiles")

    if ($OutputLocationType -eq 'ImgImage'){
        $SourcePath = [System.IO.Path]::GetFullPath("$($Script:Settings.InterimAmigaDrives)\Emu68Boot\`*")
        $DestinationPath = [System.IO.Path]::GetFullPath("$($Script:GUIActions.OutputPath)\MBR\1")
        $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk += [PSCustomObject]@{
            Command = "fs copy $SourcePath $DestinationPath"
            Sequence = 6
        }
        $SourcePath = "$DiskIconsPath\Emu68BootDrive\disk.info" 
        $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk += [PSCustomObject]@{
            Command = "fs copy $SourcePath $DestinationPath"
            Sequence = 6
        }
    }
    else {
        if ($OutputLocationType -eq 'VHDImage') {
            $IsMounted = (Get-DiskImage -ImagePath $Script:GUIActions.OutputPath -ErrorAction Ignore).Attached
                if ($IsMounted -eq $false){
                    $DeviceDetails = Mount-DiskImage -ImagePath $Script:GUIActions.OutputPath -NoDriveLetter
                    $PowershellDiskNumber = $DeviceDetails.Number                
                }
                else {
                    $PowershellDiskNumber = (Get-DiskImage -ImagePath $Script:GUIActions.OutputPath -ErrorAction Ignore).Number
                }
                Add-PartitionAccessPath -DiskNumber $PowershellDiskNumber -PartitionNumber 1 -AssignDriveLetter 
                $Emu68BootPath = "$((Get-Partition -DiskNumber $PowershellDiskNumber -PartitionNumber 1).DriveLetter):\"        
        }
        
        elseif ($OutputLocationType -eq 'Physical Disk'){
            $PowershellDiskNumber = $Script:GUIActions.OutputPath.Substring(5,($Script:GUIActions.OutputPath.length-5))
            $DriveLetterFound = (Get-Partition -DiskNumber $PowershellDiskNumber -PartitionNumber 1).DriveLetter
            if ($DriveLetterFound){
                $Emu68BootPath = "$($DriveLetterFound):\"
            } 
            else {
                Add-PartitionAccessPath -DiskNumber $PowershellDiskNumber -PartitionNumber 1 -AssignDriveLetter 
                $Emu68BootPath = "$((Get-Partition -DiskNumber $PowershellDiskNumber -PartitionNumber 1).DriveLetter):\"            
            }
        }

        if (($OutputLocationType -eq 'Physical Disk') -or ($OutputLocationType -eq 'VHDImage')){
            Set-Volume -DriveLetter $Emu68BootPath.replace(":\","") -NewFileSystemLabel "EMU68BOOT"
        }
        elseif ($OutputLocationType -eq "ImgImage"){
            Set-Fat32VolumeLabel -Path $Script:GUIActions.OutputPath
        }

        $null = Copy-Item "$($Script:Settings.InterimAmigaDrives)\Emu68Boot\*" -Destination $Emu68BootPath -Recurse -force

        $null = Copy-Item $Script:GUIActions.FoundKickstarttoUse.KickstartPath -Destination "$Emu68BootPath\$($Script:GUIActions.FoundKickstarttoUse.Fat32Name)"

        if ($Script:GUIActions.InstallOSFiles -eq $true){
            $null = Copy-Item "$DiskIconsPath\Emu68BootDrive\disk.info" -Destination "$Emu68BootPath"
        }
        else {
            Write-Warning -Message "Not creating disk.info file for Emu68Boot folder as icons not available (you haven't installed an OS)"
        }

    }

}


