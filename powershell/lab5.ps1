param (
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)
if ( !($System) -and !($Disks) -and !($Network)) {
    get-os
    get-system
    get-proc
    get-mem
    get-disk
    get-network
    get-video
}
if ($System) {
    get-os
    get-system
    get-proc
    get-mem
    get-video
}
if ($Disks) {
    get-disk
}
if ($Network) {
    get-network
}