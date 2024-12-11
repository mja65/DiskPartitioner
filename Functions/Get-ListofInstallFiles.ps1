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



function Get-WorkbenchExtractionCommands {
    param (
        $AmigaDrivetoUse,
        $AmigaTempDrivetoUse 
    )
    
    $OutputCommands = @()
    
    # $AmigaDrivetoUse = "$($Script:GUIActions.OutputPath)\$(Get-AmigaDrivePath)"
    # $AmigaTempDrivetoUse = "$($Script:Settings.AmigaTempDrive)\SDH0"
    $ListofInstallFiles = Get-ListofInstallFiles -ListofInstallFilesCSV $Script:Settings.ListofInstallFiles -IncludePath | Where-Object {$_.Kickstart_Version -eq $Script:GUIActions.KickstartVersiontoUse}

    Foreach($InstallFileLine in $ListofInstallFiles){
        
        $SourcePathtoUse = "$($InstallFileLine.Path)\$($InstallFileLine.AmigaFiletoInstall -replace '/','\')"
        if (($InstallFileLine.NewFileName -ne "")  -or ($InstallFileLine.ModifyScript -ne 'FALSE') -or ($InstallFileLine.ModifyInfoFileTooltype -ne 'FALSE')){
            if ($InstallFileLine.LocationtoInstall.Length -eq 0){
                $DestinationPathtoUse = $AmigaTempDrivetoUse
            }
            else {
                $DestinationPathtoUse = "$AmigaTempDrivetoUse\$($InstallFileLine.LocationtoInstall -replace '/','\')" 
            }    
    
        }
        else {
            if ($InstallFileLine.LocationtoInstall.Length -eq 0){
                $DestinationPathtoUse = $AmigaDrivetoUse 
            }
            else {
                $DestinationPathtoUse = "$AmigaDrivetoUse\$($InstallFileLine.LocationtoInstall -replace '/','\')" 
            }    
            
        }
        $OutputCommands += "fs extract $SourcePathtoUse $DestinationPathtoUse"  
    }
    
    return $OutputCommands
}

function Write-AmigaWorkbenchFileChanges {
    param (
        $AmigaTempDrivetoUse 
    )
    
    # $AmigaTempDrivetoUse = "$($Script:Settings.AmigaTempDrive)\SDH0"

    $ListofInstallFiles = Get-ListofInstallFiles -ListofInstallFilesCSV $Script:Settings.ListofInstallFiles -IncludePath | Where-Object {$_.Kickstart_Version -eq $Script:GUIActions.KickstartVersiontoUse} | Where-Object {$_.NewFileName -ne "" -or $_.ModifyScript -ne 'FALSE' -or $_.ModifyInfoFileTooltype -ne 'FALSE'}
    
    Foreach($InstallFileLine in $ListofInstallFiles){
        $LocationtoInstall = $InstallFileLine.LocationtoInstall -replace '/','\'
        if ($InstallFileLine.NewFileName -ne ""){
            $filename = $InstallFileLine.AmigaFiletoInstall.Split("/")[-1]
            $null = rename-Item -Path "$AmigaTempDrivetoUse\$LocationtoInstall\$filename"  -NewName $InstallFileLine.NewFileName     
        }
        if ($InstallFileLine.ModifyInfoFileTooltype -eq 'Modify'){
            Read-AmigaTooltypes -IconPath "$AmigaTempDrivetoUse\$LocationtoInstall$filename" -TooltypesPath "$($Script:ExternalProgramSettings.TempFolder)\$filename`.txt"              
            $OldToolTypes = Get-Content "$($Script:ExternalProgramSettings.TempFolder)\$filename`.txt"           
            $TooltypestoModify = Import-Csv "$($Script:Settings.LocationofAmigaFiles)\$LocationtoInstall\$filename`.txt" -Delimiter ';'
            Get-ModifiedToolTypes -OriginalToolTypes $OldToolTypes -ModifiedToolTypes $TooltypestoModify | Out-File "$($Script:ExternalProgramSettings.TempFolder)\$filename`amendedtoimport.txt"    
            Write-AmigaTooltypes -IconPath "$AmigaTempDrivetoUse\$LocationtoInstall$filename" -ToolTypesPath "$($Script:ExternalProgramSettings.TempFolder)\$filename`amendedtoimport.txt"    
        }   
        if ($InstallFileLine.ModifyScript -eq'Remove'){
            Write-InformationMessage -Message  "Modifying $FileName for: $($InstallFileLine.ScriptNameofChange)"
            $ScripttoEdit = Import-TextFileforAmiga -SystemType 'Amiga' -ImportFile "$AmigaTempDrivetoUse\$LocationtoInstall$filename"
            $ScripttoEdit = Edit-AmigaScripts -ScripttoEdit $ScripttoEdit -Action 'remove' -name $InstallFileLine.ScriptNameofChange -Startpoint $InstallFileLine.ScriptInjectionStartPoint -Endpoint $InstallFileLine.ScriptInjectionEndPoint                    
            Export-TextFileforAmiga -ExportFile "$AmigaTempDrivetoUse\$LocationtoInstall$filename" -DatatoExport $ScripttoEdit -AddLineFeeds 'TRUE'
        }   
    }
}



# Get-WorkbenchExtractionCommands -AmigaDrivetoUse "$($Script:GUIActions.OutputPath)\$(Get-AmigaDrivePath)" -AmigaTempDrivetoUse "$($Script:Settings.AmigaTempDrive)\SDH0"
# Write-AmigaWorkbenchFileChanges -AmigaTempDrivetoUse "$($Script:Settings.AmigaTempDrive)\SDH0"




