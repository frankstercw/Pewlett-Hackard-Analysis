-- create all relevant tables and import csv files

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
hire_date DATE NOT NULL,
PRIMARY KEY (emp_no)
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

SELECT * FROM retirement_eligible
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

SELECT * FROM retirement_eligible_partitioned
--  need to filter rep table by those still employed 


-- Table 2 mentorship eligible employees

SELECT employed.emp_no,
employed.first_name,
employed.last_name,
ti.title,
ti.from_date,
ti.to_date

INTO mentorship_eligible

FROM employed 
INNER JOIN titles as ti
ON (employed.emp_no = ti.emp_no)
INNER JOIN employees as e
ON (ti.emp_no = e.emp_no)

WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31');

-- SELECT * FROM mentorship_eligible
____________________________
-- remove duplicate data in the mentorship eligible table

SELECT emp_no,
first_name,
last_name,
title,
from_date,
to_date

INTO mentorship_eligible_partitioned

FROM
 (SELECT emp_no,
first_name,
last_name,
title,
from_date,
to_date,
  ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY from_date DESC) rn
 FROM mentorship_eligible
 ) tmp WHERE rn = 1
ORDER BY emp_no

SELECT * FROM mentorship_eligible_partitioned



