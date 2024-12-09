function Get-Emu68 {
    param (
        
    )
    
    if (-not(Get-GithubRelease -GithubRelease ($Script:ExternalProgramSettings.Emu68URL) -OnlyReleaseVersions 'TRUE' -Name 'Emu68-pistorm.' -LocationforDownload ("$($Script:ExternalProgramSettings.TempFolder)\Emu68Pistorm\") -LocationforProgram ("$($Script:ExternalProgramSettings.TempFolder)\Emu68Pistorm.zip") -Sort_Flag 'SORT')){
        Write-ErrorMessage -Message'Error downloading Emu68Pistorm! Cannot continue!'
        exit
    }
    
    Write-StartSubTaskMessage -Message 'Downloading Emu68Pistorm32lite' -SubtaskNumber '2' -TotalSubtasks '3'
    
    if (-not(Get-GithubRelease -GithubRelease ($Script:ExternalProgramSettings.Emu68URL) -OnlyReleaseVersions 'TRUE' -Name 'Emu68-pistorm32lite.' -LocationforDownload ("$($Script:ExternalProgramSettings.TempFolder)\Emu68Pistorm32lite.zip") -LocationforProgram ("$($Script:ExternalProgramSettings.TempFolder)\Emu68Pistorm32lite\")-Sort_Flag 'SORT')){
        Write-ErrorMessage -Message 'Error downloading Emu68Pistorm32lite! Cannot continue!'
        exit
    }
    
    Write-StartSubTaskMessage -Message 'Downloading Emu68Tools' -SubtaskNumber '3' -TotalSubtasks '3'
    
    if (-not(Get-GithubRelease -GithubRelease ($Script:ExternalProgramSettings.Emu68ToolsURL) -Tag_Name "nightly" -Name 'Emu68-tools' -LocationforDownload ("$($Script:ExternalProgramSettings.TempFolder)\Emu68Tools.zip") -LocationforProgram ("$($Script:ExternalProgramSettings.TempFolder)\Emu68Tools\") -Sort_Flag 'SORT')){
        Write-ErrorMessage -Message 'Error downloading Emu68Tools! Cannot continue! Quitting!'
        exit
    }
    
    Write-TaskCompleteMessage -Message 'Downloading Emu68 Packages - Complete'
    
}