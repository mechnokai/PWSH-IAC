$resourcegroup = "whathisface"
$nickname = "whf"
$location = "centralus"
$tags = @{
    "Project"     = "$resourcegroup"
    "Owner"       = "Whats-His-Face"
}



$resources = @{

$resourcegroup = @{
    module = "Az-ResourceGroup"
    type = "ResourceGroup"
    name = "$resourcegroup"
    location = "$location"
    tags = $tags
}

$storage1 = @{
    module = "Az-Storage"
    type = "StorageAccount"
    name = "$($nickname)storage"
    location = "$location"
    tags = $tags
    sku = "Standard_LRS"
    kind = "StorageV2"
}

}

Run-Build -resources $resources