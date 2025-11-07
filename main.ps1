Write-Host "Build is initiating..."
#grab the json file from each team in .\teams folder and pass it into each module
$allresources = Get-AzResource
$resourcegroups = Get-AzResourceGroup
$defaultLocation = "eastus2"


#Functions for the overall build process
function Use-Module{
    param (
        [string]$moduleName,
        [hashtable]$params
    )

    $modulePath = Join-Path ".." "modules" "$moduleName.ps1"
    if (Test-Path -Path $modulePath) {
        . $modulePath @params
    } else {
        Write-Error "Module '$moduleName' not found at path '$modulePath'."
    }
}

function Run-Build {
    foreach ($resource in $resources.GetEnumerator()) {
        Use-Module -moduleName $resource.Value.type -params $resource.Value
    }
}
function Update-Tags{
    param (
        [object]$resource,
        [hashtable]$tags
    )
    $existingTags = $resource.Tags #this pulls from AllResources in each module
    $updatedTags = @{}
    if ($existingTags) {
        foreach ($key in $existingTags.Keys) {
            $updatedTags[$key] = $existingTags[$key]
        }
    }
    foreach ($key in $tags.Keys) {
        $updatedTags[$key] = $tags[$key]
    }
}

if ($build -eq 1){
    #loop through each resource folder and execute
    $configfolders = Get-ChildItem -Path "$PSScriptRoot\configs" -Directory
    foreach ($config in $configfolders) {
        $scriptPath = Join-Path -Path $config.FullName -ChildPath "$($config.Name).ps1"
        if (Test-Path -Path $scriptPath) {
            Write-Host "Executing script for team: $($config.Name)" -ForegroundColor Cyan
            . $scriptPath -allresources $allresources
            cd $scriptPath
        } else {
            Write-Warning "No script found for team: $($config.Name) at path: $scriptPath"
        }
    }
}