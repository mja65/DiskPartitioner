function Install-GithubRelease {
    param (
        $LocationforDownload,
        $LocationforProgram
    )
    
    if (-not(Test-Path $LocationforProgram)){
        $null = New-Item -Path $LocationforProgram -Force -ItemType Directory
    }

    Write-InformationMessage -Message "Extracting Files for $LocationforDownload"
    $null = Expand-Archive -LiteralPath $LocationforDownload -DestinationPath $LocationforProgram -force

}