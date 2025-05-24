function Get-DownloadFile {
    param (
        $DownloadURL,
        $OutputLocation, #Needs to include filename!
        $NumberofAttempts
    )

    # $DownloadURL = "http://aminet.net/comm/net/AmiSpeedTest.lha"
    # $OutputLocation = "C:\Users\Matt\OneDrive\Documents\DiskPartitioner\Temp\WebPackagesDownload\SysInfo.lha"
    # $NumberofAttempts = 1

    #$OutputLocation = ".\Temp\StartupFiles\HSTImager.zip"
    #$NumberofAttempts = 3
    #$DownloadURL = "https://github.com/henrikstengaard/hst-imager/releases/dfdgfdgownload/1.2.437/hst-imager_v1.2.437-7d8644e_console_windows_x64.zip" 
    #$DownloadURL = "http://download.d0.se/pub/SysInfo.lha" 
    #$DownloadURL = "http://dopus.free.fr/betas/DOpus417pre21.lzx"

    $client = [System.Net.Http.HttpClient]::new()
    $client.DefaultRequestHeaders.UserAgent.ParseAdd("PowerShellHttpClient")
    
    $attempt = 0
    $success = $false
    
    while (-not $success -and $attempt -lt $NumberofAttempts) {
        $attempt++
        try {
            if ($attempt -gt 1){
                Write-InformationMessage -Message ('Trying Download again. Retry Attempt # '+$attempt)
            }
            $response = $client.GetAsync($DownloadURL , [System.Net.Http.HttpCompletionOption]::ResponseHeadersRead).Result
            if (-not $response.IsSuccessStatusCode) {
                Write-InformationMessage -Message "HTTP request failed: $($response.StatusCode) $($response.ReasonPhrase)"
                #return $false
            }
            else {
                $FileLength = $response.Content.Headers.ContentLength
                $stream = $response.Content.ReadAsStreamAsync().Result
                $fileStream = [System.IO.File]::OpenWrite($OutputLocation)
                $buffer = New-Object byte[] 65536  # 64 KB
                $read = 0
                $totalRead = 0
                $percentComplete = 0
                while (($read = $stream.Read($buffer, 0, $buffer.Length)) -gt 0) {
                    $fileStream.Write($buffer, 0, $read)
                    $totalRead += $read
                    $newPercent = [math]::Floor(($totalRead/$FileLength)*100)
                    if ($newPercent -ne $percentComplete) {
                        $percentComplete = $newPercent
                        Write-Progress -Activity "Downloading" -Status "$percentComplete% Complete" -PercentComplete $percentComplete
                    }
                }
                Write-Progress -Activity "Downloading" -Completed -Status "Done"
                $success = $true                            
            }
        }
        catch {
            if ($attempt -lt $NumberofAttempts) {
                Write-InformationMessage -message 'Download failed! Retrying in 3 seconds'
                 Start-Sleep -Seconds 3
            }
            else {
                return $false
            }
        }
        finally {
            if ($stream){
                $stream.Dispose() 
                $stream = $null 
            }
            if ($fileStream) {
                $fileStream.Dispose()
                $fileStream = $null
            }  
            
        }
    }

    return $true      

}
