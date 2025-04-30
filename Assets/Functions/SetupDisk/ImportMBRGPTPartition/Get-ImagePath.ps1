function Get-ImagePath {
    param (
        
    )
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
        DefaultExt = '.hdf'
        Filter = "HDF/IMG files (*.hdf;*.img)|*.hdf;*.img|All files (*.*)|*.*"
        Title = 'Select Image file with Partitions to import'
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

# InitialDirectory = $Script:SettingsFolder 
# DefaultExt = '.ini'
# Filter = "Emu68 Imager Settings Files (.e68)|*.hdf,*.img" # Filter files by extension
# Filter = "Amiga HDF files (*.hdf)|*.hdf|Image Files (*.img)|*.img|All files (*.*)|*.*"