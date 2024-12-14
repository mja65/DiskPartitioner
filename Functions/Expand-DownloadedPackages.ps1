function Expand-DownloadedPackages {
    param (
        $PackageDownloadsLocation,
        $AmigaTempDrivetoUse

        )
        
    # $PackageDownloadsLocation = "$($Script:ExternalProgramSettings.TempFolder)\PackageDownloads"
    #$AmigaDrivetoUse = (Resolve-Path $AmigaDrivetoUse).Path
    $AmigaTempDrivetoUse = (Resolve-Path $AmigaTempDrivetoUse).Path

    $ListofPackagestoExtract  = Get-ListofPackagestoInstall -KickstartVersion $Script:GUIActions.KickstartVersiontoUse -ListofPackagestoInstallCSV ($Script:Settings.ListofPackagestoInstall) | Where-Object {$_.InstallFlag -eq 'TRUE' -and ($_.InstallType -eq 'Extract' -or  $_.InstallType -eq 'Full')}
    
    $OutputCommands = @()

    $PackageCheck = $null

    foreach($PackagetoFind in $ListofPackagestoExtract) {
        if ($PackageCheck -ne $PackagetoFind.PackageName){
           Write-Host "Extracting package: $($PackagetoFind.PackageName)"
        }
        if ($PackagetoFind.Source -eq "ADF") {
            if ($PackagetoFind.SourceLocation -eq 'StorageADF'){
                $SourcePathtoUse = "$(Resolve-Path $Script:GUIActions.StorageADF)\$($PackagetoFind.FilestoInstall)"                      
                $DestinationPathtoUse = "$(resolve-path $PackageDownloadsLocation)\$($PackagetoFind.FileDownloadName.Trim('\'))"
                $OutputCommands += "fs extract $SourcePathtoUse $DestinationPathtoUse" 
            }
            else {
                Write-Host 'NOT USED!'
            }
            
        }
        elseif ($PackagetoFind.InstallType -eq "Full"){
            Write-InformationMessage -Message "Expanding archive file for package: $($PackagetoFind.PackageName)"
            if ([System.IO.Path]::GetExtension($PackagetoFind.FileDownloadName) -eq '.lzx'){
                $SourcePathtoUse = "$(Resolve-Path $PackageDownloadsLocation)\$($PackagetoFind.FileDownloadName)\$($PackagetoFind.FilestoInstall)"
                if ($PackagetoFind.DrivetoInstall -eq 'System'){
                    $DestinationPathtoUse = "$AmigaTempDrivetoUse\$($PackagetoFind.LocationtoInstall.Trim('\'))"
                }
                else {
                    Write-Host 'NOT USED!'
                }
                $OutputCommands += "fs extract $SourcePathtoUse $DestinationPathtoUse" 
            }
            elseif ([System.IO.Path]::GetExtension($PackagetoFind.FileDownloadName) -eq '.lha') {
                $SourcePathtoUse = "$(Resolve-Path $PackageDownloadsLocation)\$($PackagetoFind.FileDownloadName)"
                $DestinationPathtoUse = 
                if (-not(Expand-Zipfiles -InputFile $SourcePathtoUse -OutputDirectory "$PackageDownloadsLocation\$($PackagetoFind.FileDownloadName)")){
                    Write-ErrorMessage -Message 'Error in extracting!' 
                    Write-InformationMessage -Message "Deleting package $SourcePathtoUse"
                    $null=Remove-Item -Path $SourcePathtoUse -Force
                    exit
                }
            }
        }
    
        $PackageCheck = $PackagetoFind.PackageName
    }
}