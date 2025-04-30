function Get-PackagestoInstall {
    param (
        $ListofFilestoCheck
    )
    
    $PackagestoUpdate = @()

    $CurrentPackage = $null

    Foreach ($FiletoCheck in $ListofFilestoCheck){
        if ($CurrentPackage -ne $FiletoCheck.PackageName){
            Write-Host "Starting check of $($FiletoCheck.PackageName)"
            $CurrentPackageCheckComplete = $false
        }
        If ($CurrentPackageCheckComplete -eq $false){
            if ($FiletoCheck.FileHash -ne ""){
                $PathtoInstallFile = ".\$($FiletoCheck.LocationtoInstall)$($FiletoCheck.FilestoInstall)"
                if (-not (Test-Path $PathtoInstallFile)){
                    $PackagestoUpdate += $FiletoCheck.PackageName
                    $CurrentPackageCheckComplete = $true
                    Write-InformationMessage "$($FiletoCheck.PackageName) does not exist! Package will be installed."
                }
                else {
                    $HashtoCheck = Get-FileHash -Path $PathtoInstallFile -Algorithm MD5
                    if ($HashtoCheck -ne $HashtoCheck){
                        $PackagestoUpdate += $FiletoCheck.PackageName
                        Write-InformationMessage "$($FiletoCheck.PackageName) is out of date! Package will be reinstalled."
                        $CurrentPackageCheckComplete = $true
                    }
                    else {
                        Write-InformationMessage "$($FiletoCheck.PackageName) is up to date"
                    }
                }
            }
        }
        $CurrentPackage = $FiletoCheck.PackageName
    }

    return $PackagestoUpdate
}