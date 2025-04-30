function Compare-FileHash {
    param (
        $FiletoCheck,
        $HashtoCheck
    )
    Write-InformationMessage -Message "Checking hash for file: $FiletoCheck"
    $HashChecked = Get-FileHash $FiletoCheck -Algorithm MD5
    $HashtoReport=$HashChecked.Hash
    if ($HashChecked.Hash -eq $HashtoCheck) {
        Write-InformationMessage -Message "Hash of file matches!"
        return $true
    } 
    else{
        Write-ErrorMessage -Message "Hash mismatch! Hash expected was: $HashtoCheck. Hash found was: $HashtoReport"
        return $false
    }
        
}