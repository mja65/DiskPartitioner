function Get-InputCSVs {
    param (
      [switch]$OSestoInstall,
      [Switch]$Diskdefaults,
      [switch]$ROMHashes,
      [switch]$InstallMediaHashes,
      [switch]$ScreenModes,
      [switch]$PackagestoInstall,
      [switch]$FileSystems

    )
    

    if ($OSestoInstall){
        $Pathtouse = $Script:Settings.OSVersionstoInstallCSV.Path 
    }
    elseif ($Diskdefaults){
        $Pathtouse = $Script:Settings.DiskDefaultsCSV.Path
    }
    elseif ($FileSystems){
        $Pathtouse = $Script:Settings.FileSystemsCSV.Path
    }
    elseif ($ScreenModes){
        $Pathtouse = $Script:Settings.ScreenModesCSV.Path
    }
    elseif ($RomHashes){
        $Pathtouse = $Script:Settings.ROMHashesCSV.Path
    }
    elseif ($InstallMediaHashes){
        $Pathtouse = $Script:Settings.InstallMediaHashesCSV.Path
    }
    elseif ($PackagestoInstall){
        $Pathtouse = $Script:Settings.ListofPackagestoInstallCSV.Path
    }

    
    $CSV = @()
    
    import-csv -path $Pathtouse -Delimiter ";" | ForEach-Object {
        if ($_.MinimumInstallerVersion -ne "" -and $_.InstallerVersionLessThan -ne ""){
            if (($Script:Settings.Version -ge [system.version]$_.MinimumInstallerVersion) -and ($Script:Settings.Version -lt [system.version]$_.InstallerVersionLessThan)){
                $CSV += $_
            }
        }
    }
 
    if ($OSestoInstall){
        $CSVtoReturn = $CSV | Select-Object 'Kickstart_Version','Kickstart_VersionFriendlyName','InstallMedia','NewFolderIconSource','NewFolderIconSourceType','NewFolderIconSourcePath','WorkbenchIconSource','WorkbenchIconSourceType','WorkbenchIconSourcePath','WorkbenchModifyInfoFileType','WorkIconSource','WorkIconSourceType','WorkIconSourcePath','WorkModifyInfoFileType','Emu68BootIconSource','Emu68BootIconSourceType','Emu68BootIconSourcePath','Emu68BootModifyInfoFileType'

    }
    elseif ($FileSystems) {
        $CSVtoReturn = $CSV
    }
    elseif ($Diskdefaults){
        $CSVtoReturn = $CSV
    }
    elseif ($ScreenModes){
        $CSVtoReturn = $CSV | Where-Object 'Include' -eq 'TRUE'
    }
    elseif ($RomHashes){
        $CSVtoReturn = $CSV | Select-Object 'IncludeorExclude','ExcludeMessage','Kickstart_Version','Sequence','Hash','FriendlyName','FAT32Name' | Where-Object {$_.Kickstart_Version -eq $Script:GUIActions.KickstartVersiontoUse}
    }
    elseif ($InstallMediaHashes){
        $CSVtoReturn = $CSV | Select-Object 'Sequence', 'WorkbenchVersion', 'Hash', 'InstallMedia', 'ADF_Name', 'FriendlyName', 'ADFSource', 'ADFDescription' 
    }
    elseif ($PackagestoInstall){
        
        $CSVtoReturn = [System.Collections.Generic.List[PSCustomObject]]::New()

        $CSV | ForEach-Object {
            $CountofVariables = ([regex]::Matches($_.KickstartVersion, "," )).count
            if ($CountofVariables -gt 0){
                $Counter = 0
                do {
                    $CSVtoReturn += [PSCustomObject]@{                              
                        MinimumInstallerVersion = [system.version]$_.MinimumInstallerVersion
                        InstallerVersionLessThan = [system.version]$_.InstallerVersionLessThan
                        KickstartVersion = [system.version](($_.KickstartVersion -split ',')[$Counter]) 
                        PackageName = $_.PackageName
                        PackageMandatory =	$_.PackageMandatory
                        PackageNameDefaultInstall = $_.PackageNameDefaultInstall 
                        PackageNameFriendlyName = $_.PackageNameFriendlyName
                        PackageNameGroup = $_.PackageNameGroup 
                        PackageNameDescription = $_.PackageNameDescription
                        UpdatePackageSearchTerm = $_.UpdatePackageSearchTerm
                        UpdatePackageSearchResultLimit = $_.UpdatePackageSearchResultLimit
                        UpdatePackageSearchExclusionTerm = $_.UpdatePackageSearchExclusionTerm
                        UpdatePackageSearchMinimumDate = $_.UpdatePackageSearchMinimumDate
                        InstallSequence = $_.InstallSequence
                        Source = $_.Source
                        GithubReleaseType = $_.GithubReleaseType
                        GithubName = $_.GithubName
                        InstallType = $_.InstallType
                        SourceLocation = $_.SourceLocation
                        BackupSourceLocation = $_.BackupSourceLocation
                        ArchiveinArchiveName = $_.ArchiveinArchiveName
                        ArchiveinArchivePassword = $_.ArchiveinArchivePassword
                        FileDownloadName = $_.FileDownloadName
                        PerformHashCheck = $_.PerformHashCheck
                        Hash = $_.Hash
                        FilestoInstall = $_.FilestoInstall
                        DrivetoInstall = $_.DrivetoInstall
                        LocationtoInstall = $_.LocationtoInstall
                        UncompressZFiles = $_.UncompressZFiles
                        CreateFolderInfoFile = $_.CreateFolderInfoFile
                        NewFileName = $_.NewFileName
                        ScriptBeingModified = $_.ScriptBeingModified
                        ModifyScript  = $_.ModifyScript 
                        ModifyScriptAction = $_.ModifyScriptAction
                        ScriptNameofChange = $_.ScriptNameofChange
                        ScriptEditStartPoint = $_.ScriptEditStartPoint
                        ScriptEditEndPoint = $_.ScriptEditEndPoint
                        ScriptPathtoChanges = $_.ScriptPathtoChanges
                        ScriptArexxFlag = $_.ScriptArexxFlag
                        ModifyInfoFileType = $_.ModifyInfoFileType
                        ModifyInfoFileTooltype  = $_.ModifyInfoFileTooltype 
                        PathtoRevisedToolTypeInfo = $_.PathtoRevisedToolTypeInfo                                                            
                    }
                    $counter ++
                 } until (
                        $Counter -eq ($CountofVariables+1)
                    )
            }
            else {
                $CSVtoReturn += [PSCustomObject]@{
                    MinimumInstallerVersion = [system.version]$_.MinimumInstallerVersion
                    InstallerVersionLessThan = [system.version]$_.InstallerVersionLessThan
                    KickstartVersion = [system.version]$_.KickstartVersion
                    PackageName = $_.PackageName
                    PackageMandatory =	$_.PackageMandatory
                    PackageNameDefaultInstall = $_.PackageNameDefaultInstall 
                    PackageNameFriendlyName = $_.PackageNameFriendlyName
                    PackageNameGroup = $_.PackageNameGroup 
                    PackageNameDescription = $_.PackageNameDescription
                    UpdatePackageSearchTerm = $_.UpdatePackageSearchTerm
                    UpdatePackageSearchResultLimit = $_.UpdatePackageSearchResultLimit
                    UpdatePackageSearchExclusionTerm = $_.UpdatePackageSearchExclusionTerm
                    UpdatePackageSearchMinimumDate = $_.UpdatePackageSearchMinimumDate
                    InstallSequence = $_.InstallSequence
                    Source = $_.Source
                    GithubReleaseType = $_.GithubReleaseType
                    GithubName = $_.GithubName
                    InstallType = $_.InstallType
                    SourceLocation = $_.SourceLocation
                    BackupSourceLocation = $_.BackupSourceLocation
                    ArchiveinArchiveName = $_.ArchiveinArchiveName
                    ArchiveinArchivePassword = $_.ArchiveinArchivePassword
                    FileDownloadName = $_.FileDownloadName
                    PerformHashCheck = $_.PerformHashCheck
                    Hash = $_.Hash
                    FilestoInstall = $_.FilestoInstall
                    DrivetoInstall = $_.DrivetoInstall
                    LocationtoInstall = $_.LocationtoInstall
                    UncompressZFiles = $_.UncompressZFiles
                    CreateFolderInfoFile = $_.CreateFolderInfoFile
                    NewFileName = $_.NewFileName
                    ScriptBeingModified = $_.ScriptBeingModified
                    ModifyScript  = $_.ModifyScript 
                    ModifyScriptAction = $_.ModifyScriptAction
                    ScriptNameofChange = $_.ScriptNameofChange
                    ScriptEditStartPoint = $_.ScriptEditStartPoint
                    ScriptEditEndPoint = $_.ScriptEditEndPoint
                    ScriptPathtoChanges = $_.ScriptPathtoChanges
                    ScriptArexxFlag = $_.ScriptArexxFlag
                    ModifyInfoFileType = $_.ModifyInfoFileType
                    ModifyInfoFileTooltype  = $_.ModifyInfoFileTooltype 
                    PathtoRevisedToolTypeInfo = $_.PathtoRevisedToolTypeInfo                                                                         
                }
            }
        }

        $CSVtoReturn = $CSVtoReturn | Where-Object {$_.KickstartVersion -eq $Script:GUIActions.KickstartVersiontoUse}

    }

    return $CSVtoReturn
}

