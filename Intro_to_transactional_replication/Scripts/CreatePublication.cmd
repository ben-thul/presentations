sqlcmd -S virtualbox\publisher -i ConfigureDistribution.sql
sqlcmd -S virtualbox\publisher -d AdventureWorks -i AddPublication.sql
sqlcmd -S virtualbox\publisher -d AdventureWorks -i AddArticles.sql
sqlcmd -S virtualbox\subscriber -Q "create database [AdventureWorks_Snapshot_Subscriber]"
sqlcmd -S virtualbox\subscriber -d AdventureWorks_Snapshot_Subscriber -i ufnLeadingZeros.sql
sqlcmd -S virtualbox\publisher -d AdventureWorks -i AddSubscription_Snapshot.sql
sqlcmd -S virtualbox\publisher -i BackupPublisher.sql
sqlcmd -S virtualbox\subscriber -i RestoreSubscriber_1.sql
sqlcmd -S virtualbox\publisher -d AdventureWorks -i AddSubscription_Backup.sql
