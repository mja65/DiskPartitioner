function Expand-Packages {
    param (
        $ListofPackages,
        [Switch]$Web,
        [Switch]$Local
    )
    
    $Script:Settings.TotalNumberofSubTasks = 1
    $Script:Settings.CurrentSubTaskNumber = 1
   
    # $ListofPackages = $ListofPackagestoDownloadfromInternet
    # $ListofPackages = $ListofLocalPackages

    if ($Web) {

        $ArchivestoExtract = [System.Collections.Generic.List[PSCustomObject]]::New()
        $ListofPackages | ForEach-Object {
            $FileExtension = $_.FileDownloadName.Substring($_.FileDownloadName.Length -4,4)
            $ArchivestoExtract += [PSCustomObject]@{
                SourceLocation = [System.IO.Path]::GetFullPath("$($Script:Settings.WebPackagesDownloadLocation)\$($_.FileDownloadName)")
                FoldertoExtract = [System.IO.Path]::GetFullPath("$($Script:Settings.WebPackagesDownloadLocation)\$($_.FileDownloadName.Substring(0,$_.FileDownloadName.Length -4))")
                FileExtension = $FileExtension
            }
        }
    }
    elseif ($Local) {
        $ArchivestoExtract = [System.Collections.Generic.List[PSCustomObject]]::New()
        $ListofPackages | ForEach-Object {
            $FiletoExtract = Split-Path $_.SourceLocation -leaf  
            $FileExtension = $_.SourceLocation.Substring($_.SourceLocation.Length -4,4)
            $DestinationFolder = "$($Script:Settings.LocalPackagesDownloadLocation)\$($FiletoExtract.substring(0,$FiletoExtract.length-4))" 
            $ArchivestoExtract += [PSCustomObject]@{
                SourceLocation = [System.IO.Path]::GetFullPath("$($Script:Settings.LocationofAmigaFiles)\$($_.SourceLocation)") 
                FoldertoExtract = [System.IO.Path]::GetFullPath($DestinationFolder) 
                FileExtension = $FileExtension
            }
        }
    }

    $Script:Settings.TotalNumberofSubTasks ++         
    $Script:Settings.CurrentSubTaskName = "Removing any existing extracted files"
    Write-StartSubTaskMessage
    $Script:Settings.CurrentSubTaskNumber ++
    
    $FilestoDelete = $ArchivestoExtract | ForEach-Object { $_.FoldertoExtract }

    Show-SpinnerWhileDeleting -ScriptBlock {
        $using:FilestoDelete | ForEach-Object {
            if (Test-Path -Path $_ -PathType Container){
                 $null = Remove-Item $_ -Recurse -Force
            }
        }
    }

    # $ArchivestoExtract | ForEach-Object {
    #     Write-host "Test I should have done earlier $($_.FoldertoExtract)" 
    #     if (Test-Path -Path $_.FoldertoExtract -PathType Container){
    #         $null = Remove-Item $_.FoldertoExtract -Recurse -Force
    #     }
    # }
  
    $Script:Settings.CurrentSubTaskName = "Extracting Files from Package(s)"
    
    Write-StartSubTaskMessage

    $ArchivestoExtract | ForEach-Object {
        if ($_.FileExtension -eq '.lzx'){
            if (-not (Expand-LZXArchive -LZXFile $_.SourceLocation -DestinationPath $_.FoldertoExtract)){
                Write-ErrorMessage "Error extracting $($_.SourceLocation)! Exiting"
            }
        }
        elseif ($_.FileExtension -eq '.lha' -or $FileExtension -eq '.zip'){
            if (-not (Expand-Archive -InputFile $_.SourceLocation -OutputDirectory "$($_.FoldertoExtract)\")){
                Write-ErrorMessage "Error extracting $($_.SourceLocation)! Exiting"
                exit
            }
        }
    }
    
}
