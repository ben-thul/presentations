import-module sqlps -disablenamechecking;

$s = new-object microsoft.sqlserver.management.smo.server '.';
$db = $s.databases['PoSHDemo'];

foreach ( $table in $db.tables | where {$_.name -like 'tbl*'} ) {
    $new_name = $table.name -replace '^tbl', '';
    $table.rename($new_name);
}
