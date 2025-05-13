$WPF_Window_Button_Run.Add_Click({
       if ($Script:GUICurrentStatus.FileBoxOpen -eq $true){
        return
    }
   Update-UI -CheckforRunningImage

   if ($Script:GUICurrentStatus.ProcessImageStatus -eq $false){
      Get-IssuesPriortoRunningImage
      return

   }
   elseif ($Script:GUICurrentStatus.ProcessImageStatus -eq $true){
      Get-OptionsBeforeRunningImage
      if ($Script:GUICurrentStatus.ProcessImageConfirmedbyUser -eq $false){
         return
      }
      elseif ($Script:GUICurrentStatus.ProcessImageConfirmedbyUser -eq $true){

        # $Script:GUIActions.OutputType = "Disk"
        # $Script:GUIActions.OutputPath = "\disk6"
        $WPF_MainWindow.Close()
        
        if ($Script:GUICurrentStatus.RunMode -eq 'CommandLine'){
           get-process -id $Pid | set-windowstate -State SHOWDEFAULT
         }

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
         
         if (Get-AllGUIPartitions -partitiontype 'MBR' | Where-Object {$_.value.ImportedPartitionMethod -eq 'Direct'}){
            $PartitionstoImport = $true
         }
         else {
            $PartitionstoImport = $false
         }

         $Script:Settings.TotalNumberofTasks = 22

         if ($PartitionstoImport -eq $true){
            $Script:Settings.TotalNumberofTasks ++
         }

         $Script:Settings.CurrentTaskNumber = 0 

         if ($Script:GUIActions.InstallOSFiles -eq $false){
            Write-AmigaFilestoInterimDrive -DownloadFilesFromInternet # 15 tasks
         }
         elseif ($Script:GUIActions.InstallOSFiles -eq $true){
            Write-AmigaFilestoInterimDrive -DownloadFilesFromInternet -DownloadLocalFiles -ExtractADFFilesandIconFiles -AdjustingScriptsandInfoFiles -ProcessDownloadedFiles -CopyRemainingFiles -wifiprefs
         }

         $Script:Settings.CurrentTaskNumber ++
         $Script:Settings.CurrentTaskName = "Downloading and copying Emu68 Documentation to Amiga Disk"
        
         Write-StartTaskMessage

         if ((Get-Emu68ImagerDocumentation -LocationtoDownload ([System.IO.Path]::GetFullPath("$($Script:Settings.InterimAmigaDrives)\System\PiStorm\Docs\"))) -eq $false){
            Write-ErrorMessage -Message 'Documentation could not be created! You will not be able to access on the Amiga'
         }
        
         Write-TaskCompleteMessage 

         $Script:Settings.CurrentTaskNumber ++
         $Script:Settings.CurrentTaskName = "Preparing Commands for setting up image or disk and running"
        
         Write-StartTaskMessage
         
         $Script:Settings.TotalNumberofSubTasks = 3

         Get-NewDiskorImageCommands -OutputLocationType $OutputTypetoUse #Commands not run yet # 1 task
         
         $Script:Settings.CurrentSubTaskNumber ++
         $Script:Settings.CurrentSubTaskName = "Running HST commands"
         
         Write-StartSubTaskMessage

         if ($OutputTypetoUse -eq "VHDImage"){
            $Message = "Running HST Imager to create image"
            Start-HSTCommands -HSTScript $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage -Message $Message          
         }
                 
         $Script:Settings.CurrentSubTaskNumber ++
         $Script:Settings.CurrentSubTaskName = "Initialising disk"
        
         Write-StartSubTaskMessage

         Initialize-MBRDisk -OutputLocationType $OutputTypetoUse

         if (($OutputTypetoUse -eq "ImgImage") -or ($OutputTypetoUse -eq "Physical Disk")){
            if ($OutputTypetoUse -eq "ImgImage"){
               $Message = "Running HST Imager to create and initialise Image"
            } 
            elseif ($OutputTypetoUse -eq "Physical Disk"){
               $Message = "Running HST Imager to create and initialise Disk"
            }
            Start-HSTCommands -HSTScript $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage -Message "Running HST Imager to create and initialise Image"
         }
    
         Write-TaskCompleteMessage 

         $Script:Settings.CurrentTaskNumber ++
         $Script:Settings.CurrentTaskName = "Setting up Disk or Image and copying files"
         
         Write-StartTaskMessage
         
         $Script:Settings.TotalNumberofSubTasks = 4

         if ($OutputTypetoUse -eq "IMGImage"){
            $Script:Settings.TotalNumberofSubTasks --
         }

         $Script:Settings.CurrentSubTaskNumber = 0

         Get-DiskStructurestoMBRGPTDiskorImageCommands #Commands not run yet

         Get-CopyFilestoAmigaDiskCommands -OutputLocationType $OutputTypetoUse #Commands not run yet

         if (($OutputTypetoUse -eq "Physical Disk") -or ($OutputTypetoUse -eq "VHDImage")){
            $Script:Settings.CurrentSubTaskNumber ++
            $Script:Settings.CurrentTaskName = 'Processing Commands on Disk'

            Write-StartSubTaskMessage

            if ($OutputTypetoUse -eq 'VHDImage'){
               $IsMounted = (Get-DiskImage -ImagePath $Script:GUIActions.OutputPath -ErrorAction Ignore).Attached
               if ($IsMounted -eq $true){
                   Write-InformationMessage -Message "Dismounting existing image: $($Script:GUIActions.OutputPath)"
                   $null = Dismount-DiskImage -ImagePath $Script:GUIActions.OutputPath 
               }
           }

            $HSTCommandstoRun = $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures + $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk
            Start-HSTCommands -HSTScript $HSTCommandstoRun 'Processing commands'
         }

         Copy-EMU68BootFiles -OutputLocationType $OutputTypetoUse #Commands not run yet for IMG
         
         if ($OutputTypetoUse -eq 'VHDImage'){
            $IsMounted = (Get-DiskImage -ImagePath $Script:GUIActions.OutputPath -ErrorAction Ignore).Attached
            if ($IsMounted -eq $true){
                Write-InformationMessage -Message "Dismounting existing image: $($Script:GUIActions.OutputPath)"
                $null = Dismount-DiskImage -ImagePath $Script:GUIActions.OutputPath 
            }
        }         

         if ($OutputTypetoUse -eq "IMGImage"){
            $Script:Settings.CurrentSubTaskNumber ++
            $Script:Settings.CurrentTaskName = 'Processing Commands on Disk'

            Write-StartSubTaskMessage
            $HSTCommandstoRun = $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures + $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk
            Start-HSTCommands -HSTScript $HSTCommandstoRun 'Processing commands'
         }
         
         Write-TaskCompleteMessage 

         if ($PartitionstoImport -eq $true){
            $Script:Settings.CurrentTaskNumber ++
            $Script:Settings.CurrentTaskName = "Importing partitions to disk"
            
            Write-StartTaskMessage

            Write-InformationMessage -Message "This step could take a LONG time depending on the size of the partition!"

            Import-MBRPartitiontoDisk

            Write-TaskCompleteMessage 
         
         }

         $FullListofCommands =   $Script:GUICurrentStatus.HSTCommandstoProcess.ExtractOSFiles +`
                                 $Script:GUICurrentStatus.HSTCommandstoProcess.CopyIconFiles + `
                                 $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage +`
                                 $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures + `
 #                                $Script:GUICurrentStatus.HSTCommandstoProcess.CopyImportedFiles +`
                                 $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk +`
                                 $Script:GUICurrentStatus.HSTCommandstoProcess.AdjustParametersonImportedRDBPartitions                           
                                                      
         $Script:GUICurrentStatus.EndTimeForRunningInstall = (Get-Date -Format HH:mm:ss)
         $ElapsedTime = (New-TimeSpan -Start $Script:GUICurrentStatus.StartTimeForRunningInstall -end $Script:GUICurrentStatus.EndTimeForRunningInstall).TotalSeconds
       
         Write-InformationMessage -Message "Processing Complete!"    
         Write-InformationMessage -message "Started at: $($Script:GUICurrentStatus.StartTimeForRunningInstall) Finished at: $($Script:GUICurrentStatus.EndTimeForRunningInstall). Total time to run (in seconds) was: $ElapsedTime" 
         Write-InformationMessage -message "The tool has finished running. A log file was created and has been stored in the log subfolder."

         Write-InformationMessage -message "The full path to the file is: $([System.IO.Path]::GetFullPath($Script:Settings.LogLocation))"

        "HST imager commands ran:" |Out-File $Script:Settings.LogLocation -Append
         $FullListofCommands| Out-File $Script:Settings.LogLocation -Append

      }
   }
})   


