function Get-SettingsSavePath {
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.SaveFileDialog -Property @{ 
        InitialDirectory = "$([System.IO.Path]::GetFullPath($Script:Settings.DefaultSettingsLocation))\" 
        DefaultExt = '.ini'
        Filter = "Emu68 Imager Settings Files (.e68)|*.e68" # Filter files by extension
        Title = 'Save your Settings File'
        FileName =''
    }
    #[Environment]::GetFolderPath('Desktop') 
    $result = $dialog.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))
    if ($result -eq 'OK'){
        return $dialog.FileName
    }
    else {
        return
    }
}