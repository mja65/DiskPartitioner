function Get-PackagesfromInternet {
    param (
        
        $ListofPackagestoDownload

    )
      

    if (-not (Test-Path -Path $Settings.WebPackagesDownloadLocation)){
        $null = New-Item -Path $Settings.WebPackagesDownloadLocation -ItemType Directory
    }
     
    $Script:Settings.TotalNumberofSubTasks = $ListofPackagestoDownload.Count 
    $Script:Settings.CurrentSubTaskNumber = 1
    
    foreach ($Line in $ListofPackagestoDownload){
        $Script:Settings.CurrentSubTaskName = "Processing $($line.FileDownloadName)"
        Write-StartSubTaskMessage 
        if ($Line.Source -eq "Github"){
            $GithubDownloadLocation = $Settings.WebPackagesDownloadLocation
            if ($Line.GithubReleaseType -eq "Release"){
                $GithubOnlyReleaseVersions = 'TRUE'
            }
            else{
                $GithubOnlyReleaseVersions = $null
            }
            if (-not(Get-GithubRelease -OnlyReleaseVersions $GithubOnlyReleaseVersions -GithubRelease $line.SourceLocation -Tag_Name $line.GithubReleaseType -Name $line.GithubName -LocationforDownload "$GithubDownloadLocation\$($line.FileDownloadName)" -Sort_Flag '')){
                Write-ErrorMessage -Message "Error downloading $($line.GithubName)! Cannot continue!"
                return $false
            }
        }
        elseif (($Line.Source -eq "Web") -or ($Line.Source -eq "Web - SearchforPackageAminet") -or ($Line.Source -eq "Web - SearchforPackageWHDLoadWrapper")) {
            $SourceLocation = $null
            $PerformHashCheckFlag = $false
            $DownloadFileFlag = $true
            if ($Line.Source -eq "Web"){
                $SourceLocation = $line.SourceLocation
                if ($line.PerformHashCheck -eq $true){
                    $PerformHashCheckFlag = $true
                }
            }
            elseif ($Line.Source -eq "Web - SearchforPackageAminet"){
                $SourceLocation = Find-LatestAminetPackage -PackagetoFind $Line.UpdatePackageSearchTerm -Exclusion $line.UpdatePackageSearchExclusionTerm -DateNewerthan $line.UpdatePackageSearchMinimumDate -Architecture 'm68k-amigaos' 
            }
            elseif ($Line.Source -eq "Web - SearchforPackageWHDLoadWrapper") {
                $SourceLocation = (Find-WHDLoadWrapperURL -SearchCriteria 'WHDLoadWrapper' -ResultLimit '10') 
            }
            if (-not ($SourceLocation)){
                #Error reported through function
                exit
            }
            if (test-path "$($Settings.WebPackagesDownloadLocation)\$($line.FileDownloadName)"){
                Write-InformationMessage -Message "Download of $($line.FileDownloadName) already completed"
                if ($PerformHashCheckFlag -eq $true){
                    if (-not (Compare-FileHash -FiletoCheck "$($Settings.WebPackagesDownloadLocation)\$($line.FileDownloadName)" -HashtoCheck $line.Hash)){
                        Write-InformationMessage -Message "Error in previously downloaded file $($line.FileDownloadName). File will be removed and re-downloaded"
                        $null=Remove-Item -Path "$($Settings.WebPackagesDownloadLocation)\$($line.FileDownloadName)" -Force 
                    }
                    else {
                        $DownloadFileFlag = $false
                    }
                }
                else {
                    $DownloadFileFlag = $false
                }
            }
            if ($DownloadFileFlag -eq $true){
                if (-not (Get-AmigaFileWeb -URL $SourceLocation -BackupURL $line.BackupSourceLocation -NameofDL $line.FileDownloadName -LocationforDL $Script:Settings.WebPackagesDownloadLocation)){
                    Write-ErrorMessage -Message 'Unrecoverable error with download(s)!'
                    exit
                }
                if ($PerformHashCheckFlag -eq $true){
                    if (-not (Compare-FileHash -FiletoCheck "$($Settings.WebPackagesDownloadLocation)\$($line.FileDownloadName)" -HashtoCheck $line.Hash)){
                        Write-ErrorMessage -Message 'Error in downloaded packages! Unable to continue!'
                        Write-InformationMessage -Message ("Deleting package $PackageDownloadsLocation\$($line.FileDownloadName)")
                        $null=Remove-Item -Path "$($Settings.WebPackagesDownloadLocation)\$($line.FileDownloadName)" -Force 
                        exit
                    }
                }     
            }
            else {
                Write-InformationMessage -Message "No Download Required"
            }
        }
        $Script:Settings.CurrentSubTaskNumber ++
    }

}




# $PackagesDownloadLocation = "$($Script:Settings.TempFolder)\InstallPackagesDownload" 

# if (-not (Test-Path -Path $PackagesDownloadLocation)){
#     $null = New-Item -Path $PackagesDownloadLocation -ItemType Directory
# }


