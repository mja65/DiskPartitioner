function Confirm-HSTInstalled {
    param (

    [Switch]$HSTImager,
    [Switch]$HSTAmiga
   
    )
    
    $HSTInstalled = $null

    if ($HSTImager){
        $Name = 'HST-Imager'
        $PathtoUse = $Script:ExternalProgramSettings.HSTImagerPath
    }
    elseif ($HSTAmiga){
        $Name = 'HST-Amiga'
        $PathtoUse = $Script:ExternalProgramSettings.HSTAmigaPath
    }

    if (-not (Test-Path (split-path $PathtoUse -Parent))){
        Write-InformationMessage -Message "$Name Folder path does not exist. Creating $(split-path $PathtoUse -Parent). Program will be downloaded."
        $null = new-item -Path (split-path $PathtoUse -Parent) -ItemType Directory
        $HSTInstalled = $false
    }
    elseif (-not (Test-Path $Script:ExternalProgramSettings.HSTImagerPath)){
        Write-InformationMessage "$Name not available. Program will be downloaded."
        $HSTInstalled = $false
    }
    else {
        Write-InformationMessage "$Name already downloaded!"
        $HSTInstalled = $true
    }

    return $HSTInstalled

}





