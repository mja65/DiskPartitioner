function Confirm-HSTNoErrors {
    param (
        $PathtoLog,
        [Switch]$HSTImager,
        [Switch]$HSTAmiga,
        [Switch]$KeepLog
    )
    
    If ($HSTImager){
        $Name = "HST Imager"
    }
    elseif ($HSTAmiga){
        $Name = "HST Amiga"
    }

    $CheckforError = Get-Content ($PathtoLog)
    $ErrorCount = 0
    foreach ($ErrorLine in $CheckforError){
        if ($ErrorLine -match " ERR]"){
            $ErrorCount += 1
            Write-ErrorMessage -Message "Error in $($Name): $ErrorLine"           
        }
    }
    if ($ErrorCount -ge 1){
        if (-not ($KeepLog)){
            $null=Remove-Item ($Logoutput) -Force
        }
        return $false   
    }
    else{
        if (-not ($KeepLog)){
            $null=Remove-Item ($Logoutput) -Force
        }
        Write-InformationMessage -Message "$Name ran successfully"
        return $true
    }
}