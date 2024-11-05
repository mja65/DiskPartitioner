function Get-RemovableMedia {
    param (
    )

    $Script:RemovableMediaListtoreturn = [System.Collections.Generic.List[PSCustomObject]]::New()
    
    Get-WmiObject Win32_DiskDrive | Where-Object {$_.MediaType -eq "Removable Media"} | ForEach-Object {
        $DriveStartpoint = $_.DeviceID.IndexOf('DRIVE')+5 # 5 is length of 'Drive'
        $DriveEndpoint = $_.DeviceID.Length
        $DriveLength = $DriveEndpoint- $DriveStartpoint
        $DriveNumber = $_.DeviceID.Substring($DriveStartpoint,$DriveLength)
        $RemovableMediaListtoreturn += [PSCustomObject]@{
            DeviceID = $_.DeviceID
            Model = $_.Model
            SizeofDiskBytes = $_.Size           
            EnglishSize = Get-ConvertedSize -NumberofDecimalPlaces 3 -Truncate 'TRUE' -Size ($_.Size/1GB) -ScaleFrom 'GiB' -Scaleto 'GiB'
            FriendlyName = ('Disk '+$DriveNumber+' '+$_.Model+' '+ (Get-ConvertedSize -NumberofDecimalPlaces 3 -Truncate 'TRUE' -Size ($_.Size/1GB) -ScaleFrom 'GiB' -Scaleto 'GiB')) 
            HSTDiskName = ('\disk'+$DriveNumber)
            HSTDiskNumber = $DriveNumber
            DeviceisScriptRunDevice = $false
        }
    
    }

    $ScriptDriveLetter = (Get-Location).Path.substring(((Get-Location).Path.IndexOf(':\'))-1,1)
    
    foreach ($RemovableMediaItem in $RemovableMediaListtoreturn) {    
        $DriveNumber = $RemovableMediaItem.DeviceID.Substring($DriveStartpoint,$DriveLength)
        Get-Disk -Number $DriveNumber | Get-Partition | ForEach-Object {
            If ($_.DriveLetter -eq $ScriptDriveLetter){
                $RemovableMediaItem.DeviceisScriptRunDevice = $true           
            } 
        }    
    
    }

    return ($RemovableMediaListtoreturn | Where-Object {$_.DeviceisScriptRunDevice -eq $false})
}




