function New-DiskorImage {
    param (

    )
    
    # $Script:GUIActions.OutputPath = "C:\Users\Matt\OneDrive\Documents\EmuImager2\UserFiles\SavedOutputImages\test.vhd"

    $OutputLocationType = Confirm-NetworkLocalorDisk -PathtoCheck $Script:GUIActions.OutputPath
    
    $TempFoldertouse = [System.IO.Path]::GetFullPath($Script:Settings.TempFolder)
    $DiskSizeBytestouse = $WPF_DP_Disk_GPTMBR.DiskSizeBytes 
    
    $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage.Clear()
    


    
    # $HSTCommandScriptPath = "$($Script:Settings.TempFolder)\HSTCommandstoRun.txt"
    # if (Test-Path $HSTCommandScriptPath){
    #     $null = Remove-Item -Path $HSTCommandScriptPath
    # }
    
    $Script:Settings.CurrentTaskNumber += 1
    $Script:Settings.CurrentTaskName = "Preparing Commands for setting up image or disk"
    Write-StartTaskMessage

    if ($OutputLocationType -eq 'Local'){
        Write-InformationMessage -Message "Creating a Virtual Image at: $($Script:GUIActions.OutputPath)"
        if (Test-Path $Script:GUIActions.OutputPath){
            $IsMounted = (Get-DiskImage -ImagePath $Script:GUIActions.OutputPath -ErrorAction Ignore).Attached
            if ($IsMounted -eq $true){
                Write-InformationMessage -Message "Dismounting existing image: $($Script:GUIActions.OutputPath)"
                $null = Dismount-DiskImage -ImagePath $Script:GUIActions.OutputPath 
            }
            Write-InformationMessage -Message "Removing existing image: $($Script:GUIActions.OutputPath)"
            $Null = Remove-Item -Path $Script:GUIActions.OutputPath -Force
        }    
        
        $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage += "blank $($Script:GUIActions.OutputPath) $DiskSizeBytestouse"
    }
    elseif ($OutputLocationType -eq 'Physical Disk'){
        $PowershellDiskNumber = $Script:GUIActions.OutputPath.Substring(5,($Script:GUIActions.OutputPath.Length-5))
        $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage += "blank $TempFoldertouse\Clean.vhd 10mb"
        $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage += "write $TempFoldertouse\Clean.vhd $($Script:GUIActions.OutputPath)" 
    }
    else {
        Write-host "Error in Coding - WPF_Window_Button_Run !"
        $WPF_MainWindow.Close()
        exit
    }
    
    $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage += "mbr init $($Script:GUIActions.OutputPath)"

    # if ($HSTCommandstoProcess) {
    #     $HSTCommandstoProcess | Out-File -FilePath $HSTCommandScriptPath -Force
    #     $Logoutput = "$($Script:Settings.TempFolder)\LogOutputTemp.txt"
    #     if ($OutputLocationType -eq 'Local'){
    #         Write-InformationMessage -Message "Creating new disk image at: $($Script:GUIActions.OutputPath) of size(bytes): $($DiskSizeBytestouse)"
    #     }
    #     elseif ($OutputLocationType -eq 'Physical Disk'){
    #         Write-InformationMessage -Message "Running HST Imager to set up disk"
    #     }

    #     & $Script:ExternalProgramSettings.HSTImagerPath script $HSTCommandScriptPath >$Logoutput
    #     if ((Confirm-HSTNoErrors -PathtoLog $Logoutput -HSTImager) -eq $false){
    #         exit
    #     }
    #     $null = Remove-Item $HSTCommandScriptPath -Force
    # }

    Write-TaskCompleteMessage
    
}
