use [PoSHDemo];

create partition function [ID_PF_Left] (int)
	as range left
	for values (1, 2, 3, 4);
create partition scheme [ID_PS_Left]
	as partition [ID_PF_Left]
	to ([filegroup_1], [filegroup_2], [filegroup_3], [filegroup_4], [filegroup_5]);

create table dbo.PartitionedTable (
	ID int not null,
	Value varchar(20) null
);

create clustered index [CIX_PartitionedTable]
	on dbo.PartitionedTable (ID)
	on [ID_PS_Left](ID);

insert into PartitionedTable (ID, Value)
select ntile(4) over (order by Number), 'test data'
from dbadmin.dbo.Numbers
where Number <= 100;

select *, $partition.ID_PF_Left(ID) as [partition]
from dbo.PartitionedTable;
