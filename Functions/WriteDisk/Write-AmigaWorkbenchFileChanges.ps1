function Write-AmigaWorkbenchFileChanges {
    param (
        $AmigaDrivetoUse,
        $AmigaTempDrivetoUse
    )
    
    # $AmigaDrivetoUse = "$($Script:GUIActions.OutputPath)\$(Get-AmigaDrivePath -DeviceName)"
    # $AmigaTempDrivetoUse = "$($Script:Settings.AmigaTempDrive)\$(Get-AmigaDrivePath -DeviceName)"

    $AmigaDrivetoUse = (Resolve-Path $AmigaDrivetoUse).Path
    $AmigaTempDrivetoUse = (Resolve-Path $AmigaTempDrivetoUse).Path

    $ListofInstallFiles = Get-ListofInstallFiles -ListofInstallFilesCSV $Script:Settings.ListofInstallFiles -IncludePath | Where-Object {$_.Kickstart_Version -eq $Script:GUIActions.KickstartVersiontoUse} | Where-Object {$_.NewFileName -ne "" -or $_.ModifyScript -ne 'FALSE' -or $_.ModifyInfoFileTooltype -ne 'FALSE'}
    $OutputCommands = @()
    
    Foreach($InstallFileLine in $ListofInstallFiles){
        $LocationtoInstall = $InstallFileLine.LocationtoInstall -replace '/','\'
        $ExistingFilename = $InstallFileLine.AmigaFiletoInstall.Split("/")[-1]
        if ($InstallFileLine.NewFileName.Length -ne 0){
            $null = copy-Item  -Path "$AmigaTempDrivetoUse\$LocationtoInstall\$ExistingFilename" -Destination "$AmigaTempDrivetoUse\$LocationtoInstall\$($InstallFileLine.NewFileName)" 
            $OutputCommands += "fs copy `"$AmigaTempDrivetoUse\$LocationtoInstall\$($InstallFileLine.NewFileName)`"  `"$AmigaDrivetoUse\$LocationtoInstall`""     
        }
        if ($InstallFileLine.ModifyInfoFileTooltype -eq 'Modify'){
            if ($InstallFileLine.NewFileName.Length -ne 0){
                $ToolTypePathtoUse = "$AmigaTempDrivetoUse\$LocationtoInstall\$($InstallFileLine.NewFileName)"
            }
            else {
                $ToolTypePathtoUse = "$AmigaTempDrivetoUse\$LocationtoInstall\$ExistingFilename"
            }
            $ToolTypeNametoUse = Split-Path $ToolTypePathtoUse -Leaf
            Read-AmigaTooltypes -IconPath $ToolTypePathtoUse -TooltypesPath "$($Script:ExternalProgramSettings.TempFolder)\$ToolTypeNametoUse`.txt"              
            $OldToolTypes = Get-Content "$($Script:ExternalProgramSettings.TempFolder)\$ToolTypeNametoUse`.txt"           
            $TooltypestoModify = Import-Csv "$($Script:Settings.LocationofAmigaFiles)\$LocationtoInstall\$ToolTypeNametoUse`.txt" -Delimiter ';'
            Get-ModifiedToolTypes -OriginalToolTypes $OldToolTypes -ModifiedToolTypes $TooltypestoModify | Out-File "$($Script:ExternalProgramSettings.TempFolder)\$($ToolTypeNametoUse)amendedtoimport.txt"    
            Write-AmigaTooltypes -IconPath "$AmigaTempDrivetoUse\$LocationtoInstall\$ToolTypeNametoUse" -ToolTypesPath "$($Script:ExternalProgramSettings.TempFolder)\$($ToolTypeNametoUse)amendedtoimport.txt"    
        }   
        if ($InstallFileLine.ModifyScript -eq'Remove'){
            Write-InformationMessage -Message  "Modifying $ExistingFilename for: $($InstallFileLine.ScriptNameofChange)"
            $ScripttoEdit = Import-TextFileforAmiga -SystemType 'Amiga' -ImportFile "$AmigaTempDrivetoUse\$LocationtoInstall$ExistingFilename"
            $ScripttoEdit = Edit-AmigaScripts -ScripttoEdit $ScripttoEdit -Action 'remove' -name $InstallFileLine.ScriptNameofChange -Startpoint $InstallFileLine.ScriptInjectionStartPoint -Endpoint $InstallFileLine.ScriptInjectionEndPoint                    
            Export-TextFileforAmiga -ExportFile "$AmigaTempDrivetoUse\$LocationtoInstall$ExistingFilename" -DatatoExport $ScripttoEdit -AddLineFeeds 'TRUE'
        }   
    }
    
   
    }