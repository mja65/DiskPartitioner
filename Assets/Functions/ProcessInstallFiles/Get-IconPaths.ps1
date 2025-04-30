Function Get-IconPaths {
    param (
        [switch]$NewFolderIcon,
        [switch]$DiskIcon

    )
    
    $IconLocationDetails = (Get-InputCSVs -OSestoInstall | Where-Object {$_.Kickstart_Version -eq $Script:GUIActions.KickstartVersiontoUse})
    $IconLocationDetails | Add-Member -NotePropertyName 'InstallMediaPathNewFolderIcon' -NotePropertyValue $null
    $IconLocationDetails | Add-Member -NotePropertyName 'InstallMediaPathSystemDiskIcon' -NotePropertyValue $null
    $IconLocationDetails | Add-Member -NotePropertyName 'InstallMediaPathWorkDiskIcon' -NotePropertyValue $null
    $IconLocationDetails | Add-Member -NotePropertyName 'InstallMediaPathEmu68BootDiskIcon' -NotePropertyValue $null

    $HashTableforInstallMedia = @{} # Clear Hash
    $Script:GUIActions.FoundInstallMediatoUse | ForEach-Object {
        $HashTableforInstallMedia[$_.ADF_Name] = @($_.Path) 
    }

    $IconLocationDetails  | ForEach-Object {
        if ($HashTableforInstallMedia.ContainsKey($_.NewFolderIconSource)){
            $_.InstallMediaPathNewFolderIcon = $HashTableforInstallMedia.($_.NewFolderIconSource)[0]
        } 
        if ($HashTableforInstallMedia.ContainsKey($_.WorkbenchIconSource)){
            $_.InstallMediaPathSystemDiskIcon = $HashTableforInstallMedia.($_.WorkbenchIconSource)[0]
        } 
        if ($HashTableforInstallMedia.ContainsKey($_.WorkIconSource)){
            $_.InstallMediaPathWorkDiskIcon = $HashTableforInstallMedia.($_.WorkIconSource)[0]
        } 
        if ($HashTableforInstallMedia.ContainsKey($_.Emu68BootIconSource)){
            $_.InstallMediaPathEmu68BootDiskIcon = $HashTableforInstallMedia.($_.Emu68BootIconSource)[0]
        } 
    }

    if ($NewFolderIcon){
        $SourcePath =  "$($IconLocationDetails.InstallMediaPathNewFolderIcon)\$($IconLocationDetails.NewFolderIconSourcePath)"
        return $SourcePath
    }
    elseif ($DiskIcon){
        $SourcePaths  = [PSCustomObject]@{
            Emu68BootPath = "$($IconLocationDetails.InstallMediaPathEmu68BootDiskIcon)\$($IconLocationDetails.Emu68BootIconSourcePath)"
            SystemPath = "$($IconLocationDetails.InstallMediaPathSystemDiskIcon)\$($IconLocationDetails.SystemIconSourcePath)"
            WorkPath = "$($IconLocationDetails.InstallMediaPathWorkDiskIcon)\$($IconLocationDetails.WorkIconSourcePath)"
        }
        
        return $SourcePaths


    }

}
