function Get-GithubRelease {
    param (
        $GithubRelease,
        $Tag_Name,
        $Name,
        $LocationforDownload,
        $LocationforProgram,
        $Sort_Flag,
        $OnlyReleaseVersions
    )

    if (-not(Test-Path $LocationforProgram)){
        $null = New-Item -Path $LocationforProgram -Force -ItemType Directory
    }
    
    if (-not(Test-Path $LocationforDownload)){
        $null = New-Item -Path (split-path $LocationforDownload -parent) -Force -ItemType Directory
    }

    Write-InformationMessage -Message "Retrieving Github information for: $GithubRelease"

    $GithubDetails = (Get-DownloadFile -DownloadURL $GithubRelease -NumberofAttempts 3) | ConvertFrom-Json
    if ( -not $GithubDetails){
        Write-ErrorMessage 'Error accessing Github! Qutting Progream'
        exit
    }  
    if ($OnlyReleaseVersions -eq 'TRUE'){
    
        $GithubDetails_Sorted = $GithubDetails | Where-Object { $_.tag_name -ne 'nightly' -and ($_.draft).tostring() -eq 'False' -and ($_.prerelease).tostring() -eq 'False' -and ($_.name).tostring() -notmatch 'Release Candidate'} | Sort-Object -Property 'tag_name' -Descending | Select-Object -ExpandProperty assets
        $GithubDetails_ForDownload = $GithubDetails_Sorted  | Where-Object { $_.name -match $Name } | Select-Object -First 1
    }
    else {
        if ($Sort_Flag -eq 'Sort'){
            $GithubDetails_ForDownload = $GithubDetails | Where-Object { $_.tag_name -eq $Tag_Name } | Select-Object -ExpandProperty assets | Where-Object { $_.name -match $Name } | Sort-Object -Property updated_at -Descending
            $GithubDetails_ForDownload = $GithubDetails | Where-Object { $_.tag_name -eq 'nightly' } | Select-Object -ExpandProperty assets | Where-Object { $_.name -match $Name } | Sort-Object -Property updated_at -Descending
        }
        else{
            $GithubDetails_ForDownload = $GithubDetails | Where-Object { $_.tag_name -eq $Tag_Name } | Select-Object -ExpandProperty assets | Where-Object { $_.name -match $Name }
        }
    }
    $GithubDownloadURL =$GithubDetails_ForDownload[0].browser_download_url 
    Write-InformationMessage -Message ('Downloading Files for URL: '+$GithubDownloadURL)
    if ((Get-DownloadFile -DownloadURL $GithubDownloadURL -OutputLocation $LocationforDownload -NumberofAttempts 3) -eq $true){
        Write-InformationMessage -Message 'Download completed'  
    }
    else{
        Write-ErrorMessage -Message "Error downloading $LocationforDownload!"
        return $false
    }       
    Write-InformationMessage -Message "Extracting Files for $LocationforDownload"
    $null = Expand-Archive -LiteralPath $LocationforDownload -DestinationPath $LocationforProgram -force
    return $true   
}