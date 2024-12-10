function Get-AmigaFileWeb {
    param (
        $URL,
        $NameofDL,
        $LocationforDL
    )
    Write-InformationMessage -Message ('Downloading file '+$NameofDL)
    if (([System.Uri]$URL).host -eq 'aminet.net'){
        $AminetMirrors =  Import-Csv ($InputFolder+'AminetMirrors.csv') -Delimiter ';'
        foreach ($Mirror in $AminetMirrors){
            Write-InformationMessage -Message ('Trying mirror: '+$Mirror.MirrorURL+' ('+$Mirror.Type+')')
            $URLBase=$Mirror.Type+'://'+$Mirror.MirrorURL
            $URLPathandQuery=([System.Uri]$URL).pathandquery 
            $DownloadURL=($URLBase+$URLPathandQuery)
            Write-InformationMessage -Message ('Trying to download from: '+$DownloadURL)
            if ((Get-DownloadFile -DownloadURL $DownloadURL -OutputLocation ($LocationforDL+$NameofDL) -NumberofAttempts 1) -eq $true){
                Write-InformationMessage -Message "Download completed"
                return $true   
            }
            else{
                Write-ErrorMessage -Message ('Error downloading '+$NameofDL+'! Trying different server')
            }
        }
        Write-ErrorMessage -Message 'All servers attempted. Download failed'
        return $false    
    }
    else{
        if ((Get-DownloadFile -DownloadURL $URL -OutputLocation ($LocationforDL+$NameofDL) -NumberofAttempts 3) -eq $true){
            Write-InformationMessage -Message 'Download completed'
            return $true
        }
        else{
            Write-ErrorMessage -Message ('Error downloading '+$NameofDL+'!')
            return $false
        }
    }
}