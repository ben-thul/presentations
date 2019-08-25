import-module sqlps -disablenamechecking;
$s = get-sqlserver  '.';
$db = $s.databases[ 'PoSHDemo' ];

$drop_options = new-object microsoft.sqlserver.management.smo.scriptingoptions;
$create_options = new-object microsoft.sqlserver.management.smo.scriptingoptions;

$drop_file = 'c:\temp\default_drops.sql';
$create_file = 'c:\temp\default_creates.sql';

foreach ( $file in @($drop_file, $create_file) ) {
    if (test-path $file) {
        remove-item $file;
    }
}

$drop_options.filename = $drop_file;
$drop_options.tofileonly = $true;
$drop_options.scriptdrops = $true;
$drop_options.AppendToFile = $true;

$create_options.filename = $create_file;
$create_options.tofileonly = $true;
$create_options.scriptdrops = $false;
$create_options.AppendToFile = $true;

foreach ( $table in $db.tables ) {
    foreach ( $column in $table.columns ) {
        $df = $column.defaultconstraint
        if ( $df -ne $null -and $df.Text -like '*mygetdate*' ) {
            $df.script( $drop_options );
            $df.script( $create_options );
            $column | select parent, name, defaultConstraint;

        }
    }
}
