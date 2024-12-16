$WPF_TF_RecurseDepth_Value.Add_lostfocus({
    $InputValue = $WPF_TF_RecurseDepth_Value.Text
    if (Get-IsValueNumber $InputValue -eq $true){
        $WPF_TF_RecurseDepth_Value.Background = "White"
        $Script:GUIActions.TransferFilesRecurseDepth = $InputValue 
    
    }
    else {
        $WPF_TF_RecurseDepth_Value.Background = "Red"
    }
})