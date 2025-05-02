$windowSize = New-Object Management.Automation.Host.Size
$windowSize.Width = 41
$windowSize.Height = 20
$Host.UI.RawUI.WindowSize = $windowSize

$bufferSize = $Host.UI.RawUI.BufferSize
$bufferSize.Width = 41
$bufferSize.Height = 20
$Host.UI.RawUI.BufferSize = $bufferSize

Write-Host '|==============================|'
Write-Host '|                              |'
Write-Host '| Please Select What RG and VM |'
Write-Host '|                              |'
Write-Host '|==============================|'
Write-Host ''
Write-Host ''
Write-Host ''

Write-Host '|==============================|'
Write-Host '|       Resource Groups        |'
Write-Host '|                              |'
foreach ($rg in Get-AzResourceGroup) {
    Write-Host '|    ' $rg.ResourceGroupName
}
Write-Host '|                              |'
Write-Host '|==============================|'
Write-Host ''
Write-Host ''
Write-Host ''
$selectedRG = Read-Host 'Input RG Name'

Write-Host '|==============================|'
Write-Host '|       Virtual Machines       |'
Write-Host '|                              |'
foreach ($vms in Get-AzVm) {
    Write-Host '|    ' $vms.Name 
}
Write-Host '|                              |'
Write-Host '|==============================|'
Write-Host ''
Write-Host ''
Write-Host ''
$selectedVM = Read-Host 'Input VM Name'

Write-Host '|==============================|'
Write-Host '|                              |'
Write-Host '|         Stopping VM          |'
Write-Host '| Please Wait This May Take A  |'
Write-Host '|    Few Minutes To Complete   |'
Write-Host '|                              |'
Write-Host '|==============================|'

Stop-AzVM -ResourceGroupName $selectedRG -Name $selectedVM -Force