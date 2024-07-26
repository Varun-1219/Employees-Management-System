-- Create a Database 
CREATE DATABASE Employee;

-- Use a Database 
USE Employee;

-- Create a table 
CREATE TABLE EmployeeDetails(
EmployeeID INT PRIMARY KEY,
FirstName VARCHAR(50),
LastName VARCHAR(50),
Department VARCHAR(50),
Salary DECIMAL(10,2), 
HireDate DATE) ;

-- Insert values in table
INSERT INTO EmployeeDetails( EmployeeID , FirstName , LastName , Department , Salary , HireDate)
VALUES
(1, 'Kunal','Thakur','HR' , 50000.00 ,'2015-05-20'),
(2, 'Sumit','Puri','IT' , 60000.00 ,'2017-08-15'),
(3, 'Sarthak','Goel','Marketing' , 55000.00 ,'2020-01-10'),
(4, 'baldeesh','Kaur','Finance' , 65000.00 ,'2017-04-25'),
(5, 'Prachi','Sharma','HR' , 52000.00 ,'2017-09-30'),
(6, 'Karunesh','Pathak','IT', 62000.00 ,'2021-11-18'),
(7, 'Ashish','Pratap','Marketing' , 58000.00 ,'2024-02-26'),
(8, 'Darshil','Sidhu','Finance' , 70000.00 ,'2022-07-12'),
(9, 'Majhil','Singh','HR', 53000.00 ,'2023-10-05'),
(10, 'Rohit','Yadav','IT' , 64000.00 ,'2016-03-08');

-- Retrieve all Data from the table
SELECT * FROM EmployeeDetails;

-- Retrieve only the first name and last name of all employees 
SELECT FirstName , LastName FROM EmployeeDetails;

-- Retrieve distinct Departments from employeeDetails table
SELECT DISTINCT Department FROM EmployeeDetails;

-- Retrieve employees whose salary is greater than 55000
SELECT * FROM EmployeeDetails 
WHERE Salary > 55000;

-- Retrieve employees hired after 2019
SELECT * FROM EmployeeDetails 
WHERE HireDate > '2019-12-31' ;

-- Retrieve employees whose first name starts with 'A'
SELECT FirstName FROM EmployeeDetails
WHERE FirstName LIKE 'A%';

-- Retrieve employees who last name ends with 'aur'
SELECT LastName FROM EmployeeDetails
WHERE LastName LIKE '%aur';

-- Retrieve employees whose First name do not have 'a'
SELECT FirstName FROM EmployeeDetails
WHERE FirstName NOT LIKE '%a%';

-- Retrieve employees sorted by their salary in descending order
SELECT * FROM EmployeeDetails
ORDER BY Salary DESC;

-- Retrieve count of employees in each department 
SELECT Department , COUNT(*) FROM EmployeeDetails 
GROUP BY Department;

-- Retrieve the average salary of employees in the Finance department 
SELECT AVG(Salary) AS Average_Salary FROM EmployeeDetails 
WHERE Department = 'Finance';

-- Retrieve the maximum salary among all the employees
SELECT MAX(Salary) AS Maximum_Salary FROM EmployeeDetails;

-- Retrieve the total salary expense for the company
SELECT SUM(Salary) AS Total_Salary_Expense FROM EmployeeDetails;

-- Retrieve the oldest and the newest hire date among all the employees
SELECT MIN(HireDate) AS Oldest_Hire_Date , MAX(HireDate) AS Newest_Hire_Date FROM EmployeeDetails;

-- Retrieve employees with a salary between 50000 and 60000.
SELECT * FROM EmployeeDetails 
WHERE Salary BETWEEN 50000 AND 60000;

-- Retrieve employees who are in the HR department and were hired before 2019.
SELECT * FROM EmployeeDetails 
WHERE Department = 'HR' AND HireDate <'2019-01-01';

-- Retrieve employees with a salary less than the average salary of all employees.
SELECT * FROM EmployeeDetails 
WHERE Salary < (SELECT AVG(Salary) FROM EmployeeDetails);

-- Retrieve the top 3 highest paid employees
SELECT DISTINCT * FROM EmployeeDetails 
ORDER BY Salary DESC
LIMIT 3;

