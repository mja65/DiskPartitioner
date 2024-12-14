function Get-DownloadedPackages {
    param (
        $PackageDownloadsLocation 
    )
    
    # $PackageDownloadsLocation = "$($Script:ExternalProgramSettings.TempFolder)\PackageDownloads"
    
    if (-not(Test-Path $PackageDownloadsLocation)){
        $null = New-Item -Path $PackageDownloadsLocation -ItemType Directory 
    } 

    $ListofPackagestoDL = Get-ListofPackagestoInstall -KickstartVersion $Script:GUIActions.KickstartVersiontoUse -ListofPackagestoInstallCSV ($Script:Settings.ListofPackagestoInstall) | Where-Object {$_.InstallFlag -eq 'TRUE' -and $_.InstallType -ne 'CopyOnly' -and $_.InstallType -ne 'StartupSequenceOnly' -and $_.Source -eq 'Web'}

    foreach($PackagetoFind in $ListofPackagestoDL) {
        if ($PackageCheck -ne $PackagetoFind.PackageName){
            if(($PackagetoFind.SearchforUpdatedPackage -eq 'TRUE') -and ($PackagetoFind.PackageName -ne 'WHDLoadWrapper')){
                $PackagetoFind.SourceLocation=Find-LatestAminetPackage -PackagetoFind $PackagetoFind.PackageName -Exclusion $PackagetoFind.UpdatePackageSearchExclusionTerm -DateNewerthan $PackagetoFind.UpdatePackageSearchMinimumDate -Architecture 'm68k-amigaos'   
            }
            if(($PackagetoFind.SearchforUpdatedPackage -eq 'TRUE') -and ($PackagetoFind.PackageName -eq 'WHDLoadWrapper')){
                $PackagetoFind.SourceLocation=(Find-WHDLoadWrapperURL -SearchCriteria 'WHDLoadWrapper' -ResultLimit '10') 
            }
            if (Test-Path ("$PackageDownloadsLocation\$($PackagetoFind.FileDownloadName)")){
                Write-InformationMessage -Message "Download of $($PackagetoFind.FileDownloadName) already completed"
            } 
            else{
                if (-not (Get-AmigaFileWeb -URL $PackagetoFind.SourceLocation -NameofDL $PackagetoFind.FileDownloadName -LocationforDL $PackageDownloadsLocation)){
                    Write-ErrorMessage -Message 'Unrecoverable error with download(s)!'
                    exit
                }                    
            }
            if ($PackagetoFind.PerformHashCheck -eq 'TRUE'){
                if (-not (Compare-FileHash -FiletoCheck ("$PackageDownloadsLocation\$($PackagetoFind.FileDownloadName)") -HashtoCheck $PackagetoFind.Hash)){
                    Write-ErrorMessage -Message 'Error in downloaded packages! Unable to continue!'
                    Write-InformationMessage -Message ("Deleting package $PackageDownloadsLocation\$($PackagetoFind.FileDownloadName)")
                    $null=Remove-Item -Path ("$PackageDownloadsLocation\$($PackagetoFind.FileDownloadName)") -Force 
                    exit
                }
            }   
    
        }
        $PackageCheck = $PackagetoFind.PackageName
    }
    
    
}