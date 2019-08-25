import-module sqlps -disablenamechecking;
$s = new-object microsoft.sqlserver.management.smo.server '.';
$db = $s.databases['PoSHDemo'];
$pf = $db.PartitionFunctions['Id_PF_Left'];
$ps = $db.PartitionSchemes['Id_PS_Left'];

$next_boundary = ($pf | select -expandproperty rangevalues)[-1];

foreach ($i in 1..200) {
    $next_boundary++;
    $ps.NextUsedFileGroup = 'USER_DATA';
    $ps.alter();
    $pf.SplitRangePartition( $next_boundary );
}
