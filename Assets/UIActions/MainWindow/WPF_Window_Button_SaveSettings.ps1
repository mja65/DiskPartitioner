$WPF_Window_Button_SaveSettings.Add_Click({
        if ($Script:GUICurrentStatus.FileBoxOpen -eq $true){
        return
    }

    $SavePath = Get-SettingsSavePath
    if ($SavePath){
        $DataToSave = Get-SettingsDataforSave

        if (test-path $SavePath){
            $null = Remove-Item $SavePath
        }
        $DataToSave | Out-File $SavePath

    }
})