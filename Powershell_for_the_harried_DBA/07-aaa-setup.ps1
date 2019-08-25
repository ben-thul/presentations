$ErrorActionPreference = 'Stop';
if ( $(get-adminstatus) -eq $false) {
    write-error "This script must be run as administrator."
    return -1;
}
import-module sqlps -disablenamechecking;

$db_name = 'PoSHDemo';
$s = get-sqlserver '.'

$db = $s.Databases[ $db_name ];

if ($db -ne $null) {
    $s.KillDatabase($db_name);
}

$db = new-object microsoft.sqlserver.management.smo.database($s, $db_name);
$db.Create();

$data_directory = (get-item $db.FileGroups['PRIMARY'].Files[0].FileName).DirectoryName;
$file_mask = "$data_directory\${db_name}_{0}.ndf"

foreach ($i in 1..5) {
    $fg = new-object microsoft.sqlserver.management.smo.filegroup $db, "filegroup_$i";
    $fg.create();

    $file_name = $file_mask -f $i;
    $file = new-object microsoft.sqlserver.management.smo.datafile $fg, "file$i", $file_name;
    $file.create()
}

$file_mask = "$data_directory\${db_name}_USER_DATA_{0}.ndf"

$fg = new-object microsoft.sqlserver.management.smo.filegroup $db, "USER_DATA";
$fg.create();
foreach ($i in 1..20) {
    $file_name = $file_mask -f $i;
    $logical_name = "USER_DATA_{0:D2}" -f $i
    $file = new-object microsoft.sqlserver.management.smo.datafile $fg, $logical_name, $file_name;
    $file.create()
}
