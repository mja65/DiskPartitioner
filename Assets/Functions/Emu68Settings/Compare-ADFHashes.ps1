function Compare-ADFHashes {
    param (
        $PathtoADFFiles,
        $KickstartVersion,
        $MaximumFilestoCheck
    
    )

    $Msg_Header ='Finding ADFs'    
    $Msg_Body = @"
Searching folder '$PathtoADFFiles' for valid Install files (e.g. ADFs, CDs, etc.). 
"@

$Msg_Header_ExceedLimitParent = 'Exceeded file limits!'   
$Msg_Body_ExceedLimitParent = @"
Search is limited to a maximum of $MaximumFilestoCheck files! Select a different path 
with less files or move the install files into the default 
'UserFiles\InstallMedia\' folder in your install path for the tool
and select this path to scan. 


"@
    $Msg_Header_ExceedLimit ='Exceeded file limits!'   
    $Msg_Body_ExceedLimit = @"
Search is limited to a maximum of 500 files! The current path (with no sub-folders) will be matched.

If this does not find your installation files (e.g. ADFs, CDs, 
etc.) either select a different path with less files or move 
the files into the default 'UserFiles\InstallMedia\' folder 
in your install path for the tool and select this path to scan. 

"@
    
    $null = Show-WarningorError -Msg_Body $Msg_Body -Msg_Header $Msg_Header -BoxTypeNone -ButtonType_OK

#    $PathtoADFFiles = 'E:\Emulators\Amiga Files\Update3.2.3\ADFs'
#    $KickstartVersion = '3.2.3'
#    $MaximumFilestoCheck = 40

#    $PathtoADFFiles = 'E:\Emulators\Amiga Files\3.9'0
#    $KickstartVersion = '3.9'
#    $MaximumFilestoCheck = 40

    $ListofADFFilestoCheck = Get-ChildItem $PathtoADFFiles -force -Recurse 

    $TotalNumberFilesParent = ($ListofADFFilestoCheck | Where-Object {$_.PSIsContainer -eq $false -and $_.DirectoryName -eq $PathtoADFFiles.TrimEnd('\') } | Measure-Object).count
    $TotalNumberFiles = ($ListofADFFilestoCheck| Where-Object {$_.PSIsContainer -eq $false} | Measure-Object).count

    if ($TotalNumberFilesParent -gt $MaximumFilestoCheck){
        $null = Show-WarningorError -BoxTypeError -ButtonType_OK -Msg_Body $Msg_Body_ExceedLimitParent -Msg_Header $Msg_Header_ExceedLimitParent
        return
    }
   
    if ($TotalNumberFiles -gt $MaximumFilestoCheck){
        $null = Show-WarningorError -BoxTypeWarning  -ButtonType_OK -Msg_Body $Msg_Body_ExceedLimit -Msg_Header $Msg_Header_ExceedLimit
        $ListofADFFilestoCheck = $ListofADFFilestoCheck |  Where-Object {$_.DirectoryName -eq $PathtoADFFiles.TrimEnd('\')} 
    }

    if ($Script:GUIActions.OSInstallMediaType -eq 'CD'){
        $ListofADFFilestoCheck = $ListofADFFilestoCheck | Where-Object { $_.PSIsContainer -eq $false -and ($_.Name -match '.iso' -or $_.Name -match '.lha')} | Get-FileHash  -Algorithm MD5
    }
    else {
        $ListofADFFilestoCheck = $ListofADFFilestoCheck | Where-Object { $_.PSIsContainer -eq $false -and $_.Name -match '.adf' -and $_.Length -eq 901120 } | Get-FileHash  -Algorithm MD5
    }

    $ADFHashes = Get-InputCSVs -InstallMediaHashes

   # $RequiredADFsforInstall = Get-InputCSVs -PackagestoInstall | Where-Object {$_.KickstartVersion -eq $KickstartVersion -and $_.PackageName -match "OS Install"} | Select-Object @{label='ADF_Name';expression={$_.SourceLocation}} -Unique # Unique ADFs Required
   $RequiredADFsforInstall = Confirm-RequiredSources | Where-Object {($_.Source -eq 'ADF' -or $_.Source -eq 'CD' -or $_.Source -eq 'Archive' -or $_.Source -eq 'ArchiveinArchive') -and ($_.RequiredFlagUserSelectable -eq 'True' -or $_.RequiredFlagUserSelectable -eq 'Mandatory')} | Select-Object @{label='ADF_Name';expression={$_.SourceLocation}} -Unique
   
    $HashTableforInstallMedia = @{} # Clear Hash
    $ADFHashes| ForEach-Object {
        $HashTableforInstallMedia[$_.ADF_Name] = @($_.FriendlyName,$_.TypeofCheck) 
    }
    
    $RequiredADFsforInstall| Add-Member -NotePropertyName 'FriendlyName' -NotePropertyValue $null
        
    $RequiredADFsforInstall | ForEach-Object {
        if ($HashTableforInstallMedia.ContainsKey($_.ADF_Name)){
            $_.FriendlyName = $HashTableforInstallMedia.($_.ADF_Name)[0]
        } 
    } 
       
    $RequiredADFandHashes = [System.Collections.Generic.List[PSCustomObject]]::New() # Allowing for if there are multiple hashes for the same ADF
    
    $PerformFilesCheck = $false

    foreach ($ADFHash in $ADFHashes){
        foreach ($RequiredADF in $RequiredADFsforInstall){
            if ($ADFHash.ADF_Name -eq $RequiredADF.ADF_Name){
                $7zStringtoUse = @()
                if ($ADFHash.TypeofCheck -eq 'FileCheck'){
                    $PerformFilesCheck = $true
                    for ($i = 0; $i -lt ($ADFHash.FilesChecked -split ',').count; $i++) {
                        $7zStringtoUse += "`"-ir!$(($ADFHash.FilesChecked -split ',')[$i])`""
                    }                    
                    $7zStringtoUse = $7zStringtoUse.TrimEnd().Trim('"') 
                }

                $RequiredADFandHashes += [PSCustomObject]@{
                    ADF_Name = $ADFHash.ADF_Name
                    FriendlyName = $ADFHash.FriendlyName
                    TypeofCheck = $ADFHash.TypeofCheck                    
                    FilesChecked = $7zStringtoUse
                    FileCheckDetails = $ADFHash.FileCheckDetails
                    Hash = $ADFHash.Hash
                    Sequence =  $ADFHash.Sequence
                    ADFSource = $ADFHash.ADFSource
                }
            }
        }
    }
    
    $PathofFoundADFS = [System.Collections.Generic.List[PSCustomObject]]::New()

    if ($PerformFilesCheck -eq $true){
        $RequiredADFandHashes | ForEach-Object {
            if ($_.TypeofCheck -eq 'FileCheck'){
                foreach ($ADFFiletoCheck in $ListofADFFilestoCheck) {
                    $Test = & $($Script:ExternalProgramSettings.SevenZipFilePath) l $ADFFiletoCheck.Path $_.FilesChecked
                    $LinetoCheck= $Test[$Test.Count-1]
                    if ($LinetoCheck -match '^(?:\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})?\s*(\d+)\s+(\d+)\s+(\d+)\s+files') {
                        $OutputLine = "$($matches[1]),$($matches[2]),$($matches[3])"
                        if ($OutputLine -eq $_.FileCheckDetails){
                            $PathofFoundADFS += [PSCustomObject]@{
                                FileCheckDetails = $_.FileCheckDetails
                                Hash = 'N/A - Matched through sample files'
                                Path = $ADFFiletoCheck.Path
                                ADF_Name = $_.ADF_Name
                                FriendlyName = $_.FriendlyName 
                                Source = $_.ADFSource
                                Sequence = $_.Sequence
                            }
                        }
                    }
                }
            }
        }
    }
            
    $HashTableforADFHashestoFind = @{} # Clear Hash
    $RequiredADFandHashes | Sort-Object -Property 'Sequence'| ForEach-Object {
        $HashTableforADFHashestoFind[$_.Hash] = @($_.ADF_Name,$_.FriendlyName,$_.ADFSource,$_.Sequence)
    }

    $ListofADFFilestoCheck | ForEach-Object {
        if ($HashTableforADFHashestoFind.ContainsKey($_.Hash)){
            $PathofFoundADFS += [PSCustomObject]@{
                FileCheckDetails = $null
                Hash = $_.Hash
                Path = $_.Path
                ADF_Name = $HashTableforADFHashestoFind.($_.Hash)[0]
                FriendlyName = $HashTableforADFHashestoFind.($_.Hash)[1]
                Source = $HashTableforADFHashestoFind.($_.Hash)[2]
                Sequence = $HashTableforADFHashestoFind.($_.Hash)[3]
            
            }                  
        }
    }

    $PathofFoundADFS = $PathofFoundADFS | Sort-Object -Property 'Sequence'
    
    $MatchedADFs = [System.Collections.Generic.List[PSCustomObject]]::New()

    $RequiredADFsforInstall | ForEach-Object {
        $IsFoundADF = $false
        foreach ($FoundADF in $PathofFoundADFS){
            If ($_.ADF_Name -eq $FoundADF.ADF_Name){
                $MatchedADFs += [PSCustomObject]@{
                    Hash = $FoundADF.Hash
                    Path = $FoundADF.Path
                    ADF_Name = $FoundADF.ADF_Name
                    FriendlyName = $FoundADF.FriendlyName
                    Source = $FoundADF.Source
                    IsMatched = 'TRUE'
                }
                $IsFoundADF = $true
                break
            }
        }
        if ($IsFoundADF -eq $false){
            $MatchedADFs += [PSCustomObject]@{
                Hash = ''
                Path = ''
                ADF_Name = $_.ADF_Name
                FriendlyName = $_.FriendlyName
                IsMatched = 'False'                
            }
        }            
    }

    return $MatchedADFs
}  