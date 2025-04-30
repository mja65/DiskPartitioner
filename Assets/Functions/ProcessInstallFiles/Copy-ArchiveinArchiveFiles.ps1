function Copy-ArchiveinArchiveFiles {
    param (
        $InputFile,
        $OutputDirectory,
        $FiletoExtract, 
        $NewFileName,      
        $ArchiveinArchiveName,
        $ArchiveinArchivePassword
    )

    # $SevenzipPathtouse = 'E:\Emu68Imager\Programs\7z.exe'
    # $TempFoldertouse = 'E:\Emu68Imager\Working Folder\Temp\'
    # $InputFile = 'E:\Emulators\Amiga Files\3.9\BoingBag39-2.lha'
    # $FiletoExtract = 'Devs\AmigaOS ROM Update.BB39-2'
    # $OutputDirectory = 'E:\Emu68Imager\Working Folder\AmigaImageFiles\Workbench\Devs\'
    # $ArchiveinArchiveName = 'BoingBag3.9-2\AmigaOS-Update'
    # $ArchiveinArchivePassword = '3FB6986B-B0AD6339-4FF3254B'
    # $NewFileName = 'AmigaOS ROM Update'

    $TempFoldertoExtract = "$($Script:Settings.TempFolder)\ArchiveinArchiveFiles\"
    $TempFoldertoExtract_ArchiveinArchive =  "$($Script:Settings.TempFolder)\ArchiveinArchiveFiles\AiAExtractedFiles\"

    # $ArchiveinArchiveName = $ArchiveinArchiveName.Replace('/','\') 

    if (-not (Test-Path $TempFoldertoExtract_ArchiveinArchive)){
        $null = New-Item $TempFoldertoExtract_ArchiveinArchive -ItemType Directory -Force #Will also create parent folder
    }
   
    $ArchiveinArchiveFullPath = "$TempFoldertoExtract$ArchiveinArchiveName"
    $ArchiveinArchiveExtractedFilesPath = "$TempFoldertoExtract_ArchiveinArchive$ArchiveinArchiveName\"

    if (-not (test-path $ArchiveinArchiveFullPath)){
        Write-InformationMessage "Archive in Archive $ArchiveinArchiveName does not exist. Extracting $ArchiveinArchiveName"

        & $Script:ExternalProgramSettings.SevenZipFilePath x "-o$TempFoldertoExtract" $InputFile $ArchiveinArchiveName -y > "$($Script:Settings.TempFolder)\LogOutputTemp.txt"

        if ($LASTEXITCODE -ne 0) {
            Write-ErrorMessage -Message "Error extracting $InputFile! Cannot continue!"
            return $false    
        }

        if (-not (Test-Path $ArchiveinArchiveExtractedFilesPath)){
            $null = New-Item $ArchiveinArchiveExtractedFilesPath -ItemType Directory -Force
        } 
        
        Write-InformationMessage "Extracting all files within $ArchiveinArchiveName"
        
       & $Script:ExternalProgramSettings.SevenZipFilePath x ('-o'+$ArchiveinArchiveExtractedFilesPath) ('-p'+$ArchiveinArchivePassword) $ArchiveinArchiveFullPath '*' y >($TempFoldertouse+'LogOutputTemp.txt')
    
        if ($LASTEXITCODE -ne 0) {
            Write-ErrorMessage -Message "Error extracting $ArchiveinArchiveFullPath in $InputFile! Cannot continue!"
            return $false    
        }

    }
    
    else {
        Write-InformationMessage "Archive in Archive $ArchiveinArchiveName exists."
    }
    
    if (-not (test-path $OutputDirectory)){
        $null = New-Item -Path $OutputDirectory -ItemType Directory
    }

    if ($NewFileName){
        Write-InformationMessage -Message "Copying file $ArchiveinArchiveExtractedFilesPath$FiletoExtract to $OutputDirectory with new name of $NewFileName"
        Copy-Item -Path "$ArchiveinArchiveExtractedFilesPath$FiletoExtract" -Destination "$OutputDirectory\$NewFileName" -Force -Recurse 
    }
    else {
        Write-InformationMessage -Message "Copying file $ArchiveinArchiveExtractedFilesPath$FiletoExtract to $OutputDirectory"
        Copy-Item -Path "$ArchiveinArchiveExtractedFilesPath$FiletoExtract" -Destination $OutputDirectory -Force -Recurse 
    }
    return $true
}