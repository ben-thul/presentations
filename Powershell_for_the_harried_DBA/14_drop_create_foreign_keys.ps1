import-module sqlps -disablenamechecking

$drop_filename = 'c:\temp\fk_drop.sql';
$create_filename = 'c:\temp\fk_create.sql';

if (test-path $drop_filename) {
    remove-item $drop_filename;
}
if (test-path $create_filename) {
    remove-item $create_filename;
}

$drop_options = new-object microsoft.sqlserver.management.smo.scriptingoptions
$drop_options.ToFileOnly = $true;
$drop_options.FileName = $drop_filename;
$drop_options.AppendToFile = $true;

$drop_options.ScriptDrops = $true;
$create_options = new-object microsoft.sqlserver.management.smo.scriptingoptions
$create_options.ToFileOnly = $true;
$create_options.FileName = $create_filename;
$create_options.AppendToFile = $true;

$s = new-object microsoft.sqlserver.management.smo.server '.';
$db = $s.databases['AdventureWorks2014'];

foreach ($table in $db.Tables) {
    foreach ($fk in $table.ForeignKeys) {
        $fk.script( $create_options );
        $fk.script( $drop_options );
    }
}
