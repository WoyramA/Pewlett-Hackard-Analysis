CREATE TABLE departments (
  dept_no VARCHAR(4) NOT NULL,
  dept_name VARCHAR(40) NOT NULL,
  PRIMARY KEY (dept_no),
  UNIQUE (dept_name)
);

SELECT * FROM  departments;

CREATE TABLE employees (
  emp_no INT NOT NULL,
  birth_date DATE NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL,
  gender VARCHAR NOT NULL,
  hire_date DATE NOT NULL,
  PRIMARY KEY (emp_no)
);

SELECT * FROM  employees;

CREATE TABLE dept_manager (
	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

SELECT * FROM dept_manager;

CREATE TABLE dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

SELECT * FROM dept_emp;

CREATE TABLE titles (
	emp_no INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

SELECT * FROM titles;

CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, from_date)
);

SELECT * FROM salaries;

-- Copy code
-- SELECT table_name, 
-- table_schema FROM information_schema.tables WHERE table_schema NOT IN ('pg_catalog', 'information_schema');

-- DELIVERABLE 1

-- 1.Retrieve the emp_no, first_name, and last_name columns from the Employees table.
-- Retirement requirement
SELECT emp_no, first_name, last_name
-- INTO employees_retirement_info
FROM employees 
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT * FROM employees_retirement_info;

-- 2.Retrieve the title, from_date, and to_date columns from the Titles table
-- Titles info
SELECT title, from_date, to_date
INTO titles_info
FROM titles

SELECT * FROM titles_info;

-- 3.Create a new table using the INTO clause.
-- Create new table for retiring_titled_employees
SELECT emp_no, title, from_date, to_date
INTO retirement_titles_info
FROM titles

SELECT * FROM retirement_titles_info;

-- 4.Join both tables on the primary key.
-- Joining titles and employees tables
SELECT employees_retirement_info.emp_no,
    employees_retirement_info.first_name,
employees_retirement_info.last_name,
	retirement_titles_info.title,
  	retirement_titles_info.from_date,
	retirement_titles_info.to_date
INTO retirement_titles
FROM retirement_titles_info
INNER JOIN employees_retirement_info
ON retirement_titles_info.emp_no = employees_retirement_info.emp_no;

-- 5.Filter the data on the birth_date column to retrieve the employees who were born between 1952 and 1955. Then, order by the employee number.
SELECT * FROM retirement_titles;
-- 6.Export the Retirement Titles table from the previous step as retirement_titles.csv and save it to your Data folder in the Pewlett-Hackard-Analysis folder.
-- 8.Copy the query from the Employee_Challenge_starter_code.sql and add it to your Employee_Database_challenge.sql file.

-- 9.Retrieve the employee number, first and last name, and title columns from the Retirement Titles table.
SELECT emp_no, first_name, last_name, title
INTO most_recent_titles
FROM retirement_titles

SELECT * FROM most_recent_titles;

-- 10. Use the DISTINCT ON statement to retrieve the first occurrence of the employee number for each set of rows defined by the ON () clause.
-- 11.Exclude those employees that have already left the company by filtering on to_date to keep only those dates that are equal to '9999-01-01'
-- 12.Create a Unique Titles table using the INTO clause.
-- 13.Sort the Unique Titles table in ascending order by the employee number and descending order by the last date (i.e., to_date) of the most recent title.
-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO unique_titles
FROM retirement_titles
WHERE to_date = '9999-01-01'
ORDER BY emp_no ASC;
-- 14.Export the Unique Titles table as unique_titles.csv and save it to your Data folder in the Pewlett-Hackard-Analysis folder.
SELECT * FROM unique_titles;
-- 16.Write another query in the Employee_Database_challenge.sql file to retrieve the number of employees by their most recent job title who are about to retire.
-- 17.First, retrieve the number of titles from the Unique Titles table.
-- Retiree count by title
SELECT COUNT (title),title
INTO retiring_title
FROM unique_titles
GROUP BY title;

SELECT * FROM retiring_title
-- INTO retiring_titles
ORDER BY count DESC;

SELECT * FROM retiring_titles;

-- DELIVERABLE 2
-- Using the ERD you created in this module as a reference and your knowledge of SQL queries, create a mentorship-eligibility table that holds the current employees who were born between January 1, 1965 and December 31, 1965.
-- In the Employee_Database_challenge.sql file, write a query to create a Mentorship Eligibility table that holds the employees who are eligible to participate in a mentorship program.

-- 1.Retrieve the emp_no, first_name, last_name, and birth_date columns from the Employees table.
-- Mentorship Eligibility
SELECT emp_no, first_name, last_name
INTO employees_mentorship_info
FROM employees 
WHERE birth_date BETWEEN '1965-01-01' AND '1965-12-31';
-- Check Table
SELECT * FROM employees_mentorship_info;

-- 2.Retrieve the from_date and to_date columns from the Department Employee table.
-- Dept_info
SELECT from_date, to_date
INTO dept_info
FROM dept_emp
--Check Table
SELECT * FROM dept_info;

-- 3.Retrieve the title column from the Titles table.
SELECT title
INTO emp_titles
FROM titles
--Check Table
SELECT * FROM emp_titles;

-- 4.Use a DISTINCT ON statement to retrieve the first occurrence of the employee number for each set of rows defined by the ON () clause.
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, birth_date
-- INTO mentorship_emp
FROM employees
WHERE emp_no = '10001';

-- 5.Create a new table using the INTO clause.
SELECT emp_no, first_name, last_name
INTO employees_mentorship_eligibility
FROM employees 
WHERE birth_date BETWEEN '1965-01-01' AND '1965-12-31';

-- 6.Join the Employees and the Department Employee tables on the primary key.
SELECT employees.emp_no,
    employees.first_name,
employees.last_name,
employees.birth_date,
  	dept_emp.from_date,
	dept_emp.to_date
-- INTO employees_dept
FROM employees
LEFT JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no;
--Check Table
SELECT * FROM employees_dept;

-- 7.Join the Employees and the Titles tables on the primary key.
SELECT employees.emp_no,
    employees.first_name,
employees.last_name,
employees.birth_date,
  	titles.from_date,
	titles.to_date,
	titles.title
-- INTO employees_eligibility
FROM employees
LEFT JOIN titles
ON employees.emp_no = titles.emp_no;
--Check Table
SELECT * FROM employees_eligibility;

-- 8.Filter the data on the to_date column to all the current employees, then filter the data on the birth_date columns to get all the employees whose birth dates are between January 1, 1965 and December 31, 1965.
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, birth_date, from_date, to_date, title
-- INTO mentorship_eligibility
FROM employees_eligibility
WHERE birth_date BETWEEN '1965-01-01' AND '1965-12-31' AND to_date = '9999-01-01';
--Check Table
SELECT * FROM mentorship_eligibility;

-- 9.Order the table by the employee number.
-- 10.Export the Mentorship Eligibility table as mentorship_eligibilty.csv and save it to your Data folder in the Pewlett-Hackard-Analysis folder.
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, birth_date, from_date, to_date, title
-- INTO mentorship_eligibility
FROM employees_eligibility
WHERE birth_date BETWEEN '1965-01-01' AND '1965-12-31' AND to_date = '9999-01-01'
ORDER BY emp_no;
--Check Table
SELECT * FROM mentorship_eligibility;






-- Retirement eligibility
SELECT DISTINCT ON (birth_date) emp_no, first_name, last_name, title, from_date, to_date 
-- INTO retirement_titles
FROM retirement_titles
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no DESC
;

-- Retirement eligibility