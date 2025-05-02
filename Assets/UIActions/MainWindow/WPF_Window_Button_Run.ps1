$WPF_Window_Button_Run.Add_Click({
   
   Update-UI -CheckforRunningImage

   if ($Script:GUICurrentStatus.ProcessImageStatus -eq $false){
      Get-IssuesPriortoRunningImage

   }
   elseif ($Script:GUICurrentStatus.ProcessImageStatus -eq $true){
      if (($Script:GUIActions.KickstartVersiontoUse) -and (-not ($Script:GUIActions.AvailablePackages))){
         Get-SelectablePackage
     } 
    Write-host 'To complete linking to actually running the tool'
   }

})   


