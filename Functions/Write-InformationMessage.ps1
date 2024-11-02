function Write-InformationMessage {
    param (
        $Message,
        [switch]$NoLog
    )
    Write-Host " `t $Message" -ForegroundColor Yellow
    if (-not $NoLog){
        $Message | Out-File $Script:Options.LogLocation -Append
    }
}