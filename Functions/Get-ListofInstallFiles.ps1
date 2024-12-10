function Get-ListofInstallFiles {
    param (
        $ListofInstallFilesCSV
        )       

        #$ListofInstallFilesCSV = ($InputFolder+'ListofInstallFiles.csv')

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
        return $RevisedListofInstallFiles
}


$InstallFiles = Get-ListofInstallFiles -ListofInstallFilesCSV $Script:Settings.ListofInstallFiles


# $OutputCommands = @()

# Foreach($InstallFileLine in $ListofInstallFiles){
#     $SourcePathtoUse = "$($InstallFileLine.Path)\$($InstallFileLine.AmigaFiletoInstall -replace '/','\')"
#     if ($InstallFileLine.Uncompress -eq "TRUE"){
#         Write-InformationMessage -Message 'Extracting files from ADFs containing .Z files'
#         if ($InstallFileLine.LocationtoInstall.Length -eq 0){        
#             $DestinationPathtoUse = "$AmigaDrivetoCopy$($InstallFileLine.DrivetoInstall_VolumeName)"
#         }
#         else{  
#             $DestinationPathtoUse = "$AmigaDrivetoCopy$($InstallFileLine.DrivetoInstall_VolumeName)\$($InstallFileLine.LocationtoInstall -replace '/','\')" 
#         }
#         $OutputCommands += "fs extract $SourcePathtoUse $DestinationPathtoUse"       
        
#         #Expand-AmigaZFiles  -SevenzipPathtouse $7zipPath -WorkingFoldertouse $TempFolder -LocationofZFiles $DestinationPathtoUse
#     }    
#     elseif (($InstallFileLine.NewFileName -ne "")  -or ($InstallFileLine.ModifyScript -ne 'FALSE') -or ($InstallFileLine.ModifyInfoFileTooltype -ne 'FALSE')){
#         if ($InstallFileLine.LocationtoInstall -ne '`*'){
#             $LocationtoInstall=(($InstallFileLine.LocationtoInstall -replace '/','\')+'\')
#         }
#         else{
#             $LocationtoInstall=$null
#         }
#         if ($InstallFileLine.NewFileName -ne ""){
#             $FullPath = $AmigaDrivetoCopy+$InstallFileLine.DrivetoInstall_VolumeName+'\'+$LocationtoInstall+$InstallFileLine.NewFileName
#         }
#         else{
#             $FullPath = $AmigaDrivetoCopy+$InstallFileLine.DrivetoInstall_VolumeName+'\'+$LocationtoInstall+(Split-Path ($InstallFileLine.AmigaFiletoInstall -replace '/','\') -Leaf) 
#         }
#         $filename = Split-Path $FullPath -leaf
#         Write-InformationMessage -Message 'Extracting files from ADFs where changes needed'
#         if ($InstallFileLine.LocationtoInstall.Length -eq 0){
#             $DestinationPathtoUse = ($AmigaDrivetoCopy+$InstallFileLine.DrivetoInstall_VolumeName)
#         }
#         else{        
#             $DestinationPathtoUse = ($AmigaDrivetoCopy+$InstallFileLine.DrivetoInstall_VolumeName+'\'+($InstallFileLine.LocationtoInstall -replace '/','\'))
#         }
#         if (-not (Start-HSTImager -Command 'fs extract' -SourcePath $SourcePathtoUse -DestinationPath $DestinationPathtoUse -TempFoldertouse $TempFolder -HSTImagePathtouse $HSTImagePath)){
#             exit
#         }
#         if ($InstallFileLine.NewFileName -ne ""){
#             $NameofFiletoChange=$InstallFileLine.AmigaFiletoInstall.split("/")[-1]  
#             if (Test-Path ($AmigaDrivetoCopy+$InstallFileLine.DrivetoInstall_VolumeName+'\'+$LocationtoInstall+$InstallFileLine.NewFileName)){
#                 Remove-Item ($AmigaDrivetoCopy+$InstallFileLine.DrivetoInstall_VolumeName+'\'+$LocationtoInstall+$InstallFileLine.NewFileName)
#             }
#             $null = rename-Item -Path ($AmigaDrivetoCopy+$InstallFileLine.DrivetoInstall_VolumeName+'\'+$LocationtoInstall+$NameofFiletoChange) -NewName $InstallFileLine.NewFileName            
#         }
#         if ($InstallFileLine.ModifyInfoFileTooltype -eq 'Modify'){
#             if (-not (Read-AmigaTooltypes -IconPath ($AmigaDrivetoCopy+$InstallFileLine.DrivetoInstall_VolumeName+'\'+$LocationtoInstall+$filename) -TooltypesPath ($TempFolder+$filename+'.txt') -HSTAmigaPathtouse $HSTAmigaPath -TempFoldertouse $TempFolder)){
#                 exit
#             }                 
#             $OldToolTypes = Get-Content($TempFolder+$filename+'.txt')
#             $TooltypestoModify = Import-Csv ($LocationofAmigaFiles+$LocationtoInstall+'\'+$filename+'.txt') -Delimiter ';'
#             Get-ModifiedToolTypes -OriginalToolTypes $OldToolTypes -ModifiedToolTypes $TooltypestoModify | Out-File ($TempFolder+$filename+'amendedtoimport.txt')
#             if (-not (Write-AmigaTooltypes -IconPath ($AmigaDrivetoCopy+$InstallFileLine.DrivetoInstall_VolumeName+'\'+$LocationtoInstall+$filename) -ToolTypesPath ($TempFolder+$fileName+'amendedtoimport.txt') -TempFoldertouse $TempFolder -HSTAmigaPathtouse $HSTAmigaPath)){
#                 exit
#             }                 
#         }        
#         if ($InstallFileLine.ModifyScript -eq'Remove'){
#             Write-InformationMessage -Message  ('Modifying '+$FileName+' for: '+$InstallFileLine.ScriptNameofChange)
#             $ScripttoEdit = Import-TextFileforAmiga -SystemType 'Amiga' -ImportFile ($AmigaDrivetoCopy+$InstallFileLine.DrivetoInstall_VolumeName+'\'+$LocationtoInstall+$FileName)
#             $ScripttoEdit = Edit-AmigaScripts -ScripttoEdit $ScripttoEdit -Action 'remove' -name $InstallFileLine.ScriptNameofChange -Startpoint $InstallFileLine.ScriptInjectionStartPoint -Endpoint $InstallFileLine.ScriptInjectionEndPoint                    
#             Export-TextFileforAmiga -ExportFile ($AmigaDrivetoCopy+$InstallFileLine.DrivetoInstall_VolumeName+'\'+$LocationtoInstall+$FileName) -DatatoExport $ScripttoEdit -AddLineFeeds 'TRUE'
#         }   
#     }
#     else {
#         Write-InformationMessage -Message 'Extracting files from ADFs to .hdf file'
#         if ($InstallFileLine.LocationtoInstall.Length -eq 0){
#            $DestinationPathtoUse = ($HDFImageLocation +$NameofImage+'\rdb\'+$DeviceName_System)
#         }
#         else{
#            $DestinationPathtoUse = ($HDFImageLocation +$NameofImage+'\rdb\'+$DeviceName_System+'\'+($InstallFileLine.LocationtoInstall -replace '/','\'))
#         }
#         if (-not (Start-HSTImager -Command 'fs extract' -SourcePath $SourcePathtoUse -DestinationPath $DestinationPathtoUse -TempFoldertouse $TempFolder -HSTImagePathtouse $HSTImagePath)){
#             exit
#         }
#     }         
#     $ItemCounter+=1    
# }