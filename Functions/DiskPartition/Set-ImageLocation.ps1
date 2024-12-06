function Set-ImageLocation {
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.SaveFileDialog -Property @{ 
        InitialDirectory = $Script:SettingsFolder 
        DefaultExt = '.vhd'
        Filter = "Image Virtual File (.vhd)|*.vhd | Image files (*.img)|*.img" # Filter files by extension
        Title = 'Save Image File'
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

