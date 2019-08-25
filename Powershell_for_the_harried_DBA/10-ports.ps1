param (
    [string]$server_name = $(Read-Host -prompt Server)
)
$ErrorActionPreference = 'Stop';
if ( $(get-adminstatus) -eq $false) {
    write-error "This script must be run as administrator."
    return -1;
}
$Machine = new-object Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer $server_name

$instance = $Machine.ServerInstances[ 'MSSQLSERVER' ];

$instance.ServerProtocols[ 'Tcp' ].IsEnabled = $true;
$instance.ServerProtocols[ 'Tcp' ].Alter();

$ipAll = $instance.ServerProtocols[ 'Tcp' ].IPAddresses[ 'IPAll' ];
$ipAll.IPAddressProperties[ 'TcpPort' ].Value = "14330";
$ipAll.IPAddressProperties[ 'TcpDynamicPorts' ].Value = ""
$instance.ServerProtocols[ 'Tcp' ].Alter();

$instance.ServerProtocols[ 'Np' ].IsEnabled = $false;
$instance.ServerProtocols[ 'Np' ].Alter();

if ($instance.ServerProtocols[ 'Via' ] -ne $null) {
    $instance.ServerProtocols[ 'Via' ].IsEnabled = $false;
    $instance.ServerProtocols[ 'Via' ].Alter();
}

$services = $Machine.services | where { $_.Type -eq 'SqlServer' }

foreach ( $service in $services ) {
    $StartupParameters = @{};
    foreach ( $parm in $service.StartupParameters.split(';') ) {
        $StartupParameters[ $parm ] = $null;
    }
    $StartupParameters[ '-T1222' ] = $null;
    $StartupParameters[ '-T3226' ] = $null;
    $service.StartupParameters = [string]::join(';', $($StartupParameters.keys));

    $service.Alter();
#$service.Stop();
#while ( $service.ServiceState -ne 'Stopped' ) {
#sleep 3
#}
#$service.Start();
}
