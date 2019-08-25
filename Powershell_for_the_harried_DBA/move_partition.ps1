import-module sqlps -disablenamechecking;

function calculate-filegroup {
}

$s = get-sqlserver '.';
$db = $s.databases['Optimine_ADS'];

foreach ( $table in $db.Tables | where {$_.IsPartitioned -eq $true} )
    
