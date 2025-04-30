function Get-InterimInstallFiles {
    param (
       
    )

    $Script:Settings.TotalNumberofSubTasks = 4

    $Script:Settings.CurrentSubTaskNumber = 1
    $Script:Settings.CurrentSubTaskName = "Removing Existing Files"

    Write-StartSubTaskMessage

    Get-ChildItem -Path $Script:Settings.InterimAmigaDrives | Remove-Item -Force -Recurse

    $Script:Settings.CurrentSubTaskNumber = 2
    $Script:Settings.CurrentSubTaskName = "Determining File Paths"

    Write-StartSubTaskMessage

    $ListofPackagestoDownload = Get-InputCSVs -PackagestoInstall | Where-Object {($_.KickstartVersion -eq $Script:GUIActions.KickstartVersiontoUse)}
    
    $ListofPackagestoDownloadInterimFiles = $ListofPackagestoDownload | Where-Object {($_.UncompressZFiles -eq "True" -or $_.NewFileName -ne "" -or $_.ScriptBeingModified -eq "True" -or $_.ModifyInfoFileType -ne "False" -or $_.ModifyInfoFileTooltype -ne "False")} 
    $ListofPackagestoDownloadInterimFiles | Add-Member -NotePropertyName 'InstallMediaPath' -NotePropertyValue $null
    
    $HashTableforInstallMedia = @{} # Clear Hash
    $Script:GUIActions.FoundInstallMediatoUse | ForEach-Object {
        $HashTableforInstallMedia[$_.ADF_Name] = @($_.Path) 
    }
    
    $ListofPackagestoDownloadInterimFiles | ForEach-Object {
        if ($HashTableforInstallMedia.ContainsKey($_.SourceLocation)){
            $_.InstallMediaPath = $HashTableforInstallMedia.($_.SourceLocation)[0]
        } 
    }

    $HSTCommandstoProcess = @()
    
    $HSTCommandScriptPath = "$($Script:Settings.TempFolder)\HSTCommandstoRun.txt"
    if (Test-Path $HSTCommandScriptPath){
        $null = Remove-Item -Path $HSTCommandScriptPath
    }     

    $Script:Settings.CurrentSubTaskNumber = 3
    $Script:Settings.CurrentSubTaskName = "Performing copy of files - Local, CD, and ArchiveFiles"

    Write-StartSubTaskMessage

    $ListofPackagestoDownloadInterimFiles | ForEach-Object {
        if ($_.Source -eq 'ADF'){
            $SourcePath  = "$($_.InstallMediaPath)\$($_.FilestoInstall)"
            If ($_.NewFileName -ne ""){
                $LocationtoInstalltoUse = ($($_.LocationtoInstall)).replace('\','_')                
                $DestinationPath = "$($Script:Settings.InterimAmigaDrives)\ADFRenameFiles\$($_.DrivetoInstall)_$($LocationtoInstalltoUse)_$($_.NewFileName)"
                #$DestinationPath 
            }
            else {
                $DestinationPath = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)"
            }
            $HSTCommandstoProcess += "fs extract `"$SourcePath`" `"$DestinationPath`" --uaemetadata none"        
        }
        elseif ($_.Source -eq 'Local'){
            $SourcePath = "$($Script:Settings.LocationofAmigaFiles)\$($_.SourceLocation)"
            $DestinationPath = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)\"
            $DestinationPath = $DestinationPath.TrimEnd("\")
            if (-not (Test-Path $DestinationPath -PathType Container)){
                $null = New-Item -Path $DestinationPath -ItemType Directory
            }
            if  ($_.NewFileName){
                $DestinationPath = "$DestinationPath\$($_.NewFileName)" 
            }
            $null = Copy-Item -Path $SourcePath -Destination $DestinationPath -Force

        }
        elseif ($_.Source -eq 'CD'){
            $DestinationPath = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)\"
            $DestinationPath = $DestinationPath.TrimEnd("\")
            if (-not (Copy-CDFiles -InputFile $_.InstallMediaPath -OutputDirectory $DestinationPath -FiletoExtract $_.FilestoInstall -NewFileName $_.NewFileName)){
                Write-ErrorMessage -Message 'Error extracting file(s) from CD! Quitting'
                exit        
            }
        }
        elseif ($_.Source -eq 'ArchiveinArchive'){
            $DestinationPath = "$($Script:Settings.InterimAmigaDrives)\$($_.DrivetoInstall)\$($_.LocationtoInstall)\"
            $DestinationPath = $DestinationPath.TrimEnd("\")
            if (-not (Copy-ArchiveinArchiveFiles -InputFile $_.InstallMediaPath -ArchiveinArchiveName $_.ArchiveinArchiveName -ArchiveinArchivePassword $_.ArchiveinArchivePassword -OutputDirectory $DestinationPath -FiletoExtract $_.FilestoInstall -NewFileName $_.NewFileName)){
                Write-ErrorMessage -Message 'Error extracting file(s) from Archive! Quitting'
                exit
            } 
        }
    }

    $Script:Settings.CurrentSubTaskNumber = 4
    $Script:Settings.CurrentSubTaskName = "Performing copy of files - ADF"

    Write-StartSubTaskMessage

    if ($HSTCommandstoProcess){
        $HSTCommandstoProcess | Out-File -FilePath $HSTCommandScriptPath -Force
        & $Script:ExternalProgramSettings.HSTImagerPath script $HSTCommandScriptPath
    }

}


# $InterimFilePath = "$($Script:Settings.TempFolder)\InterimAmigaDrives"
# $InterimFilePath = [System.IO.Path]::GetFullPath($InterimFilePath)

# $HSTCommandstoProcess = @()

# $ListofPackagestoDownloadInterimFiles | ForEach-Object {
#     $SourcePath  = "$($_.InstallMediaPath)\$($_.FilestoInstall)"
#     $DestinationPath = "$InterimFilePath\$($_.DrivetoInstall)\$($_.LocationtoInstall)\$($_.NewFileName)"
#     $DestinationPath = $DestinationPath.TrimEnd("\")
#     $HSTCommandstoProcess += "fs extract `"$SourcePath`" `"$DestinationPath`" --uaemetadata none"
# }

# $HSTCommandScriptPath = "$($Script:Settings.TempFolder)\HSTCommandstoRun.txt"
# if (Test-Path $HSTCommandScriptPath){
#     $null = Remove-Item -Path $HSTCommandScriptPath
# }

# $HSTCommandstoProcess | Out-File -FilePath $HSTCommandScriptPath -Force

# & $Script:ExternalProgramSettings.HSTImagerPath script $HSTCommandScriptPath

# $ListofPackagestoDownloadInterimFiles | Where-Object {$_.UncompressZFiles -eq 'True'} | Select-Object 'DrivetoInstall','LocationtoInstall' -Unique | ForEach-Object {
#     $PathtoExpand = "$($InterimFilePath)\$($_.DrivetoInstall)\$($_.LocationtoInstall)"
#     $PathtoExpand = [string]$PathtoExpand.TrimEnd("\")
#     Expand-AmigaZFiles -LocationofZFiles $PathtoExpand 
# }

# $ListofScriptstoChange = $ListofPackagestoDownload | Where-Object {$_.ModifyScript -ne "False"} | Select-Object 'ModifyScript','ModifyScriptAction', 'ScriptNameofChange','ScriptInjectionStartPoint','ScriptInjectionEndPoint','ScriptPathtoChanges','ScriptArexxFlag' -Unique

# $ListofScriptstoChange | ForEach-Object {
#     if ($_.ModifyScriptAction -eq "Add"){
#         $LinestoAdd = Import-TextFileforAmiga -SystemType 'PC' -ImportFile "$($Script:Settings.LocationofAmigaFiles)\$($_.ScriptPathtoChanges)" 
#     }
#     else {
#         $LinestoAdd = $null
#     }
#     $ScripttoEdit = Import-TextFileforAmiga -SystemType 'Amiga' -ImportFile "$InterimFilePath\System\$($_.ModifyScript)"
#     $RevisedScript = Edit-AmigaScripts -ScripttoEdit $ScripttoEdit -Action $_.ModifyScriptAction -name $_.ScriptNameofChange -Startpoint $_.ScriptInjectionStartPoint -Endpoint $_.ScriptInjectionEndPoint -LinestoAdd $LinestoAdd                   
#     Export-TextFileforAmiga -ExportFile "$InterimFilePath\System\$($_.ModifyScript)" -DatatoExport $RevisedScript -AddLineFeeds 'TRUE'                   
# }

# $ListofInfoTypestoChange = $ListofPackagestoDownload | Where-Object {$_.ModifyInfoFileType -ne 'False' -or $_.ModifyInfoFileTooltype -ne 'False'} 
# $ListofInfoTypestoChange | ForEach-Object {
#     if ($_.NewFileName){
#         $PathtoIcon = "$InterimFilePath\System\$($_.LocationToInstall)\$($_.NewFileName)"
#         $IconName = $_.NewFileName
#     }
#     else {
#         $PathtoIcon = "$InterimFilePath\System\$($_.LocationToInstall)\$(Split-Path -path $_.FilestoInstall -Leaf)"
#         $IconName = "$(Split-Path -path $_.FilestoInstall -Leaf)"
#     }
#     if ($_.ModifyInfoFileType -ne 'False'){
#         if (-not (Write-AmigaInfoType -IconPath $PathtoIcon -TypetoSet $_.ModifyInfoFileType)){
#             Write-ErrorMessage -Message "Error setting icon type to $($_.ModifyInfoFileType)! Quitting"
#             exit    
#         }
        
#     }
#     if ($_.ModifyInfoFileTooltype -ne 'False'){
#         $TooltypestoModifyPath = "$($Script:Settings.LocationofAmigaFiles)\$($_.PathtoRevisedToolTypeInfo)"
#         $NewToolTypes = Import-Csv $TooltypestoModifyPath -Delimiter ';'   
#         if ($_.ModifyInfoFileTooltype -eq 'Modify'){
#             if (-not (Read-AmigaTooltypes -IconPath $PathtoIcon -TooltypesPath "$($Script:Settings.TempFolder)\ChangedInfoFiles\$IconName.txt")){
#                 exit
#             }   
#             $OldToolTypes = Get-Content "$($Script:Settings.TempFolder)\ChangedInfoFiles\$IconName.txt"
#             Get-ModifiedToolTypes -OriginalToolTypes $OldToolTypes -ModifiedToolTypes $NewToolTypes | Out-File "$($Script:Settings.TempFolder)\ChangedInfoFiles\$($IconName)amendedtoimport.txt"
#         }
#         elseif ($_.ModifyInfoFileTooltype -eq 'Replace'){
#             $NewToolTypes.NewValue | Out-File "$($Script:Settings.TempFolder)\ChangedInfoFiles\$($IconName)amendedtoimport.txt"
#         }
#         if (-not (Write-AmigaTooltypes -IconPath $PathtoIcon  -ToolTypesPath "$($Script:Settings.TempFolder)\ChangedInfoFiles\$($IconName)amendedtoimport.txt")){
#             exit
#         }                                 
#     }
# }
