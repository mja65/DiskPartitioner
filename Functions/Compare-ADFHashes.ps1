function Compare-ADFHashes {
    param (
        $PathtoADFFiles,
        $PathtoADFHashes,
        $KickstartVersion,
        $PathtoListofInstallFiles
    
    )

    $Msg_Header ='Finding ADFs'    
    $Msg_Body = @"
Searching folder '$PathtoADFFiles' for valid ADFs. 

"@
    $Msg_Header_ExceedLimit ='Exceeded file limits!'   
    $Msg_Body_ExceedLimit = @"
Search is limited to a maximum of 500 files! The current path (with no sub-folders) will be matched.

If this does not find your ADFs either select a different path 
with less files or move the ADFs into the default 
'UserFiles\ADFs\' folder in your install path for the tool
and select this path to scan. 

"@
    
    $null = Show-WarningorError -Msg_Body $Msg_Body -Msg_Header $Msg_Header -BoxTypeNone -ButtonType_OK

   #$PathtoADFFiles = 'E:\Emulators\Amiga Files\Shared\adf\commodore-amiga-operating-systems-workbench\ESCOM\'
   #$PathtoADFHashes = "C:\Users\Matt\OneDrive\Documents\DiskPartitioner\InputFiles\ADFHashes.CSV"
   #$KickstartVersion='3.1'
   #$PathtoListofInstallFiles = "C:\Users\Matt\OneDrive\Documents\DiskPartitioner\InputFiles\ListofInstallFiles.CSV"

    $ListofADFFilestoCheck = Get-ChildItem $PathtoADFFiles -force -Recurse
    if ((($ListofADFFilestoCheck | Measure-Object).count) -gt 500){
        $null = Show-WarningorError -Msg_Body $Msg_Body_ExceedLimit -Msg_Header $Msg_Header_ExceedLimit -BoxTypeNone -BoxTypeWarning
        #$ListofADFFilestoCheck = $ListofADFFilestoCheck | Where-Object {$_.DirectoryName -eq $PathtoADFFiles.TrimEnd('\')} 
    } 
    $ListofADFFilestoCheck = $ListofADFFilestoCheck | Where-Object { $_.PSIsContainer -eq $false -and $_.Name -match '.adf' -and $_.Length -eq 901120 } | Get-FileHash  -Algorithm MD5

    $ADFHashes = Import-Csv $PathtoADFHashes -Delimiter ';' | Sort-Object -Property 'Sequence'
   
    $RequiredOSFiles = Confirm-DefaultOSFilesNeeded

    if ($RequiredOSFiles.WorkbenchInstallNeeded -eq 'All'){
        $RequiredADFsforInstall = Get-ListofInstallFiles $PathtoListofInstallFiles |  Where-Object {$_.Kickstart_Version -eq $KickstartVersion} | Select-Object ADF_Name, FriendlyName -Unique # Unique ADFs Required
    }
    elseif ($RequiredOSFiles.WorkbenchInstallNeeded -eq 'InstallADFOnly') {
        $RequiredADFsforInstall = Get-ListofInstallFiles $PathtoListofInstallFiles |  Where-Object {$_.Kickstart_Version -eq $KickstartVersion -and $_.ADF_Name -match 'install'}  | Select-Object ADF_Name, FriendlyName -Unique # Unique ADFs Required
    }

    $RequiredADFandHashes = [System.Collections.Generic.List[PSCustomObject]]::New() # Allowing for if there are multiple hashes for the same ADF
    
    foreach ($ADFHash in $ADFHashes){
        foreach ($RequiredADF in $RequiredADFsforInstall){
            if ($ADFHash.ADF_Name -eq $RequiredADF.ADF_Name){
                $RequiredADFandHashes += [PSCustomObject]@{
                    ADF_Name = $ADFHash.ADF_Name
                    FriendlyName = $ADFHash.FriendlyName
                    Hash = $ADFHash.Hash
                    Sequence =  $ADFHash.Sequence
                    ADFSource = $ADFHash.ADFSource
                }
            }
        }
    }
    
    $HashTableforADFHashestoFind = @{} # Clear Hash
    $RequiredADFandHashes | Sort-Object -Property 'Sequence'| ForEach-Object {
        $HashTableforADFHashestoFind[$_.Hash] = @($_.ADF_Name,$_.FriendlyName,$_.ADFSource,$_.Sequence)
    }

    $PathofFoundADFS = [System.Collections.Generic.List[PSCustomObject]]::New()
    $ListofADFFilestoCheck | ForEach-Object {
        if ($HashTableforADFHashestoFind.ContainsKey($_.Hash)){
            $PathofFoundADFS += [PSCustomObject]@{
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