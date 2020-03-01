-- CHALLENGE --

-- Create a table for employees eligible for retirement:
select emp_no, 
	first_name, 
	last_name
into retirement_info
from employees
where (birth_date between '1952-01-01' and '1955-12-31')
	and (hire_date between '1985-01-01' and '1988-12-31');

-- Create a table that shows current employees eligible for retirement:
select ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.from_date,
	de.to_date
into current_emp
from retirement_info as ri
	left join dept_emp as de
		on ri.emp_no = de.emp_no
where de.to_date = ('9999-01-01');

-- Table 1: Number of [Titles] Retiring
select ce.emp_no,
	ce.first_name,
	ce.last_name,
	ttl.title,
	s.salary,
	ce.from_date
into tbl_titles_retiring
from current_emp as ce
	inner join titles as ttl
		on (ce.emp_no = ttl.emp_no)
	inner join salaries as s
		on (ce.emp_no = s.emp_no);
	