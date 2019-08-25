import-module sqlps -disablenamechecking;

$s = get-sqlserver '.';
$db = $s.databases['Optimine_ADS'];
$fg = $db.FileGroups['USER_DATA'];

if ($fg -eq $null) {
    $fg = new-object microsoft.sqlserver.management.smo.filegroup $db, 'USER_DATA';
    $fg.create();
}

$logical_template = 'USER_DATA_{0:d2}';
$physical_template = 'G:\Program Files\Microsoft SQL Server\MSSQL10_50.TW_SQLSERV\MSSQL\Data\Staging_ADS\Staging_ADS_USER_DATA_{0:d2}.ndf';
foreach ($i in 1..48) {
    $logical_name = $logical_template -f $i;
    $physical_name =  $physical_template -f $i;
    $f = new-object microsoft.sqlserver.management.smo.datafile $fg, $logical_name, $physical_name
    $f.size = 1gb/1kb
    $f.growth = 512mb/1kb
    $f.growthtype = "KB"
    $f.create()
}

$partition = 96;

$ps.NextUsedFileGroup = 'DATA';
$ps.Alter();

(measure-command { $pf.MergeRangePartition( $partition ); $pf.SplitRangePartition( $partition ) }).TotalSeconds
