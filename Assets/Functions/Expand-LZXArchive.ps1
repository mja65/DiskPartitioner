function Expand-LZXArchive {
    param (
        $LZXFile,
        $DestinationPath
    )

    # $LZXFile = ".\Temp\WebPackagesDownload\DOpus417pre21.lzx" 
    # $DestinationPath = ".\Temp\WebPackagesDownload\DOpus417pre21"

    Write-InformationMessage -Message "Extracting file $LZXFile"
    if (-not(Test-Path $DestinationPath -PathType Container)){
       $null = New-Item $DestinationPath -ItemType Directory
    }

    $CurrentLocation = Get-Location
    $unlzxPathtoUse = [System.IO.Path]::GetFullPath($Script:ExternalProgramSettings.UnlzxFilePath)
    $TempFoldertoUse = [System.IO.Path]::GetFullPath($Script:Settings.TempFolder)
    $LZXFiletouse = [System.IO.Path]::GetFullPath($LZXFile)

    Set-Location $DestinationPath
    & $unlzxPathtoUse $LZXFiletouse >"$TempFoldertoUse\LogOutputTemp.txt"
    Set-Location $CurrentLocation
    if ($LASTEXITCODE -ne 0) {
        Write-ErrorMessage -Message "Error extracting from $LZXFile Cannot continue!"
        return $false    
    }
    else {
        return $true
    }
     

}