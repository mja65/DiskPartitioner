function Expand-LHAfiles {
    param (
        $InputFile,
        $OutputDirectory
    )
    Write-InformationMessage -Message "Extracting from: $InputFile"
    & $Script:ExternalProgramSettings.SevenZipFilePath x "-o$OutputDirectory" $InputFile -y > "$($Script:ExternalProgramSettings.TempFolder)\LogOutputTemp.txt"
    if ($LASTEXITCODE -ne 0) {
        Write-ErrorMessage -Message "Error extracting $InputFile! Cannot continue!"
        return $false    
    }
    else {
        return $true
    }
}

