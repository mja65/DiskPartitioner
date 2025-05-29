function Get-ConvertedSize {
    param (
        [decimal]$Size,
        $ScaleFrom,
        $Scaleto,
        [Switch]$AutoScale,
        $NumberofDecimalPlaces,
        [Switch]$Truncate
    )


    # $AutoScale = $true
    # $Size = 3
    # $NumberofDecimalPlaces = 2
    # $ScaleFrom = 'B'

    #Write-debug "Function: $($MyInvocation.MyCommand.Name)"
    #Write-debug "Parameters received: $($PSBoundParameters | Out-String)"

    $OutputtoReturn  = [PSCustomObject]@{
        Size = $null
        Scale = $null
    }

    if ($Size -eq 0){
        $OutputtoReturn.Size = 0
        $OutputtoReturn.Scale = 'B'
        return $OutputtoReturn 
    }

    if ($ScaleFrom -eq $Scaleto){
        $OutputtoReturn.Size  = ([decimal]$Size)
    }
    else{
        if ($ScaleFrom -eq 'TiB'){
            $SizeBytes = ([decimal]$Size)*1024*1024*1024*1024
        }
        elseif($ScaleFrom -eq 'GiB'){
            $SizeBytes = ([decimal]$Size)*1024*1024*1024
        }
        elseif($ScaleFrom -eq 'MiB'){
            $SizeBytes = ([decimal]$Size)*1024*1024
        }
        elseif($ScaleFrom -eq 'KiB'){
            $SizeBytes = ([decimal]$Size)*1024
        }
        elseif($ScaleFrom -eq 'B'){
            $SizeBytes = ([decimal]$Size)
        }

        if ($AutoScale){
            if (([math]::abs($SizeBytes)) -lt 1024) {
                $Scaleto = 'B'
            }
            elseif ((([math]::abs($SizeBytes)) -ge 1024) -and (([math]::abs($SizeBytes)) -lt (1024*1024))){
                $Scaleto = 'KiB'
            }  
            elseif ((([math]::abs($SizeBytes)) -ge 1024*1024) -and (([math]::abs($SizeBytes)) -lt (1024*1024*1024))){
                $Scaleto = 'MiB'
            }  
            elseif ((([math]::abs($SizeBytes)) -ge (1024*1024*1024)) -and (([math]::abs($SizeBytes)) -lt (1024*1024*1024*1024))){
                $Scaleto = 'GiB'
            }
            else{
                $Scaleto = 'TiB'
            }  
        }

        if ($Scaleto -eq 'TiB'){
            $OutputtoReturn.Size = $SizeBytes/1024/1024/1024/1024
        }
        elseif ($Scaleto -eq 'GiB'){
            $OutputtoReturn.Size = $SizeBytes/1024/1024/1024
        }
        elseif ($Scaleto -eq 'MiB'){
            $OutputtoReturn.Size = $SizeBytes/1024/1024
        }
        elseif ($Scaleto -eq 'KiB'){
            $OutputtoReturn.Size= $SizeBytes/1024
        }
        elseif ($Scaleto -eq 'B'){
            $OutputtoReturn.Size = $SizeBytes
        }  
             
    }

    if ($NumberofDecimalPlaces){
        if (-not $Truncate){
            $OutputtoReturn.Size= ([math]::Round($OutputtoReturn.Size,$NumberofDecimalPlaces))
        }
        else {
            $RoundingFactor = [Math]::Pow(10, $NumberofDecimalPlaces)
            $OutputtoReturn.Size = ([math]::truncate($OutputtoReturn.Size*$RoundingFactor))/$RoundingFactor
        }
    }

    $OutputtoReturn.Scale  = $Scaleto
    return $OutputtoReturn

}

