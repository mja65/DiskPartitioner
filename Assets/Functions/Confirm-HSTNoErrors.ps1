function Confirm-HSTNoErrors {
    param (
        $Logoutput,
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

    #$CheckforError = Get-Content ($PathtoLog)
    $ErrorCount = 0
    foreach ($ErrorLine in $Logoutput){
        if ($ErrorLine -match " ERR]"){
            $ErrorCount ++
            Write-ErrorMessage -Message "Error in $($Name): $ErrorLine"           
        }
    }
    if ($ErrorCount -ge 1){
        # if (-not ($KeepLog)){
        #     $null=Remove-Item ($Logoutput) -Force
        # }
        return $false   
    }
    else{
        # if (-not ($KeepLog)){
        #     $null=Remove-Item ($Logoutput) -Force
        # }
        Write-InformationMessage -Message "$Name ran successfully"
        return $true
    }
}