create DATABASE IF NOT exists absence;

use absence;

CREATE TABLE If Not Exists absentRecords(
	transExpense int not null,
    distance int not null,
    age int not null,
    dailyWork int not null,
    bodyMass int not null,
    education bit not null,
    children int not null,
    pets int not null,
    day_ofwk int not null,
    month_num int not null,
    reasonAbs1 bit not null,
    reasonAbs2 bit not null,
    reasonAbs3 bit not null,
    reasonAbs4 bit not null,
    excessivelyAbs bit not null,
    prob float not null);

Select * from absentRecords;

select * from absentRecords limit 20;

select age, prob from absentRecords
where prob < 0.5;

SELECT 
    age, avg(prob)
FROM
    absentRecords
WHERE
    prob < .5
GROUP BY age;

SELECT 
    *
FROM
    absentRecords;