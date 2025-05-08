function Start-HSTCommands {
    param (
        $HSTScript,
        $Message

    )

   # $HSTScript = $Script:GUICurrentStatus.HSTCommandstoProcess.WriteFilestoDisk

    $HSTCommandScriptPath = "$($Script:Settings.TempFolder)\HSTCommandstoRun.txt"

    if (Test-Path $HSTCommandScriptPath){
        $null = Remove-Item -Path $HSTCommandScriptPath
    }     

    #($HSTScript | Sort-Object {$_.Sequence}).Command |  Out-File -FilePath $HSTCommandScriptPath -Force

    $HSTScript.Command |  Out-File -FilePath $HSTCommandScriptPath -Force

    $Logoutput = "$($Script:Settings.TempFolder)\LogOutputTemp.txt"
    Write-InformationMessage -Message  $Message
    & $Script:ExternalProgramSettings.HSTImagerPath script $HSTCommandScriptPath >$Logoutput
    if ((Confirm-HSTNoErrors -PathtoLog $Logoutput -HSTImager) -eq $false){
        exit
    }
    $null = Remove-Item $HSTCommandScriptPath -Force
    
}