function Get-GithubRelease {
    param (
        $GithubRelease,
        $Tag_Name,
        $Name,
        $LocationforDownload,
        $Sort_Flag,
        $OnlyReleaseVersions
    )
  

    # $DownloadURL = "https://github.com/henrikstengaard/hst-imager/releases/download/1.2.437/hst-imager_v1.2.437-7d8644e_console_windows_x64.zip" 
    # $OutputLocation = ".\Temp\StartupFiles\HSTImager.zip"
    # $NumberofAttempts = 3


    # $GithubRelease = "https://api.github.com/repos/henrikstengaard/hst-imager/releases" 
    # $Tag_Name = "1.2.437" 
    # $Name = "_console_windows_x64.zip" 
    # $LocationforDownload =  "$($Script:Settings.TempFolder)\StartupFiles\HSTImager.zip" 
    # $Sort_Flag= ''

    if (-not(Test-Path (split-path $LocationforDownload -parent))){
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
   # Write-host "GithubDownload: $GithubDownloadURL LocationforDownload: $LocationforDownload"
    if ((Get-DownloadFile -DownloadURL $GithubDownloadURL -OutputLocation $LocationforDownload -NumberofAttempts 3) -eq $true){
        Write-InformationMessage -Message 'Download completed'  
    }
    else{
        Write-ErrorMessage -Message "Error downloading $LocationforDownload!"
        return $false
    }       

    return $true   
}

