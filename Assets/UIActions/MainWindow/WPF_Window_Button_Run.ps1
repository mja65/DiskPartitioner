$WPF_Window_Button_Run.Add_Click({
       if ($Script:GUICurrentStatus.FileBoxOpen -eq $true){
        return
    }
   Update-UI -CheckforRunningImage

   if ($Script:GUICurrentStatus.ProcessImageStatus -eq $false){
      Get-IssuesPriortoRunningImage
      return

   }
   elseif ($Script:GUICurrentStatus.ProcessImageStatus -eq $true){
      Get-OptionsBeforeRunningImage
      if ($Script:GUICurrentStatus.ProcessImageConfirmedbyUser -eq $false){
         return
      }
      elseif ($Script:GUICurrentStatus.ProcessImageConfirmedbyUser -eq $true){

        # $Script:GUIActions.OutputType = "Disk"
        # $Script:GUIActions.OutputPath = "\disk6"
        $WPF_MainWindow.Close()
      }
   }
  
})   


