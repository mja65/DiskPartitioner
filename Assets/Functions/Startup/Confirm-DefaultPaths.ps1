function Confirm-DefaultPaths {
    param (
     
    )
    
    $LocationstoCheck = @()

    $LocationstoCheck += $Script:Settings.DefaultSettingsLocation 
    $LocationstoCheck += $Script:Settings.DefaultOutputImageLocation 
    $LocationstoCheck += $Script:Settings.DefaultInstallMediaLocation
    $LocationstoCheck += $Script:Settings.DefaultImportLocation 
    $LocationstoCheck += $Script:Settings.DefaultROMLocation
    $LocationstoCheck += $Script:Settings.DownloadedFileSystems
    $LocationstoCheck += $Script:Settings.DefaultAmigaFileSystemLocation
    $LocationstoCheck += $Script:Settings.InputFiles.Path
    $LocationstoCheck += $Script:Settings.TempFolder

    Write-InformationMessage "Checking for existence of default folders"
    Write-InformationMessage ""
    
    foreach ($PathtoCheck in $LocationstoCheck) {
        if (-not(Test-Path $PathtoCheck -PathType Container)){
            Write-InformationMessage "Folder $(Split-Path -Path $PathtoCheck -Leaf) does not exist! Creating folder."
            $null = New-Item ($PathtoCheck) -ItemType Directory -Force
        } 
    }

    Write-InformationMessage "Checking for temporary files from previous use and removing"
    Write-InformationMessage ""

    # Remove all items in TempFolder except "WebPackagesDownload"
    Get-ChildItem -Path $Script:Settings.TempFolder | Where-Object { $_.Name -ne "WebPackagesDownload" } | ForEach-Object {
        Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
    }

# Remove subfolders within "WebPackagesDownload" if it exists
    $webPackagesPath = Join-Path $Script:Settings.TempFolder "WebPackagesDownload"
    if (Test-Path $webPackagesPath) {
        Get-ChildItem -Path $webPackagesPath | Where-Object { $_.PSIsContainer } | ForEach-Object {
            Remove-Item -Path $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
        }

    }
      
        
    Write-InformationMessage "Checking for existence of default folders - Complete"
    Write-InformationMessage ""

}
