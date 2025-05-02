$WPF_Window_Button_SetupEmu68.Add_Click({

    $Script:GUICurrentStatus.CurrentWindow = 'Emu68Settings'

    # if (-not ($Script:WPF_SetupEmu68)){
    #     $Script:WPF_SetupEmu68 = Get-XAML -WPFPrefix 'WPF_Setup_' -XMLFile '.\Assets\WPF\Grid_SetupEmu68.xaml' -ActionsPath '.\Assets\UIActions\SetupEmu68\' -AddWPFVariables
    # }


    for ($i = 0; $i -lt $WPF_Window_Main.Children.Count; $i++) {        
        if ($WPF_Window_Main.Children[$i].Name -eq $WPF_Partition.Name){
            $WPF_Window_Main.Children.Remove($WPF_Partition)
        }
        if ($WPF_Window_Main.Children[$i].Name -eq $WPF_PackageSelection.Name){
            $WPF_Window_Main.Children.Remove($WPF_PackageSelection)
        }
        if ($WPF_Window_Main.Children[$i].Name -eq $WPF_StartPage.Name){
            $WPF_Window_Main.Children.Remove($WPF_StartPage)
        }
    }
    
    for ($i = 0; $i -lt $WPF_Window_Main.Children.Count; $i++) {        
        if ($WPF_Window_Main.Children[$i].Name -eq $WPF_SetupEmu68.Name){
            $IsChild = $true
            break
        }
    }

    if ($IsChild -ne $true){
        $WPF_Window_Main.AddChild($WPF_SetupEmu68)
    }

    update-ui -MainWindowButtons

})

