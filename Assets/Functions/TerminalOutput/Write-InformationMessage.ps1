function Write-InformationMessage {
    param (
        $Message,
        [switch]$NoLog,
        $LogLocation
    )

    If ($LogLocation){
        $LogLocationtoUse = $LogLocation
    }
    else {
        $LogLocationtoUse = $Script:Settings.LogLocation
    }
    
    Write-Host " `t $Message" -ForegroundColor Yellow
    if (-not $NoLog){
        $Message | Out-File $LogLocationtoUse -Append
    }
}