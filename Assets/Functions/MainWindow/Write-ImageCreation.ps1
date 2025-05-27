function Write-ImageCreation {
    param (
  
    )
    
    if ($Script:GUICurrentStatus.RunMode -eq 'CommandLine'){
       get-process -id $Pid | set-windowstate -State SHOWDEFAULT
     }

     $Script:GUICurrentStatus.ProgressBarMarkers = $Script:Settings.ProgressBarMarkers | Where-Object {(([System.Version]$Script:GUIActions.KickstartVersiontoUse).Major -eq ([System.Version]$_.KickstartVersion).major -and ([System.Version]$Script:GUIActions.KickstartVersiontoUse).Minor -eq ([System.Version]$_.KickstartVersion).Minor)}
  
     $fileCount = 0
     
     $Script:GUICurrentStatus.AmigaPartitionsandBoundaries | ForEach-Object {
        if ($_.Partition.ImportedFilesPath){
           $fileCount += (Get-ChildItem -Path $_.value.ImportedFilesPath -File -Recurse).Count
         }
      }

      $Script:GUICurrentStatus.ProgressBarMarkers.WriteFilestoDisk += $fileCount
      
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
     
     if ($Script:GUICurrentStatus.GPTMBRPartitionsandBoundaries | Where-Object {$_.Partition.ImportedPartitionMethod -eq 'Direct'}){
        $PartitionstoImport_Direct = $true
     }
     else {
        $PartitionstoImport_Direct = $false
     }
     
     if ($Script:GUICurrentStatus.GPTMBRPartitionsandBoundaries | Where-Object {$_.Partition.ImportedPartitionMethod -eq 'Derived'}){
        $PartitionstoImport_Derived = $true
     }
     else {
        $PartitionstoImport_Derived = $false
     }

     $Script:Settings.TotalNumberofTasks = 22

     if ($PartitionstoImport_Direct -eq $true){
        $Script:Settings.TotalNumberofTasks ++
     }
     
     if ($PartitionstoImport_Derived -eq $true){
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
        Start-HSTCommands -HSTScript $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage -Section "NewDiskorImage" -ActivityDescription $Message -ReportTime -TotalSteps 7 -ReportActualSteps       
     }
             
     $Script:Settings.CurrentSubTaskNumber ++
     $Script:Settings.CurrentSubTaskName = "Initialising disk"
    
     Write-StartSubTaskMessage

     Initialize-MBRDisk -OutputLocationType $OutputTypetoUse

     if (($OutputTypetoUse -eq "ImgImage") -or ($OutputTypetoUse -eq "Physical Disk")){
        if ($OutputTypetoUse -eq "ImgImage"){
           $Message = "Running HST Imager to create and initialise Image"
           $totalsteps = 10
        } 
        elseif ($OutputTypetoUse -eq "Physical Disk"){
           $Message = "Running HST Imager to create and initialise Disk"
           $totalsteps = 20
        }
        Start-HSTCommands -HSTScript $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage -Section "NewDiskorImage" -ActivityDescription $Message -ReportTime -TotalSteps $totalsteps -ReportActualSteps
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

     # if ($Script:GUIActions.InstallOSFiles -eq $true){
     #    $Script:Settings.CurrentTaskNumber ++
     #    $Script:Settings.CurrentTaskName = "Setting Icon Positions"
     #    Write-StartTaskMessage

     #    Write-IconPositions

     #    Write-TaskCompleteMessage 
     # }         

     Get-CopyFilestoAmigaDiskCommands -OutputLocationType $OutputTypetoUse #Commands not run yet

     if (($OutputTypetoUse -eq "Physical Disk") -or ($OutputTypetoUse -eq "VHDImage")){
        $Script:Settings.CurrentSubTaskNumber ++
        $Script:Settings.CurrentSubTaskName = "Processing Commands on Disk (this may take a few minutes depending on the size of your disk)"

        Write-StartSubTaskMessage

        if ($OutputTypetoUse -eq 'VHDImage'){
           $IsMounted = (Get-DiskImage -ImagePath $Script:GUIActions.OutputPath -ErrorAction Ignore).Attached
           if ($IsMounted -eq $true){
               Write-InformationMessage -Message "Dismounting existing image: $($Script:GUIActions.OutputPath)"
               $null = Dismount-DiskImage -ImagePath $Script:GUIActions.OutputPath 
           }
       }

        $HSTCommandstoRun = $Script:GUICurrentStatus.HSTCommandstoProcess.DiskStructures + $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk
        Start-HSTCommands -HSTScript $HSTCommandstoRun -Section "DiskStructures;WriteFilestoDisk" -ActivityDescription "Processing commands (this may take a few minutes depending on the size of your disk)" -ReportActualSteps -ReportTime
        #"Processing commands (this may take a few minutes depending on the size of your disk)"
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
        Start-HSTCommands -HSTScript $HSTCommandstoRun -Section "DiskStructures;WriteFilestoDisk" -ActivityDescription 'Processing commands' -ReportActualSteps -ReportTime
     }
     
     Write-TaskCompleteMessage 

     if ($PartitionstoImport_Direct -eq $true){
        $Script:Settings.CurrentTaskNumber ++
        $Script:Settings.CurrentTaskName = "Importing partitions to disk"
        
        Write-StartTaskMessage

        Write-InformationMessage -Message "This step could take a LONG time depending on the size of the partition!"

        Import-MBRPartitiontoDisk

        Write-TaskCompleteMessage 
     
     }

   #   if ($PartitionstoImport_Derived -eq $true){
   #      Import-RDBPartitiontoDisk     
   #   }
     
     if ($OutputTypetoUse -eq 'VHDImage'){
        $IsMounted = (Get-DiskImage -ImagePath $Script:GUIActions.OutputPath -ErrorAction Ignore).Attached
        if ($IsMounted -eq $true){
           Write-InformationMessage -Message "Dismounting existing image: $($Script:GUIActions.OutputPath)"
           $null = Dismount-DiskImage -ImagePath $Script:GUIActions.OutputPath 
         }
      }
           
     $HSTCommandstoRun = $Script:GUICurrentStatus.HSTCommandstoProcess.AdjustParametersonImportedRDBPartition
     if ($HSTCommandstoRun){
        Start-HSTCommands -HSTScript $HSTCommandstoRun -section "AdjustParametersonImportedRDBPartition" -ActivityDescription 'Processing commands' -ReportActualSteps -ReportTime
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