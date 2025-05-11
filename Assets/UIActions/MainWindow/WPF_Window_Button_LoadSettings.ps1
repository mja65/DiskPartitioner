$WPF_Window_Button_LoadSettings.Add_Click({
        $LoadPath = Get-SettingsLoadPath
    if ($LoadPath){
        if ((Read-SettingsFile -SettingsFile $LoadPath) -eq $true){
           # Update-UI -All
           $null = Show-WarningorError -ButtonType_OK -Msg_Header "Settings Loaded" -Msg_Body "The settings have been loaded" -BoxTypeNone
        }
        else {
            $null = Show-WarningorError -BoxTypeError -ButtonType_OK -Msg_Header "Invalid Load File" -Msg_Body "The file you have chosen is not a valid settings file!"
        }
    }
})