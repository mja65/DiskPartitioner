function Read-AmigaTooltypes {
    param (
        $IconPath,
        $ToolTypesPath
        
    )
    Write-InformationMessage -Message "Extracting Tooltypes for info file(s): $IconPath to $ToolTypesPath" 
    & $Script:ExternalProgramSettings.HSTAmigaPath icon tooltypes export $IconPath $ToolTypesPath

}

