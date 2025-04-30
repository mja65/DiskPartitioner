function Expand-Archive {
    param (
        $InputFile,
        $OutputDirectory,
        $FiletoExtract
    )
    Write-InformationMessage -Message "Extracting from: $InputFile"
    & $Script:ExternalProgramSettings.SevenZipFilePath x "-o$OutputDirectory" $InputFile $FiletoExtract -y > "$($Script:Settings.TempFolder)\LogOutputTemp.txt"
    if ($LASTEXITCODE -ne 0) {
        Write-ErrorMessage -Message "Error extracting $InputFile! Cannot continue!"
        return $false    
    }
    else {
        return $true
    }
}