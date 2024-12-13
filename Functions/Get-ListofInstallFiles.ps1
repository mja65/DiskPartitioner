function Get-ListofInstallFiles {
    param (
        $ListofInstallFilesCSV,
        [Switch]$IncludePath
        )       

        # $ListofInstallFilesCSV = $Script:Settings.ListofInstallFiles

        $ListofInstallFilesImported = Import-Csv $ListofInstallFilesCSV -delimiter ';'

        $SemanticVersion = [System.Version]$Script:Settings.Version

        $RevisedListofInstallFiles = [System.Collections.Generic.List[PSCustomObject]]::New()
        foreach ($Line in $ListofInstallFilesImported ) {
            $PackageMinimumVersion = [System.Version]$line.MinimumInstallerVersion
            if (($SemanticVersion.Major -ge $PackageMinimumVersion.Major) -and `
            ($SemanticVersion.Minor -ge $PackageMinimumVersion.Minor) -and `
            ($SemanticVersion.Build -ge $PackageMinimumVersion.Build) -and `
            ($SemanticVersion.Revision -ge $PackageMinimumVersion.Revision)){
                $CountofVariables = ([regex]::Matches($line.Kickstart_Version, "," )).count
                if ($CountofVariables -gt 0){
                    $Counter = 0
                    do {
                        $RevisedListofInstallFiles += [PSCustomObject]@{
                            Kickstart_Version = ($line.Kickstart_Version -split ',')[$Counter] 
                            Kickstart_VersionFriendlyName = ($line.Kickstart_VersionFriendlyName -split ',')[$Counter] 
                            InstallSequence = $line.InstallSequence
                            ADF_Name = $line.ADF_Name
                            FriendlyName = $line.FriendlyName
                            AmigaFiletoInstall = $line.AmigaFiletoInstall
                            DrivetoInstall = $line.DrivetoInstall
                            LocationtoInstall = $line.LocationtoInstall
                            NewFileName = $line.NewFileName
                            ExcludedFolders = $line.ExcludedFolder
                            ExcludedFiles = $line.ExcludedFiles 
                            Uncompress = $line.Uncompress
                            ModifyScript = $line.ModifyScript
                            ScriptNameofChange = $line.ScriptNameofChange
                            ScriptInjectionStartPoint = $line.ScriptInjectionStartPoint
                            ScriptInjectionEndPoint = $line.ScriptInjectionEndPoint
                            ModifyInfoFileTooltype = $line.ModifyInfoFileTooltype
                        }
                        $counter ++
                    } until (
                        $Counter -eq ($CountofVariables+1)
                    )
                }
                else{
                    $RevisedListofInstallFiles  += [PSCustomObject]@{
                        Kickstart_Version = $line.Kickstart_Version  
                        Kickstart_VersionFriendlyName = $line.Kickstart_VersionFriendlyName 
                        InstallSequence = $line.InstallSequence
                        ADF_Name = $line.ADF_Name
                        FriendlyName = $line.FriendlyName
                        AmigaFiletoInstall = $line.AmigaFiletoInstall
                        DrivetoInstall = $line.DrivetoInstall
                        LocationtoInstall = $line.LocationtoInstall
                        NewFileName = $line.NewFileName
                        ExcludedFolders = $line.ExcludedFolder
                        ExcludedFiles = $line.ExcludedFiles 
                        Uncompress = $line.Uncompress
                        ModifyScript = $line.ModifyScript
                        ScriptNameofChange = $line.ScriptNameofChange
                        ScriptInjectionStartPoint = $line.ScriptInjectionStartPoint
                        ScriptInjectionEndPoint = $line.ScriptInjectionEndPoint
                        ModifyInfoFileTooltype = $line.ModifyInfoFileTooltype
                    }
                }
            }
        }

        if ($IncludePath){
            $HashTableADFPath = @{} # Clear Hash
            $Script:GUIActions.FoundADFstoUse | ForEach-Object {
                $HashTableADFPath[$_.ADF_Name] = @($_.Path)
            }

            $RevisedListofInstallFiles  | Add-Member -NotePropertyMembers @{
                Path = $null
            }

            $RevisedListofInstallFiles  | ForEach-Object {
                if ($HashTableADFPath.ContainsKey($_.ADF_Name)){
                    $_.Path = $HashTableADFPath.($_.ADF_Name)[0]

                } 
            }

        }

        return $RevisedListofInstallFiles
}



# $HSTScript = Get-ListofInstallFilesExtractionCommands -AmigaDrivetoUse "$($Script:GUIActions.OutputPath)\$(Get-AmigaDrivePath -DeviceName)" -AmigaTempDrivetoUse "$($Script:Settings.AmigaTempDrive)\$(Get-AmigaDrivePath -DeviceName)" -TempDriveFilesOnly

# Start-HSTImagerScript -Script $HSTScript 



# $AmigaDrivetoUse = "$($Script:GUIActions.OutputPath)\$(Get-AmigaDrivePath -DeviceName)"
# $AmigaTempDrivetoUse = "$($Script:Settings.AmigaTempDrive)\$(Get-AmigaDrivePath -DeviceName)"



# # Write-AmigaWorkbenchFileChanges -AmigaTempDrivetoUse "$($Script:Settings.AmigaTempDrive)\SDH0"

