$WPF_DP_Button_SaveImage.add_click({
        if ($Script:GUICurrentStatus.FileBoxOpen -eq $true){
        return
    }
    $LocationSelected = Set-ImageLocation 
    if ($LocationSelected){
        $Script:GUIActions.OutputPath = $LocationSelected
    }
    update-ui -buttons -CheckforRunningImage
})