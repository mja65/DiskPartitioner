function Repair-MBRDisk {
    param (
        $Path
    )
    
    $TempFolderResolved = Resolve-Path $Script:ExternalProgramSettings.TempFolder

    Write-InformationMessage -Message "Cleaning Disk"
    $Command = @()
    $Command += "blank $TempFolderResolved\Clean.vhd 10mb"
    $Command += "write $TempFolderResolved\Clean.vhd $Path" 

    return $Command

}