# $ListofPackagestoDownload = $ListofPackagestoInstall | Where-Object {$_.DownloadFlag -eq $true} | Select-Object 'Source','GithubName','GithubReleaseType','SourceLocation','BackupSourceLocation','FileDownloadName','PerformHashCheck','Hash','UpdatePackageSearchTerm','UpdatePackageSearchResultLimit', 'UpdatePackageSearchExclusionTerm','UpdatePackageSearchMinimumDate' -Unique

# #$ListofPackagestoDownload = $ListofPackagestoDownload | Where-Object {$_.Source -eq 'Github' -and $_.GithubName -eq 'Emu68-tools'} 
# $ListofPackagestoDownload = $ListofPackagestoDownload | Where-Object {$_.Source -eq 'Web - SearchforPackageAminet'}

# $Script:Settings.TotalNumberofSubTasks = $ListofPackagestoDownload.Count 
# $Script:Settings.CurrentSubTaskNumber = 1

# foreach ($Line in $ListofPackagestoDownload){
#     $Script:Settings.CurrentSubTaskName = "Processing $($line.FileDownloadName)"
#     Write-StartSubTaskMessage 
#     if ($Line.Source -eq "Github"){
#         $GithubDownloadLocation = "$PackagesDownloadLocation\Github"
#         if ($Line.GithubReleaseType -eq "Release"){
#             $GithubOnlyReleaseVersions = 'TRUE'
#         }
#         else{
#             $GithubOnlyReleaseVersions = $null
#         }
#         if (-not(Get-GithubRelease -OnlyReleaseVersions $GithubOnlyReleaseVersions -GithubRelease $line.SourceLocation -Tag_Name $line.GithubReleaseType -Name $line.GithubName -LocationforDownload "$GithubDownloadLocation\$($line.FileDownloadName)" -Sort_Flag '')){
#             Write-ErrorMessage -Message "Error downloading $($line.GithubName)! Cannot continue!"
#             return $false
#         }
#     }
#     elseif (($Line.Source -eq "Web") -or ($Line.Source -eq "Web - SearchforPackageAminet") -or ($Line.Source -eq "Web - SearchforPackageWHDLoadWrapper")) {
#         $WebDownloadLocation = "$PackagesDownloadLocation\Web"
#         $SourceLocation = $null
#         $PerformHashCheckFlag = $false
#         $DownloadFileFlag = $true
#         if ($Line.Source -eq "Web"){
#             $SourceLocation = $line.SourceLocation
#             if ($line.PerformHashCheck -eq $true){
#                 $PerformHashCheckFlag = $true
#             }
#         }
#         elseif ($Line.Source -eq "Web - SearchforPackageAminet"){
#             $SourceLocation = Find-LatestAminetPackage -PackagetoFind $Line.UpdatePackageSearchTerm -Exclusion $line.UpdatePackageSearchExclusionTerm -DateNewerthan $line.UpdatePackageSearchMinimumDate -Architecture 'm68k-amigaos' 
#         }
#         elseif ($Line.Source -eq "Web - SearchforPackageWHDLoadWrapper") {
#             $SourceLocation = (Find-WHDLoadWrapperURL -SearchCriteria 'WHDLoadWrapper' -ResultLimit '10') 
#         }
#         if (-not ($SourceLocation)){
#             #Error reported through function
#             exit
#         }
#         if (test-path "$WebDownloadLocation\$($line.FileDownloadName)"){
#             Write-InformationMessage -Message "Download of $($line.FileDownloadName) already completed"
#             if ($PerformHashCheckFlag -eq $true){
#                 if (-not (Compare-FileHash -FiletoCheck "$WebDownloadLocation\$($line.FileDownloadName)" -HashtoCheck $line.Hash)){
#                     Write-InformationMessage -Message "Error in previously downloaded file $($line.FileDownloadName). File will be removed and re-downloaded"
#                     $null=Remove-Item -Path "$WebDownloadLocation\$($line.FileDownloadName)" -Force 
#                 }
#                 else {
#                     $DownloadFileFlag = $false
#                 }
#             }
#             else {
#                 $DownloadFileFlag = $false
#             }
#         }
#         if ($DownloadFileFlag -eq $true){
#             if (-not (Get-AmigaFileWeb -URL $SourceLocation -BackupURL $line.BackupSourceLocation -NameofDL $line.FileDownloadName -LocationforDL $WebDownloadLocation)){
#                 Write-ErrorMessage -Message 'Unrecoverable error with download(s)!'
#                 exit
#             }
#             if ($PerformHashCheckFlag -eq $true){
#                 if (-not (Compare-FileHash -FiletoCheck "$WebDownloadLocation\$($line.FileDownloadName)" -HashtoCheck $line.Hash)){
#                     Write-ErrorMessage -Message 'Error in downloaded packages! Unable to continue!'
#                     Write-InformationMessage -Message ("Deleting package $PackageDownloadsLocation\$($line.FileDownloadName)")
#                     $null=Remove-Item -Path ("$PackageDownloadsLocation\$($line.FileDownloadName)") -Force 
#                     exit
#                 }
#             }     
#         }
#     }
#     $Script:Settings.CurrentSubTaskNumber ++
# }
