foreach ($i in 1..40) {
    $col = new-object microsoft.sqlserver.management.smo.column $tbl, "Column$i";
    $col.DataType = [microsoft.sqlserver.management.smo.DataType]::VarChar(300)
    $tbl.Columns.Add( $col );
}
