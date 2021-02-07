# Problem 1
# Retrieve data to export to tableau to see number of male and femaile employees by year

Use employees_mod;
show tables;

SELECT 
    *
FROM
    t_employees
LIMIT 10;

#query to obtain male and female employee counts by year
SELECT 
    YEAR(d.from_date) AS calendarYear, e.gender, COUNT(d.emp_no)
FROM
    t_dept_emp d
        JOIN
    t_employees e ON d.emp_no = e.emp_no
GROUP BY calendarYear , gender
HAVING calendarYear >= 1990;

#Problem #2
#compare the number of male managers to the number of female managers from different departments each year starting from 1990

select * from t_dept_emp limit 5;
select * from t_dept_manager limit 25;

select m.* from t_dept_manager m;
select year(hire_date) from t_employees;

SELECT 
    m.*, e.calYr, ee.gender, d.dept_name,
    case
		when e.calYr between year(m.from_date) and year(m.to_date) then 1
        else 0
	end as Active
FROM
    (SELECT  distinct
        YEAR(hire_date) as calYr
    FROM
        t_employees) e
        CROSS JOIN
    t_dept_manager m
    join t_employees ee on ee.emp_no = m.emp_no
    join t_departments d on d.dept_no = m.dept_no;
    
    select distinct year(hire_date) from t_employees;
 
# Problem #3 Compare salaries between male and females by department 

SELECT 
    avg(s.salary), e.gender, YEAR(s.from_date) as calYr, dm.dept_name
FROM
    t_salaries s
        JOIN
    t_employees e ON s.emp_no = e.emp_no
        JOIN
    t_dept_emp d ON d.emp_no = e.emp_no
        JOIN
    t_departments dm ON dm.dept_no = d.dept_no
group by calYr, e.gender, dm.dept_name
having calYr <2004;



# Problem #4
#Create an SQL stored procedure that will allow you to obtain the average male and female salary per department within a certain salary range. 
#Let this range be defined by two values the user can insert when calling the procedure.

select ee.emp_no, ee.gender, s.salary, dept.dept_name from t_employees ee
join t_salaries s on s.emp_no = ee.emp_no
join t_dept_emp d on d.emp_no = ee.emp_no
join t_departments dept on dept.dept_no = d.dept_no
where s.salary between 50000 and 90000;

delimiter $$

create procedure getSalMandF(IN lowRange INT, IN highRange INT)
begin

select ee.emp_no, ee.gender, s.salary, dept.dept_name from t_employees ee
join t_salaries s on s.emp_no = ee.emp_no
join t_dept_emp d on d.emp_no = ee.emp_no
join t_departments dept on dept.dept_no = d.dept_no
where s.salary between lowRange and highRange;

end$$

delimiter ;

call getSalMandF(50000, 90000);
