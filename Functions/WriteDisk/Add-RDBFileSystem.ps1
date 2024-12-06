function Add-RDBFileSystem {
    param (
        $Path,
        $DosType
    )

    if ($DosType -eq 'PFS\3'){
        $FileSystemPath = $Script:ExternalProgramSettings.PFS3AIOPath
        $DosTypetoAdd = 'pfs3'
    }
    elseif ($DosType -eq 'PDS\3'){
        $FileSystemPath = $Script:ExternalProgramSettings.PFS3AIOPath
        $DosTypetoAdd = 'pds3'
    }

    $Command = @()
    $Command += "rdb filesystem add $Path $FileSystemPath $DosTypetoAdd"

    return $Command
}