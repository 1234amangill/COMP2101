function get-os{
    Write-Output "OS Information"
    Write-Output "------------------------"
    Get-WmiObject win32_operatingsystem | foreach {
            New-Object -TypeName psobject -Property @{
                'Name' = if( $_.name  -ne $null ) {$_.name} Else {"data unavailable"}
                'Version' = if( $_.version  -ne $null ) {$_.version} Else {"data unavailable"}
            }
    } | format-list
}

function get-system{
    Write-Output "System Information:"
    Write-Output "------------------------"
    Get-WmiObject -class win32_computersystem | foreach {
            New-Object -TypeName psobject -Property @{
                'Description' = if( $_.Description  -ne $null ) {$_.Description} Else {"data unavailable"}
            }
    } | format-list
}

function get-proc{
    Write-Output "CPU Information:"
    Write-Output "------------------------"
    Get-WmiObject win32_processor | foreach {
            New-Object -TypeName psobject -Property @{
                'Description' = if( $_.Description  -ne $null ) {$_.Description} Else {"data unavailable"}
                'CurrentClockSpeed' = if( $_.CurrentClockSpeed  -ne $null ) {$_.CurrentClockSpeed} Else {"data unavailable"}
                'NumberOfCores' = if( $_.NumberOfCores  -ne $null ) {$_.NumberOfCores} Else {"data unavailable"}
                'L3CacheSize (MB)' = if( $_.L3CacheSize  -ne $null ) {$_.L3CacheSize/1kb} Else {"data unavailable"}
                'L2CacheSize (MB)' = if( $_.L2CacheSize  -ne $null ) {$_.L2CacheSize/1kb} Else {"data unavailable"}
                'L1CacheSize (MB)' = if( $_.L1CacheSize  -ne $null ) {$_.L1CacheSize/1kb} Else {"data unavailable"}
            }
    } | format-list
}

function get-mem{
    
    Write-Output "RAM Information"
    Write-Output "------------------------"
    $total = 0
    Get-WmiObject -class win32_physicalmemory | foreach {
                New-Object -TypeName psobject -Property @{
                    Vendor = if( $_.manufacturer  -ne $null ) {$_.manufacturer} Else {"data unavailable"}
                    Description =  if( $_.Description  -ne $null ) {$_.Description} Else {"data unavailable"}
                    "Size(MB)" = if( $_.capacity  -ne $null ) {$_.capacity/1mb} Else {"data unavailable"}
                    Bank =  if( $_.Banklabel  -ne $null ) {$_.Banklabel} Else {"data unavailable"}
                    Slot = if( $_.devicelocator  -ne $null ) {$_.devicelocator} Else {"data unavailable"}
            }
        $total += $_.capacity/1mb } | format-list 
    "Total RAM: ${total}MB"
}

function get-disk{
  Write-Output "Disk Information"
  Write-Output "------------------------"
  $diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=if( $logicaldisk.size  -ne $null ) {[String]($logicaldisk.size/1gb -as [int])+"GB"} Else {"data unavailable"}
							       Free= if( $logicaldisk.freespace  -ne $null ) {[string]((($logicaldisk.freespace / $logicaldisk.size) * 100) -as [int])+ "%"} Else {"data unavailable"}
							       FreeSpace = if( $logicaldisk.freespace   -ne $null ) {[string]($logicaldisk.freespace / 1gb -as [int]) +"GB"} Else {"data unavailable"}
                                                               }  | ft
           }
      } 
  }
}

function get-network{
    Write-Output "Network Information"
    Write-Output "------------------------"
    get-ciminstance win32_networkadapterconfiguration | 
	where-object IPEnabled -eq True | 
	foreach {
            New-Object -TypeName psobject -Property @{
                'Description' = if( $_.Description  -ne $null ) {$_.Description} Else {"data unavailable"}
                'Index' = if( $_.Index  -ne $null ) {$_.Index} Else {"data unavailable"}
                'IPAddress' = if( $_.IPAddress  -ne $null ) {$_.IPAddress} Else {"data unavailable"}
                'IPSubnet' = if( $_.IPSubnet  -ne $null ) {$_.IPSubnet} Else {"data unavailable"}
                'DNSDomain' = if( $_.DNSDomain  -ne $null ) {$_.DNSDomain} Else {"data unavailable"}
                'DNSServerSearchOrder' = if( $_.DNSServerSearchOrder  -ne $null ) {$_.DNSServerSearchOrder} Else {"data unavailable"}
            }
    } | ft -Wrap
}


function get-video{
    Write-Output "Video Card Information"
    Write-Output "------------------------"
    gwmi win32_videocontroller | foreach {
            New-Object -TypeName psobject -Property @{
                'Description' = if( $_.Description  -ne $null ) {$_.Description} Else {"data unavailable"}
                'Vendor' = if( $_.Vendor  -ne $null ) {$_.Vendor} Else {"data unavailable"}
                'Screen Resolution' = if( $_.CurrentHorizontalResolution  -ne $null ) {'' + $_.CurrentHorizontalResolution +' X '+ $_.CurrentVerticalResolution} Else {"data unavailable"}}
    } | fl
}

get-os
get-system
get-proc
get-mem
get-disk
get-network
get-video