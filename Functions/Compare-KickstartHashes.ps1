function Compare-KickstartHashes {
    param (
        $PathtoKickstartHashes,
        $PathtoKickstartFiles,
        $KickstartVersion
    )
    
    $Msg_Header ='Finding Kickstart'    
    $Msg_Body = @"
Searching folder '$PathtoKickstartFiles' for valid Kickstart file. Depending on the size of the folder you selected this may take some time. 
"@

    $Msg_Header_ExceedLimit ='Exceeded file limits!'   
    $Msg_Body_ExceedLimit = @"
Search is limited to a maximum of 500 files! The current path (with no sub-folders) will be matched.

If this does not find your Kickstart file either select a different path 
with less files or move the Kickstart into the default 
'UserFiles\Kickstarts\' folder in your install path for the tool
and select this path to scan. 

"@

#    $PathtoKickstartHashes = 'E:\Emu68Imager\InputFiles\RomHashes.csv'
#    $PathtoKickstartFiles = 'E:\Emulators\Amiga Files\Shared\rom\'
#    $KickstartVersion = 3.2
    
    $null = Show-WarningorError -Msg_Body $Msg_Body -Msg_Header $Msg_Header -BoxTypeNone -ButtonType_OK   

    $KickstartHashestoFind =Import-Csv $PathtoKickstartHashes -Delimiter ';' |  Where-Object {$_.Kickstart_Version -eq $KickstartVersion} | Sort-Object -Property 'Sequence'   

    $ListofKickstartFilestoCheck  = Get-ChildItem $PathtoKickstartFiles -force -Recurse

    if ((($ListofKickstartFilestoCheck | Measure-Object).count) -gt 500){
        $null = Show-WarningorError -Msg_Body $Msg_Body_ExceedLimit -Msg_Header $Msg_Header_ExceedLimit -BoxTypeWarning -ButtonType_OK        
        $ListofKickstartFilestoCheck  = $ListofKickstartFilestoCheck | Where-Object {$_.DirectoryName -eq $PathtoKickstartFiles.TrimEnd('\') } 
    } 

    $ListofKickstartFilestoCheck  = $ListofKickstartFilestoCheck  | Where-Object { $_.PSIsContainer -eq $false -and $_.Length -eq 524288}
   
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
                Fat32Name = $KickstartRomandHash.Fat32Name
                KickstartPath = ($HashTableforKickstartFilestoCheck[$KickstartRomandHash.Hash])
            }        
        }
        # else{
        #     $FoundKickstarts += [PSCustomObject]@{
        #         Kickstart_Version = $KickstartRomandHash.Kickstart_Version
        #         FriendlyName= $KickstartRomandHash.FriendlyName
        #         Sequence = $KickstartRomandHash.Sequence 
        #         Fat32Name = $KickstartRomandHash.Fat32Name
        #         KickstartPath = ""
        #     }        
        # }
    }
    
    if ($FoundKickstarts){
        $KickstarttoUse = $FoundKickstarts | Sort-Object -Property 'Sequence' | Select-Object -first 1
        return $KickstarttoUse 
    }
    else{
        return
    }
}