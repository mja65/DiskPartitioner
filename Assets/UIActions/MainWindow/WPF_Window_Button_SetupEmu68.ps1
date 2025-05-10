$WPF_Window_Button_SetupEmu68.Add_Click({

    $Script:GUICurrentStatus.CurrentWindow = 'Emu68Settings'
    If ($Script:GUIActions.InstallOSFiles -eq $true){
        $WPF_Setup_OSSelection_GroupBox.Visibility = 'Visible'
        $WPF_Setup_SourceFiles_GroupBox.Visibility = 'Visible'
        $WPF_Setup_Settings_GroupBox.Visibility = 'Visible'

        if ($Script:GUICurrentStatus.InstallMediaRequiredFromUserSelectablePackages){
           
            If ($Script:GUIActions.FoundInstallMediatoUse){
                $HashTableforInstallMedia = @{} # Clear Hash
                $Script:GUIActions.FoundInstallMediatoUse | ForEach-Object {
                    $HashTableforInstallMedia[$_.ADF_Name] = @($_.FriendlyName) 
                }
                
                $Script:GUICurrentStatus.InstallMediaRequiredFromUserSelectablePackages | ForEach-Object {
                    if  (-not ($HashTableforInstallMedia.ContainsKey($_.SourceLocation) -and $_.Source -eq 'ADF')){
                        Write-host "Install Media requirements changed"
                        $Script:GUIActions.FoundInstallMediatoUse = $null
                        break               
                    } 
                 }
            }
               
        }


    }
    elseif ($Script:GUIActions.InstallOSFiles -eq $false){
        $WPF_Setup_OSSelection_GroupBox.Visibility = 'Visible'
        $WPF_Setup_SourceFiles_GroupBox.Visibility = 'Hidden'
        $WPF_Setup_Settings_GroupBox.Visibility = 'Visible'
    }

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

    update-ui -MainWindowButtons -Emu68Settings

})

