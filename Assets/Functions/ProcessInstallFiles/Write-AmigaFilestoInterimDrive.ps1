function Write-AmigaFilestoInterimDrive {
    param (
       [switch]$DownloadFilesFromInternet,
       [switch]$DownloadLocalFiles,
       [switch]$ExtractADFFilesandIconFiles,
       [switch]$AdjustingScriptsandInfoFiles,
       [switch]$ProcessDownloadedFiles,
       [switch]$CopyRemainingFiles
    )
    
    $Script:Settings.CurrentTaskNumber ++
    $Script:Settings.CurrentTaskName = "Determining list of OS files, local install files, and files from internet to be installed"

    Write-StartTaskMessage

    if ($Script:GUIActions.InstallOSFiles -eq $false){
        $ListofPackagestoInstall = Get-InputCSVs -PackagestoInstallEmu68Only
    }
    else {

        $ListofPackagestoInstall = Get-InputCSVs -PackagestoInstall | Where-Object {(($_.KickstartVersion -eq $Script:GUIActions.KickstartVersiontoUse) -and ($_.IconsetName -eq "" -or $_.IconsetName -eq $Script:GUIActions.SelectedIconSet))} 
        $ListofPackagestoInstall | Add-Member -NotePropertyName 'InstallMediaPath' -NotePropertyValue $null
        $ListofPackagestoInstall | Add-Member -NotePropertyName 'PackageNameUserSelected' -NotePropertyValue $null
        
        
        $HashTableforSelectedPackages = @{} # Clear Hash
        $Script:GUIActions.AvailablePackages | ForEach-Object {
            $HashTableforSelectedPackages[$_.PackageNameFriendlyName] = @($_.PackageNameUserSelected)
        }
        
        $HashTableforInstallMedia = @{} # Clear Hash
        $Script:GUIActions.FoundInstallMediatoUse | ForEach-Object {
            $HashTableforInstallMedia[$_.ADF_Name] = @($_.Path) 
        }
        
        $ListofPackagestoInstall| ForEach-Object {
            if ($HashTableforInstallMedia.ContainsKey($_.SourceLocation)){
                $_.InstallMediaPath = $HashTableforInstallMedia.($_.SourceLocation)[0]
            } 
            if ($HashTableforSelectedPackages.ContainsKey($_.PackageNameFriendlyName)){
                $_.PackageNameUserSelected = $HashTableforSelectedPackages.($_.PackageNameFriendlyName)[0]
            }
            else {
                $_.PackageNameUserSelected = $true
            }        
        }
    
        $ListofPackagestoInstall = $ListofPackagestoInstall | Where-Object {$_.PackageNameUserSelected -eq $true}

    }

    Write-TaskCompleteMessage 

    if ($DownloadFilesFromInternet){

        $Script:Settings.CurrentTaskNumber ++
        $Script:Settings.CurrentTaskName = "Getting Packages from Internet"
        
        Write-StartTaskMessage
        
        $ListofPackagestoDownloadfromInternet = $ListofPackagestoInstall | Where-Object {(($_.Source -eq "Github") -or  ($_.Source -eq "Web") -or ($_.Source -eq "Web - SearchforPackageAminet") -or ($_.Source -eq "Web - SearchforPackageWHDLoadWrapper"))} | Select-Object 'Source','GithubName','GithubReleaseType','SourceLocation','BackupSourceLocation','FileDownloadName','PerformHashCheck','Hash','UpdatePackageSearchTerm','UpdatePackageSearchResultLimit', 'UpdatePackageSearchExclusionTerm','UpdatePackageSearchMinimumDate' -Unique 
        
        Get-PackagesfromInternet -ListofPackagestoDownload $ListofPackagestoDownloadfromInternet
        
        Write-TaskCompleteMessage 

        $Script:Settings.CurrentTaskNumber ++
        $Script:Settings.CurrentTaskName = "Extracting Packages from Internet"
        
        Write-StartTaskMessage
        
        Expand-Packages -Web -ListofPackages $ListofPackagestoDownloadfromInternet
        
        Write-TaskCompleteMessage 

    }

   if ($DownloadLocalFiles){

       $Script:Settings.CurrentTaskNumber ++
       $Script:Settings.CurrentTaskName = "Extracting Local Packages"
       
       Write-StartTaskMessage
       
       $ListofLocalPackages = $ListofPackagestoInstall | Where-Object {$_.KickstartVersion -eq $Script:GUIActions.KickstartVersiontoUse -and $_.Source -eq 'Local - LHA File'} | Select-Object 'SourceLocation' -Unique
       
       Expand-Packages -Local -ListofPackages $ListofLocalPackages
       
       Write-TaskCompleteMessage 

   }
    
   if ($ExtractADFFilesandIconFiles){
   
       $Script:Settings.CurrentTaskNumber ++
       $Script:Settings.CurrentTaskName = "Extracting files from ADFs and Icon Files and copying to interim Amiga Drive"
       
       Write-StartTaskMessage
       
       $Script:Settings.TotalNumberofSubTasks = 3
       
       $Script:Settings.CurrentSubTaskNumber = 1
       $Script:Settings.CurrentSubTaskName = "Removing Existing Files"
       
       Write-StartSubTaskMessage
       
       if (test-path $Script:Settings.InterimAmigaDrives){
           Get-ChildItem -Path $Script:Settings.InterimAmigaDrives | Remove-Item -Recurse -Force
       }
   
   
       $Script:Settings.CurrentSubTaskNumber ++
       $Script:Settings.CurrentSubTaskName = 'Preparing extraction commands for files from ADFs to interim drives'
   
       Write-StartSubTaskMessage
   
       $Script:GUICurrentStatus.HSTCommandstoProcess.ExtractOSFiles = [System.Collections.Generic.List[PSCustomObject]]::New()
           
       $ListofPackagestoInstall | Where-Object {$_.Source -eq "ADF"} | ForEach-Object{
           $SourcePath  = "$($_.InstallMediaPath)\$($_.FilestoInstall)"
           If ($_.NewFileName -ne ""){
               $FileName = Split-Path $SourcePath -Leaf
               $LocationtoInstalltoUse = ($($_.LocationtoInstall)).replace('\','_')      
               if ($FileName.Substring($FileName.Length-2) -eq ".Z"){
                   $NewFileNametoUse = "$($_.NewFileName).Z"
               }
               else{
                   $NewFileNametoUse = $_.NewFileName 
               }
               $DestinationPath = "$($Script:Settings.InterimAmigaDrives)\ADFRenameFiles\$($_.DrivetoInstall)_$($LocationtoInstalltoUse)_$($NewFileNametoUse)"
               $DestinationPath = [System.IO.Path]::GetFullPath($DestinationPath)    
       
           }
           else {
               $DestinationPath = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)"
               $DestinationPath = [System.IO.Path]::GetFullPath($DestinationPath)            
           }
           $Script:GUICurrentStatus.HSTCommandstoProcess.ExtractOSFiles += [PSCustomObject]@{ 
               Command = "fs extract `"$SourcePath`" `"$DestinationPath`" --uaemetadata none"
               Sequence = $_.InstallSequence
           }
       
       }

       $Script:Settings.CurrentSubTaskNumber ++
       $Script:Settings.CurrentSubTaskName = 'Preparing extraction commands for files from Install Media for Icons to interim drives and processing copy commands'
   
       Write-StartSubTaskMessage

       $DestinationPath = [System.IO.Path]::GetFullPath("$($Script:Settings.TempFolder)\IconFiles")
       $IconsPaths = Get-IconPaths

       $Script:GUICurrentStatus.HSTCommandstoProcess.CopyIconFiles = [System.Collections.Generic.List[PSCustomObject]]::New()
   
       if (Test-Path -Path $DestinationPath -PathType Container){
           $null = Remove-Item -Path  $DestinationPath -Force -Recurse
       }
   
       $null = New-Item $DestinationPath -ItemType Directory
   
       If ($IconsPaths.NewFolderIconInstallMedia -eq 'ADF'){
           $Script:GUICurrentStatus.HSTCommandstoProcess.CopyIconFiles += [PSCustomObject]@{
               Command = "fs extract `"$($IconsPaths.InstallMediaPathNewFolderIcon)\$($IconsPaths.NewFolderIconFilestoInstall)`" `"$DestinationPath\NewFolderIcon`" --uaemetadata none" 
               Sequence = 3           
            }
   
       }
       elseIf ($IconsPaths.NewFolderIconInstallMedia -eq 'CD'){
           if (-not (Copy-CDFiles -InputFile $IconsPaths.InstallMediaPathNewFolderIcon -FiletoExtract $IconsPaths.NewFolderIconFilestoInstall -OutputDirectory "$DestinationPath\NewFolderIcon")){
               Write-ErrorMessage -Message 'Error extracting file(s) from CD! Quitting'
               exit      
           } 
       }
   
       if ($IconsPaths.Emu68BootDiskIconInstallMedia -eq 'ADF'){
           $Script:GUICurrentStatus.HSTCommandstoProcess.CopyIconFiles += [PSCustomObject]@{
               Command = "fs extract `"$($IconsPaths.InstallMediaPathEmu68BootDiskIcon)\$($IconsPaths.Emu68BootDiskIconFilestoInstall)`" `"$DestinationPath\Emu68BootDiskIcon`" --uaemetadata none" 
               Sequence = 3
           }
       }
       elseif ($IconsPaths.Emu68BootDiskIconInstallMedia -eq 'CD'){
           if (-not (Copy-CDFiles -InputFile $IconsPaths.InstallMediaPathEmu68BootDiskIcon -FiletoExtract $IconsPaths.Emu68BootDiskIconFilestoInstall -OutputDirectory "$DestinationPath\Emu68BootDiskIcon")){
               Write-ErrorMessage -Message 'Error extracting file(s) from CD! Quitting'
               exit      
           }  
       }
   
       if ($IconsPaths.SystemDiskIconInstallMedia -eq 'ADF'){
           $Script:GUICurrentStatus.HSTCommandstoProcess.CopyIconFiles += [PSCustomObject]@{
               Command = "fs extract `"$($IconsPaths.InstallMediaPathSystemDiskIcon)\$($IconsPaths.SystemDiskIconFilestoInstall)`" `"$DestinationPath\SystemDiskIcon`" --uaemetadata none"
               Sequence = 3
           }
      }
       elseif ($IconsPaths.SystemDiskIconInstallMedia -eq 'CD'){
           if (-not (Copy-CDFiles -InputFile $IconsPaths.InstallMediaPathSystemDiskIcon -FiletoExtract $IconsPaths.SystemDiskIconFilestoInstall -OutputDirectory "$DestinationPath\SystemDiskIcon")){
               Write-ErrorMessage -Message 'Error extracting file(s) from CD! Quitting'
               exit      
           }  
       }
   
       if ($IconsPaths.WorkDiskIconInstallMedia -eq 'ADF'){
           $Script:GUICurrentStatus.HSTCommandstoProcess.CopyIconFiles += [PSCustomObject]@{
               Command = "fs extract `"$($IconsPaths.InstallMediaPathWorkDiskIcon)\$($IconsPaths.WorkDiskIconFilestoInstall)`" `"$DestinationPath\WorkDiskIcon`" --uaemetadata none"
               Sequence = 3
           }
       }
       elseif ($IconsPaths.WorkDiskIconInstallMedia -eq 'CD'){
           if (-not (Copy-CDFiles -InputFile $IconsPaths.InstallMediaPathWorkDiskIcon -FiletoExtract $IconsPaths.WorkDiskIconFilestoInstall -OutputDirectory "$DestinationPath\WorkDiskIcon")){
               Write-ErrorMessage -Message 'Error extracting file(s) from CD! Quitting'
               exit      
           } 
       }

       $HSTCommandstoProcess = $Script:GUICurrentStatus.HSTCommandstoProcess.ExtractOSFiles + $Script:GUICurrentStatus.HSTCommandstoProcess.CopyIconFiles 

       if ($HSTCommandstoProcess){
           Start-HSTCommands -HSTScript $HSTCommandstoProcess -Message "Running HST Imager to extract files from ADFs"
       }
       else {
           Write-InformationMessage -Message 'No ADF files to process!'
       }
   
       Write-TaskCompleteMessage 

   }
    
   if ($ProcessDownloadedFiles){
       
       $Script:Settings.CurrentTaskNumber ++
       $Script:Settings.CurrentTaskName = "Processing Downloaded Files"
       
       Write-StartTaskMessage
       
       $Script:Settings.TotalNumberofSubTasks = 3
       $Script:Settings.CurrentSubTaskNumber = 1
       $Script:Settings.CurrentSubTaskName = 'Preparing default icon files for future use'
    
       if (-not (test-path "$DestinationPath\Emu68BootDrive" -PathType Container)){
           $null = New-Item "$DestinationPath\Emu68BootDrive" -ItemType Directory
       }
       if (-not (test-path "$DestinationPath\SystemDrive" -PathType Container)){
           $null = New-Item "$DestinationPath\SystemDrive" -ItemType Directory
       }
       if (-not (test-path "$DestinationPath\WorkDrive" -PathType Container)){
           $null = New-Item "$DestinationPath\WorkDrive" -ItemType Directory           
       }

       $null = copy-item -path "$DestinationPath\NewFolderIcon\$(Split-Path -Path $IconsPaths.NewFolderIconFilestoInstall -Leaf)" -Destination "$DestinationPath\NewFolder.info" -Force
       $null = copy-item -path "$DestinationPath\Emu68BootDiskIcon\$(Split-Path -Path $IconsPaths.Emu68BootDiskIconFilestoInstall -Leaf)" -Destination "$DestinationPath\Emu68BootDrive\disk.info" -Force
       $null = copy-item -path "$DestinationPath\SystemDiskIcon\$(Split-Path -Path $IconsPaths.SystemDiskIconFilestoInstall -Leaf)" -Destination "$DestinationPath\SystemDrive\disk.info" -Force
       $null = copy-item -path "$DestinationPath\WorkDiskIcon\$(Split-Path -Path $IconsPaths.WorkDiskIconFilestoInstall -Leaf)" -Destination "$DestinationPath\WorkDrive\disk.info" -Force
    
       $Script:Settings.CurrentSubTaskNumber ++
       $Script:Settings.CurrentSubTaskName = 'Renaming extracted files where needed'
    
       $PathtoExtractedFilesFilestoRename = [System.IO.Path]::GetFullPath("$($Script:Settings.InterimAmigaDrives)\ADFRenameFiles")
    
       if (test-path $PathtoExtractedFilesFilestoRename){
           (Get-ChildItem $PathtoExtractedFilesFilestoRename  -Recurse -File).FullName |ForEach-Object {
               $SourcePath = $_
               $ParentPathtoRemove = "$PathtoExtractedFilesFilestoRename\"
               $DestinationPath = $_.replace('_','\').Replace($ParentPathtoRemove,'') 
               $DestinationPath = "$($Script:Settings.InterimAmigaDrives)\$DestinationPath" 
               $DestinationPath = Split-Path $DestinationPath -Parent
               $ParentFolder = Split-Path $DestinationPath -Parent
               if (-not (Test-Path -Path $ParentFolder -PathType Container)){
                   $null = New-Item -Path $ParentFolder -ItemType Directory
               }
               Write-InformationMessage -Message "Copying file `"$SourcePath`" to `"$DestinationPath`""
               $null = copy-item $SourcePath $DestinationPath
               if ($DestinationPath.Substring($DestinationPath.Length-2) -eq ".Z"){
                   $DestinationPathtoRemove = $DestinationPath.Substring(0,$DestinationPath.Length-2)
                   if (Test-Path $DestinationPathtoRemove){
                       $null = Remove-Item $DestinationPathtoRemove -Force
                   } 
               }          
           }
       }
    
       if (($Script:GUIActions.OSInstallMediaType -eq 'Disk') -and ([system.version]$Script:GUIActions.KickstartVersiontoUse -ge [system.version]3.2) -and ([system.version]$Script:GUIActions.KickstartVersiontoUse -lt [system.version]3.3)){
           $Script:Settings.CurrentSubTaskNumber ++
           $Script:Settings.CurrentSubTaskName = "Uncompressing .Z Files"
           Write-StartSubTaskMessage
           
           Expand-AmigaZFiles -LocationofZFiles "$($Script:Settings.InterimAmigaDrives)\System" -MultipleDirectoryFlag
       }
   
       Write-TaskCompleteMessage 
    
    }
 
   if ($CopyRemainingFiles) {
    $Script:Settings.CurrentTaskNumber ++
    $Script:Settings.CurrentTaskName = "Copy Remaining files to Interim Drive"
    
    Write-StartTaskMessage

    $ListofPackagestoInstall | Where-Object {$_.Source -eq 'Local - ConfigTXT' -or $_.Source -eq 'Local - LHA File' -or $_.Source -eq 'Github' -or  $_.Source -eq 'Local' -or $_.Source -eq 'ArchiveinArchive' -or $_.Source -eq 'CD' `
                                              -or $_.Source -eq 'Web' -or $_.Source -eq 'Web - SearchforPackageAminet' -or $_.Source -eq 'Web - SearchforPackageWHDLoadWrapper'}  | ForEach-Object {
  
  
        if ($_.Source -eq 'Local - LHA File'){
            Write-InformationMessage -Message "Processing Local Packages"
             $ArchiveNameExtractedFilePath = Split-Path -Path $_.SourceLocation -Leaf
             if ($ArchiveNameExtractedFilePath.Substring($ArchiveNameExtractedFilePath.Length-4) -eq ".lha"){
                 $ArchiveNameExtractedFilePath = $ArchiveNameExtractedFilePath.Substring(0,$ArchiveNameExtractedFilePath.Length-4)
             }
             $SourcePath = "$($Script:Settings.LocalPackagesDownloadLocation)\$ArchiveNameExtractedFilePath\$($_.FilestoInstall)"    
             $DestinationFolder = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)"
             $DestinationFolder = $DestinationFolder.TrimEnd('\')   
             if (-not (test-path $DestinationFolder -PathType Container)){
                 Write-InformationMessage -Message "Creating destination folder $DestinationFolder"    
                 $null = New-Item -Path $DestinationFolder -ItemType Directory   
             }
             if ($_.NewFileName -ne ""){
                 $DestinationPath = "$DestinationFolder\$($_.NewFileName)"
             }
             else {
                 $DestinationPath = $DestinationFolder
             }    
             (Resolve-Path -Path $SourcePath).path | ForEach-Object {
                 $SourcePath = $_
                 Write-InformationMessage -message "Copying file(s) from $SourcePath to $DestinationPath" 
                 $null = Copy-Item $SourcePath  $DestinationPath -Force
             } 

        }
 
         elseif ($_.Source -eq "Local"){
            $SourcePath = "$($Script:Settings.LocationofAmigaFiles)\$($_.SourceLocation)"       
            $DestinationPath = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)"
            $DestinationPath = $DestinationPath.TrimEnd("\")
            if (-not (Test-Path $DestinationPath -PathType Container)){
                $null = New-Item -Path $DestinationPath -ItemType Directory
            }
            if  ($_.NewFileName){
                $DestinationPath = "$DestinationPath\$($_.NewFileName)" 
            }
            Write-InformationMessage -message "Copying file(s) from $SourcePath to $DestinationPath" 
            $null = Copy-Item -path $SourcePath  -Destination $DestinationPath -Force
        }

        elseif ($_.Source -eq "Local - ConfigTXT") {
            $SourcePath = "$($Script:Settings.LocationofAmigaFiles)\$($_.SourceLocation)"
            $FileName = Split-Path -Path $SourcePath -Leaf
            $DestinationPath = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$FileName "
            $DestinationPath = $DestinationPath.TrimEnd("\")
            Update-ConfigTXT -PathtoConfigTXT $SourcePath -PathtoExportedConfigTXT $DestinationPath
        }

        elseif ($_.Source -eq "CD") {
            $DestinationPath = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)"
            $DestinationPath = $DestinationPath.TrimEnd("\")
            if (-not (Copy-CDFiles -InputFile $($_.InstallMediaPath) -OutputDirectory $DestinationPath -FiletoExtract $($_.FilestoInstall) -NewFileName $($_.NewFileName))){
                Write-ErrorMessage -Message 'Error extracting file(s) from CD! Quitting'
                exit        
            }
        }
        elseif ($_Source -eq "Archive"){
            Write-ErrorMessage -Message "Not built!"
            exit
        }
        elseif ($_.Source -eq "ArchiveinArchive"){
            $DestinationPath = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)"
            $DestinationPath = $DestinationPath.TrimEnd("\")
            if (-not (Copy-ArchiveinArchiveFiles -InputFile $($_.InstallMediaPath) -ArchiveinArchiveName $($_.ArchiveinArchiveName) -ArchiveinArchivePassword $($_.ArchiveinArchivePassword) -OutputDirectory $DestinationPath -FiletoExtract $($_.FilestoInstall) -NewFileName $($_.NewFileName))){
                Write-ErrorMessage -Message 'Error extracting file(s) from Archive! Quitting'
                exit
            } 
        }  

        elseif ($_.Source -eq 'Github' -or $_.Source -eq 'Web' -or $_.Source -eq 'Web - SearchforPackageAminet' -or $_.Source -eq 'Web - SearchforPackageWHDLoadWrapper'){
            $ArchiveNameExtractedFilePath = Split-Path -Path $_.FileDownloadName -Leaf
            if (($ArchiveNameExtractedFilePath.Substring($ArchiveNameExtractedFilePath.Length-4) -eq ".lha") -or ($ArchiveNameExtractedFilePath.Substring($ArchiveNameExtractedFilePath.Length-4) -eq ".lzx") -or ($ArchiveNameExtractedFilePath.Substring($ArchiveNameExtractedFilePath.Length-4) -eq ".zip")){
                $ArchiveNameExtractedFilePath = $ArchiveNameExtractedFilePath.Substring(0,$ArchiveNameExtractedFilePath.Length-4)
            }
            $SourcePath = "$($Script:Settings.WebPackagesDownloadLocation)\$ArchiveNameExtractedFilePath\$($_.FilestoInstall)"   
            $DestinationFolder = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)"
            $DestinationFolder = $DestinationFolder.TrimEnd('\')   
            if (-not (test-path $DestinationFolder -PathType Container)){
                Write-InformationMessage -Message "Creating destination folder $DestinationFolder"    
                $null = New-Item -Path $DestinationFolder -ItemType Directory   
            }
            if ($_.NewFileName -ne ""){
                $DestinationPath = "$DestinationFolder\$($_.NewFileName)"
            }
            else {
                $DestinationPath = $DestinationFolder
            }    
            (Resolve-Path -Path $SourcePath).path | ForEach-Object {
                $SourcePath = $_
                Write-InformationMessage -message "Copying file(s) from $SourcePath to $DestinationPath" 
                $null = Copy-Item $SourcePath  $DestinationPath -Force
            } 
        }
    }

    Write-TaskCompleteMessage 

   }

   if ($AdjustingScriptsandInfoFiles){
    $Script:Settings.CurrentTaskNumber ++
    $Script:Settings.CurrentTaskName = "Adjusting scripts and .info files"
    
    Write-StartTaskMessage

    $Script:Settings.TotalNumberofSubTasks = 3
    $Script:Settings.CurrentSubTaskNumber = 1
    $Script:Settings.CurrentSubTaskName = "Modifying scripts"
    Write-StartSubTaskMessage

    $ListofScriptstoChange = $ListofPackagestoInstall | Where-Object {$_.ModifyScript -ne "False"} | Select-Object 'ModifyScript','ModifyScriptAction', 'ScriptNameofChange','ScriptEditStartPoint','ScriptEditEndPoint','ScriptPathtoChanges','ScriptArexxFlag' -Unique
    
    $ListofScriptstoChange | ForEach-Object {
        $ScripttoModifyPath = "$($Script:Settings.InterimAmigaDrives)\System\$($_.ModifyScript)"
        if (-not (Test-Path $ScripttoModifyPath)){
            [System.IO.File]::WriteAllText($ScripttoModifyPath,'',[System.Text.Encoding]::GetEncoding('iso-8859-1'))
        }
        $ScriptPathtoChanges = "$($Script:Settings.LocationofAmigaFiles)\System\$($_.ScriptPathtoChanges)" 
        if ($_.ScriptArexxFlag -eq 'True'){
            Update-AmigaScripts -ScripttoModifyPath $ScripttoModifyPath `
                                -ScriptPathtoChanges $ScriptPathtoChanges `
                                -ScriptEditStartPoint $_.ScriptEditStartPoint `
                                -ScriptEditEndPoint $_.ScriptEditEndPoint `
                                -NameofChange $_.ScriptNameofChange `
                                -Action $_.ModifyScriptAction `
                                -AREXXFlag
        }
        else {
            Update-AmigaScripts -ScripttoModifyPath $ScripttoModifyPath `
                                -ScriptPathtoChanges $ScriptPathtoChanges `
                                -ScriptEditStartPoint $_.ScriptEditStartPoint `
                                -ScriptEditEndPoint $_.ScriptEditEndPoint `
                                -NameofChange $_.ScriptNameofChange `
                                -Action $_.ModifyScriptAction
        }
    }

    $Script:Settings.CurrentSubTaskNumber ++
    $Script:Settings.CurrentSubTaskName = "Modifying tooltypes"
    Write-StartSubTaskMessage
           
    $ListofPackagestoInstall| Where-Object {$_.ModifyInfoFileType -ne 'False' -or $_.ModifyInfoFileTooltype -ne 'False'} | ForEach-Object {
        if ($_.NewFileName){
            $PathtoIcon = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationToInstall)\$($_.NewFileName)"
            $IconName = $_.NewFileName
        }
        else {
            $PathtoIcon = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationToInstall)\$(Split-Path -path $_.FilestoInstall -Leaf)"
            $IconName = "$(Split-Path -path $_.FilestoInstall -Leaf)"        
        }
        if ($_.ModifyInfoFileType -ne 'False'){
            if (-not (Write-AmigaInfoType -IconPath $PathtoIcon -TypetoSet $_.ModifyInfoFileType)){
                Write-ErrorMessage -Message "Error setting icon type to $($_.ModifyInfoFileType)! Quitting"
                exit    
            }
            
        }
        if ($_.ModifyInfoFileTooltype -ne 'False'){
            $TooltypestoModifyPath = "$($Script:Settings.LocationofAmigaFiles)\System\$($_.PathtoRevisedToolTypeInfo)"
            Write-InformationMessage -Message "Importing tooltype data from  `"$TooltypestoModifyPath`""
            $NewToolTypes = Import-Csv $TooltypestoModifyPath -Delimiter ';'
            if ($_.ModifyInfoFileTooltype -eq 'Modify'){
                Write-InformationMessage -Message "Modifying Tooltype(s) in: `"$PathtoIcon`""
                $FolderforExportedInfoTypes = "$($Script:Settings.TempFolder)\ChangedInfoFiles"
                if (-not (Test-Path -Path $FolderforExportedInfoTypes -PathType Container)){
                    $null = New-Item -Path $FolderforExportedInfoTypes -ItemType Directory
                }
                if (-not (Read-AmigaTooltypes -IconPath $PathtoIcon -TooltypesPath "$($Script:Settings.TempFolder)\ChangedInfoFiles\$IconName.txt")){
                    exit
                }   
                $OldToolTypes = Get-Content "$($Script:Settings.TempFolder)\ChangedInfoFiles\$IconName.txt"
                Get-ModifiedToolTypes -OriginalToolTypes $OldToolTypes -ModifiedToolTypes $NewToolTypes | Out-File "$($Script:Settings.TempFolder)\ChangedInfoFiles\$($IconName)amendedtoimport.txt"
            }
            elseif ($_.ModifyInfoFileTooltype -eq 'Replace'){
                Write-InformationMessage -Message "Replacing Tooltype(s) in: `"$PathtoIcon`""
                $NewToolTypes.NewValue | Out-File "$($Script:Settings.TempFolder)\ChangedInfoFiles\$($IconName)amendedtoimport.txt"            
            }
            if (-not (Write-AmigaTooltypes -IconPath $PathtoIcon -ToolTypesPath "$($Script:Settings.TempFolder)\ChangedInfoFiles\$($IconName)amendedtoimport.txt")){
                exit
            }     
        }
    }

    $Script:Settings.CurrentSubTaskNumber ++
    $Script:Settings.CurrentSubTaskName = "Creating new folders and/or adding .info files where needed"

    Write-StartSubTaskMessage

    $ListofPackagestoInstall | Where-Object {$_.InstallType -eq 'AddFolder'} | Select-Object 'InstallType','DrivetoInstall', 'LocationtoInstall' -Unique | ForEach-Object {
        $DestinationFolder = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)".TrimEnd('\')
        $null = New-Item $DestinationFolder -ItemType Directory -Force
    }
       
        
    $ListofPackagestoInstall | Where-Object {$_.CreateFolderInfoFile -eq 'True'} | Select-Object 'DrivetoInstall', 'LocationtoInstall' -Unique | ForEach-Object {
        $DestinationFolder = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)".TrimEnd('\')
        $null = Copy-Item "$($Script:Settings.TempFolder)\IconFiles\NewFolder.info" "$DestinationFolder.info" 
        
    }

    Write-TaskCompleteMessage 
   }

}