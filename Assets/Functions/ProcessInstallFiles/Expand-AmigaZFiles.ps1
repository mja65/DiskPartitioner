function Expand-AmigaZFiles {
    param (
        $LocationofZFiles,
        [switch]$MultipleDirectoryFlag

    )
    
    # $LocationofZFiles = "C:\Users\Matt\OneDrive\Documents\EmuImager2\Temp\InterimAmigaDrives\System\Locale"

    $CurrentLocation = Get-Location
    $SevenzipPathtouse  = [System.IO.Path]::GetFullPath($Script:ExternalProgramSettings.SevenZipFilePath)
    $LogLocation = [System.IO.Path]::GetFullPath($Script:Settings.LogLocation)

    $LocationofZFiles = [System.IO.Path]::GetFullPath($LocationofZFiles)

    if ($MultipleDirectoryFlag){
        $DirectoriestoDecompress = ((Get-ChildItem  -path $LocationofZFiles -Recurse -Filter '*.Z').Directory).FullName 
        $UniqueDirectoriestoDecompress = $DirectoriestoDecompress | Select-Object -Unique 
        foreach ($Directory in $UniqueDirectoriestoDecompress){
            Write-InformationMessage -Message "Decompressing .Z files in location: $Directory" -LogLocation $LogLocation
            set-location $Directory 
            & $SevenzipPathtouse e *.z -bso0 -bsp0 -y
        }
        
        

    }
    else {
        $ListofFilestoDecompress = Get-ChildItem -Path $LocationofZFiles -Recurse -Filter '*.Z'
        Write-InformationMessage -Message "Decompressing .Z files in location: $LocationofZFiles" 
        foreach ($FiletoDecompress in $ListofFilestoDecompress){
            $InputFile = $FiletoDecompress.FullName
            set-location $FiletoDecompress.DirectoryName
            & $SevenzipPathtouse e $InputFile -bso0 -bsp0 -y
        }    
        
    }

    Set-Location $CurrentLocation
    
    Write-InformationMessage -Message "Deleting .Z files in location: $LocationofZFiles"
    
    Get-ChildItem -Path $LocationofZFiles -Recurse -Filter '*.Z' | remove-Item -Recurse -Force
   

}