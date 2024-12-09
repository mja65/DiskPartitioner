function Confirm-Prerequisites {
    param (
    )
    
    $is64bit = Test-64bit
    $isAministrator = Test-Administrator
    $FailedCheck = 0
        
    if ($is64bit -eq $false){
        $FailedCheck ++
    }
    if ($isAministrator  -eq $false){
        $FailedCheck ++
    }
    
    if ($FailedCheck -gt 0){
        $WPF_FailedPrerequisite = Get-XAML -WPFPrefix 'WPF_PreRequisiteCheck_' -XMLFile '.\Assets\WPF\Window_FailedPrerequisite.xaml' -ActionsPath '.\UIActions\PreRequisiteCheck\' -AddWPFVariables
        if (($is64bit -eq $false) -and ($isAministrator  -eq $false)){
            $WPF_PreRequisiteCheck_TextBox_Message.Text = 'You must run the tool in Administrator Mode and using a 64bit OS!'
        }
        elseif (($is64bit -eq $false) -and ($isAministrator  -eq $true)) {
            $WPF_PreRequisiteCheck_TextBox_Message.Text = 'You must run the tool using a 64bit OS!'
        }
        elseif (($isAministrator  -eq $false) -and ($is64bit -eq $true))  {
            $WPF_PreRequisiteCheck_TextBox_Message.Text = 'You must run the tool in Administrator Mode!'
        }
        $WPF_FailedPrerequisite.ShowDialog()
    }

}

