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

-- Retirement requirement
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Title info
SELECT title, from_date, to_date
FROM titles

--Count number of titles 
SELECT COUNT (title)
FROM titles;

-- Most recent titles
CREATE TABLE most_recent_titles AS (
    SELECT emp_no, title, from_date, to_date
    FROM titles
);
SELECT * FROM most_recent_titles;

SELECT COUNT (title)
FROM most_recent_titles;

-- Retirement eligibility
-- SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title, from_date, to_date 
-- INTO retirement_titles
-- FROM employees
-- WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
-- ORDER BY (emp_no)
-- ;

-- Joining most_recent_titles and employees tables
SELECT employees.emp_no,
    employees.first_name,
employees.last_name,
	most_recent_titles.title,
    most_recent_titles.from_date,
	most_recent_titles.to_date
-- INTO retirement_titles
FROM most_recent_titles
LEFT JOIN employees
ON most_recent_titles.emp_no = employees.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (______) _____,
______,
______,
______

INTO nameyourtable
FROM _______
WHERE _______
ORDER BY _____, _____ DESC;
