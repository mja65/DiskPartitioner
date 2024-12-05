function Initialize-Disk {
    param (
        $Path
    )
    
    $Command = @()
    $Command += "blank $($Script:ExternalProgramSettings.TempFolder)\Clean.vhd 10mb"
    $Command += "write $($Script:ExternalProgramSettings.TempFolder)\Clean.vhd $Path" 

    return $Command

}