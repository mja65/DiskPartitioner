function Get-IsValueNumber {
    param (
        $TexttoCheck,
        [Switch]$IntegerValue
    )
    #$TexttoCheck = 'w'

    #$TexttoCheck = $WPF_DP_SelectedSize_Input.Text

    $Startingpointforendcheck = (($TexttoCheck).Length)-1
    
    if (($TexttoCheck -match "^[\d\.]+$") -and (($TexttoCheck).substring($Startingpointforendcheck,1) -match "^[0-9]")){
        if ($IntegerValue){
            if ($TexttoCheck -match "\."){
                return $false        
            }
            else{
                return $true
            }
        }
        else {
            return $true
        }

    }
    else {
        return $false
    }
    
}
