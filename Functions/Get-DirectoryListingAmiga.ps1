function Get-DirectoryListingAmiga {
    param (
        $Path
    )
    
    #$Path = $Script:GUIActions.TransferSourceLocation
    #$Path = 'E:\Emulators\Amiga Files\Hard Drives\workbench-311.hdf\rdb\dh0'
    $Headertouse = 'Name','Size','Date','Attributes','Comment'
       
    $Headertocheck = 'Entries:'
    $Footertocheck = 'directories, '


    $DataToParse =  & $Script:ExternalProgramSettings.HSTImagerPath fs dir $Path --recursive
    $StartRow = 0
    $EndRow = 0    

    for ($i = 0; $i -lt $DataToParse.Count; $i++) {
        if ($DataToParse[$i] -match $Headertocheck){
            $StartRow = $i+4
        }
        if ($DataToParse[$i] -match $Footertocheck){
            $EndRow = $i-2
            break
        }
    }

    $DirectoryListing = @()

    for ($i = $StartRow ; $i -le $EndRow; $i++) {
        $DirectoryListing += ConvertFrom-Csv -InputObject $DataToParse[$i] -Delimiter '|' -Header $HeadertoUse   
    }
    
    
    $DirectoryListing | Add-Member -NotePropertyMembers @{
        PathHeader = $null
        Type = $null
        Source = $null
    }
    
    foreach ($File  in $DirectoryListing){
        $File.PathHeader = $Path
        if ($File.Size -match '<DIR>'){
            $file.Size = ''
            $File.Type = 'Directory'
        }
        else{
            $File.Type = 'File'
        }
        $Scale = ($file.size).Split(' ')[1]
        if ($Scale -eq 'KB'){
            $Scale = 'KiB'
        }
        elseif ($Scale -eq 'MB'){
            $Scale = 'MiB'
        }
        elseif ($Scale -eq 'GB'){
            $Scale = 'GiB'
        }
        $file.Size = (Get-ConvertedSize -Size (($file.size).Split(' ')[0]) -ScaleFrom $Scale -Scaleto 'B').Size 
        $file.Source = 'Amiga'
    }
    
    
    return $DirectoryListing
       
}





