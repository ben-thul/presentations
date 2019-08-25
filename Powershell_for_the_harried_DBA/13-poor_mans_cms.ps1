import-module sqlps -disablenamechecking
foreach ($instance in get-content .\instances.txt) {
    $s = new-object microsoft.sqlserver.management.smo.server $instance;
    $s.databases | select parent, name, recoverymodel;
}
