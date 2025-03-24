function Get-InputFiles {
    param (

    )
    
    Update-InputCSV -PathtoGoogleDrive $Script:Settings.PathtoInputFileSpreadsheet -GidValue 0 -ExistingCSV "$($Script:Settings.InputFiles)\ADFHashes.CSV" 
    Update-InputCSV -PathtoGoogleDrive $Script:Settings.PathtoInputFileSpreadsheet -GidValue 750546389 -ExistingCSV "$($Script:Settings.InputFiles)\ListofInstallFiles.CSV"
    Update-InputCSV -PathtoGoogleDrive $Script:Settings.PathtoInputFileSpreadsheet -GidValue 2048180409 -ExistingCSV "$($Script:Settings.InputFiles)\ListofPackagestoInstall.CSV"
    Update-InputCSV -PathtoGoogleDrive $Script:Settings.PathtoInputFileSpreadsheet -GidValue 1875558855 -ExistingCSV "$($Script:Settings.InputFiles)\RomHashes.CSV"
    Update-InputCSV -PathtoGoogleDrive $Script:Settings.PathtoInputFileSpreadsheet -GidValue 860542576 -ExistingCSV "$($Script:Settings.InputFiles)\ScreenModes.CSV"

}