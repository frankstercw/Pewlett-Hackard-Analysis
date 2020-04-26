CREATE TABLE departments (
dept_no VARCHAR(4) NOT NULL,
dept_name VARCHAR(40) NOT NULL,
PRIMARY KEY (dept_no),
UNIQUE (dept_name)
);

CREATE TABLE employees (
emp_no INT NOT NULL,
birth_date DATE NOT NULL,
first_name VARCHAR NOT NULL,
last_name VARCHAR NOT NULL,
gender VARCHAR NOT NULL,
hire_date DATE NOT NULL
);

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
emp_no INT NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
 	PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
emp_no INT NOT NULL,
salary INT NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
PRIMARY KEY (emp_no)
);

SELECT * FROM salaries
CREATE TABLE titles (
emp_no INT NOT NULL,
title VARCHAR NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL
);

CREATE TABLE dept_emp (
emp_no INT NOT NULL,
dept_no VARCHAR NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL
);

-- SELECT * FROM titles;

-- SELECT first_name, last_name
-- FROM employees
-- WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
-- AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- SELECT first_name, last_name
-- FROM employees
-- WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

-- SELECT COUNT(first_name)
-- FROM employees
-- WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
-- AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- SELECT first_name, last_name
-- INTO retirement_info
-- FROM employees
-- WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
-- AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- SELECT * FROM retirement_info;

-- SELECT emp_no, first_name, last_name
-- INTO retirement_info
-- FROM employees
-- WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
-- AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- -- Check the table
-- SELECT * FROM retirement_info;

-- SELECT retirement_info.emp_no,
-- 	retirement_info.first_name,
-- retirement_info.last_name,
-- 	dept_emp.to_date
	
-- 	FROM retirement_info
	
-- 	LEFT JOIN dept_emp
	
-- 	ON retirement_info.emp_no = dept_emp.emp_no;

-- SELECT ri.emp_no,
-- 	ri.first_name,
-- ri.last_name,
-- 	de.to_date 
-- FROM retirement_info as ri
-- LEFT JOIN dept_emp as de
-- ON ri.emp_no = de.emp_no;

-- SELECT ri.emp_no,
-- 	ri.first_name,
-- 	ri.last_name,
-- de.to_date

-- INTO current_emp

-- FROM retirement_info as ri
-- LEFT JOIN dept_emp as de
-- ON ri.emp_no = de.emp_no
-- WHERE de.to_date = ('9999-01-01');

-- SELECT * FROM current_emp;

-- SELECT COUNT(ce.emp_no), de.dept_no

-- INTO retirees_by_department

-- FROM current_emp as ce
-- LEFT JOIN dept_emp as de
-- ON ce.emp_no = de.emp_no
-- GROUP BY de.dept_no
-- ORDER BY de.dept_no;

-- SELECT * FROM salaries
-- ORDER BY to_date DESC;

-- SELECT emp_no, first_name, last_name, gender
-- INTO emp_info
-- FROM employees
-- WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
-- AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- SELECT e.emp_no,
-- 	e.first_name,
-- e.last_name,
-- 	e.gender,
-- 	s.salary,
-- 	de.to_date
	
-- INTO emp_info
-- FROM employees as e
-- INNER JOIN salaries as s
-- ON (e.emp_no = s.emp_no)
-- INNER JOIN dept_emp as de
-- ON (e.emp_no = de.emp_no)

-- WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
--      AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
-- 	 AND (de.to_date = '9999-01-01');


-- SELECT  dm.dept_no,
--         d.dept_name,
--         dm.emp_no,
--         ce.last_name,
--         ce.first_name,
--         dm.from_date,
--         dm.to_date
-- -- INTO manager_info
-- FROM dept_manager AS dm
--     INNER JOIN departments AS d
--         ON (dm.dept_no = d.dept_no)
--     INNER JOIN current_emp AS ce
--         ON (dm.emp_no = ce.emp_no);

-- SELECT ce.emp_no,
-- ce.first_name,
-- ce.last_name,
-- d.dept_name	

-- FROM current_emp as ce
-- INNER JOIN dept_emp AS de
-- ON (ce.emp_no = de.emp_no)
-- INNER JOIN departments AS d
-- ON (de.dept_no = d.dept_no);

-- ________________ Module 7 Submission 

CREATE TABLE employees (
	     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL
);

CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  dept_no VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL
);
-- table to identify all current employees

SELECT de.emp_no,
	e.first_name,
	e.last_name,
    de.to_date

INTO employed

FROM dept_emp as de
LEFT JOIN employees as e
ON de.emp_no = e.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * FROM employed

___________________________
-- table to identify all current employees within retirement range 

SELECT employed.emp_no, 
employed.first_name, 
employed.last_name, 
ti.title, 
ti.from_date, 
sal.salary

INTO retirement_eligible

FROM employed
INNER JOIN titles as ti
ON (employed.emp_no = ti.emp_no)
INNER JOIN salaries as sal
ON (employed.emp_no = sal.emp_no)
INNER JOIN employees as e
ON (employed.emp_no = e.emp_no)

WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- SELECT * FROM retirement_eligible
________________________
-- second table to partition duplicate data 

SELECT emp_no,
first_name,
last_name,
title,
from_date,
salary

INTO retirement_eligible_partitioned

FROM
 (SELECT emp_no,
 first_name,
last_name,
title,
from_date,
salary, 
  ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY from_date DESC) rn
 FROM retirement_eligible
 ) tmp WHERE rn = 1
ORDER BY emp_no

SELECT * FROM retirement_eligible_partitioned
____________________________

-- third table to gather the number of vacancies by title

SELECT rep.title, COUNT(*)

INTO retirements_by_title 

FROM retirement_eligible_partitioned as rep
GROUP BY rep.title

SELECT * FROM retirements_by_title
______________ 

-- Table 2  

SELECT employed.emp_no,
employed.first_name,
employed.last_name,
ti.title,
ti.from_date,
employed.to_date


INTO mentorship_eligible

FROM employed 
INNER JOIN titles as ti
ON (employed.emp_no = ti.emp_no)
INNER JOIN employees as e
ON (employed.emp_no = e.emp_no)

WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31');

SELECT * FROM mentorship_eligible
____________

SELECT * FROM retirements_by_title
SELECT * FROM retirement_eligible