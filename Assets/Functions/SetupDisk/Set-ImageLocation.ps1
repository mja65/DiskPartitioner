function Set-ImageLocation {
    Add-Type -AssemblyName System.Windows.Forms
    $dialog = New-Object System.Windows.Forms.SaveFileDialog -Property @{ 
        InitialDirectory = "$([System.IO.Path]::GetFullPath($Script:Settings.DefaultOutputImageLocation))\" 
        DefaultExt = '.vhd'
        Filter = "Image Virtual File (.vhd)|*.vhd|Image files (.img)|*.img" # Filter files by extension
        Title = 'Save Image File'
        FileName =''
    }
    #[Environment]::GetFolderPath('Desktop') 
    $result = $dialog.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))
    if ($result -eq 'OK'){
        # if (Test-Path ($dialog.FileName)){
        #     $Confirmation = (Show-WarningorError -Msg_Body "The file already exists! Please confirm you wish to overwrite it." -Msg_Header "Confirm Overwrite of Image" -BoxTypeWarning -ButtonType_OKCancel)
        #     if ($Confirmation -eq 'OK'){
        #         return $dialog.FileName        
        #     }
        #     else {
        #         return
        #     }
        # }
        return $dialog.FileName
    }
    else {
        return
    }
}