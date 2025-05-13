function Get-SettingsLoadPath {
    if ($Script:GUICurrentStatus.FileBoxOpen -eq $true){
        return
    }
    else {
        $Script:GUICurrentStatus.FileBoxOpen = $true
        Add-Type -AssemblyName System.Windows.Forms
        $dialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
            InitialDirectory = "$([System.IO.Path]::GetFullPath($Script:Settings.DefaultSettingsLocation))\" 
            DefaultExt = '.ini'
            Filter = "Emu68 Imager Settings Files (.e68)|*.e68" # Filter files by extension
            Title = 'Load your Settings File'
            FileName =''
        }
        #[Environment]::GetFolderPath('Desktop') 
        $result = $dialog.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))
        if ($result -eq 'OK'){
            $Script:GUICurrentStatus.FileBoxOpen = $false
            return $dialog.FileName
        }
        else {
            $Script:GUICurrentStatus.FileBoxOpen = $false
            return
        }

    }
}