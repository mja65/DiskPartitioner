function Get-ListofPackagestoInstall {
    param (
        $ListofPackagestoInstallCSV
        )       

        #$ListofPackagestoInstallCSV = ($InputFolder+'ListofPackagestoInstall.csv') 

        $ListofPackagestoInstallImported = Import-Csv $ListofPackagestoInstallCSV -delimiter ';'
        
        $SemanticVersion = [System.Version]$Script:Settings.Version
    
        $RevisedListofPackagestoInstall = [System.Collections.Generic.List[PSCustomObject]]::New()
        foreach ($Line in $ListofPackagestoInstallImported) {
            $PackageMinimumVersion = [System.Version]$line.MinimumInstallerVersion
            if (($SemanticVersion.Major -ge $PackageMinimumVersion.Major) -and `
            ($SemanticVersion.Minor -ge $PackageMinimumVersion.Minor) -and `
            ($SemanticVersion.Build -ge $PackageMinimumVersion.Build) -and `
            ($SemanticVersion.Revision -ge $PackageMinimumVersion.Revision)){
                $CountofVariables = ([regex]::Matches($line.KickstartVersion, "," )).count
                if ($CountofVariables -gt 0){
                    $Counter = 0
                    do {
                        $RevisedListofPackagestoInstall += [PSCustomObject]@{
                            InstallFlag = $line.InstallFlag
                            KickstartVersion = ($line.KickstartVersion -split ',')[$Counter] 
                            PackageName = $line.PackageName
                            SearchforUpdatedPackage = $line.SearchforUpdatedPackage
                            UpdatePackageSearchTerm = $line.UpdatePackageSearchTerm    
                            UpdatePackageSearchExclusionTerm  = $line.UpdatePackageSearchExclusionTerm
                            UpdatePackageSearchMinimumDate  = $line.UpdatePackageSearchMinimumDate  
                            Source = $line.Source     
                            InstallType = $line.InstallType       
                            SourceLocation = $line.SourceLocation          
                            FileDownloadName = $line.FileDownloadName         
                            PerformHashCheck = $line.PerformHashCheck    
                            Hash = $line.Hash        
                            FilestoInstall = $line.FilestoInstall        
                            DrivetoInstall = $line. DrivetoInstall    
                            LocationtoInstall = $line.LocationtoInstall    
                            CreateFolderInfoFile = $line.CreateFolderInfoFile    
                            NewFileName = $line.NewFileName       
                            ModifyUserStartup = $line.ModifyUserStartup  
                            ModifyStartupSequence = $line.ModifyStartupSequence 
                            StartupSequenceInjectionStartPoint = $line.StartupSequenceInjectionStartPoint
                            StartupSequenceInjectionEndPoint  =$line.StartupSequenceInjectionEndPoint
                            ModifyInfoFileTooltype = $line.ModifyInfoFileTooltype    
                            PiSpecificStorageDriver = $line.PiSpecificStorageDriver 
                        }
                        $counter ++
                    } until (
                        $Counter -eq ($CountofVariables+1)
                    )
                }
                else{
                    $RevisedListofPackagestoInstall   += [PSCustomObject]@{
                        InstallFlag = $line.InstallFlag
                        KickstartVersion = $line.KickstartVersion 
                        PackageName = $line.PackageName
                        SearchforUpdatedPackage = $line.SearchforUpdatedPackage
                        UpdatePackageSearchTerm = $line.UpdatePackageSearchTerm    
                        UpdatePackageSearchExclusionTerm  = $line.UpdatePackageSearchExclusionTerm
                        UpdatePackageSearchMinimumDate  = $line.UpdatePackageSearchMinimumDate  
                        Source = $line.Source     
                        InstallType = $line.InstallType       
                        SourceLocation = $line.SourceLocation          
                        FileDownloadName = $line.FileDownloadName         
                        PerformHashCheck = $line.PerformHashCheck    
                        Hash = $line.Hash        
                        FilestoInstall = $line.FilestoInstall        
                        DrivetoInstall = $line. DrivetoInstall    
                        LocationtoInstall = $line.LocationtoInstall    
                        CreateFolderInfoFile = $line.CreateFolderInfoFile    
                        NewFileName = $line.NewFileName       
                        ModifyUserStartup = $line.ModifyUserStartup  
                        ModifyStartupSequence = $line.ModifyStartupSequence 
                        StartupSequenceInjectionStartPoint = $line.StartupSequenceInjectionStartPoint
                        StartupSequenceInjectionEndPoint  =$line.StartupSequenceInjectionEndPoint
                        ModifyInfoFileTooltype = $line.ModifyInfoFileTooltype    
                    }
                }
            }
        }
        return $RevisedListofPackagestoInstall
}

# $ListofPackagestoInstall = Get-ListofPackagestoInstall -ListofPackagestoInstallCSV ($Script:Settings.ListofPackagestoInstall) | Where-Object {$_.InstallFlag -eq 'TRUE' -and $_.InstallType -ne 'CopyOnly' -and $_.InstallType -ne 'StartupSequenceOnly'}

# $InstallLocationtoUse = "$($Script:GUIActions.OutputPath)\$(Get-AmigaDrivePath)"

# $PackageDownloadsLocation = "$($Script:ExternalProgramSettings.TempFolder)\PackageDownloads"
# if (-not(Test-Path $PackageDownloadsLocation)){
#     $null = New-Item -Path $PackageDownloadsLocation -ItemType Directory 
# } 

# $ListofPackagestoDL = $ListofPackagestoInstall | Where-Object {$_.Source -eq 'Web'}

# foreach($PackagetoFind in $ListofPackagestoDL) {
#     if ($PackageCheck -ne $PackagetoFind.PackageName){
#         if(($PackagetoFind.SearchforUpdatedPackage -eq 'TRUE') -and ($PackagetoFind.PackageName -ne 'WHDLoadWrapper')){
#             $PackagetoFind.SourceLocation=Find-LatestAminetPackage -PackagetoFind $PackagetoFind.PackageName -Exclusion $PackagetoFind.UpdatePackageSearchExclusionTerm -DateNewerthan $PackagetoFind.UpdatePackageSearchMinimumDate -Architecture 'm68k-amigaos'   
#         }
#         if(($PackagetoFind.SearchforUpdatedPackage -eq 'TRUE') -and ($PackagetoFind.PackageName -eq 'WHDLoadWrapper')){
#             $PackagetoFind.SourceLocation=(Find-WHDLoadWrapperURL -SearchCriteria 'WHDLoadWrapper' -ResultLimit '10') 
#         }
#         if (Test-Path ("$PackageDownloadsLocation\$($PackagetoFind.FileDownloadName)")){
#             Write-InformationMessage -Message "Download of $($PackagetoFind.FileDownloadName) already completed"
#         } 
#         else{
#             if (-not (Get-AmigaFileWeb -URL $PackagetoFind.SourceLocation -NameofDL $PackagetoFind.FileDownloadName -LocationforDL $PackageDownloadsLocation)){
#                 Write-ErrorMessage -Message 'Unrecoverable error with download(s)!'
#                 exit
#             }                    
#         }
#         if ($PackagetoFind.PerformHashCheck -eq 'TRUE'){
#             if (-not (Compare-FileHash -FiletoCheck ("$PackageDownloadsLocation\$($PackagetoFind.FileDownloadName)") -HashtoCheck $PackagetoFind.Hash)){
#                 Write-ErrorMessage -Message 'Error in downloaded packages! Unable to continue!'
#                 Write-InformationMessage -Message ("Deleting package $PackageDownloadsLocation\$($PackagetoFind.FileDownloadName)")
#                 $null=Remove-Item -Path ("$PackageDownloadsLocation\$($PackagetoFind.FileDownloadName)") -Force 
#                 exit
#             }
#         }   

#     }
#     $PackageCheck = $PackagetoFind.PackageName
# }



# $OutputCommands = @()

# foreach($PackagetoFind in $ListofPackagestoInstall) {
#     if ($PackageCheck -ne $PackagetoFind.PackageName){
#        Write-Host "Downloading (or Copying) package: $($PackagetoFind.PackageName)"
#        if ($PackagetoFind.Source -eq "ADF") {
#            if ($PackagetoFind.SourceLocation -eq 'StorageADF'){
#                $SourcePathtoUse = "$($Script:GUIActions.StorageADF)\$($PackagetoFind.FilestoInstall)"                      
#                $DestinationPathtoUse = "$PackageDownloadsLocation\$($PackagetoFind.FileDownloadName.Trim('\'))"
#                $OutputCommands += "fs extract $SourcePathtoUse $DestinationPathtoUse" 
#            }
#            else {
#                Write-Host 'NOT USED!'
#            }
#        }
#        Elseif ($PackagetoFind.Source -eq "Web"){
        
#         }
#         Elseif (($PackagetoFind.Source -eq "Local") -and ($PackagetoFind.InstallType -eq "Full")){
#             Write-InformationMessage -Message "Copying local file: $($PackagetoFind.SourceLocation)"
#             if (Test-Path ("$PackageDownloadsLocation\$($PackagetoFind.FileDownloadName)")){
#                 Write-InformationMessage -Message "File: $($PackagetoFind.SourceLocation) already copied"
#             }
#             else {
#                 Copy-Item ($LocationofAmigaFiles+$PackagetoFind.SourceLocation) ("$PackageDownloadsLocation\$($PackagetoFind.FileDownloadName)")
#             }
#         }
#         if ($PackagetoFind.InstallType -eq "Full"){
#             Write-InformationMessage -Message "Expanding archive file for package: $($PackagetoFind.PackageName)"
#             if (([System.IO.Path]::GetExtension($PackagetoFind.FileDownloadName) -eq '.lzx') -or ([System.IO.Path]::GetExtension($PackagetoFind.FileDownloadName) -eq '.lha')){
#                 $SourcePathtoUse = "$PackageDownloadsLocation\$($PackagetoFind.FileDownloadName)"
#                 $DestinationPathtoUse = "$TempFolder+$PackagetoFind.FileDownloadName"
#                 $OutputCommands += "fs extract $SourcePathtoUse $DestinationPathtoUse" 
#             } 
#         }
#     }
#     $PackageCheck = $PackagetoFind.PackageName
# }


       




        
    
            
    













################










# foreach($PackagetoFind in $ListofPackagestoInstall) {
#     if ($PackageCheck -ne $PackagetoFind.PackageName){}
#     $PackageCheck = $PackagetoFind.PackageName
# }


        
#             if ($PackagetoFind.Source -eq "ADF") {
#                 if ($PackagetoFind.SourceLocation -eq 'StorageADF'){
#                     $ADFtoUse = $StorageADF
#                     $SourcePathtoUse = ($ADFtoUse+'\'+$PackagetoFind.FilestoInstall)
#                     $DestinationPathtoUse = ($TempFolder+$PackagetoFind.FileDownloadName).Trim('\')       
#                     $OutputCommands += "fs extract $SourcePathtoUse $DestinationPathtoUse" 
#                 }
#             }
#             Elseif ($PackagetoFind.Source -eq "Web"){
#                 if(($PackagetoFind.SearchforUpdatedPackage -eq 'TRUE') -and ($PackagetoFind.PackageName -ne 'WHDLoadWrapper')){
#                     $PackagetoFind.SourceLocation=Find-LatestAminetPackage -PackagetoFind $PackagetoFind.PackageName -Exclusion $PackagetoFind.UpdatePackageSearchExclusionTerm -DateNewerthan $PackagetoFind.UpdatePackageSearchMinimumDate -Architecture 'm68k-amigaos'   
#                 }
#                 if(($PackagetoFind.SearchforUpdatedPackage -eq 'TRUE') -and ($PackagetoFind.PackageName -eq 'WHDLoadWrapper')){
#                     $PackagetoFind.SourceLocation=(Find-WHDLoadWrapperURL -SearchCriteria 'WHDLoadWrapper' -ResultLimit '10') 
#                 }
#                 if (Test-Path ($AmigaDownloads+$PackagetoFind.FileDownloadName)){
#                     Write-InformationMessage -Message "Download already completed"
#                 } 
#                 else{
#                     if (-not (Get-AmigaFileWeb -URL $PackagetoFind.SourceLocation -NameofDL $PackagetoFind.FileDownloadName -LocationforDL $AmigaDownloads)){
#                         Write-ErrorMessage -Message 'Unrecoverable error with download(s)!'
#                         exit
#                     }                    
#                 }
#                 if ($PackagetoFind.PerformHashCheck -eq 'TRUE'){
#                     if (-not (Compare-FileHash -FiletoCheck ($AmigaDownloads+$PackagetoFind.FileDownloadName) -HashtoCheck $PackagetoFind.Hash)){
#                         Write-ErrorMessage -Message 'Error in downloaded packages! Unable to continue!'
#                         Write-InformationMessage -Message ('Deleting package '+($AmigaDownloads+$PackagetoFind.FileDownloadName))
#                         $null=Remove-Item -Path ($AmigaDownloads+$PackagetoFind.FileDownloadName) -Force 
#                         exit
#                     }
#                 }
#             }
#             Elseif (($PackagetoFind.Source -eq "Local") -and ($PackagetoFind.InstallType -eq "Full")){
#                 Write-InformationMessage -Message ('Copying local file '+$PackagetoFind.SourceLocation)
#                 if (Test-Path ($AmigaDownloads+$PackagetoFind.FileDownloadName)){
#                     Write-InformationMessage -Message 'File already copied'
#                 }
#                 else {
#                     Copy-Item ($LocationofAmigaFiles+$PackagetoFind.SourceLocation) ($AmigaDownloads+$PackagetoFind.FileDownloadName)
#                 }
#             }
#             if ($PackagetoFind.InstallType -eq "Full"){
#                 Write-InformationMessage -Message ('Expanding archive file for package '+$PackagetoFind.PackageName)
#                 if ([System.IO.Path]::GetExtension($PackagetoFind.FileDownloadName) -eq '.lzx'){
#                     Expand-LZXArchive -LZXPathtouse $LZXPath -WorkingFoldertouse  $Script:WorkingPath -LZXFile ($AmigaDownloads+$PackagetoFind.FileDownloadName) -TempFoldertouse $TempFolder -DestinationPath ($TempFolder+$PackagetoFind.FileDownloadName) 
#                 } 
#                 if ([System.IO.Path]::GetExtension($PackagetoFind.FileDownloadName) -eq '.lha'){
#                     if (-not(Expand-Zipfiles -SevenzipPathtouse $7zipPath -TempFoldertouse $TempFolder -InputFile ($AmigaDownloads+$PackagetoFind.FileDownloadName) -OutputDirectory ($TempFolder+$PackagetoFind.FileDownloadName))){
#                         Write-ErrorMessage -Message 'Error in extracting!' 
#                         Write-InformationMessage -Message ('Deleting package '+($AmigaDownloads+$PackagetoFind.FileDownloadName))
#                         $null=Remove-Item -Path ($AmigaDownloads+$PackagetoFind.FileDownloadName) -Force
#                         exit
#                     }
                               
#                 } 
#             }

#             $ItemCounter+=1    
#         }
        
            
    
# }