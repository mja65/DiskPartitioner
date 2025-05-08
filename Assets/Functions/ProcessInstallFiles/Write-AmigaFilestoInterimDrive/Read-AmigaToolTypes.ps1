function Read-AmigaTooltypes {
    param (
        $IconPath,
        $ToolTypesPath
        
    )
    $Logoutput = "$($Script:Settings.TempFolder)\LogOutputTemp.txt"

    Write-InformationMessage -Message "Extracting Tooltypes for info file(s): $IconPath to $ToolTypesPath" 
    
    & $Script:ExternalProgramSettings.HSTAmigaPath icon tooltypes export $IconPath $ToolTypesPath >$Logoutput
    $CheckforError = Get-Content ($Logoutput)
    $ErrorCount  =0
    foreach ($ErrorLine in $CheckforError){
        if ($ErrorLine -match " ERR]"){
            $ErrorCount ++
            Write-ErrorMessage -Message "Error in HST-Amiga: $ErrorLine"           
        }
    }
    if ($ErrorCount -ge 1){
        $null=Remove-Item ($Logoutput) -Force
        return $false   
    }
    else{
        return $true
    }
}