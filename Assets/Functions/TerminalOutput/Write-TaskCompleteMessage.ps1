function Write-TaskCompleteMessage {
    param (
    )
    Write-Host "[Section: $($Script:Settings.CurrentTaskNumber) of $($Script:Settings.TotalNumberofTasks)]: `t Task $($Script:Settings.CurrentTaskName) - Completed" -ForegroundColor Green
    "[Section: $($Script:Settings.CurrentTaskNumber) of $($Script:Settings.TotalNumberofTasks)]: `t Task $($Script:Settings.CurrentTaskName) - Completed" | Out-File $Script:Settings.LogLocation -Append
    $Script:Settings.CurrentTaskNumber ++
}