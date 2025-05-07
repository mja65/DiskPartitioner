$WPF_Window_Button_Run.Add_Click({
   
   Update-UI -CheckforRunningImage

   if ($Script:GUICurrentStatus.ProcessImageStatus -eq $false){
      Get-IssuesPriortoRunningImage

   }
   elseif ($Script:GUICurrentStatus.ProcessImageStatus -eq $true){
      Get-OptionsBeforeRunningImage
      if ($Script:GUICurrentStatus.ProcessImageConfirmedbyUser -eq $true){

         $Script:GUICurrentStatus.StartTimeForRunningInstall = (Get-Date -Format HH:mm:ss)

         Write-InformationMessage "Started processing at: $($Script:GUICurrentStatus.StartTimeForRunningInstall)"

         if ($Script:GUIActions.OutputType -eq 'Image' -and ($Script:GUIActions.OutputPath.Substring($Script:GUIActions.OutputPath.Length-3) -eq 'vhd')){
            $OutputTypetoUse = 'VHDImage'
         }
         elseif ($Script:GUIActions.OutputType -eq 'Image' -and ($Script:GUIActions.OutputPath.Substring($Script:GUIActions.OutputPath.Length-3) -eq 'img')){
            $OutputTypetoUse = 'ImgImage'            
         }
         elseif ($Script:GUIActions.OutputType -eq 'Disk'){
            $OutputTypetoUse = "Physical Disk"
         }
         
         if ($Script:GUIActions.InstallOSFiles -eq $false){
            Write-AmigaFilestoInterimDrive -DownloadFilesFromInternet
         }
         elseif ($Script:GUIActions.InstallOSFiles -eq $true){
            Write-AmigaFilestoInterimDrive -DownloadFilesFromInternet -DownloadLocalFiles -ExtractADFFilesandIconFiles -AdjustingScriptsandInfoFiles -ProcessDownloadedFiles -CopyRemainingFiles
         }

         Get-NewDiskorImageCommands -OutputLocationType $OutputTypetoUse #Commands not run yet

         if (($OutputTypetoUse -eq "Physical Disk") -or ($OutputTypetoUse -eq "VHDImage")){
            if ($OutputTypetoUse -eq "Physical Disk"){
               $Message = "Running HST Imager to wipe disk of any existing partitions"
            } 
            elseif ($OutputTypetoUse -eq "VHDImage"){
               $Message = "Running HST Imager to create image"
            }
            Start-HSTCommands -HSTScript $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage -Message $Message          
         }

         Initialize-MBRDisk -OutputLocationType $OutputTypetoUse

         if ($OutputTypetoUse -eq "ImgImage"){
            Start-HSTCommands -HSTScript $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage -Message "Running HST Imager to create and initialise Image"
         } 
    
         Get-DiskStructurestoMBRGPTDiskorImageCommands #Commands not run yet

         Get-CopyFilestoAmigaDiskCommands -OutputLocationType $OutputTypetoUse #Commands not run yet

         if (($OutputTypetoUse -eq "Physical Disk") -or ($OutputTypetoUse -eq "VHDImage")){
            $HSTCommandstoRun = $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures + $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk
            Start-HSTCommands -HSTScript $HSTCommandstoRun 'Doing shit'
         }

         Copy-EMU68BootFiles -OutputLocationType $OutputTypetoUse #Commands not run yet for IMG

         if ($OutputTypetoUse -eq "IMGImage"){
            $HSTCommandstoRun = $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures + $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk
            Start-HSTCommands -HSTScript $HSTCommandstoRun 'Doing shit'
         }

         $Script:GUICurrentStatus.EndTimeForRunningInstall = (Get-Date -Format HH:mm:ss)
         $ElapsedTime = (New-TimeSpan -Start $Script:GUICurrentStatus.StartTimeForRunningInstall -end $Script:GUICurrentStatus.EndTimeForRunningInstall).TotalSeconds
       
         Write-InformationMessage -Message "Processing Complete!"    
         Write-InformationMessage -message "Started at: $($Script:GUICurrentStatus.StartTimeForRunningInstall) Finished at: $($Script:GUICurrentStatus.EndTimeForRunningInstall). Total time to run (in seconds) was: $ElapsedTime" 
         Write-InformationMessage -message "The tool has finished running. A log file was created and has been stored in the log subfolder."
         Write-InformationMessage -message "The full path to the file is: $([System.IO.Path]::GetFullPath($Script:Settings.LogLocation))"

      }
   }
})   


