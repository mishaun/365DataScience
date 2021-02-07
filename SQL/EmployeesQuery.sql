Use employees;

SELECT * FROM employees;
SHOW TABLES;

select * from employees
where first_name in ("Mark", "Cathie");

select * from employees
where first_name like ("Ma%");

SELECT * FROM employees
where first_name Like ("j____")
LIMIT 10;

select * from employees
where hire_date between '1999-1-1' and '2015-1-1';

select * from employees
where last_name is not null
and gender is not null;

select length(first_name) from employees;

select min(hire_date) from employees;

select count(emp_no) from employees;

select hire_date, count(hire_date) as "Countofemps" from employees
group by hire_date
order by COUNT(hire_date) desc;

Select first_name, count(first_name) from employees
where hire_date > '1-1-2000'
group by first_name
having count(first_name) < 200;

select distinct first_name from employees;

select salary, round(salary, 1) from salaries
limit 15;

select d.dept_name, m.dept_no, m.emp_no from
departments d
join dept_manager m on d.dept_no = m.dept_no;

select e.emp_no, e.last_name
from employees e
where e.last_name like ("Markovitch");

select e.emp_no, e.last_name, m.dept_no
from employees e
join dept_manager m 
on e.emp_no = m.emp_no
where e.last_name like ("Markovitch");

select e.emp_no, e.last_name, m.*
from employees e
join dept_manager m 
on e.emp_no = m.emp_no
where e.last_name like ("Markovitch");
   
select e.emp_no, e.last_name, m.*
from employees e
join dept_manager m 
on e.emp_no = m.emp_no
where e.last_name like ("Markovitch") and m.dept_no is not null;

select m.emp_no, m.dept_no, d.dept_name, e.first_name, e.last_name
from dept_manager m
join departments d on m.dept_no = d.dept_no
join employees e on e.emp_no = m.emp_no;

#find avg salary of men and women

Select avg(s.salary), e.gender
from employees e 
join salaries s
on e.emp_no = s.emp_no
group by e.gender;

#how many managers are male/female

SELECT 
    e.gender, COUNT(m.emp_no), AVG(s.salary)
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
        JOIN
    salaries s ON s.emp_no = e.emp_no
GROUP BY e.gender;

select * from employees e
where e.emp_no in 
(select t.emp_no from titles t
where title = "Assistant Engineer");

select title, count(title) as countedTitles from titles
group by title;  

#assign emp 110022 to 10001 and 10020 employees

SELECT 
    e.emp_no,
    (SELECT 
            m.emp_no
        FROM
            dept_manager m
        WHERE
            m.emp_no = 110022) AS managerId
FROM
    employees e
WHERE
    e.emp_no BETWEEN 10001 AND 10020;   

#exercise with unions
DROP TABLE IF EXISTS emp_manager;

CREATE TABLE emp_manager (

  emp_no INT(11) NOT NULL,

  dept_no CHAR(4) NULL,

  manager_no INT(11) NOT NULL

);

#getting data to insert into new table

### Creating query blocks that will be unionized ###

Select A.* from 
(select e.emp_no, min(d.dept_no) as DeptofEmployee,
(select e.emp_no from employees e where e.emp_no = 110022) as ManagerID
from employees e
join dept_emp d on e.emp_no = d.emp_no
where e.emp_no between 10001 and 10200
group by e.emp_no) as A;

select B.*from (select e.emp_no, min(d.dept_no) as DeptofEmplyee,
(select e.emp_no from employees e where e.emp_no = 110039) as ManagerID
from employees e
join dept_emp d on e.emp_no = d.emp_no
where e.emp_no between 10021 and 10040
group by e.emp_no) as B;

Select C.* from 
(select e.emp_no, min(d.dept_no) as DeptofEmployee,
(select e.emp_no from employees e where e.emp_no = 110039) as ManagerID
from employees e
join dept_emp d on e.emp_no = d.emp_no
where e.emp_no = 110022
group by e.emp_no) as C;

Select D.* from 
(select e.emp_no, min(d.dept_no) as DeptofEmployee,
(select e.emp_no from employees e where e.emp_no = 110022) as ManagerID
from employees e
join dept_emp d on e.emp_no = d.emp_no
where e.emp_no = 110039
group by e.emp_no) as D;

########

### Union on code block above ###

SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no,
            MIN(d.dept_no) AS DeptofEmployee,
            (SELECT 
                    e.emp_no
                FROM
                    employees e
                WHERE
                    e.emp_no = 110022) AS ManagerID
    FROM
        employees e
    JOIN dept_emp d ON e.emp_no = d.emp_no
    WHERE
        e.emp_no < 11021
    GROUP BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no,
            MIN(d.dept_no) AS DeptofEmplyee,
            (SELECT 
                    e.emp_no
                FROM
                    employees e
                WHERE
                    e.emp_no = 110039) AS ManagerID
    FROM
        employees e
    JOIN dept_emp d ON e.emp_no = d.emp_no
    WHERE
        e.emp_no > 11020
    GROUP BY e.emp_no
    limit 20) AS B;

#solution code

SELECT 
    u.*
FROM
    (SELECT 
        a.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS a UNION SELECT 
        b.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS b UNION SELECT 
        c.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no) AS c UNION SELECT 
        d.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no) AS d) as u;
    
    #solution insertting into table
    
    INSERT INTO emp_manager
SELECT 
    u.*
FROM
    (SELECT 
        a.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS a UNION SELECT 
        b.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS b UNION SELECT 
        c.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no) AS c UNION SELECT 
        d.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no) AS d) as u;

###Self Join

select * from emp_manager;

SELECT 
    *
FROM
    emp_manager
WHERE
    emp_no IN (SELECT 
            manager_no
        FROM
            emp_manager);

select distinct e1.* 
from emp_manager e1
join emp_manager e2 on e1.emp_no = e2.manager_no;


## Additional Practice

select e.*, s.salary from employees e
join salaries s on e.emp_no = s.emp_no
where year(e.hire_date) between 2000 and 2003;

select birth_date, first_name, 2020 - year(birth_date) as Age from employees limit 10;

select e.first_name, e.last_name, concat(left(e.first_name, 1), ".", left(e.last_name, 1)) as Initials, avg(s.salary) from employees e
join salaries s on s.emp_no = e.emp_no
group by e.first_name, e.last_name;

select distinct first_name, last_name from employees;

