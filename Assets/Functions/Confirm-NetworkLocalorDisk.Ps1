function Confirm-NetworkLocalorDisk {
    param (
        $PathtoCheck
    )
    
    # $PathtoCheck = $Script:GUIActions.OutputPath

    If (($PathtoCheck.Length -ge 2) -and ($PathtoCheck.Substring(0,2) -eq '\\')){
        $result = 'Network-UNC'
    }
    else{
        if (($PathtoCheck.Substring(($PathtoCheck.Length-1)) -match "^\d+$") -and ($PathtoCheck.IndexOf("\disk") -eq 0)){
            $result = 'Physical Disk'
        }
        else {
            $EndPosition = $PathtoCheck.IndexOf(':\')
            $DriveLetter = $PathtoCheck.Substring(0,$EndPosition)
            $MappedDrives = Get-PSDrive -PSProvider FileSystem | Select-Object Name, DisplayRoot | Where-Object {$null -ne $_.DisplayRoot} | Where-Object {$_.Name -eq $DriveLetter}
            $AllDrives =  Get-PSDrive -PSProvider FileSystem | Select-Object Name | Where-Object {$null -eq $_.DisplayRoot} | Where-Object {$_.Name -eq $DriveLetter}
        
            if ($AllDrives){
                if ($MappedDrives){
                    $result = 'Network-MappedDrive'
                }
                else {
                    $result = 'Local'
                }
            }
            else {
                $result = 'Invalid'
            }
        }
    }
    
    return $result

}





