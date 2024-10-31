function Get-ConvertedSize {
    param (
        $Size,
        $ScaleFrom,
        $Scaleto
    )
    if ($ScaleFrom -eq 'GiB'){
        $SizetoReturn = ([decimal]$Size)*1024*1024*1024
    }

    return $SizetoReturn

}
