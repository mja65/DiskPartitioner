$WPF_DP_Button_SaveImage.add_click({
    $LocationSelected = Set-ImageLocation 
    if ($LocationSelected){
        $Script:GUIActions.OutputPath = $LocationSelected
    }
    update-ui -buttons -CheckforRunningImage
})