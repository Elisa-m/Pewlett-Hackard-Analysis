-- Deliverable 1

-- Creating tables for PH-EmployeeDB
CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

Create Table titles (
	emp_no INT NOT NULL, 
	title VARCHAR(40) NOT NULL,
	from_date DATE NOT NULL, 
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

-- Create retirement_titles table for employees who are born between January 1, 1952 and December 31, 1955.
SELECT employees.emp_no, 
	employees.first_name, 
	employees.last_name, 
	titles.title,
	titles.from_date,
	titles.to_date
INTO retirement_titles
FROM employees
INNER JOIN titles
ON employees.emp_no = titles.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;

-- Check the table
SELECT * FROM retirement_titles;

-- Create a Unique Titles table that contains the employee number, first and last name, and most recent title. 
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title

INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, from_date DESC;

-- Check the table
SELECT * FROM unique_titles;

-- Retrieve the number of employees by their most recent job title who are about to retire.
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC

-- Check the table
SELECT * FROM retiring_titles;

