function Start-HSTImager {
    param (
        $Command,
        $SourcePath,
        $DestinationPath,
        $FileSystemPath,
        $Options,
        $DosType, 
        $ImageSize,
        $DeviceName,
        $SizeofPartition,
        $PartitionNumber,
        $VolumeName  
    )
    $Logoutput=($Script:Options.TempFolder+'LogOutputTemp.txt')
    if ($Command -eq 'Blank'){
        Write-InformationMessage -Message 'Creating image'
        & $Script:Options.HSTLocation blank $DestinationPath $ImageSize >$Logoutput            
    }
    elseif ($Command -eq 'rdb init'){
        Write-InformationMessage -Message 'Initialising partition'
        & $Script:Options.HSTLocation rdb init $DestinationPath $Options >$Logoutput            
    }
    elseif ($Command -eq 'rdb filesystem add'){
        Write-InformationMessage -Message ('Adding Filesystem '+$DosType+' to RDB')
        & $Script:Options.HSTLocation rdb filesystem add $DestinationPath $FileSystemPath $DosType $Options >$Logoutput            
    }
    elseif ($Command -eq 'rdb part add'){
        Write-InformationMessage -Message ('Adding partition '+$DeviceName+' '+$DosType+' with size '+$SizeofPartition)
        & $Script:Options.HSTLocation rdb part add $DestinationPath $DeviceName $DosType $SizeofPartition $Options --mask 0x7ffffffe --buffers 300 --max-transfer 0xffffff >$Logoutput
    }
    elseif ($Command -eq 'rdb part format'){
        Write-InformationMessage -Message ('Formatting partition '+$VolumeName)
        & $Script:Options.HSTLocation rdb part format $DestinationPath $PartitionNumber $VolumeName >$Logoutput         
    }   
    elseif ($Command -eq 'fs extract') {
        Write-InformationMessage -Message ('Extracting data from ADF. Source path is: '+$SourcePath+' Destination path is: '+$DestinationPath)
        & $Script:Options.HSTLocation fs extract $SourcePath $DestinationPath $Options >$Logoutput                                
    }
    elseif ($Command -eq 'fs copy') {
        Write-InformationMessage -Message ('Writing file(s) to HDF image for: '+$SourcePath+' to '+$DestinationPath) 
        & $Script:Options.HSTLocation fs copy $SourcePath $DestinationPath $Options >$Logoutput  
    } 
    $CheckforError = Get-Content ($Logoutput)
    $ErrorCount=0
    foreach ($ErrorLine in $CheckforError){
        if ($ErrorLine -match " ERR]"){
            $ErrorCount += 1
            Write-ErrorMessage -Message ('Error in HST-Imager: '+$ErrorLine)
            Copy-Item -Path $Logoutput -Destination ($Script:Options.LogFolder+$Script:Options.LogDateTime+'_LastHSTErrorLogFull.txt')        
        }
    }
    if ($ErrorCount -ge 1){       
        return $false
    }    
    else{
        return $true
    }
}