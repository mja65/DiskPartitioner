function Get-IsValueNumber {
    param (
        $TexttoCheck
    )
    #$TexttoCheck = 'w'

    #$TexttoCheck = $WPF_DP_SelectedSize_Input.Text

    $Startingpointforendcheck = (($TexttoCheck).Length)-1
    if (($TexttoCheck -match "^[\d\.]+$") -and (($TexttoCheck).substring($Startingpointforendcheck,1) -match "^[0-9]")){
        return $true

    }
    else {
        return $false
    }
}