param {
    [string]$name,
    [string]$description,
    [string]$org,
    [string]$team,
    [string]$permission = "maintain"
}

if (-not $org) {
    $org = "Americas"
}
if (-not $description) {
    $description = "Managed by Infrastructure Team"
}

$headers = @{ 'User-Agent' = 'PowerShell'; 'Accept' = 'application/vnd.github.v3+json' }
if ($token) { $headers['Authorization'] = "token $token" }

$repos = @()

gh repo list $org --limit 1000 --json name,nameWithOwner,fullName,description,private | ForEach-Object {
    $repos += $_
}

if ($name) {
    $repos = $repos | Where-Object { $_.name -like "*$name*" -or $_.full_name -like "*$name*" }
}

if ($repos -notcontains $name){
    Write-Host "No repository found with the name: $name"
    gh repo create "$org/$name" --private --description $description -t $team
}

gh api -X PUT "/orgs/$org/teams/$team/repos/$org/$name" -f "permission=$permission"