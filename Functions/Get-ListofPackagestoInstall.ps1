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

Get-ListofPackagestoInstall -ListofPackagestoInstallCSV ($Script:Settings.ListofPackagestoInstall)
