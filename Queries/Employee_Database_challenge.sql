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
SELECT DISTINCT ON (emp_no) 
	emp_no,
	first_name,
	last_name,
	title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- Check the table
SELECT * FROM unique_titles;

-- Retrieve the number of employees by their most recent job title who are about to retire.
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

-- Check the table
SELECT * FROM retiring_titles;


-- Deliverable 2

-- Creating tables for PH-EmployeeDB

CREATE TABLE department_employee (
     emp_no INT NOT NULL, 
	 dept_no VARCHAR(4) NOT NULL, 
	 from_date DATE NOT NULL, 
	 to_date DATE NOT NULL, 
	 FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

-- Create a Mentorship Eligibility table for current employees who were born between 
-- January 1, 1965 and December 31, 1965.
SELECT DISTINCT ON (e.emp_no) 
	e.emp_no,
	e.first_name, 
	e.last_name, 
	e.birth_date,
	de.from_date,
	de.to_date,
	tl.title
INTO mentorship_eligibility
FROM employees as e
	INNER JOIN department_employee as de ON e.emp_no = de.emp_no
	INNER JOIN titles as tl ON e.emp_no = tl.emp_no
WHERE (de.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no; 

-- Retrieve the number of employees by their most recent job title who are eligible for mentorship program
SELECT COUNT(title), title
INTO mentorship_title
FROM mentorship_eligibility
GROUP BY title
ORDER BY count DESC;

-- Combine tables
SELECT rt.title,
	rt.count, 
	me.count
FROM retiring_titles as rt
INNER JOIN mentorship_title as me ON rt.title = me.title;

