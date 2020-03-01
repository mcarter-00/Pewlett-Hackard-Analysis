-- CHALLENGE --

-- Table 1: Number of [Titles] Retiring

-- 1. Create a table that shows *current* employees eligible for retirement:
select e.emp_no,
	e.first_name,
	e.last_name,
	de.from_date,
	de.to_date
into tbl_current_emp
from employees as e
	left join dept_emp as de
		on e.emp_no = de.emp_no
where (e.birth_date between '1952-01-01' and '1955-12-31')
	and (e.hire_date between '1985-01-01' and '1988-12-31')
		and de.to_date = ('9999-01-01');

select * from tbl_current_emp;

-- 2. Determine # of Retiring
select ce.emp_no,
	ce.first_name,
	ce.last_name,
	ttl.title,
	s.salary,
	ce.from_date
into tbl_titles_retiring
from tbl_current_emp as ce
	inner join titles as ttl
		on (ce.emp_no = ttl.emp_no)
	inner join salaries as s
		on (ce.emp_no = s.emp_no);

select * from tbl_titles_retiring;

-- Table 2: Only the Most Recent Titles

-- 1. Find dups
select emp_no,
	first_name,
	last_name,
	count(*)
from tbl_titles_retiring 
group by emp_no,
	first_name,
	last_name
having count(*) > 1
order by emp_no;

-- 2. Display dups with all info
select * from 
	(select *, count(*)
	over 
	 (partition by
		emp_no,
	 	first_name,
		last_name
	 ) as count
	from tbl_titles_retiring) tableWithCount
	where tableWithCount.count > 1;
	
-- 3. Combine dups into a single row
select 
	emp_no,
	first_name,
	last_name,
	string_agg(title, '/') as titles,
	salary,
	from_date
into tbl_dups_combined
from tbl_titles_retiring
group by
	emp_no,
	first_name,
	last_name,
	salary,
	from_date;

-- 4. List the frequency count of employee titles
select 
	count(titles),
	emp_no,
	first_name,
	last_name,
	salary,
	from_date
into tbl_most_recent_titles
from tbl_dups_combined
group by 
	emp_no,
	first_name,
	last_name,
	salary,
	from_date
order by from_date DESC;

select * from tbl_most_recent_titles;

-- Table 3: Who's Ready for a Mentor?
-- VERIFY: Directions doesn't say to include birth date, but Background does?
select
	e.emp_no,
	e.first_name,
	e.last_name,
	string_agg(ttl.title, '/') as titles,
	de.from_date,
	de.to_date
into tbl_mentor_ready
from employees as e
	left join titles as ttl
		on e.emp_no = ttl.emp_no
	left join dept_emp as de
		on e.emp_no = de.emp_no
where e.birth_date between '1965-01-01' and '1965-12-31'
	and de.to_date = ('9999-01-01')
group by
	e.emp_no,
	e.first_name,
	e.last_name,
	de.from_date,
	de.to_date;
	
select * from tbl_mentor_ready;