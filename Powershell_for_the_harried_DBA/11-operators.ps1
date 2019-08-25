param(
    [string]$serverName,
    [string]$operatorName
)
import-module sqlps -disablenamechecking;

$s = new-object microsoft.sqlserver.management.smo.server '.';
$a = $s.JobServer;

#ensure that the operator exists
if ($a.Operators[$operatorName] -eq $null) {
    $oper = new-object microsoft.sqlserver.management.smo.agent.operator $a, $operatorName;
    $oper.Create();
}

foreach ($job in $a.Jobs) {
    if ($job.OperatorToEmail -eq '') {
        $job.OperatorToEmail = $operatorName;
        $job.EmailLevel = 'OnFailure';
        $job.Alter();
    }
}
