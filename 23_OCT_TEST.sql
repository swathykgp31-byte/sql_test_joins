CREATE DATABASE company_str;
USE company_str;
CREATE TABLE Departments(dept_id INT PRIMARY KEY, dept_name VARCHAR(30), location VARCHAR(30));
INSERT INTO Departments (dept_id, dept_name, location)
VALUES
(1, 'IT', 'Chennai'),
(2, 'HR', 'Bangalore'),
(3, 'Sales', 'Mumbai'),
(4, 'Finance', 'Delhi');

CREATE TABLE Employees (emp_id INT PRIMARY KEY, name VARCHAR(30), salary DECIMAL(10,2), dept_id INT, manager_id INT, hire_date DATE);
INSERT INTO Employees VALUES
(1, 'Karthik', 62000, 1, NULL, '2020-01-10'),
(2, 'Arun', 55000, 1, 1, '2022-03-15'),
(3, 'Sneha', 50000, 1, 1, '2023-01-09'),
(4, 'Divya', 48000, 2, NULL, '2021-07-01'),
(5, 'Anita', 45000, 2, 4, '2022-08-22'),
(6, 'Ravi', 52000, 3, NULL, '2022-11-05'),
(7, 'Meena', 40000, 3, 6, '2023-05-20'),
(8, 'Vijay', 52000, 3, 6, '2021-02-14'),
(9, 'Kiran', 35000, NULL, NULL, '2024-01-15');

CREATE TABLE Sales (sale_id INT PRIMARY KEY, emp_id INT, sale_date DATE, amount DECIMAL(10,2));
INSERT INTO Sales VALUES
(1, 6, '2024-01-05', 20000),
(2, 6, '2024-01-20', 15000),
(3, 7, '2024-01-12', 10000),
(4, 8, '2024-01-18', 25000),
(5, 7, '2024-02-03', 12000),
(6, 8, '2024-02-10', 18000);
INSERT INTO Sales (sale_id, emp_id, sale_date, amount)
VALUES
(7, 6, '2024-02-15', 30000),
(8, 8, '2024-03-01', 22000);

SELECT DATABASE();
SHOW TABLES;
SELECT * FROM Departments; 
SELECT * FROM Employees; 
SELECT * FROM Sales; 

-- QUESTION: 1
SELECT e.name AS employee_name, d.dept_name AS department_name
FROM Employees e
INNER JOIN Departments d ON e.dept_id = d.dept_id;

-- QUESTION: 2
SELECT e.name AS employee_name, d.dept_name AS department_name
FROM Employees e
LEFT JOIN Departments d ON e.dept_id = d.dept_id;

-- QUES: 3
SELECT e.name AS employee_name, d.dept_name AS department_name
FROM Employees e
RIGHT JOIN Departments d ON e.dept_id = d.dept_id;

-- QUES: 4
SELECT e.name AS employee_name, d.dept_name AS department_name
FROM Employees e
LEFT JOIN Departments d ON e.dept_id = d.dept_id
UNION
SELECT e.name AS employee_name, d.dept_name AS department_name
FROM Employees e
RIGHT JOIN Departments d ON e.dept_id = d.dept_id;

-- QUES: 5
SELECT d.dept_id, d.dept_name
FROM Departments d
LEFT JOIN Employees e ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL;

-- QUES: 6
SELECT e.name AS employee_name, m.name AS manager_name
FROM Employees e
JOIN Employees m ON e.manager_id = m.emp_id;

-- QUES: 7
SELECT e.name AS employee_name,
COALESCE(m.name, 'No Manager') AS manager_name
FROM Employees e
LEFT JOIN Employees m
ON e.manager_id = m.emp_id;

-- QUES: 8
SELECT d.dept_name, e.name AS Employee_name
FROM Departments d
CROSS JOIN Employees e;

-- QUES: 9
SELECT d.dept_name, COUNT(e.emp_id) AS total_employees
FROM Departments d
LEFT JOIN Employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

-- QUES: 10
SELECT e.name AS employee_name, d.dept_id AS department_name,
SUM(e.emp_id * amount) AS total_sales
FROM Employees e
JOIN Departments d ON d.dept_id = e.dept_id
JOIN sales s ON e.emp_id = s.emp_id
GROUP BY e.emp_id, e.name, d.dept_name;

-- QUES: 11
SELECT name AS employee_name, salary
FROM Employees
WHERE salary > (SELECT AVG(salary)
FROM Employees);

-- QUES: 12
SELECT emp_id, name, salary
FROM Employees
WHERE salary = (SELECT MAX(salary) 
FROM Employees);

-- QUES: 13
SELECT MAX(salary) AS second_highest_salary
FROM Employees
WHERE salary < (SELECT MAX(salary)
FROM Employees);

-- QUES: 14
SELECT name 
FROM Employees
WHERE dept_id IN(SELECT dept_id
FROM Departments 
WHERE location IN ('chennai'));

-- QUES: 15
SELECT dept_id, dept_name
FROM Departments
WHERE dept_id NOT IN(SELECT dept_id
FROM Employees
WHERE dept_id IS NOT NULL);

-- QUES: 16
SELECT e.emp_id, e.name, e.salary, e.dept_id
FROM Employees e
WHERE e.salary > (SELECT AVG(e2.salary)
FROM Employees e2
WHERE e.dept_id = e2.dept_id); 

