--creating table and insterting data
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT
);
INSERT INTO employees (employee_id, name, department, salary) VALUES (1, 'Alice', 'HR', 3000);
INSERT INTO employees (employee_id, name, department, salary) VALUES (2, 'Bob', 'HR', 4000);
INSERT INTO employees (employee_id, name, department, salary) VALUES (3, 'Charlie', 'HR', 5000);
INSERT INTO employees (employee_id, name, department, salary) VALUES (4, 'David', 'IT', 6000);
INSERT INTO employees (employee_id, name, department, salary) VALUES (5, 'Eve', 'IT', 7000);
INSERT INTO employees (employee_id, name, department, salary) VALUES (6, 'Frank', 'IT', 8000);
INSERT INTO employees (employee_id, name, department, salary) VALUES (7, 'Grace', 'Finance', 4500);
INSERT INTO employees (employee_id, name, department, salary) VALUES (8, 'Hank', 'Finance', 5500);
INSERT INTO employees (employee_id, name, department, salary) VALUES (9, 'Ivy', 'Finance', 6500);
INSERT INTO employees (employee_id, name, department, salary) VALUES (10, 'Jack', 'Marketing', 3500);
INSERT INTO employees (employee_id, name, department, salary) VALUES (11, 'Kelly', 'Marketing', 4500);
INSERT INTO employees (employee_id, name, department, salary) VALUES (12, 'Leo', 'Marketing', 5500);
INSERT INTO employees (employee_id, name, department, salary) VALUES (13, 'Mary', 'HR', 4500);
INSERT INTO employees (employee_id, name, department, salary) VALUES (14, 'Nadia', 'IT', 5000);
INSERT INTO employees (employee_id, name, department, salary) VALUES (15, 'Ornella', 'Finance', 7500);
INSERT INTO employees (employee_id, name, department, salary) VALUES (16, 'Patty', 'Marketing', 6000);


--TASKS IN THE ASSIGNMENT
--1
--used lag() and lead() and 
--here we are comparing the current salary to prevoius one and display diffrennt info according to the cases we might get

select employee_id,department,salary,
    lag(salary) over (partition by department ORDER BY salary) AS previous_salary,
    lead(salary) over (partition by department ORDER BY salary) AS next_salary,
    CASE
        WHEN salary > LAG(salary) OVER (PARTITION BY department ORDER BY salary) THEN 'HIGHER'
        WHEN salary < LAG(salary) OVER (PARTITION BY department ORDER BY salary) THEN 'LOWER'
        ELSE 'EQUAL'
    end as compare_with_prev
from employees;




--2
--in here we talk about rank and dense rank where the main difference is in how they handle ties where rank skips numbers while 
--dense rank doesnt skip number instead it continues from wehre it left off

select employee_id,department,salary,
    rank() over (partition by department order by salary desc) AS rank_salary,
    dense_rank() over (partition by department order by salary desc) AS dense_rank_salary
from employees;


--3
--identifying top 3 records 
with ranked as (
    select employee_id, name, department, salary,
           rank() over (partition by department order by salary desc) AS rnk
    from employees
)
select * from ranked where rnk <= 3;



--4
-- We assumed employee_id correlates to the date the employee joined the company. The query returns the first 2 employees per department.
WITH earliest_employees AS (
    SELECT 
        employee_id,
        name,
        department,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY employee_id) AS row_num
    FROM employees
)
SELECT * 
FROM earliest_employees 
WHERE row_num <= 2;



--5
-- MAX(salary) OVER (PARTITION BY department) gives department-level maximums.
-- MAX(salary) OVER () gives the global maximum across all employees.
SELECT
    employee_id,
    name,
    department,
    salary,
    MAX(salary) OVER (PARTITION BY department) AS max_salary_in_department,
    MAX(salary) OVER () AS overall_max_salary
FROM employees;

