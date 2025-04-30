function Write-AmigaFilestoInterimDrive {
    param (
       
    )
    
    $Script:GUICurrentStatus.StartTimeForRunningInstall = (Get-Date -Format HH:mm:ss)

    Write-InformationMessage "Started processing at: $($Script:GUICurrentStatus.StartTimeForRunningInstall)"

    $Script:Settings.CurrentTaskNumber += 1
    $Script:Settings.CurrentTaskName = "Determining list of OS files and files from internet to be installed"

    Write-StartTaskMessage

    $ListofPackagestoDownload = Get-InputCSVs -PackagestoInstall | Where-Object {($_.KickstartVersion -eq $Script:GUIActions.KickstartVersiontoUse)} 
    $ListofPackagestoDownload | Add-Member -NotePropertyName 'InstallMediaPath' -NotePropertyValue $null
    $ListofPackagestoDownload | Add-Member -NotePropertyName 'PackageNameUserSelected' -NotePropertyValue $null
    
    
    $HashTableforSelectedPackages = @{} # Clear Hash
    $Script:GUIActions.AvailablePackages | ForEach-Object {
        $HashTableforSelectedPackages[$_.PackageNameFriendlyName] = @($_.PackageNameUserSelected)
    }
    
    $HashTableforInstallMedia = @{} # Clear Hash
    $Script:GUIActions.FoundInstallMediatoUse | ForEach-Object {
        $HashTableforInstallMedia[$_.ADF_Name] = @($_.Path) 
    }
    
    $ListofPackagestoDownload | ForEach-Object {
        if ($HashTableforInstallMedia.ContainsKey($_.SourceLocation)){
            $_.InstallMediaPath = $HashTableforInstallMedia.($_.SourceLocation)[0]
        } 
        if ($HashTableforSelectedPackages.ContainsKey($_.PackageNameFriendlyName)){
            $_.PackageNameUserSelected = $HashTableforSelectedPackages.($_.PackageNameFriendlyName)[0]
        }
        else {
            $_.PackageNameUserSelected = $null
        }        
    }
    
   # $ListofPackagestoDownload > text.txt


    Write-TaskCompleteMessage 
    
    $Script:Settings.CurrentTaskNumber += 1
    $Script:Settings.CurrentTaskName = "Getting Packages from Internet"
    
    Write-StartTaskMessage
    
    $ListofPackagestoDownloadfromInternet = $ListofPackagestoDownload | Where-Object {(($_.Source -eq "Github") -or  ($_.Source -eq "Web") -or ($_.Source -eq "Web - SearchforPackageAminet") -or ($_.Source -eq "Web - SearchforPackageWHDLoadWrapper"))} | Select-Object 'Source','GithubName','GithubReleaseType','SourceLocation','BackupSourceLocation','FileDownloadName','PerformHashCheck','Hash','UpdatePackageSearchTerm','UpdatePackageSearchResultLimit', 'UpdatePackageSearchExclusionTerm','UpdatePackageSearchMinimumDate' -Unique 
    
    Get-PackagesfromInternet -ListofPackagestoDownload $ListofPackagestoDownloadfromInternet
    
    Write-TaskCompleteMessage 
    
    $Script:Settings.CurrentTaskNumber += 1
    $Script:Settings.CurrentTaskName = "Extracting Packages from Internet"
    
    Write-StartTaskMessage
    
    Expand-Packages -Web -ListofPackages $ListofPackagestoDownloadfromInternet
    
    Write-TaskCompleteMessage 
    
    $Script:Settings.CurrentTaskNumber += 1
    $Script:Settings.CurrentTaskName = "Extracting Local Packages"
    
    Write-StartTaskMessage
    
    $ListofLocalPackages = $ListofPackagestoDownload | Where-Object {$_.KickstartVersion -eq $Script:GUIActions.KickstartVersiontoUse -and $_.Source -eq 'Local - LHA File'} | Select-Object 'SourceLocation' -Unique
    
    Expand-Packages -Local -ListofPackages $ListofLocalPackages
    
    Write-TaskCompleteMessage 
    

    $Script:Settings.CurrentTaskNumber += 1
    $Script:Settings.CurrentTaskName = "Copying OS files and files from internet to interim drives"
    
    Write-StartTaskMessage
    
    $Script:Settings.TotalNumberofSubTasks = 4
    
    $Script:Settings.CurrentSubTaskNumber = 1
    $Script:Settings.CurrentSubTaskName = "Removing Existing Files"
    
    Write-StartSubTaskMessage
    
    Get-ChildItem -Path $Script:Settings.InterimAmigaDrives | Remove-Item -Recurse -Force

    $Script:Settings.CurrentSubTaskNumber += 1
    $Script:Settings.CurrentSubTaskName = 'Extracting files from ADFs to interim drives'

    Write-StartSubTaskMessage

    $HSTCommandstoProcess = @()
        
    $HSTCommandScriptPath = "$($Script:Settings.TempFolder)\HSTCommandstoRun.txt"
    if (Test-Path $HSTCommandScriptPath){
        $null = Remove-Item -Path $HSTCommandScriptPath
    }     

    $ListofPackagestoDownload | Where-Object {$_.Source -eq "ADF"} | ForEach-Object{
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
    
        }
        else {
            $DestinationPath = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)"        
        }
        $HSTCommandstoProcess += "fs extract `"$SourcePath`" `"$DestinationPath`" --uaemetadata none"      
    
    }

    $DestinationPath = [System.IO.Path]::GetFullPath("$($Script:Settings.TempFolder)\IconFiles")
    $DiskIconsPaths = Get-IconPaths -DiskIcon
    $NewFolderIconPath = Get-IconPaths -NewFolderIcon


    if (Test-Path -Path $DestinationPath -PathType Container){
        $null = Remove-Item -Path  $DestinationPath -Force -Recurse
    }

    $null = New-Item $DestinationPath -ItemType Directory

    $HSTCommandstoProcess += "fs extract `"$NewFolderIconPath`" `"$DestinationPath\NewFolderIcon`" --uaemetadata none" 
    $HSTCommandstoProcess += "fs extract `"$($DiskIconsPaths.Emu68BootPath)`" `"$DestinationPath\Emu68BootDiskIcon`" --uaemetadata none" 
    $HSTCommandstoProcess += "fs extract `"$($DiskIconsPaths.SystemPath)`" `"$DestinationPath\SystemDiskIcon`" --uaemetadata none" 
    $HSTCommandstoProcess += "fs extract `"$($DiskIconsPaths.WorkPath)`" `"$DestinationPath\WorkDiskIcon`" --uaemetadata none" 

    if ($HSTCommandstoProcess){
        $HSTCommandstoProcess | Out-File -FilePath $HSTCommandScriptPath -Force
        $Logoutput = "$($Script:Settings.TempFolder)\LogOutputTemp.txt"
        Write-InformationMessage -Message "Running HST Imager to extract files from ADFs"
        & $Script:ExternalProgramSettings.HSTImagerPath script $HSTCommandScriptPath >$Logoutput
        if ((Confirm-HSTNoErrors -PathtoLog $Logoutput -HSTImager) -eq $false){
            exit
        }
        $null = Remove-Item $HSTCommandScriptPath -Force
    }

    $Script:Settings.CurrentSubTaskNumber += 1
    $Script:Settings.CurrentSubTaskName = 'Preparing default icon files for future use'

    $null = copy-item -path "$DestinationPath\NewFolderIcon\$(Split-Path -Path $NewFolderIconPath -Leaf)" -Destination "$DestinationPath\NewFolder.info" -Force
    $null = copy-item -path "$DestinationPath\Emu68BootDiskIcon\$(Split-Path -Path $DiskIconsPaths.Emu68BootPath -Leaf)" -Destination "$DestinationPath\Emu68Disk.info" -Force
    $null = copy-item -path "$DestinationPath\SystemDiskIcon\$(Split-Path -Path $DiskIconsPaths.WorkbenchPath -Leaf)" -Destination "$DestinationPath\SystemDisk.info" -Force
    $null = copy-item -path "$DestinationPath\WorkDiskIcon\$(Split-Path -Path $DiskIconsPaths.WorkPath -Leaf)" -Destination "$DestinationPath\WorkDisk.info" -Force

    $Script:Settings.CurrentSubTaskNumber += 1
    $Script:Settings.CurrentSubTaskName = 'Renaming extracted files where needed'

    $PathtoExtractedFilesFilestoRename = [System.IO.Path]::GetFullPath("$($Script:Settings.InterimAmigaDrives)\ADFRenameFiles")
    
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

    $Script:Settings.CurrentSubTaskNumber += 1
    $Script:Settings.CurrentSubTaskName = "Uncompressing .Z Files"
    Write-StartSubTaskMessage
    
    Expand-AmigaZFiles -LocationofZFiles "$($Script:Settings.InterimAmigaDrives)\System" -MultipleDirectoryFlag

    $Script:Settings.CurrentSubTaskNumber += 1
    $Script:Settings.CurrentSubTaskName = "Copying remaining files to interim drives"
    Write-StartSubTaskMessage
    
    $ListofPackagestoDownload | Where-Object {$_.Source -eq 'Local - ConfigTXT' -or $_.Source -eq 'Local - LHA File' -or $_.Source -eq 'Github' -or  $_.Source -eq 'Local' -or $_.Source -eq 'ArchiveinArchive' -or $_.Source -eq 'CD' `
                                              -or $_.Source -eq 'Web' -or $_.Source -eq 'CD' -or $_.Source -eq 'Web - SearchforPackageAminet' -or $_.Source -eq 'Web - SearchforPackageWHDLoadWrapper'}  | ForEach-Object {
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
        elseif ($Line.Source -eq "CD") {
            $DestinationPath = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)"
            $DestinationPath = $DestinationPath.TrimEnd("\")
            if (-not (Copy-CDFiles -InputFile $($_.InstallMediaPath) -OutputDirectory $DestinationPath -FiletoExtract $($_.FilestoInstall) -NewFileName $($_.NewFileName))){
                Write-ErrorMessage -Message 'Error extracting file(s) from CD! Quitting'
                exit        
            }
        }
        elseif ($Line.Source -eq "Archive"){
            Write-ErrorMessage -Message "Not built!"
            exit
        }
        elseif ($Line.Source -eq "ArchiveinArchive"){
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

    $Script:Settings.CurrentTaskNumber += 1
    $Script:Settings.CurrentTaskName = "Adjusting files where needed"

    Write-StartTaskMessage

    $Script:Settings.CurrentSubTaskNumber = 1
    $Script:Settings.CurrentSubTaskName = "Modifying scripts"
    Write-StartSubTaskMessage

    $ListofScriptstoChange = $ListofPackagestoDownload | Where-Object {$_.ModifyScript -ne "False"} | Select-Object 'ModifyScript','ModifyScriptAction', 'ScriptNameofChange','ScriptEditStartPoint','ScriptEditEndPoint','ScriptPathtoChanges','ScriptArexxFlag' -Unique
    
    $ListofScriptstoChange | ForEach-Object {
        $ScripttoModifyPath = "$($Script:Settings.InterimAmigaDrives)\System\$($_.ModifyScript)"
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

    $Script:Settings.CurrentSubTaskNumber += 1
    $Script:Settings.CurrentSubTaskName = "Modifying tooltypes"
    Write-StartSubTaskMessage
           
    $ListofPackagestoDownload | Where-Object {$_.ModifyInfoFileType -ne 'False' -or $_.ModifyInfoFileTooltype -ne 'False'} | ForEach-Object {
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
    
    $Script:Settings.CurrentSubTaskNumber += 1
    $Script:Settings.CurrentSubTaskName = "Creating new folders and/or adding .info files where needed"

    Write-StartSubTaskMessage

    $ListofPackagestoDownload | Where-Object {$_.InstallType -eq 'AddFolder'} | Select-Object 'InstallType','DrivetoInstall', 'LocationtoInstall' -Unique | ForEach-Object {
        $DestinationFolder = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)".TrimEnd('\')
        $null = New-Item $DestinationFolder -ItemType Directory -Force
    }
       
        
    $ListofPackagestoDownload | Where-Object {$_.CreateFolderInfoFile -eq 'True'} | Select-Object 'DrivetoInstall', 'LocationtoInstall' -Unique | ForEach-Object {
        $DestinationFolder = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)".TrimEnd('\')
        $null = Copy-Item "$($Script:Settings.TempFolder)\IconFiles\NewFolder.info" "$DestinationFolder.info" 
        
    }

#### Need to do disk icons

$Script:GUICurrentStatus.EndTimeForRunningInstall = (Get-Date -Format HH:mm:ss)

$ElapsedTime = (New-TimeSpan -Start $Script:GUICurrentStatus.StartTimeForRunningInstall -end $Script:GUICurrentStatus.EndTimeForRunningInstall).TotalSeconds

Write-InformationMessage -Message "Processing Complete!"    
Write-InformationMessage -message "Started at: $($Script:GUICurrentStatus.StartTimeForRunningInstall) Finished at: $($Script:GUICurrentStatus.EndTimeForRunningInstall). Total time to run (in seconds) was: $ElapsedTime" 
Write-InformationMessage -message "The tool has finished running. A log file was created and has been stored in the log subfolder."
Write-InformationMessage -message "The full path to the file is: $([System.IO.Path]::GetFullPath($Script:Settings.LogLocation))"

   
    
    # $OutputPath = "C:\Users\Matt\OneDrive\Documents\EmuImager2\Test.vhd"
    # $DiskPartitionTypeEmu68Boot = 'MBR'
    # $PartitionNumberEmu68Boot = '1'
    # $PartitionNumberSystem = '1'
    # $DestinationPathPrefix = "$OutputPath\$DiskPartitionTypeEmu68Boot\$PartitionNumberEmu68Boot"
    # $InterimFilePath = "$($Script:Settings.TempFolder)\InterimInstallFiles"
    


}