-- Retrieve employees whose hire date is not in 2017
SELECT * FROM EmployeeDetails 
WHERE YEAR(HireDate) <> 2017; 

-- Retrieve the nth highest salary (you can choose the value of n).
SELECT * FROM (
SELECT * , DENSE_RANK() OVER( ORDER BY Salary DESC ) rnk 
FROM EmployeeDetails
) AS SUB
WHERE rnk = 3; -- WE CAN PUT ANY NUMBER TO FIND THE HIGHEST SALARY

-- Retrieve employees who were hired in the same year as ‘Sumit Puri’.
SELECT * FROM EmployeeDetails WHERE YEAR(HireDate) = ( SELECT YEAR(HireDate) FROM EmployeeDetails WHERE FirstName = 'Sumit' AND LastName ='Puri');

-- Retrieve employees who have been hired on weekends (Saturday or Sunday).
SELECT * FROM EmployeeDetails WHERE DAYOFWEEK(HireDate) IN (1,7);

-- Retrieve employees who have been hired in the last 6 years.
SELECT * FROM EmployeeDetails 
WHERE HireDate >= CURDATE() - INTERVAL 6 YEAR;

-- Retrieve the department with the highest average salary.
SELECT Department, AVG(Salary) AS Average_Salary FROM EmployeeDetails
GROUP BY Department
ORDER BY Average_Salary DESC 
LIMIT 1;

-- Retrieve the top 2 highest paid employees in each department.
WITH HIGHEST_SALARY AS (
SELECT * , DENSE_RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) rnk
FROM EmployeeDetails )
SELECT * FROM HIGHEST_SALARY WHERE rnk <= 2;

-- Retrieve the cumulative salary expense for each department sorted by department and hire date.
WITH CTE AS (
SELECT * , SUM(Salary) OVER(PARTITION BY Department ORDER BY HireDate) Cumulative_Salary 
FROM EmployeeDetails )
SELECT * FROM CTE 
ORDER BY Department, HireDate ;

-- Retrieve the employee ID, salary, and the next highest salary for each employee.
SELECT EmployeeID, Salary , LEAD(Salary) OVER(ORDER BY Salary DESC) NEXT_HIGHEST_SALARY
FROM EmployeeDetails 
ORDER BY Salary DESC;

-- Retrieve the employee ID, salary, and the difference between the current salary and the next highest salary for each employee.
SELECT EmployeeID, Salary , 
Salary-LEAD(Salary) OVER(ORDER BY Salary DESC) AS Salary_Difference 
FROM EmployeeDetails;

-- Retrieve the employee(s) with the highest salary in each department.
WITH CTE AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY Department ORDER BY Salary DESC) rnk
FROM EmployeeDetails)
SELECT * FROM CTE 
WHERE rnk = 1;

-- Retrieve the department(s) where the total salary expense is greater than the average total salary expense across all departments.
WITH DEP_TOTAL_SALARY AS (
 SELECT Department , SUM(Salary) as Total_Salary
 FROM EmployeeDetails
 GROUP BY Department
 ),
AVERAGE_TOTAL_SALARY AS (
SELECT AVG(Salary) AS avg_salary_total
FROM DEP_TOTAL_SALARY
)
SELECT Department , Total_Salary 
FROM DEP_TOTAL_SALARY d,
AVERAGE_TOTAL_SALARY a
WHERE d.Total_Salary > a.avg_salary_total;

-- Retrieve the employee(s) who have the same first name and last name as any other employee.
SELECT e1.FirstName , e1.lastName, e1.EmployeeID
FROM EmployeeDetails e1 
JOIN EmployeeDetails e2
ON e1.FirstName = e2.FirstName
AND e1.lastName = e2.lastName
AND e1.EmployeeID != e2.EmployeeID;

-- Retrieve the employee(s) who have been with the company for more then 7 Years.
SELECT * FROM EmployeeDetails 
WHERE HireDate <= DATE_SUB(CURDATE() , INTERVAL 7 YEAR);

-- Retrieve the department with the highest salary range (Difference b/w highest and lowest).
SELECT Department , MAX(Salary) - MIN(Salary) AS DIFFERENCE
FROM EmployeeDetails 
GROUP BY Department 
ORDER BY DIFFERENCE DESC ;


