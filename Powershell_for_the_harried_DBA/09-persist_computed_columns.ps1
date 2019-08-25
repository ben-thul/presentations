import-module sqlps -disablenamechecking;
set-strictmode -version latest;
$errorActionPreference = 'Stop';

$s = get-sqlserver '.';
$db = $s.Databases['PoSHDemo'];

foreach ( $tbl in $db.Tables ) {
    foreach ( $col in $tbl.Columns ) {
        if ( $col.Computed -and 
                $col.IsPersisted -eq $false -and 
                $col.IsDeterministic -and 
                $tbl.AnsiNullsStatus -eq $true -and 
                $tbl.IsIndexable -eq $true) {
            $col.IsPersisted = $true;
            $col | select Parent, Name 
            $col.Alter();
        }
    }
}
