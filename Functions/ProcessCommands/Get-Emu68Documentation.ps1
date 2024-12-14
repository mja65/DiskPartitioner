function Get-Emu68ImagerDocumentation {
    param (
        $LocationtoDownload
    )

   # $LocationtoDownload ='E:\PiStorm\Docs\'

    $DownloadURLs = "https://mja65.github.io/Emu68-Imager/index.html", `
                    "https://mja65.github.io/Emu68-Imager/requirements.html", `
                    "https://mja65.github.io/Emu68-Imager/download.html", `
                    "https://mja65.github.io/Emu68-Imager/installation.html",
                    "https://mja65.github.io/Emu68-Imager/quickstart.html", `
                    "https://mja65.github.io/Emu68-Imager/instructions.html", `
                    "https://mja65.github.io/Emu68-Imager/amigautilities.html", `
                    "https://mja65.github.io/Emu68-Imager/packages.html", `
                    "https://mja65.github.io/Emu68-Imager/included.html", `
                    "https://mja65.github.io/Emu68-Imager/faqs.html", `
                    "https://mja65.github.io/Emu68-Imager/support.html", `
                    "https://mja65.github.io/Emu68-Imager/credits.html", `
                    "https://mja65.github.io/Emu68-Imager/images/screenshot1.png", `
                    "https://mja65.github.io/Emu68-Imager/images/screenshot2.png"

    foreach ($URL in $DownloadURLs){
        If ((Split-Path $URL -Leaf) -eq 'index.html'){
            $OutfileLocation = $LocationtoDownload 
        }
        elseif (((Split-Path $URL -Leaf) -eq 'screenshot1.png') -or ((Split-Path $URL -Leaf) -eq 'screenshot2.png')) {
            $OutfileLocation = $LocationtoDownload+'images\'
        }
        else {
            $OutfileLocation = ($LocationtoDownload+'html\')
        }
        if (-not (test-path $OutfileLocation)){
                $null = New-Item $OutfileLocation -ItemType Directory
        }
        
        if ((Get-DownloadFile -DownloadURL $URL -OutputLocation ($OutfileLocation+(Split-Path $URL -Leaf)) -NumberofAttempts 3) -eq $true){
            if (($OutfileLocation+(Split-Path $URL -Leaf)).IndexOf('.html') -gt 0){
                $URLContent = Get-Content ($OutfileLocation+(Split-Path $URL -Leaf))
                $RevisedURLContent = $null
                foreach ($Line in $URLContent){
                    If ((Split-Path $URL -Leaf) -eq 'index.html'){
                        $Line = $Line -replace '<a href="/Emu68-Imager/', '<a href="./html/'
                        $Line = $Line -replace '<a href="https://mja65.github.io/Emu68-Imager/', '<a href="./index.html'
                        $Line = $Line -replace '<img src="/Emu68-Imager/images' , '<img src="./images'
                    }
                    else{
                        $Line = $Line -replace '<a href="/Emu68-Imager/', '<a href="../html/'
                        $Line = $Line -replace '<a href="https://mja65.github.io/Emu68-Imager/', '<a href="../index.html'
                        $Line = $Line -replace '<img src="/Emu68-Imager/images' , '<img src="../images'
                    }
                    $RevisedURLContent += $Line+"`r`n"
                }
                Set-Content -Path ($OutfileLocation+(Split-Path $URL -Leaf)+'NEW') -Value $RevisedURLContent
                $null = remove-item ($OutfileLocation+(Split-Path $URL -Leaf))
                $null = rename-item ($OutfileLocation+(Split-Path $URL -Leaf)+'NEW') ($OutfileLocation+(Split-Path $URL -Leaf)) 
                If ((Split-Path $URL -Leaf) -eq 'index.html'){
                    if (-not (Test-Path ($LocationtoDownload+'html\'))){
                        $Null = New-Item ($LocationtoDownload+'html\') -ItemType Directory   
                    }
                    $Null = Copy-Item -Path ($OutfileLocation+(Split-Path $URL -Leaf)) -Destination ($LocationtoDownload+'html\Emu68-Imager.html')
                }
            }
        }
        else{
            return $false
        }

    }
    return $true
}