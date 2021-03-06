﻿param ($ResourceGroup)
$diskarray = @()

$VMs = @(Get-AzVM -ResourceGroupName $ResourceGroup)


foreach ($VM in $VMs)
{

    Write-Verbose "$($VM.name) start" 
    $disk = Get-AzDisk -ResourceGroupName $ResourceGroup -DiskName $VM.StorageProfile.OsDisk.Name
    $diskarray += [PSCustomObject]@{
                    "VMName"         = $VM.name
                    "OS"             = $VM.StorageProfile.OsDisk.OsType
                    "DiskType"       = "OS"
                    "DiskName"       = $disk.Name
                    "DiskSize"       = $disk.DiskSizeGB
                    "DiskSKU"        = $disk.Sku.Name
                    "IOPSRead"       = $disk.DiskIOPSReadOnly
                    "IOPSReadWrite"  = $disk.DiskIOPSReadWrite
                    "MBPSRead"       = $disk.DiskMBpsReadOnly
                    "MBPSReadWrite"  = $disk.DiskMBpsReadWrite
                }

    foreach ($DataDisk in $VM.StorageProfile.DataDisks)
    { 
        $disk = Get-AzDisk -ResourceGroupName $ResourceGroup -DiskName $DataDisk.Name
        $diskarray += [PSCustomObject]@{
                        "VMName"         = $VM.name
                        "OS"             = $VM.StorageProfile.OsDisk.OsType
                        "DiskType"       = "Data"
                        "DiskName"       = $disk.Name
                        "DiskSize"       = $disk.DiskSizeGB
                        "DiskSKU"        = $disk.Sku.Name
                        "IOPSRead"       = $disk.DiskIOPSReadOnly
                        "IOPSReadWrite"  = $disk.DiskIOPSReadWrite
                        "MBPSRead"       = $disk.DiskMBpsReadOnly
                        "MBPSReadWrite"  = $disk.DiskMBpsReadWrite
                    }
    }

    Write-Verbose "$($VM.name) end"
}

$diskarray | Export-Csv -Path out.csv -NoTypeInformation

