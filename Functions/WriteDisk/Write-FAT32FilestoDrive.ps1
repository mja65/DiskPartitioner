function Write-FAT32FilestoDrive {
    param (
       
    )
    
    if ((Confirm-NetworkLocalorDisk -PathtoCheck $Script:GUIActions.OutputPath) -eq 'Physical Disk'){
        Write-Host 'Not built!!'
    }
    elseif ((Confirm-NetworkLocalorDisk -PathtoCheck $Script:GUIActions.OutputPath) -eq 'Local'){
        $null = Dismount-DiskImage -ImagePath $Script:GUIActions.OutputPath
        $DeviceDetails = Mount-DiskImage -ImagePath $Script:GUIActions.OutputPath
        $PowershellDiskNumber = $DeviceDetails.Number
        $Fat32DrivePath = ((Get-Partition -DiskNumber $PowershellDiskNumber -PartitionNumber 1).DriveLetter)+':'
    
    }
    
    $null = copy-Item "$($Script:ExternalProgramSettings.TempFolder)\Emu68Downloads\Emu68Pistorm\*" -Destination "$Fat32DrivePath\"
    $null = copy-Item "$($Script:ExternalProgramSettings.TempFolder)\Emu68Downloads\Emu68Pistorm32lite\*" -Destination "$Fat32DrivePath\"
    $null= Remove-Item "$Fat32DrivePath\config.txt" 
    $null = copy-Item "$($Script:Settings.LocationofAmigaFiles)\FAT32\ps32lite-stealth-firmware.gz" -Destination "$Fat32DrivePath\"
    
    if (-not (Test-Path "$Fat32DrivePath\Kickstarts")){
        $null = New-Item -path "$Fat32DrivePath\Kickstarts" -ItemType Directory -Force
    }
    
    if (-not (Test-Path "$Fat32DrivePath\Install")){
        $null = New-Item -path "$Fat32DrivePath\Install" -ItemType Directory -Force
    }
    
    Write-InformationMessage -Message 'Copying Cmdline.txt' 
    
    Copy-Item "$($Script:Settings.LocationofAmigaFiles)\FAT32\cmdline_$($Script:GUIActions.KickstartVersiontoUse).txt" -Destination "$Fat32DrivePath\cmdline.txt" 
    
    Write-InformationMessage -Message 'Preparing Config.txt'
    
    $ConfigTxt = Get-Content -Path "$($Script:Settings.LocationofAmigaFiles)\FAT32\config.txt"
    
    $RevisedConfigTxt=$null
    
    foreach ($AvailableScreenMode in $Script:GUIActions.AvailableScreenModes){
        if ($AvailableScreenMode.Name -eq  $Script:GUIActions.ScreenModetoUse){
            $AvailableScreenMode.Selected = $true
        }
    }
    
    foreach ($Line in $ConfigTxt) {
        if ($line -eq '[ROMPATH]'){
            $RevisedConfigTxt += "initramfs $($Script:GUIActions.FoundKickstarttoUse.Fat32Name)`n"
    
        }
        elseif ($line -eq '[VIDEOMODES]'){
            $RevisedConfigTxt += "# The following section defines the screenmode for your monitor for output from the Raspberry Pi. If you wish to `n"
            $RevisedConfigTxt += "# select a different screenmode you can comment out the existing mode and remove the comment marks from the new one.`n"
            foreach ($AvailableScreenMode in ($AvailableScreenModes | Sort-Object -Property 'Selected' -Descending)){
                if ($AvailableScreenMode.Selected -eq $true){
                    $RevisedConfigTxt += "`n"
                    $RevisedConfigTxt += "# ScreenMode: $($AvailableScreenMode.FriendlyName) (Currently Selected)`n"
                    if (-not ($AvailableScreenMode.hdmi_group.Length -eq 0)){
                        $RevisedConfigTxt += "hdmi_group=$($AvailableScreenMode.hdmi_group)`n"
                    }
                    if (-not ($AvailableScreenMode.hdmi_mode.Length -eq 0)){
                        $RevisedConfigTxt += "hdmi_mode=$($AvailableScreenMode.hdmi_mode)`n"
                    }
                    if (-not ($AvailableScreenMode.hdmi_cvt.length -eq 0)){
                        $RevisedConfigTxt += "hdmi_cvt=$($AvailableScreenMode.hdmi_cvt)`n"
                    }
                    if (-not ($AvailableScreenMode.max_framebuffer_width.length -eq 0)){
                        $RevisedConfigTxt += "max_framebuffer_width=$($AvailableScreenMode.max_framebuffer_width)`n"
                    }
                    if (-not ($AvailableScreenMode.max_framebuffer_height.length -eq 0)){
                        $RevisedConfigTxt += "max_framebuffer_height=$($AvailableScreenMode.max_framebuffer_height)`n"
                    }
                    if (-not ($AvailableScreenMode.hdmi_pixel_freq_limit.length -eq 0)){
                        $RevisedConfigTxt += "hdmi_pixel_freq_limit=$($AvailableScreenMode.hdmi_pixel_freq_limit)`n"
                    }
                    if (-not ($AvailableScreenMode.disable_overscan.length -eq 0)){
                        $RevisedConfigTxt += "disable_overscan=$($AvailableScreenMode.disable_overscan)`n"
                    }
                }
                else{
                    $RevisedConfigTxt += "`n"
                    $RevisedConfigTxt += "# ScreenMode: $($AvailableScreenMode.FriendlyName)`n"
                    if (-not ($AvailableScreenMode.hdmi_group.Length -eq 0)){
                        $RevisedConfigTxt +="# hdmi_group=$($AvailableScreenMode.hdmi_group)`n"
                    }
                    if (-not ($AvailableScreenMode.hdmi_mode.Length -eq 0)){
                        $RevisedConfigTxt += "# hdmi_mode=$($AvailableScreenMode.hdmi_mode)`n"
                    }
                    if (-not ($AvailableScreenMode.hdmi_cvt.length -eq 0)){
                        $RevisedConfigTxt += "# hdmi_cvt=$($AvailableScreenMode.hdmi_cvt)`n"
                    }
                    if (-not ($AvailableScreenMode.max_framebuffer_width.length -eq 0)){
                        $RevisedConfigTxt += "# max_framebuffer_width=$($AvailableScreenMode.max_framebuffer_width)`n"
                    }
                    if (-not ($AvailableScreenMode.max_framebuffer_height.length -eq 0)){
                        $RevisedConfigTxt += "# max_framebuffer_height=$($AvailableScreenMode.max_framebuffer_height)`n"
                    }
                    if (-not ($AvailableScreenMode.hdmi_pixel_freq_limit.length -eq 0)){
                        $RevisedConfigTxt += "# hdmi_pixel_freq_limit=$($AvailableScreenMode.hdmi_pixel_freq_limit)`n"
                    }
                    if (-not ($AvailableScreenMode.disable_overscan.length -eq 0)){
                        $RevisedConfigTxt += "# disable_overscan=$($AvailableScreenMode.disable_overscan)`n"
                    }            
                }            
            }
        }
        else{
            $RevisedConfigTxt += "$Line`n"
        }    
    }
    Export-TextFileforAmiga -DatatoExport $RevisedConfigTxt -ExportFile "$Fat32DrivePath\config.txt" -AddLineFeeds 'TRUE' 
     
    Write-InformationMessage -Message 'Copying Kickstart file to FAT32 partition'
    $null = copy-Item -LiteralPath $Script:GUIActions.FoundKickstarttoUse.KickstartPath -Destination "$Fat32DrivePath\$($Script:GUIActions.FoundKickstarttoUse.Fat32Name)"
}


