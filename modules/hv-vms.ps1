param (
    [Parameter(Mandatory)]
    [string]$VMName,
    [Parameter(Mandatory)]
    [string]$VHDPath,
    [Parameter()]
    [int]$MemoryStartupBytes = 2GB,
    [Parameter()]
    [int]$ProcessorCount = 2,
    [Parameter()]
    [string]$SwitchName = "Default Switch"
)

# Check if Hyper-V module is available
Import-Module Hyper-V -ErrorAction Stop

# Validate VHD file exists
if (-not (Test-Path $VHDPath)) {
    Write-Error "VHD file not found at $VHDPath"
    exit 1
}

# Create new VM
New-VM -Name $VMName -MemoryStartupBytes $MemoryStartupBytes -Generation 2 -SwitchName $SwitchName

# Set processor count
Set-VMProcessor -VMName $VMName -Count $ProcessorCount

# Attach VHD
Set-VMHardDiskDrive -VMName $VMName -ControllerType SCSI -ControllerNumber 0 -Path $VHDPath

# Start VM
Start-VM -Name $VMName

Write-Host "VM '$VMName' created and started successfully."