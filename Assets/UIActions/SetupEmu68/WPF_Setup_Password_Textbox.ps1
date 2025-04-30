$WPF_Setup_Password_Textbox.add_LostFocus({
    if ($WPF_Setup_Password_Textbox.Text){
        $Script:GUIActions.WifiPassword = $WPF_Setup_Password_Textbox.Text
    }
})

