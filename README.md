# Brain_INTO_Commit
A pair work project on Windows Function in DB Development with PL/SQL

# Question 1: Salary Comparison Using Window Functions

## QUERY

```sql
SELECT employee_id, department, salary,
    LAG(salary) OVER (PARTITION BY department ORDER BY salary) AS previous_salary,
    LEAD(salary) OVER (PARTITION BY department ORDER BY salary) AS next_salary,
    CASE
        WHEN salary > LAG(salary) OVER (PARTITION BY department ORDER BY salary) THEN 'HIGHER'
        WHEN salary < LAG(salary) OVER (PARTITION BY department ORDER BY salary) THEN 'LOWER'
        ELSE 'EQUAL'
    END AS compare_with_prev
FROM employees;
```
## EXPLANATION

Compare Values with Previous or Next Records

In here the query is using the LAG function to get the previous salary of an employee and comparing it to the salary of the current employee,
while the LEAD function just helps us get the salary of the next employee, and we can do operations on it like the ones we did on the LAG function.
![compare values with previous record](https://github.com/user-attachments/assets/52b831ea-a8e3-455c-be70-508d835a6568)

## USE IN REAL WORLD

This type of query can be used in banks when checking loan payment patterns of a customer before being given another loan.



# Question 2: Ranking Data within a Category

## QUERY

```sql
select employee_id,department,salary,
    rank() over (partition by department order by salary desc) AS rank_salary,
    dense_rank() over (partition by department order by salary desc) AS dense_rank_salary
from employees;
```
## EXPLANATION

Ranking Data within a Category

In here the RANK function works in a way that when there is a tie between two sets of data, both the data recieve the same rank and it skips the next rank and goes to the one after that as seen below,
while the DENSE_RANK is almost similar to the RANK function but the only difference is that the dense_rank even in the case of tie it will give the data same rank but it will not skip the next rank as in the rank function
![rank and dense rank](https://github.com/user-attachments/assets/1716839f-198c-4cc4-a4c4-cb8cf23744c3)

## USE IN REAL WORLD

This type of query can be used in organizations when ranking employees based on a certain perfomance whether sales or otherwise



# Question 3: Identifying Top Records

## QUERY

```sql
with ranked as (
    select employee_id, name, department, salary,
           rank() over (partition by department order by salary desc) AS rnk
    from employees
)
select * from ranked where rnk <= 3;
```
## EXPLANATION

 Identifying Top Records

In here we created a common table expression named ranked and from their we used the RANK() window function to get the ranks of all the members in their respective departments and outside of the CTE we gave a small condition of returning just the top 3 performers from these departments
![top 3 earners in each department](https://github.com/user-attachments/assets/02518bb6-2419-4d1b-87ac-b129fcb53566)


## USE IN REAL WORLD

This type of query can be used in organizations such as sports organizations to see the top earners in your sport organization or any organization

### NOTE: In the results below 4 records were added to enhance the results. 
<img width="566" alt="insert4" src="https://github.com/user-attachments/assets/8141410f-cce5-4d14-b2be-592d3c7d0e99" />



# Question 4: Finding the Earliest Records

## QUERY

```sql
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
```
## EXPLANATION

Finding the earliest records

By sorting each department by employee_id, we can retrieve the first two entries per department, representing the earliest joiners. This is useful for understanding team formation history or seniority.
<img width="780" alt="question4" src="https://github.com/user-attachments/assets/ac58cbac-dba6-4bb8-a70b-7830c5435bf0" />

## USE IN REAL WORLD

First Joiners: An HR tool could list the first 2 employees who joined each department, useful for identifying departmental pioneers or creating anniversary awards.
It also applies to first customers per region, or first product purchases per user in e-commerce.



# Question 5: Aggregation with Window Functions

## QUERY

```sql
with ranked as (
    select employee_id, name, department, salary,
           rank() over (partition by department order by salary desc) AS rnk
    from employees
)
select * from ranked where rnk <= 3;
```
## EXPLANATION

 Aggregation with Window Functions

We use MAX() with PARTITION BY to find the highest salary within each department, and without PARTITION BY to find the company-wide highest salary. Unlike GROUP BY, this retains all records and allows comparisons directly in the result set.
<img width="775" alt="qtn5" src="https://github.com/user-attachments/assets/35d8f1c6-0548-409c-9984-09f833eb40ca" />

## USE IN REAL WORLD

Salary Benchmarking: A finance report could show each employee’s salary, along with the highest salary in their department and across the entire company.
Also helps in assessing how competitive an individual's salary is within their team and globally.
