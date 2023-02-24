------------------------- Table Schemata / Data Engineering --------------------------------------

CREATE TABLE titles(
 title_id VARCHAR(10) PRIMARY KEY NOT NULL,
 title VARCHAR(100) NOT NULL	
);

SELECT * FROM titles;

CREATE TABLE employees(
 emp_no INT PRIMARY KEY NOT NULL,
    emp_title VARCHAR(100) NOT NULL,
    FOREIGN KEY (emp_title) REFERENCES titles(title_id),
    birth_date DATE NOT NULL,
    first_name VARCHAR (100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
	sex VARCHAR NOT NULL,
	hire_date DATE NOT NULL
);

SELECT * FROM employees;

CREATE TABLE departments(
 dept_no VARCHAR(10) PRIMARY KEY NOT NULL,
	dept_name VARCHAR(100) NOT NULL
);

SELECT * FROM departments;

CREATE TABLE dept_manager(
 dept_no VARCHAR(10) NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	emp_no INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

SELECT * FROM dept_manager;

CREATE TABLE dept_emp(
	emp_no INT NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	dept_no VARCHAR(10) NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

SELECT * FROM dept_emp;

CREATE TABLE salaries(
	emp_no INT NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	salary INT NOT NULL
);

SELECT * FROM salaries;


-------------------Queries / Data Analysis -----------------------------------

-- Listing the employee number, last name, first name, sex, and salary of each employee.
CREATE VIEW salaries_by_names AS
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees AS e
INNER JOIN salaries AS s ON e.emp_no = s.emp_no; 

-- Listing the first name, last name, and hire date for the employees who were hired in 1986.
CREATE VIEW employees_hired_in_1986 AS
SELECT e.first_name, e.last_name, e.hire_date
FROM employees AS e
WHERE DATE_PART('year', e.hire_date) = 1986;

-- Listing the manager of each department along with their department number, department name, 
-- employee number, last name, and first name.
CREATE VIEW dept_manager_names AS
SELECT dm.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
FROM dept_manager AS dm
LEFT JOIN departments AS d ON dm.dept_no = d.dept_no
LEFT JOIN employees AS e ON dm.emp_no = e.emp_no;

-- List the department number for each employee along with that employee’s employee number, 
-- last name, first name, and department name.
CREATE VIEW employee_names_by_dept AS
SELECT de.dept_no, de.emp_no, e.last_name, e.first_name, d.dept_name
FROM dept_emp AS de 
INNER JOIN employees AS e ON de.emp_no = e.emp_no
INNER JOIN departments AS d ON de.dept_no = d.dept_no;

-- List first name, last name, and sex of each employee whose first name is Hercules 
-- and whose last name begins with the letter B.
CREATE VIEW Hercules_B_employees AS
SELECT e.first_name, e.last_name, e.sex
FROM employees AS e
WHERE e.first_name = 'Hercules' AND e.last_name LIKE 'B%';

-- List each employee in the Sales department, including their employee number, last name, and first name.
CREATE VIEW sales_employees AS
SELECT d.dept_name, de.emp_no, e.last_name, e.first_name
FROM departments AS d
INNER JOIN dept_emp AS de ON d.dept_no = de.dept_no
INNER JOIN employees AS e ON de.emp_no = e.emp_no
WHERE d.dept_name = 'Sales';

-- List each employee in the Sales and Development departments, 
-- including their employee number, last name, first name, and department name.
CREATE VIEW sales_and_development_employees AS
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS de ON e.emp_no = de.emp_no
INNER JOIN departments AS d ON de.dept_no = d.dept_no
WHERE d.dept_name IN ('Sales', 'Development');

-- List the frequency counts, in descending order, 
-- of all the employee last names (that is, how many employees share each last name).
CREATE VIEW last_name_occurrence AS
SELECT last_name, COUNT(last_name) AS "last_name occurrence"
FROM employees
GROUP BY last_name
ORDER BY "last_name occurrence" DESC;