-- QUES: 17
SELECT d.dept_id, d.dept_name
FROM Departments d
WHERE EXISTS(SELECT 1
FROM Employees e
WHERE e.dept_id = d.dept_id);

-- ques: 18
SELECT MAX(dept_total_salary) AS Highest_salary
FROM (SELECT dept_id, SUM(salary) AS dept_total_salary
FROM Employees
GROUP BY dept_id) AS dept_salary;

-- ques: 19
SELECT name, salary,
ROUND(salary - (SELECT AVG(salary) FROM Employees), 2)
AS salary_difference
FROM Employees;

-- ques: 20
WITH high_paid AS(SELECT * FROM Employees
WHERE salary > 50000)
SELECT * FROM high_paid;

-- ques: 21
WITH dept_avg AS(SELECT dept_id, AVG(salary) AS avg_salary
FROM Employees
GROUP BY dept_id)
SELECT e.name, d.dept_name, e.salary, da.avg_salary AS department_average
FROM Employees e
JOIN Departments d ON d.dept_id = e.dept_id
JOIN dept_avg da ON e.dept_id = da.dept_id;

-- ques: 22
WITH dept_total AS(SELECT dept_id, SUM(salary) AS total_salary
FROM Employees
GROUP BY dept_id),
company_total AS(SELECT SUM(salary) AS company_salary
FROM Employees)
SELECT d.dept_name, dt.total_salary, (dt.total_salary / ct.company_salary) * 100 AS salary_percent
FROM dept_total dt 
JOIN Departments d ON dt.dept_id = d.dept_id
CROSS JOIN company_total ct;

-- ques: 23
WITH employee_sales AS (SELECT emp_id, SUM(amount) AS total_sales
FROM Sales
GROUP BY emp_id)
SELECT e.name, es.total_sales
FROM employee_sales es
JOIN Employees e
ON e.emp_id = es.emp_id
WHERE es.total_sales > (
SELECT AVG(total_sales)
FROM employee_sales);

-- ques: 24
WITH RECURSIVE numbers (num) AS (
SELECT 1
UNION ALL
SELECT num + 1
FROM numbers
WHERE num < 5)
SELECT num
FROM numbers;
   
-- ques: 25
WITH RECURSIVE emp_hierarchy AS 
(SELECT emp_id, name, manager_id,
1 AS level
FROM employees
WHERE manager_id IS NULL
UNION ALL
SELECT e.emp_id, e.name, e.manager_id, h.level + 1
FROM employees e
JOIN emp_hierarchy h
ON e.manager_id = h.emp_id)
SELECT * FROM emp_hierarchy;   

-- ques: 26
-- CTE makes SQL queries easy to read and write. NO. CTE exists only for temporary sql statement.

-- ques: 27
SELECT emp_id, name, salary,
ROW_NUMBER() OVER (
ORDER BY salary DESC, emp_id ASC) AS row_num
FROM Employees;

-- ques: 28
SELECT emp_id, name, salary,
RANK() OVER (ORDER BY salary DESC) AS salary_rank,
DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_salary_rank
FROM Employees;

-- ques: 29
WITH employees_rank AS ( SELECT emp_id, name, salary, dept_id, 
RANK() OVER ( PARTITION BY dept_id
ORDER BY salary DESC) AS salary_rank
FROM Employees)
SELECT emp_id, name, salary, dept_id 
FROM employees_rank
WHERE salary_rank = 1;

-- ques: 30
SELECT emp_id, name, salary, 
NTILE(3) OVER 
(ORDER BY salary DESC, emp_id ASC)
AS salary_group
FROM Employees;

-- ques: 31
SELECT sale_id, emp_id, sale_date, amount, LAG(amount) OVER
( PARTITION BY emp_id 
ORDER BY sale_date, sale_id)
AS previous_sale_amount
FROM sales;

-- ques: 32
SELECT sale_id, emp_id, sale_date, amount, LEAD(amount) OVER
( PARTITION BY emp_id 
ORDER BY sale_date, sale_id)
AS new_sale_amount
FROM sales;

-- ques: 33
SELECT emp_id, name, salary, dept_id,
FIRST_VALUE(salary) OVER 
( PARTITION BY dept_id
ORDER BY salary DESC, emp_id ASC)
AS top_salary
FROM Employees;

-- ques: 34
SELECT sale_id, emp_id, sale_date, amount,
SUM(amount) OVER 
(ORDER BY sale_date, sale_id
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM Sales;

-- ques: 35
SELECT sale_id, emp_id, sale_date, amount,
SUM(amount) OVER 
(PARTITION BY emp_id
ORDER BY sale_date, sale_id
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM Sales;

-- ques: 36
SELECT sale_id, emp_id, sale_date, amount,
ROUND( AVG(amount) OVER(
ORDER BY sale_date, sale_id
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS moving_average
FROM Sales;

-- ques: 37
SELECT emp_id, dept_id, name, salary, 
ROUND( salary * 100 / SUM(salary) OVER
(PARTITION BY dept_id), 2) AS salary_percent
FROM Employees;

-- ques: 38
SELECT name, salary,
ROW_NUMBER() OVER (ORDER BY salary DESC, emp_id) AS 'row',
RANK() OVER (ORDER BY salary DESC) AS 'rank',
DENSE_RANK() OVER ( ORDER BY salary DESC) AS 'dense'
FROM employees;

