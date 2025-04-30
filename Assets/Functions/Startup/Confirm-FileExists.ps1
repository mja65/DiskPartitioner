function Confirm-FileExists {
    param (
        $Pathtocheck,
        $HashtoCheck
    )
    
    if (-not (Test-path $Pathtocheck)){
        Write-InformationMessage "Required file $($StartupFile.FileDownloadName) does not exist. Downloading"
        return $false
    } 
    if ((Get-FileHash -Path $Pathtocheck -Algorithm MD5).hash -ne $HashtoCheck){
        Write-InformationMessage "File hashes do not match. Removing existing file and re-downloading"
        $null = Remove-Item -Path $Pathtocheck
        return $false 
    }
    
    Write-InformationMessage "File $Pathtocheck exists. No download required."
    
    return $true
}