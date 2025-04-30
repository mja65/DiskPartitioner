function Get-FolderPath {
    param (
        $InitialDirectory,
        $RootFolder,
        $Message,
        [switch]$ShowNewFolderButton
    )

   # $InitialDirectory = [System.IO.Path]::GetFullPath($Script:Settings.DefaultROMLocation) 

    if ($Script:Settings.PowershellVersion -gt 7){
        Add-Type -AssemblyName System.Windows.Forms
        $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
        $dialog.RootFolder = "MyComputer"
        $dialog.Description = $Message
        $dialog.ShowNewFolderButton = if ($ShowNewFolderButton) { $true } else { $false }
        $dialog.UseDescriptionForTitle = 'TRUE'
        $dialog.InitialDirectory = "$($InitialDirectory.TrimEnd('\'))\"
        #$dialog.selectedpath = "$($InitialDirectory.TrimEnd('\'))\"
       # Write-Host $dialog.InitialDirectory
       # Write-Host $dialog.selectedpath 
        # if ($RootFolder){
        #     $dialog.RootFolder = $RootFolder
        # }
        #[Environment]::GetFolderPath('MyComputer') 
        $result = $dialog.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true }))
        if ($result -eq 'OK'){
            return $dialog.SelectedPath
        }
        else {
            return
        }
    }
    else{
        $AssemblyFullName = 'System.Windows.Forms, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089'
        $Assembly = [System.Reflection.Assembly]::Load($AssemblyFullName)
        $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $OpenFileDialog.AddExtension = $false
        $OpenFileDialog.CheckFileExists = $false
        $OpenFileDialog.DereferenceLinks = $true
        $OpenFileDialog.Filter = "Folders|`n"
        $OpenFileDialog.Multiselect = $false
        $OpenFileDialog.Title = $Message
        $OpenFileDialog.InitialDirectory = $InitialDirectory       
        $OpenFileDialogType = $OpenFileDialog.GetType()
        $FileDialogInterfaceType = $Assembly.GetType('System.Windows.Forms.FileDialogNative+IFileDialog')
        $IFileDialog = $OpenFileDialogType.GetMethod('CreateVistaDialog',@('NonPublic','Public','Static','Instance')).Invoke($OpenFileDialog,$null)
        $null = $OpenFileDialogType.GetMethod('OnBeforeVistaDialog',@('NonPublic','Public','Static','Instance')).Invoke($OpenFileDialog,$IFileDialog)
        [uint32]$PickFoldersOption = $Assembly.GetType('System.Windows.Forms.FileDialogNative+FOS').GetField('FOS_PICKFOLDERS').GetValue($null)
        $FolderOptions = $OpenFileDialogType.GetMethod('get_Options',@('NonPublic','Public','Static','Instance')).Invoke($OpenFileDialog,$null) -bor $PickFoldersOption
        $null = $FileDialogInterfaceType.GetMethod('SetOptions',@('NonPublic','Public','Static','Instance')).Invoke($IFileDialog,$FolderOptions)
        $VistaDialogEvent = [System.Activator]::CreateInstance($AssemblyFullName,'System.Windows.Forms.FileDialog+VistaDialogEvents',$false,0,$null,$OpenFileDialog,$null,$null).Unwrap()
        [uint32]$AdviceCookie = 0
        $AdvisoryParameters = @($VistaDialogEvent,$AdviceCookie)
        $AdviseResult = $FileDialogInterfaceType.GetMethod('Advise',@('NonPublic','Public','Static','Instance')).Invoke($IFileDialog,$AdvisoryParameters)
        $AdviceCookie = $AdvisoryParameters[1]
        $Result = $FileDialogInterfaceType.GetMethod('Show',@('NonPublic','Public','Static','Instance')).Invoke($IFileDialog,[System.IntPtr]::Zero)
        $null = $FileDialogInterfaceType.GetMethod('Unadvise',@('NonPublic','Public','Static','Instance')).Invoke($IFileDialog,$AdviceCookie)
        if ($Result -eq [System.Windows.Forms.DialogResult]::OK) {
            $FileDialogInterfaceType.GetMethod('GetResult',@('NonPublic','Public','Static','Instance')).Invoke($IFileDialog,$null)
        }
        if($OpenFileDialog.FileName){
            return $OpenFileDialog.FileName
        }
        else{
            return
        }
    }
}
