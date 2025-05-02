$WPF_Window_Button_StartPage.Add_Click({
    $Script:GUICurrentStatus.CurrentWindow = 'StartPage'
    for ($i = 0; $i -lt $WPF_Window_Main.Children.Count; $i++) {        
        if ($WPF_Window_Main.Children[$i].Name -eq $WPF_SetupEmu68.Name){
            $WPF_Window_Main.Children.Remove($WPF_SetupEmu68)
        }
        if ($WPF_Window_Main.Children[$i].Name -eq $WPF_PackageSelection.Name){
            $WPF_Window_Main.Children.Remove($WPF_PackageSelection)
        }
        if ($WPF_Window_Main.Children[$i].Name -eq $WPF_Partition.Name){
            $WPF_Window_Main.Children.Remove($WPF_Partition)
        }
    }
    
    for ($i = 0; $i -lt $WPF_Window_Main.Children.Count; $i++) {        
        if ($WPF_Window_Main.Children[$i].Name -eq $WPF_StartPage.Name){
            $IsChild = $true
            break
        }
    }
    
    if ($IsChild -ne $true){
        $WPF_Window_Main.AddChild($WPF_StartPage)
    }
    update-ui -MainWindowButtons
})

