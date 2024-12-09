function Confirm-DefaultPaths {
    param (
     
    )
    
    $LocationstoCheck = @()

    $LocationstoCheck += $Script:Settings.DefaultADFLocation
    $LocationstoCheck += $Script:Settings.DefaultROMLocation
    $LocationstoCheck += $Script:Settings.InputFiles
    $LocationstoCheck += $Script:Settings.LogFolder

    foreach ($PathtoCheck in $LocationstoCheck) {
        if (-not(Test-Path $PathtoCheck)){
            $null = New-Item ($PathtoCheck) -ItemType Directory -Force
        } 
    }

}
