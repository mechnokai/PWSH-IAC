$path = pwd
$team = Read-Host "What is the name of the new team?"
$nickname = Read-Host "What is the nickname for the team? (e.g., 'infrastructure', 'dataeng')"
$location = Read-Host "What is the Azure location for the team? (e.g., 'centralus', 'eastus2')"
$owner = Read-Host "Who is the owner of the team? (e.g., 'Ted Smith')"

$configfile = @"
`$resourcegroup = "$team"
`$nickname = "$nickname"
`$location = "$location"
`$tags = @{
    "Project"     = "`$resourcegroup"
    "Owner"       = "$owner"
}

`$resources = @{

`$resourcegroup = @{
    module = "Az-ResourceGroup"
    type = "ResourceGroup"
    name = "`$resourcegroup"
    location = "`$location"
    tags = `$tags
}

}

Run-Build -resources `$resources
"@

Out-File -FilePath $(Join-Path "$path" "configs" "$team.ps1") -InputObject $configfile -Encoding UTF8