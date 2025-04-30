function Compare-KickstartHashes {
    param (
        $PathtoKickstartFiles,
        $KickstartVersion,
        $MaximumFilestoCheck
    )
    
    
    $Msg_Header ='Finding Kickstart'    
    $Msg_Body = @"
Searching folder '$PathtoKickstartFiles' for valid Kickstart file. Depending on the size of the folder you selected this may take some time. 
"@

$Msg_Header_ExceedLimitParent ='Exceeded file limits!'   
$Msg_Body_ExceedLimitParent = @"
Search is limited to a maximum of $MaximumFilestoCheck files! Select a different path 
with less files or move the Kickstart into the default 
'UserFiles\Kickstarts\' folder in your install path for the tool
and select this path to scan. 

"@

    $Msg_Header_ExceedLimit ='Exceeded file limits!'   
    $Msg_Body_ExceedLimit = @"
Search is limited to a maximum of $MaximumFilestoCheck files! The current path (with no sub-folders) will be matched.

If this does not find your Kickstart file either select a different path 
with less files or move the Kickstart into the default 
'UserFiles\Kickstarts\' folder in your install path for the tool
and select this path to scan. 

"@

    $null = Show-WarningorError -BoxTypeNone -ButtonType_OK -Msg_Header $Msg_Header -Msg_Body $Msg_Body

    #  $PathtoKickstartFiles = 'E:\Emulators\Amiga Files\Shared\rom\'
    #  $KickstartVersion = 3.2
    #  $MaximumFilestoCheck = 40
          
    $ListofKickstartFilestoCheck = Get-ChildItem $PathtoKickstartFiles -force -Recurse

    $TotalNumberFilesParent = ($ListofKickstartFilestoCheck | Where-Object {$_.PSIsContainer -eq $false -and $_.DirectoryName -eq $PathtoKickstartFiles.TrimEnd('\') } | Measure-Object).count
    $TotalNumberFiles = ($ListofKickstartFilestoCheck | Where-Object {$_.PSIsContainer -eq $false} | Measure-Object).count


    if ($TotalNumberFilesParent -gt $MaximumFilestoCheck){
        $null = Show-WarningorError -BoxTypeError -ButtonType_OK -Msg_Body $Msg_Body_ExceedLimitParent -Msg_Header $Msg_Header_ExceedLimitParent
        return
    }
    if ($TotalNumberFiles -gt $MaximumFilestoCheck){
        $null = Show-WarningorError -BoxTypeWarning -ButtonType_OK -Msg_Body $Msg_Body_ExceedLimit -Msg_Header $Msg_Header_ExceedLimit
        $ListofKickstartFilestoCheck = ($ListofKickstartFilestoCheck | Where-Object {$_.DirectoryName -eq $PathtoKickstartFiles.TrimEnd('\')})
    }

    $KickstartHashestoFind = Get-InputCSVs -ROMHashes | Where-Object {$_.Kickstart_version -eq $KickstartVersion}
    
    $ListofKickstartFilestoCheck  = $ListofKickstartFilestoCheck  | Where-Object { $_.PSIsContainer -eq $false -and ($_.Length -eq 524288 -or $_.Length -eq  524299)}
   
    $FoundKickstarts = [System.Collections.Generic.List[PSCustomObject]]::New()
    $HashTableforKickstartFilestoCheck = @{} # Clear Hash
   
    foreach ($KickstartDetailLine in $ListofKickstartFilestoCheck){
        $KickstartHash=Get-FileHash -LiteralPath $KickstartDetailLine.FullName -Algorithm MD5
        if (-not ($HashTableforKickstartFilestoCheck[$KickstartHash.Hash])){
            $HashTableforKickstartFilestoCheck.Add(($KickstartHash.Hash),$KickstartDetailLine.FullName)
        }
    }
      
    foreach ($KickstartRomandHash in $KickstartHashestoFind){
        if ($HashTableforKickstartFilestoCheck[$KickstartRomandHash.Hash]){
            $FoundKickstarts += [PSCustomObject]@{
                Kickstart_Version = $KickstartRomandHash.Kickstart_Version
                FriendlyName= $KickstartRomandHash.FriendlyName
                Sequence = $KickstartRomandHash.Sequence 
                IncludeorExclude = $KickstartRomandHash.IncludeorExclude
                ExcludeMessage = $KickstartRomandHash.ExcludeMessage
                Fat32Name = $KickstartRomandHash.Fat32Name
                KickstartPath = ($HashTableforKickstartFilestoCheck[$KickstartRomandHash.Hash])
            }        
        }
    }
    
    if ($FoundKickstarts){
        $KickstarttoUse = $FoundKickstarts | Sort-Object -Property 'Sequence' | Select-Object -first 1
        return $KickstarttoUse 
    }
    else{
        return
    }
}