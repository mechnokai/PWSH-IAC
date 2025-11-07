# Script requires a team json and the databricks extension installed
# Parameters
param (
    # Mandatory parameters
    [Parameter(Mandatory=$true)]
    [string]$resourcegroup,
    [Parameter(Mandatory=$true)]
    [string]$teamname,
    [Parameter(Mandatory=$true)]
    [string]$location = $defaultLocation,
    # Optional parameters
    [string]$sku = "Standard",
    [string[]]$envs = @("PRD"),
    [bool]$enhancedsecuritymonitoring = $false,
    [bool]$prepareencryption = $false,
    [bool]$infrastructureencryption = $false,
    [string]$publicnetworkaccess = "Enabled",
    [string]$subnet = "",
    [bool]$enablenopublicip = $false,
    [string]$vnet = "",
    [hashtable]$tags = @{}
)

# Potential to be removed once it verified that all resources are being passed from main
# Or could just keep it as a safety net
$allresources = az resource list | ConvertFrom-Json
$filter = $allresources | Where-Object { $_.type -eq "microsoft.databricks/workspaces" }
foreach ($env in $envs) {
    $workspaceName = "$teamname-Databricks-$env"
    if ($filter.name -notcontains $workspaceName) {
        Write-Host "Creating databricks workspace '$workspaceName' in resource group '$resourcegroup'..." -ForegroundColor Green
        
        # Build parameter hashtable with only non-empty values
        $databricksParams = @{
            Name = $workspaceName
            ResourceGroupName = $resourcegroup
            Location = $location
            Sku = $sku
            AsJob = $true
        }
        
        # Add optional parameters only if they have meaningful values
        if ($tags.Count -gt 0) { $databricksParams.Tag = $tags }
        if ($subnet -ne "") { $databricksParams.Subnet = $subnet }
        if ($vnet -ne "") { $databricksParams.Vnet = $vnet }
        if ($enhancedsecuritymonitoring) { $databricksParams.EnhancedSecurityMonitoringValue = $enhancedsecuritymonitoring }
        if ($prepareencryption) { $databricksParams.PrepareEncryptionValue = $prepareencryption }
        if ($infrastructureencryption) { $databricksParams.InfrastructureEncryptionValue = $infrastructureencryption }
        if ($publicnetworkaccess -ne "Enabled") { $databricksParams.PublicNetworkAccessValue = $publicnetworkaccess }
        if ($enablenopublicip) { $databricksParams.EnableNoPublicIpValue = $enablenopublicip }
        
        New-AzDatabricksWorkspace @databricksParams
    }
    else {
        Write-Host "Databricks workspace '$workspaceName' already exists. Updating tags..." -ForegroundColor Yellow
        # Update the databricks workspace tags
        # If you run as job it fails but when you don't it works fine so not using AsJob here
        Update-AzDatabricksWorkspace -ResourceGroupName $resourcegroup -Name $workspaceName -Tag $tags
    }
}