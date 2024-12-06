function Copy-FileToRDBPartition {
    param (
        $SourcePath,
        $DestinationPath
    )
    
    #$SourcePath = 'C:\AMD\Chipset_Software\Binaries\GPIO2 Driver\W11x64\amdgpio2.sys'

    #$SourcePath = '\disk6\mbr\2\rdb\dh0\Workbench'

    if ($SourcePath.IndexOf('\disk') -ne -1 -and $SourcePath.IndexOf(':\') -eq -1){
        $DelimiterPosition = $SourcePath.Substring(1,($SourcePath.Length-1)).IndexOf('\')+1
        $SourcePath.Substring(1,$DelimiterPosition-1)
        $Suffix = $SourcePath.Substring(1,$DelimiterPosition-1)
        $DestinationPathtoUse = "$DestinationPath/AmigaFiles/$Suffix"
    } 
    else{
        $DestinationPathtoUse = "$DestinationPath/PCFiles"
    }

    $Command = @()
    $Command += "fs copy $SourcePath $DestinationPathtoUse"

    return $Command
}