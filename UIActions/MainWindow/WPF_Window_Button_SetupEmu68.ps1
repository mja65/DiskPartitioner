$WPF_Window_Button_SetupEmu68.Add_Click({
    for ($i = 0; $i -lt $WPF_Window_Main.Children.Count; $i++) {        
        if ($WPF_Window_Main.Children[$i].Name -eq $WPF_Partition.Name){
            $WPF_Window_Main.Children.Remove($WPF_Partition)
            break
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

})

