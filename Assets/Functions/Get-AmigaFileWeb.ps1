function Get-AmigaFileWeb {
    param (
        $URL,
        $BackupURL,
        $NameofDL,
        $LocationforDL
    )
  
    # $URL = "https://aminet.net/comm/net/AmiSpeedTest.lha"
    # $NameofDL = "AmiSpeedTest.lha"
    # $LocationforDL = ".\Temp\InstallPackagesDownload\Web"

    # $BackupURL = "http://ftp2.grandis.nu/turran/FTP/Misc/WHDUpdate/datafile/Amiga/DOpus417pre21.lzx"
    
    # $BackupURL = $null
    # $URL = "http://dopus.free.fr/betas/DOpus417pre21.lzx"
    # $NameofDL = "DOpus417pre21.lzx"
    # $LocationforDL = ".\Temp\InstallPackagesDownload\Web"

    Write-InformationMessage -Message "Downloading file $NameofDL"
    if (([System.Uri]$URL).host -eq 'aminet.net'){
        $AminetMirrors =  Import-Csv $Script:Settings.AminetMirrorsCSV.Path -Delimiter ';'
        foreach ($Mirror in $AminetMirrors){
            Write-InformationMessage -Message "Trying mirror: $($Mirror.MirrorURL) `($($Mirror.Type)`)"
            $URLBase = "$($Mirror.Type)://$($Mirror.MirrorURL)"
            $URLPathandQuery = ([System.Uri]$URL).pathandquery 
            $DownloadURL = "$URLBase$URLPathandQuery"
            Write-InformationMessage -Message "Trying to download from: $DownloadURL"
            if ((Get-DownloadFile -DownloadURL $DownloadURL -OutputLocation "$LocationforDL\$NameofDL" -NumberofAttempts 1) -eq $true){
                Write-InformationMessage -Message "Download completed"
                return $true   
            }
            else{
                Write-ErrorMessage -Message "Error downloading $NameofDL! Trying different server"
            }
        }
        if ($BackupURL){
            Write-InformationMessage -Message "All Aminet servers attempted. Download failed. Trying alternative server."
            $BackupServertoTest = ([System.Uri]$BackupURL).host
            if (-not(Test-Connection $BackupServertoTest -Count 2 -Quiet)){
                Write-ErrorMessage -Message "No accessible server! Error downloading $NameofDL!"
                return $false
            }
            else {
                $URLtoUse = $BackupURL
                Write-InformationMessage -Message "Using alternative server $BackupServertoTest "
            }
            if ((Get-DownloadFile -DownloadURL $URLtoUse -OutputLocation "$LocationforDL\$NameofDL" -NumberofAttempts 3) -eq $true){
                Write-InformationMessage -Message 'Download completed'
                return $true
            }
            else{
                Write-ErrorMessage -Message "Error downloading $NameofDL!"
                return $false
            }
        }
        else{
            Write-ErrorMessage -Message "All servers attempted. Download failed"
            return $false    
        }
    }
    else{
        if ($BackupURL){
            $ServertoTest = ([System.Uri]$URL).host
            $BackupServertoTest = ([System.Uri]$BackupURL).host
            if (-not(Test-Connection $ServertoTest -Count 2 -Quiet)){
                Write-InformationMessage -Message "Server $ServertoTest not accessible!"
                if (-not(Test-Connection $BackupServertoTest -Count 2 -Quiet)){
                    Write-ErrorMessage -Message "No accessible server! Error downloading $NameofDL!"
                    return $false
                }
                else {
                    $URLtoUse = $BackupURL
                    Write-InformationMessage -Message "Using alternative server $BackupServertoTest "
                }
            }
            else {
                $URLtoUse = $URL
            }
        }
        else {
            $URLtoUse = $URL
        }
        if ((Get-DownloadFile -DownloadURL $URLtoUse -OutputLocation "$LocationforDL\$NameofDL" -NumberofAttempts 3) -eq $true){
            Write-InformationMessage -Message 'Download completed'
            return $true
        }
        else{
            Write-ErrorMessage -Message "Error downloading $NameofDL!"
            return $false
        }
    }

}
