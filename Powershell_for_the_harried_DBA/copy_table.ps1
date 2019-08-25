[cmdletbinding()]
param(
    [string]$server,
    [string]$database,
    [string]$schema,
    [string]$table,
    [string]$new_schema,
    [string]$new_table,
    [string]$filegroup
)
import-module sqlps -disablenamechecking;
$s = new-object microsoft.sqlserver.management.smo.server $server;
$db = $s.databases[$database];
$tbl = $db.Tables | where {$_.schema -eq $schema -and $_.name -eq $table};

$myTbl = new-object microsoft.sqlserver.management.smo.Table $db, $new_table, $new_schema;
foreach ($col in $tbl.Columns) {
    $newCol = new-object microsoft.sqlserver.management.smo.column $myTbl, $col.Name
    $newCol.DataType = $col.DataType
    $newCol.Nullable = $col.Nullable;
    $myTbl.Columns.Add( $newCol );
}

$myTbl.Create();

foreach ($index in $tbl.Indexes) {
    $g = [guid]::NewGuid();
    $newIdx = new-object microsoft.sqlserver.management.smo.Index $myTbl, ($index.Name + "-$g");
    $newIdx.IsUnique = $index.IsUnique;
    $newIdx.IsClustered = $index.IsClustered;
    $newIdx.IndexKeyType = $index.IndexKeyType; #primary key, unique key, none
    if ($filegroup -eq $null) {
        $newIdx.Filegroup = $index.Filegroup;
    }
    else {
        $newIdx.Filegroup = $filegroup;
    }
    foreach ($col in $index.IndexedColumns) {
        $newCol = new-object microsoft.sqlserver.management.smo.IndexedColumn $newIdx, $col.Name;
        $newCol.Descending = $col.Descending;
        $newCol.IsIncluded = $newCol.IsIncluded;
        $newIdx.IndexedColumns.Add( $newCol );
    }
    $myTbl.Indexes.Add( $newIdx );
    $newIdx.Create();
}

foreach ($fk in $tbl.ForeignKeys) {
    $g = [guid]::NewGuid();
    $new_fk = new-object microsoft.sqlserver.management.smo.foreignkey $mytbl, ($fk.Name + "-$g");
    $new_fk.ReferencedTableSchema = $fk.ReferencedTableSchema;
    $new_fk.ReferencedTable = $fk.ReferencedTable;
    $new_fk.IsChecked = $fk.IsChecked;
    foreach ($col in $fk.Columns) {
        $newCol = new-object microsoft.sqlserver.management.smo.ForeignKeyColumn $new_fk, $col.Name;
        $newCol.ReferencedColumn = $col.ReferencedColumn;
        $new_fk.Columns.Add( $newCol );
    }
    $myTbl.ForeignKeys.Add( $new_fk );
    $new_Fk.Create();
}
#switch partition into new table

#move table and all indexes to new filegroup
foreach ($index in $myTbl.Indexes) {
    if ($index.IndexKeyType -eq 'DriPrimaryKey') {
        $newIdx = new-object microsoft.sqlserver.management.smo.Index $myTbl, ($index.Name + "-$g");
        $newIdx.IsUnique = $index.IsUnique;
        $newIdx.IsClustered = $index.IsClustered;
        $newIdx.IndexKeyType = $index.IndexKeyType; #primary key, unique key, none
        $newIdx.FileGroup = 'USER_DATA';
        foreach ($col in $index.IndexedColumns) {
            $newCol = new-object microsoft.sqlserver.management.smo.IndexedColumn $newIdx, $col.Name;
            $newCol.Descending = $col.Descending;
            $newCol.IsIncluded = $newCol.IsIncluded;
            $newIdx.IndexedColumns.Add( $newCol );
        }
        $index.Drop();
        $myTbl.Indexes.Add( $newIdx );
        $newIdx.Create();

    }   
    else {
        $index.DropAndMove('USER_DATA');
    }
}
#add check constraint before switch in

#switch table back into original partitioned table
