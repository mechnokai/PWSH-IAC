param (
    [string]$resourcegroup,
    [string]$location = $defaultLocation,
    [string]$nickname,
    [hashtable]$tags,
    [string]$vmName = "$($nickname)-vm"
)
# Create the VM if it doesn't exist
$existingVM = $allresources | Where-Object {
    $_.ResourceType -eq "Microsoft.Compute/virtualMachines"
}
if ($existingVM.Name -notcontains $vmName) {
    Write-Host "Creating virtual machine '$vmName' in resource group '$resourcegroup'..." -ForegroundColor Green
    # VM creation logic goes here
    New-AzVM -ResourceGroupName $resourcegroup -Location $location -VMName $vmName -Tag $tags
} else {
    Write-Host "Virtual machine '$vmName' already exists." -ForegroundColor Yellow
    # VM update logic goes here
    Set-AzVM -ResourceGroupName $resourcegroup -Name $vmName -Tag $tags
}