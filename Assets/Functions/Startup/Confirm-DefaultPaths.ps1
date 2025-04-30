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

    Write-InformationMessage "Checking for existence of default folders - Complete"
    Write-InformationMessage ""

}
