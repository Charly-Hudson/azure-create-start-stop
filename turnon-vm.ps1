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
    Write-Host '|   ' $rg.ResourceGroupName '   |'
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
    Write-Host '|   ' $vms.Name '   |'
}
Write-Host '|                              |'
Write-Host '|==============================|'
Write-Host ''
Write-Host ''
Write-Host ''
$selectedVM = Read-Host 'Input VM Name'

Write-Host '|==============================|'
Write-Host '|                              |'
Write-Host '|         Starting VM          |'
Write-Host '| Please Wait This May Take A  |'
Write-Host '|    Few Minutes To Complete   |'
Write-Host '|                              |'
Write-Host '|==============================|'

Start-AzVM -ResourceGroupName $selectedRG -Name $selectedVM

Write-Host '|==============================|'
Write-Host '|                              |'
Write-Host '| Do you want to download RDP  |'
Write-Host '|      file for this VM?       |'
Write-Host '|                              |'
Write-Host '|  This will create a file in  |'
Write-Host '|     your documents folder    |'
Write-Host '|                              |'
Write-Host '|==============================|'
Write-Host ''
Write-Host ''
Write-Host ''
$selectedRDP = Read-Host '(y/n)'

if ($selectedRDP -eq 'y') {
    if (-not (Test-Path "$env:USERPROFILE/documents/RDP-Sessions")) {
        New-Item -Path "$env:USERPROFILE/documents/RDP-Sessions" -ItemType Directory
    }
    Get-AzRemoteDesktopFile -ResourceGroupName $selectedRG -Name $selectedVM -LocalPath "$env:USERPROFILE/documents/RDP-Sessions/$selectedVM.rdp"
    Write-Host '|==============================|'
    Write-Host '|                              |'
    Write-Host '|           All Done           |'
    Write-Host '|         Starting RDP         |'
    Write-Host '|                              |'
    Write-Host '|==============================|'
    Start-Process "$env:USERPROFILE/documents/RDP-Sessions/$selectedVM.rdp"
} else {
    Write-Host '|==============================|'
    Write-Host '|                              |'
    Write-Host '|           All Done           |'
    Write-Host '|            Enjoy             |'
    Write-Host '|                              |'
    Write-Host '|==============================|'
}