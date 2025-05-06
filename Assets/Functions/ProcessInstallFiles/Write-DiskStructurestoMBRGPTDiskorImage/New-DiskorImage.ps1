function New-DiskorImage {
    param (

    )
    
    # $Script:GUIActions.OutputPath = "C:\Users\Matt\OneDrive\Documents\EmuImager2\UserFiles\SavedOutputImages\test.vhd"

    $OutputLocationType = Confirm-NetworkLocalorDisk -PathtoCheck $Script:GUIActions.OutputPath
    
    $TempFoldertouse = [System.IO.Path]::GetFullPath($Script:Settings.TempFolder)
    $DiskSizeBytestouse = $WPF_DP_Disk_GPTMBR.DiskSizeBytes 
    
    $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage.Clear()
    
    $Script:Settings.CurrentTaskNumber += 1
    $Script:Settings.CurrentTaskName = "Preparing Commands for setting up image or disk"
    Write-StartTaskMessage

    if ($OutputLocationType -eq 'Local'){
        Write-InformationMessage -Message "Virtualised disk being used"
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
        
        $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage += [PSCustomObject]@{
            Command = "blank $($Script:GUIActions.OutputPath) $DiskSizeBytestouse"
            Sequence = 1           
         }
   
    }
    elseif ($OutputLocationType -eq 'Physical Disk'){
        Write-InformationMessage -Message "Physical disk being used"
      #  $PowershellDiskNumber = $Script:GUIActions.OutputPath.Substring(5,($Script:GUIActions.OutputPath.Length-5))
        Write-InformationMessage -Message 'Adding commands to wipe disk'
        $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage += [PSCustomObject]@{
            Command = "blank $TempFoldertouse\Clean.vhd 10mb"
            Sequence = 1
        }
        $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage += [PSCustomObject]@{
            Command = "write $TempFoldertouse\Clean.vhd $($Script:GUIActions.OutputPath)" 
            Sequence = 2 
        }
    }
    else {
        Write-host "Error in Coding - WPF_Window_Button_Run !"
        $WPF_MainWindow.Close()
        exit
    }
    Write-InformationMessage -Message 'Adding command to initialise disk'
    $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage += [PSCustomObject]@{
        Command = "mbr init $($Script:GUIActions.OutputPath)"
        Sequence = 3           
     }

    Write-TaskCompleteMessage
    
}
