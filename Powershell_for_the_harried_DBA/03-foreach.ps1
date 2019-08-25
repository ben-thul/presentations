import-module sqlps -disablenamechecking;

$s = new-object microsoft.sqlserver.management.smo.server '.';
foreach ($db in $s.Databases) {
   $db | select name, recoverymodel, owner;
}
