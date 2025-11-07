$resourcegroup = "Example"
$nickname = "exp"
$location = "eastus2"
$tags = @{
    "Project"     = "$resourcegroup"
    "Owner"       = "Julie Chalek"
}

$resources = @{

$resourcegroup = @{
    module = "Az-ResourceGroup"
    type = "ResourceGroup"
    name = "$resourcegroup"
    location = "$location"
    tags = $tags
}

}
Run-Build -resources $resources
