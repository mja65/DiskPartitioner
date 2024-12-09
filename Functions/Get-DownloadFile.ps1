function Get-DownloadFile {
    param (
        $DownloadURL,
        $OutputLocation,
        $NumberofAttempts
    )

    #$DownloadURL = $PathtoGoogleDrivetouse
    #$NumberofAttempts = 3

    $Counter = 0
    $IsSuccess = $null
    do {
        if ($Counter -gt 0){
            Write-InformationMessage -Message ('Trying Download again. Retry Attempt # '+$Counter)
        }
        try {
            if ($OutputLocation){
                Invoke-WebRequest -Uri $DownloadURL -OutFile $OutputLocation # Powershell 5 compatibility -AllowInsecureRedirect
            }    
            else {
                $Download = Invoke-WebRequest -Uri $DownloadURL
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