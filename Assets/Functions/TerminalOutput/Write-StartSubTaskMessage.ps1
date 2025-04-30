function Write-StartSubTaskMessage {
    param (

    )
    Write-Host ''
    Write-Host "[Subtask: $($Script:Settings.CurrentSubTaskNumber) of $($Script:Settings.TotalNumberofSubTasks)]: `t Starting Subtask: $($Script:Settings.CurrentSubTaskName)" -ForegroundColor White
    Write-Host ''
    '' | Out-File $Script:Settings.LogLocation -Append
    "[Subtask: $($Script:Settings.CurrentSubTaskNumber) of $($Script:Settings.TotalNumberofSubTasks)]: `t Starting Subtask: $($Script:Settings.CurrentSubTaskName)" | Out-File $Script:Settings.LogLocation -Append
    '' | Out-File $Script:Settings.LogLocation -Append
}