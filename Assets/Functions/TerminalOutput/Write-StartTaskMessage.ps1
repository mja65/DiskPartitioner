function Write-StartTaskMessage {
    param (
    )
    Write-Host ''
    Write-Host "[Section: $($Script:Settings.CurrentTaskNumber) of $($Script:Settings.TotalNumberofTasks)]: `t Starting Task: $($Script:Settings.CurrentTaskName)" -ForegroundColor White
    Write-Host ''
    '' | Out-File $Script:Settings.LogLocation -Append
    "[Section: $($Script:Settings.CurrentTaskNumber) of $($Script:Settings.TotalNumberofTasks)]: `t Starting Task: $($Script:Settings.CurrentTaskName)" | Out-File $Script:Settings.LogLocation -Append
    '' | Out-File $Script:Settings.LogLocation -Append
}



