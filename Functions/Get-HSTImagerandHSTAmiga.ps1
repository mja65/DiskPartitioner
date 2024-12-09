function Get-HSTImagerandHSTAmiga {
    param (
       
    )
    $IsInstalledHSTImager = Confirm-HSTInstalled -HSTImager
    $IsInstalledHSTAmiga = Confirm-HSTInstalled -HSTAmiga

if ($IsInstalledHSTImager -eq $false){
    if (-not(Get-GithubRelease -GithubRelease ($Script:ExternalProgramSettings.HSTImagerURL) -Tag_Name '1.2.396' -Name '_console_windows_x64.zip' -LocationforDownload ("$($Script:ExternalProgramSettings.TempFolder)\HSTImager.zip") -LocationforProgram ("$(Split-Path -Path $Script:ExternalProgramSettings.HSTImagerPath -Parent)\") -Sort_Flag '')){
        Write-ErrorMessage -Message 'Error downloading HST-Imager! Cannot continue!'
        exit
    }
}
if ($IsInstalledHSTAmiga -eq $false){
    if (-not(Get-GithubRelease -GithubRelease ($Script:ExternalProgramSettings.HSTAmigaURL) -Tag_Name '0.3.163' -Name '_console_windows_x64.zip' -LocationforDownload ("$($Script:ExternalProgramSettings.TempFolder)\HSTAmiga.zip") -LocationforProgram ("$(Split-Path -Path $Script:ExternalProgramSettings.HSTAmigaPath -Parent)\") -Sort_Flag '')){
        Write-ErrorMessage -Message 'Error downloading HST-Amiga! Cannot continue!'
        exit
    }
}
}


