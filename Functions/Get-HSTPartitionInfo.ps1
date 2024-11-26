function Get-ParsedHSTPartitionInfo {
    param (
        $DataToParse,
        $FirstHeader,
        $SecondHeader,
        $HeadertoUse
   
    )    

    $PartitionDetails = @()
    $StartRow = 0
    $EndRow = 0    

    for ($i = 0; $i -lt $DataToParse.Count; $i++) {
        if ($DataToParse[$i] -match $FirstHeader){
            $StartRow = $i+2
        }
        if ($DataToParse[$i] -match $SecondHeader){
            $EndRow = $i-2
            break
        }
    }

    for ($i = $StartRow ; $i -le $EndRow; $i++) {
        $PartitionDetails += ConvertFrom-Csv -InputObject $DataToParse[$i] -Delimiter '|' -Header $HeadertoUse   
    }

    return $PartitionDetails

}

function Get-HSTPartitionInfo {
    param (
        [Switch]$MBRInfo,
        [Switch]$RDBInfo,
        $Path

    )
        
    # $Path = '\disk7\mbr\2' 
    # $Path = "E:\Emulators\Amiga Files\Hard Drives\InstallProgs\CFD133.lha"
    
    If ($MBRInfo){
        $Header_MBR1 = 'Number','Id','Type','FileSystem','Size','StartSector','EndSector','Active','Primary'
        $HeadertoFind_MBR1_1 = 'File System'
        $HeadertoFind_MBR1_2 = 'Partition table overview:'
    
        $Header_MBR2 = 'Number','Type','Size','StartOffset','EndOffset','Layout'
        $HeadertoFind_MBR2_1 = 'Start Off'
        $HeadertoFind_MBR2_2  = 'Done'
        
        $OutputtoParse_MBR = & $Script:ExternalProgramSettings.HSTImagePath mbr info $Path

        $OutputtoParse_MBR | ForEach-Object {
            if ($_ -match 'No Master Boot Record present'){
                Write-Host "No MBR found!"
                return
            }
        } 

        $MBR_1 = Get-ParsedHSTPartitionInfo -DataToParse $OutputtoParse_MBR -FirstHeader $HeadertoFind_MBR1_1 -SecondHeader $HeadertoFind_MBR1_2 -HeadertoUse $Header_MBR1
        $MBR_2 = Get-ParsedHSTPartitionInfo -DataToParse $OutputtoParse_MBR -FirstHeader $HeadertoFind_MBR2_1 -SecondHeader $HeadertoFind_MBR2_2 -HeadertoUse $Header_MBR2 

        $MBRPartitionTable = [System.Collections.Generic.List[PSCustomObject]]::New()

        $HashTableforMBR_1 = @{} # Clear Hash
        $MBR_1 | ForEach-Object {
            $HashTableforMBR_1[$_.Number] = @($_.Id,$_.Type,$_.FileSystem,$_.Size,$_.StartSector,$_.EndSector,$_.Active,$_.Primary)
        }

        $MBR_2 | ForEach-Object {
            if ($HashTableforMBR_1.ContainsKey($_.Number)){
                $MBRPartitionTable += [PSCustomObject]@{
                    Number = $_.Number
                    ID = $HashTableforMBR_1.($_.Number)[0]
                    Type = $_.Type
                    FileSystem = $HashTableforMBR_1.($_.Number)[2]
                    Size = $_.Size
                    StartOffSet = $_.StartOffset                
                    EndOffSet = $_.EndOffset
                    TotalBytes = $_.EndOffset-$_.StartOffset 
                    StartSector = $HashTableforMBR_1.($_.Number)[4]
                    EndSector = $HashTableforMBR_1.($_.Number)[5]
                    TotalSectors = $HashTableforMBR_1.($_.Number)[5]-$HashTableforMBR_1.($_.Number)[4]
                    Active = $HashTableforMBR_1.($_.Number)[6]
                    Primary = $HashTableforMBR_1.($_.Number)[7]
                
                }
            }
        }

        return $MBRPartitionTable

    }

    elseif ($RDBInfo){
        $Header_RDB1 = 'Number','Name','Size','LowCyl','HighCyl','Reserved','PreAlloc','BlockSize','Buffers','DOSType','MaxTransfer','Bootable','NoMount','Priority'
        $HeadertoFind_RDB1_1 = 'Max Transfer'
        $HeadertoFind_RDB1_2 = 'Partition table overview:'
    
        $Header_RDB2 = 'Number','Type','Size','StartOffset','EndOffset','Layout'
        $HeadertoFind_RDB2_1 = 'Start Off'
        $HeadertoFind_RDB2_2 = 'Done'

        $OutputtoParse_RDB = & $Script:ExternalProgramSettings.HSTImagePath rdb info $Path 

        $OutputtoParse_RDB | ForEach-Object {
            if ($_ -match 'No Rigid Disk Block present'){
                Write-host "Not RDB!"
                return

            }
        } 

        $RDB_1 = Get-ParsedHSTPartitionInfo -DataToParse $OutputtoParse_RDB -FirstHeader $HeadertoFind_RDB1_1 -SecondHeader $HeadertoFind_RDB1_2 -HeadertoUse $Header_RDB1 
        $RDB_2 = Get-ParsedHSTPartitionInfo -DataToParse $OutputtoParse_RDB -FirstHeader $HeadertoFind_RDB2_1 -SecondHeader $HeadertoFind_RDB2_2 -HeadertoUse $Header_RDB2 
        
        $RDBPartitionTable = [System.Collections.Generic.List[PSCustomObject]]::New()

        $HashTableforRDB_1 = @{} # Clear Hash
        $RDB_1 | ForEach-Object {
            $HashTableforRDB_1[$_.Number] = @($_.Name, $_.Size, $_.LowCyl, $_.HighCyl,$_.Reserved,$_.PreAlloc,$_.BlockSize,$_.Buffers,$_.DOSType,$_.MaxTransfer,$_.Bootable,$_.NoMount,$_.Priority)
        }
   
        $RDB_2 | ForEach-Object {
    
            if ($HashTableforRDB_1.ContainsKey($_.Number)){
                $RDBPartitionTable += [PSCustomObject]@{
                    Number = $_.Number
                    Name = $HashTableforRDB_1.($_.Number)[0]
                    Type = $_.Type
                    Size = $_.Size
                    StartOffSet = $_.StartOffSet
                    EndOffSet = $_.EndOffSet
                    TotalBytes = $_.EndOffset-$_.StartOffset 
                    LowCylinder = $HashTableforRDB_1.($_.Number)[2]
                    HighCylinder = $HashTableforRDB_1.($_.Number)[3]
                    TotalCylinders = $HashTableforRDB_1.($_.Number)[3] - $HashTableforRDB_1.($_.Number)[2] 
                    Reserved = $HashTableforRDB_1.($_.Number)[4]
                    PreAlloc = $HashTableforRDB_1.($_.Number)[5]
                    BlockSize = $HashTableforRDB_1.($_.Number)[6]
                    Buffers = $HashTableforRDB_1.($_.Number)[7]
                    DOSType = $HashTableforRDB_1.($_.Number)[8]
                    MaxTransfer = $HashTableforRDB_1.($_.Number)[9]
                    Bootable = $HashTableforRDB_1.($_.Number)[10]
                    NoMount = $HashTableforRDB_1.($_.Number)[11]
                    Priority = $HashTableforRDB_1.($_.Number)[12]
                }
            }

        }

        $StartPoint = $Path.IndexOf('\mbr\')+5
        $EndPoint = $Path.Length - $StartPoint

        $MBRNumber = $Path.Substring($StartPoint,$EndPoint)

        $RDBPartitionTable | Add-Member -NotePropertyMembers @{
            MBRNumber  = $MBRNumber           
        }
        return $RDBPartitionTable
    }
}

# Get-HSTPartitionInfo -RDBInfo -Path '\disk6\mbr\2' 
# Get-HSTPartitionInfo -MBRInfo -Path '\disk6'