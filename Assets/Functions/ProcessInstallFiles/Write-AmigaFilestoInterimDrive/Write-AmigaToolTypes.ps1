function Write-AmigaTooltypes {
    param (
        $IconPath,
        $ToolTypesPath
    )
    
    $Logoutput = "$($Script:Settings.TempFolder)\LogOutputTemp.txt"
    Write-InformationMessage -Message "Updating info file: $IconPath based on Tooltypes from $ToolTypesPath" 
    & $Script:ExternalProgramSettings.HSTAmigaPath icon tooltypes import $IconPath $ToolTypesPath >$Logoutput
    $CheckforError = Get-Content ($Logoutput)
    $ErrorCount = 0
    foreach ($ErrorLine in $CheckforError){
        if ($ErrorLine -match " ERR]"){
            $ErrorCount += 1
            Write-ErrorMessage -Message "Error in HST-Amiga: $ErrorLine"           
        }
    }
    if ($ErrorCount -ge 1){
        $null = Remove-Item ($Logoutput) -Force
        return $false    
    }
    else{
        return $true
    }        
}