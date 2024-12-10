$WPF_Setup_SSID_Textbox.add_LostFocus({
    if ($WPF_Setup_SSID_Textbox.Text){
        $Script:GUIActions.SSID = $WPF_Setup_SSID_Textbox.Text    
    }    
})
