function Start-HSTImagerScript {
    param (
        $Script
    )
    
    $ScriptFolder = "$($Script:ExternalProgramSettings.TempFolder)\HSTCommands"

    if (-not (Test-path  $ScriptFolder)){
        $null = new-item -Path $ScriptFolder -ItemType Directory
    }

    $Script | Out-File "$ScriptFolder\HSTScripttoExecute.txt" 

    & $Script:ExternalProgramSettings.HSTImagerPath script "$ScriptFolder\HSTScripttoExecute.txt"  
      
}
