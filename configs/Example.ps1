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

$storage = @{
    module = "Az-Storage"
    type = "StorageAccount"
    name = "$nickname-storage"
    location = "$location"
    sku = "Standard_LRS"
    tags = $tags
}

$virtualmachine = @{
    module = "Az-Compute"
    type = "VirtualMachine"
    name = "$nickname-vm"
    location = "$location"
    resourcegroup = "$resourcegroup"
    vmSize = "Standard_B1s"
    adminUsername = "adminuser"
    adminPassword = "P@ssw0rd1234!"
    tags = $tags
}
}
Run-Build -resources $resources
