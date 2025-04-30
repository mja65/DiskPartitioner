function Get-DownloadFile {
    param (
        $DownloadURL,
        $OutputLocation, #Needs to include filename!
        $NumberofAttempts
    )

    # $DownloadURL = "http://aminet.net/comm/net/AmiSpeedTest.lha"
    # $OutputLocation = ".\Temp\InstallPackagesDownload\Web\AmiSpeedTest.lha"
    # $NumberofAttempts = 1

    #$DownloadURL = "https://github.com/henrikstengaard/hst-imager/releases/download/1.2.437/hst-imager_v1.2.437-7d8644e_console_windows_x64.zip" 
    #$OutputLocation = ".\Temp\StartupFiles\HSTImager.zip"
    #$NumberofAttempts = 3

    $Counter = 0
    $IsSuccess = $null
    do {
        if ($Counter -gt 0){
            Write-InformationMessage -Message ('Trying Download again. Retry Attempt # '+$Counter)
        }
        try {
            if ($OutputLocation){
                $DownloadFolder = Split-Path -Path $OutputLocation -Parent
                if (-not (test-path $DownloadFolder)){
                    $null = New-Item -Path $DownloadFolder -ItemType Directory
                }                
                Invoke-WebRequest -Uri $DownloadURL -OutFile $OutputLocation # Powershell 5 compatibility -AllowInsecureRedirect
            }    
            else {
                $Download = Invoke-WebRequest -Uri $DownloadURL # Return DL as output of function
            }
            $IsSuccess = $true              
        }
        catch {
            Write-InformationMessage -message 'Download failed! Retrying in 3 seconds'
            Start-Sleep -Seconds 3
            $IsSuccess = $false
        }
        $Counter ++             
    } until (
        $IsSuccess -eq $true -or $Counter -eq 3 
    )
    if ($IsSuccess -eq $false){
        return $false
    }
    else{
        if ($OutputLocation){
            return $true
        }
        else{
            return $Download
        }
    }
}