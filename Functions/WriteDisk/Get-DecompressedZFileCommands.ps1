function Get-DecompressedZFileCommands {
    param (

    $AmigaDrivetoUse,
    $AmigaTempDrivetoUse

    )

    # $AmigaDrivetoUse = "$($Script:GUIActions.OutputPath)\$(Get-AmigaDrivePath -DeviceName)" 
    # $AmigaTempDrivetoUse = "$($Script:Settings.AmigaTempDrive)\$(Get-AmigaDrivePath -DeviceName)"
    
    $AmigaDrivetoUse = (Resolve-Path $AmigaDrivetoUse).Path
    $AmigaTempDrivetoUse = (Resolve-Path $AmigaTempDrivetoUse).Path

    $ListofFilestoDecompress = Get-ChildItem -Path "$AmigaTempDrivetoUse\$(Get-AmigaDrivePath -DeviceName)" -Recurse -Filter '*.Z'  
    $OutputCommands = @()
    foreach ($File in $ListofFilestoDecompress) {
        $FullNamewithoutZ = $File.FullName.Substring(0,($File.FullName.Length-2))
        $DestinationPathtoUse = (split-path $FullNamewithoutZ -parent).Replace($AmigaTempDrivetoUse,$AmigaDrivetoUse)
        $OutputCommands += "fs extract `"$($File.fullname)`" `"$(split-path $File.FullName -Parent)`""
        $OutputCommands += "fs copy `"$FullNamewithoutZ`" `"$DestinationPathtoUse`""
        }
    
}