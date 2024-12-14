function Get-FixedMenuToolsCommands {
    param (
        $AmigaTempDrivetoUse
    )
    $OutputCommands = @()
    
    If ($Script:GUIActions.GKickstartVersiontoUse -ge 3.2){
        $OutputCommand += "fs extract `"$($Script:GUIActions.StorageADF)\WBStartup\MenuTools`" `"$AmigaTempDrivetoUse\WBStartup`""
    }
    
    return $OutputCommands 
    
}
