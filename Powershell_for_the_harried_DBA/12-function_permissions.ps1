import-module sqlps -disablenamechecking;

$perms = new-object Microsoft.SqlServer.Management.Smo.ObjectPermissionSet;
$perms.Select = $true;

$srv = new-object microsoft.sqlserver.management.smo.server '.'
$db = $srv.databases['PoSHDemo'];
foreach ($f in $db.UserDefinedFunctions |
        where {
            $_.IsSystemObject -eq $false -and
            $_.FunctionType -ne 'scalar'
        }) {
    $f.grant($perms, 'fn_user')
}
