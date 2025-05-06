Function Get-IconPaths {
    param (

    )
    
    $IconLocationDetails = Get-InputCSVs -IconSets | Where-Object {$_.IconsetName -eq $Script:GUIActions.SelectedIconSet}
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
        if ($HashTableforInstallMedia.ContainsKey($_.SystemDiskIconSource)){
            $_.InstallMediaPathSystemDiskIcon = $HashTableforInstallMedia.($_.SystemDiskIconSource)[0]
        } 
        if ($HashTableforInstallMedia.ContainsKey($_.WorkDiskIconSource)){
            $_.InstallMediaPathWorkDiskIcon = $HashTableforInstallMedia.($_.WorkDiskIconSource)[0]
        } 
        if ($HashTableforInstallMedia.ContainsKey($_.Emu68BootDiskIconSource)){
            $_.InstallMediaPathEmu68BootDiskIcon = $HashTableforInstallMedia.($_.Emu68BootDiskIconSource)[0]
        } 
    }

    return $IconLocationDetails 


}
