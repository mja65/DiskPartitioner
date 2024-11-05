function Get-ConvertedSize {
    param (
        $Size,
        $ScaleFrom,
        $Scaleto,
        $NumberofDecimalPlaces,
        $Truncate
    )

    if ($ScaleFrom -eq $Scaleto){
        $SizetoReturn = ([decimal]$Size)
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
        if ($Scaleto -eq 'TiB'){
            $SizetoReturn = $SizeBytes/1024/1024/1024/1024
        }
        elseif ($Scaleto -eq 'GiB'){
            $SizetoReturn = $SizeBytes/1024/1024/1024
        }
        elseif ($Scaleto -eq 'MiB'){
            $SizetoReturn = $SizeBytes/1024/1024
        }
        elseif ($Scaleto -eq 'KiB'){
            $SizetoReturn = $SizeBytes/1024
        }
        elseif ($Scaleto -eq 'B'){
            $SizetoReturn = $SizeBytes
        }  
     
    }

    if ($NumberofDecimalPlaces){
        if (-not $Truncate){
            $SizetoReturn = ([math]::Round($SizetoReturn,$NumberofDecimalPlaces))
        }
        else {
            $RoundingFactor = [Math]::Pow(10, $NumberofDecimalPlaces)
            $SizetoReturn = ([math]::truncate($SizetoReturn*$RoundingFactor))/$RoundingFactor
        }
    }
    return $SizetoReturn
    

}

