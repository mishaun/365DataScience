use employees;

drop procedure if exists select_employees;

delimiter $$

create procedure select_employees()
begin
	select * from employees 
    limit 1000;
end$$

delimiter ;

call employees.select_employees();

drop procedure if exists select_empSalary;

delimiter $$

create procedure select_empSalary(IN empId Int)
begin
	select e.emp_no, e.first_name, e.last_name, avg(s.salary)
    from employees e
    join salaries s on s.emp_no = e.emp_no
    where
    e.emp_no = empId
    group by e.emp_no;
end$$

delimiter ;

call select_empSalary(11330);

drop procedure if exists getAvgSalary;

delimiter $$

create procedure getAvgSalary(IN empID INT, OUT avgSal Decimal(10,2))
begin
	select avg(salary) into avgSal
    from salaries
    where 
    emp_no = empID;
    
end$$

delimiter ;

call getAvgSalary(11000);


drop procedure if exists getSalbyName;

delimiter $$

create procedure getSalbyName(IN fname varchar(30), IN lname varchar(30), OUT sal decimal(10,2))
begin
	select avg(s.salary) into sal from employees e
    join salaries s on s.emp_no = e.emp_no
	where e.last_name = lname and e.first_name = fname;
    group by e.emp_no;
end$$

delimiter ;

call getSalbyName("Aruna", "Journel");

SELECT 
    e.emp_no, avg(s.salary)
FROM
    employees e
    
    Join
    
    salaries s on s.emp_no = e.emp_no
    
WHERE
    e.first_name = 'Aruna'
        AND e.last_name = 'Journel'
	group by e.emp_no;
    
