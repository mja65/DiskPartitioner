$WPF_Window_Button_SetupDisk.Add_Click({
    if ($Script:Settings.DebugMode){
        Write-host "Set up Disk button pressed"
    }

    # if (-not ($Script:WPF_Partition)){
    #     $Script:WPF_Partition = Get-XAML -WPFPrefix 'WPF_DP_' -XMLFile '.\Assets\WPF\Grid_DiskPartition.xaml' -ActionsPath '.\Assets\UIActions\DiskPartition\' -AddWPFVariables
    #     Set-PartitionGridActions
    # }


        $Script:GUICurrentStatus.CurrentWindow = 'DiskPartition'
    
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
        for ($i = 0; $i -lt $WPF_Window_Main.Children.Count; $i++) {        
            if ($WPF_Window_Main.Children[$i].Name -eq $WPF_SetupEmu68.Name){
                $WPF_Window_Main.Children.Remove($WPF_SetupEmu68)
            }
            if ($WPF_Window_Main.Children[$i].Name -eq $WPF_PackageSelection.Name){
                $WPF_Window_Main.Children.Remove($WPF_PackageSelection)
            }
            if ($WPF_Window_Main.Children[$i].Name -eq $WPF_StartPage.Name){
                $WPF_Window_Main.Children.Remove($WPF_StartPage)
            }
        }
       
        for ($i = 0; $i -lt $WPF_Window_Main.Children.Count; $i++) {        
            if ($WPF_Window_Main.Children[$i].Name -eq $WPF_Partition.Name){
                $IsChild = $true
                break
            }
        }
    
        if ($IsChild -ne $true){
            $WPF_Window_Main.AddChild($WPF_Partition)
        }
        
        update-ui -WindowButtons
        Update-UI -Emu68Settings

})
 

