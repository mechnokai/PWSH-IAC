param (
    [string]$resourcegroup,
    [string]$location = $defaultLocation,
    [hashtable]$tags
)

# Create the resource group if it doesn't exist
if ($resourcegroups.ResourceGroupName -notcontains $resourcegroup) {
    Write-Host "Creating resource group '$resourcegroup' in location '$location'..." -ForegroundColor Green
    New-AzResourceGroup -Name $resourcegroup -Location $location -Tag $tags
} else {
    Write-Host "Resource group '$resourcegroup' already exists." -ForegroundColor Yellow
    # Update the resource group tags
    $resource = $resourcegroups | where-object {$_.ResourceGroupName -eq $resourcegroup}
    Update-Tags -resource $resource -tags $tags
    Set-AzResourceGroup -Name $resourcegroup -Tag $updatedTags
}