$windowSize = New-Object Management.Automation.Host.Size
$windowSize.Width = 41
$windowSize.Height = 20
$Host.UI.RawUI.WindowSize = $windowSize

$bufferSize = $Host.UI.RawUI.BufferSize
$bufferSize.Width = 41
$bufferSize.Height = 20
$Host.UI.RawUI.BufferSize = $bufferSize

Write-Host '|=======================================|'
write-host '| |                                   | |'
write-host '| |   Login Initiated please wait.    | |'
write-host '| |                                   | |'
Write-Host '|=======================================|'
Write-Host ''
Write-Host ''
Write-Host ''
Connect-AzAccount

# get-aztenent as a variable and display name then identify the tenant you want to use
$subs = Get-AzSubscription
write-host '|=======================================|'
foreach ($sub in $subs) {
    write-host '|                                       |'
    Write-Host '|     ' $sub.Name ' |'
    Write-Host '|' $sub.Id ' |'
    write-host '|                                       |'
}
write-host '|=======================================|'
Write-Host ''
Write-Host ''
Write-Host ''
Write-Host '|=======================================|'
write-host '| |                                   | |'
write-host '| |   What Sub do you want to use?    | |'
write-host '| |                                   | |'
Write-Host '|=======================================|'
Write-Host ''
$subID = Read-Host "Input Sub Name or ID"
Update-AzConfig -EnableLoginByWam $true
start-sleep -Seconds 1
Update-AzConfig -DefaultSubscriptionForLogin $subID
Start-Sleep -Seconds 1

Write-Host ''
Write-Host ''
Write-Host ''
Write-Host '|=======================================|'
write-host '|    |                              |   |'
Write-Host '|    |  Please Select A Name.       |   |'
write-host '|    |  This will Name Everything   |   |'
write-host '|    |  Like So:                    |   |'
write-host '|    |                              |   |'
write-host '|    |  Name-VM                     |   |'
write-host '|    |  Name-RG                     |   |'
write-host '|    |  Name-VNet                   |   |'
write-host '|    |  Name-Subnet                 |   |'
write-host '|    |  Name-backendSubnet          |   |'
write-host '|    |                              |   |'
write-host '|=======================================|'
Write-Host ''
Start-Sleep -Seconds 1
$name = Read-host "Input Name "

Write-Host '|=======================================|'
write-host '| |                                   | |'
write-host '| |  Please input from the following  | |'
write-host '| |                                   | |'
write-host '| |  East US | West US | East US 2,   | |'
write-host '| |-----------------------------------| |'
write-host '| |  eastus  | westus  | eastus2      | |'
write-host '| |                                   | |'
write-host '| | UK South | UK West | North Europe | |'
write-host '| |-----------------------------------| |'
write-host '| | uksouth  | ukwest  | northeurope  | |'
write-host '| |                                   | |'
Write-Host '|=======================================|'
Start-Sleep -Seconds 1
$region = Read-host "Identify Region "

# Set-AzVirtualNetwork -Name $name-VNet
Start-Sleep -Seconds 1

## Create resource group 
New-AzResourceGroup -Name $name-RG -Location $region
Start-Sleep -Seconds 1

## Front and back end subnet creation
$frontendSubnet = New-AzVirtualNetworkSubnetConfig -Name $name-Subnet -AddressPrefix "10.0.1.0/24"
$backendSubnet = New-AzVirtualNetworkSubnetConfig -Name $name-backendSubnet -AddressPrefix "10.0.2.0/24" 
Start-Sleep -Seconds 1

## Create virtual network
$virtualNetwork = New-AzVirtualNetwork -Name $name-VNet -ResourceGroupName $name-RG `
    -Location $region -AddressPrefix "10.0.0.0/16" -Subnet $frontendSubnet,$backendSubnet

## Remove subnet from in memory representation of virtual network
Remove-AzVirtualNetworkSubnetConfig -Name $name-backendSubnet -VirtualNetwork $virtualNetwork
Start-Sleep -Seconds 1

## Remove subnet from virtual network
$virtualNetwork | Set-AzVirtualNetwork 
Start-Sleep -Seconds 1

New-AzVm -ResourceGroupName $name-RG -Name $name-VM -Location $region -Image 'MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition:latest' -VirtualNetworkName $name-VNet -SubnetName $name-Subnet -SecurityGroupName $name-NSG -PublicIpAddressName $name-PubIP -OpenPorts 80,3389

Write-Host '|=======================================|'
Write-Host '|                                       |'
Write-Host '|  Do you want to download RDPfile for  |'
Write-Host '|              this VM?                 |'
Write-Host '|                                       |'
Write-Host '|    This will create a file in your    |'
Write-Host '|           documents folder.           |'
Write-Host '|                                       |'
Write-Host '|=======================================|'
Write-Host ''
Write-Host ''
Write-Host ''
$selectedRDP = Read-Host '(y/n)'

if ($selectedRDP -eq 'y') {
    Get-AzRemoteDesktopFile -ResourceGroupName $selectedRG -Name $selectedVM -LocalPath "$env:USERPROFILE/documents/RDP-Sessions/$selectedVM.rdp"
    Write-Host '|=======================================|'
    Write-Host '|                                       |'
    Write-Host '|               All Done                |'
    Write-Host '|             Starting RDP              |'
    Write-Host '|                                       |'
    Write-Host '|=======================================|'
    Start-Process "$env:USERPROFILE/documents/RDP-Sessions/$selectedVM.rdp"
} else {
    Write-Host '|=======================================|'
    Write-Host '|                                       |'
    Write-Host '|               All Done                |'
    Write-Host '|                Enjoy                  |'
    Write-Host '|                                       |'
    Write-Host '|=======================================|'
}