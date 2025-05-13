cd "%~dp0"
powershell.exe -Command "& {$wd = Get-Location; Start-Process powershell.exe -Verb RunAs -ArgumentList \"-ExecutionPolicy ByPass -NoExit -Command Set-Location '$wd'; .\Script\Main.ps1\"}"
