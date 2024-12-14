function Get-ListofInstallFilesExtractionCommands {
    param (
        $AmigaDrivetoUse,
        $AmigaTempDrivetoUse,
        [Switch]$TempDriveFilesOnly, 
        [Switch]$AmigaDriveFilesOnly
    )
    
    $OutputCommands = @()
    
    #$AmigaDrivetoUse = "$($Script:GUIActions.OutputPath)\$(Get-AmigaDrivePath -DeviceName)" 
    #$AmigaTempDrivetoUse = "$($Script:Settings.AmigaTempDrive)\$(Get-AmigaDrivePath -DeviceName)"

    if (-not (Test-Path $AmigaTempDrivetoUse)){
        $null = new-item $AmigaTempDrivetoUse -ItemType Directory -Force
    } 
    
    $ListofInstallFiles = Get-ListofInstallFiles -ListofInstallFilesCSV $Script:Settings.ListofInstallFiles -IncludePath | Where-Object {$_.Kickstart_Version -eq $Script:GUIActions.KickstartVersiontoUse}

    Foreach($InstallFileLine in $ListofInstallFiles){
        $SourcePathtoUse = "$($InstallFileLine.Path)\$($InstallFileLine.AmigaFiletoInstall -replace '/','\')"
        if (($InstallFileLine.NewFileName.Length -eq 0) -and ($InstallFileLine.Uncompress -eq 'FALSE') -and ($InstallFileLine.ModifyScript -eq 'FALSE') -and ($InstallFileLine.ModifyInfoFileTooltype -eq 'FALSE')){
            if ($InstallFileLine.LocationtoInstall.Length -eq 0){
                $DestinationPathtoUse = $AmigaDrivetoUse 
            }
            else {
                $DestinationPathtoUse = "$AmigaDrivetoUse\$($InstallFileLine.LocationtoInstall -replace '/','\')" 
            }   
            if (-not ($TempDriveFilesOnly)){
                $OutputCommands += "fs extract `"$SourcePathtoUse`" `"$DestinationPathtoUse`""   
            }
        } 
        else {
                if ($InstallFileLine.LocationtoInstall.Length -eq 0){
                    $DestinationPathtoUse = resolve-path $AmigaTempDrivetoUse
                }
                else {
                    if (-not (Test-Path ("$AmigaTempDrivetoUse\$($InstallFileLine.LocationtoInstall -replace '/','\')"))){
                        $null = new-item ("$AmigaTempDrivetoUse\$($InstallFileLine.LocationtoInstall -replace '/','\')") -ItemType Directory -Force
                    }
                    $DestinationPathtoUse = resolve-path  ("$AmigaTempDrivetoUse\$($InstallFileLine.LocationtoInstall -replace '/','\')")
                }
                if (-not($AmigaDriveFilesOnly)){
                    $OutputCommands += "fs extract `"$SourcePathtoUse`" `"$DestinationPathtoUse`" -uae None"  
                }               
            } 
        }

    return $OutputCommands 

}