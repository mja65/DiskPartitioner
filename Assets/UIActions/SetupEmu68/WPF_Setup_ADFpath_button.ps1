$WPF_Setup_ADFPath_Button.Add_Click({
    If ($Script:GUICurrentStatus.FileBoxOpen -eq $true){
        return
    }

        $Script:GUICurrentStatus.FileBoxOpen = $true
        $PathtoPopulate = Get-FolderPath -Message 'Select path to installation files' -InitialDirectory "$([System.IO.Path]::GetFullPath($Script:Settings.DefaultInstallMediaLocation))\"  
        if ($PathtoPopulate){
            if ($PathtoPopulate -ne $Script:GUIActions.InstallMediaLocation) {
                $Script:GUIActions.InstallMediaLocation = $PathtoPopulate
            }
    
    
        }
        $Script:GUICurrentStatus.FileBoxOpen = $false
        $null = Update-UI -Emu68Settings
    
})
