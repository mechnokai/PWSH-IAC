#Takes in the storage account and storage container information and creates them if they do not exist
param (
    [string]$resourcegroup,
    [string]$location = $defaultLocation,
    [string]$nickname,
    [hashtable]$tags,
    [string]$storageAccountName = ($nickname + (Get-Random -Maximum 9999)).ToLower(),
    [bool]$access = $false
)
# Check if the storage account exists
$storage = $allresources | where-object {$_.ResourceType -eq "Microsoft.Storage/storageAccounts"}
if ($storage.Name -notcontains $storageAccountName) {
    Write-Host "Creating storage account '$storageAccountName' in resource group '$resourcegroup'..." -ForegroundColor Green
    New-AzStorageAccount -Name $storageAccountName -ResourceGroupName $resourcegroup -Location $location -SkuName "Standard_LRS" -Kind "StorageV2" -Tag $tags

#Storage account exists
} else {
    Write-Host "Storage account '$storageAccountName' already exists." -ForegroundColor Yellow
    # Get the existing storage account from the already pulled resources in $allresources, as part of the main script
    $resource = $storage | where-object {$_.Name -eq $storageAccountName}
    # Update the storage account tags
    Update-Tags -resource $resource -tags $tags
    Set-AzStorageAccount -ResourceGroupName $resourcegroup -Name $storageAccountName -Tag $updatedTags -MinimumTlsVersion TLS1_2 -AllowBlobPublicAccess $access
    if ($resource.ResourceGroupName -ne $resourcegroup) {
        #Storage not in the defined resource group, move it
        Write-Host "Moving storage account '$storageAccountName' to resource group '$resourcegroup'..." -ForegroundColor Green
        Move-AzResource -DestinationResourceGroupName $resourcegroup -ResourceId $resource.Id
    }
}