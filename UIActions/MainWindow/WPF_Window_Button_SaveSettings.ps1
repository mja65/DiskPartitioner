$WPF_Window_Button_SaveSettings.Add_Click({
    $SavePath = Get-SettingsSavePath
    if ($SavePath){
        Write-SettingsFile -SettingsFile $SavePath
    }
})