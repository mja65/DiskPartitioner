function New-DiskImage {
    param (
        $PathforImage,
        $SizeBytes
    )

    # $PathforImage = $Script:GUIActions.OutputPath
    Write-InformationMessage -Message "Creating new disk image at: $PathforImage of size: $SizeBytes"
    & $Script:ExternalProgramSettings.HSTImagerPath blank $PathforImage $SizeBytes
    
}