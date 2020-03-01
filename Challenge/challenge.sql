-- CHALLENGE --

-- TABLE 1: Number of [Titles] Retiring
-- 1. Create a table that shows *current* employees eligible for retirement
select e.emp_no,
	e.first_name,
	e.last_name,
	de.to_date
into tbl_current_emp
from employees as e
	left join dept_emp as de
		on e.emp_no = de.emp_no
where (e.birth_date between '1952-01-01' and '1955-12-31')
	and (e.hire_date between '1985-01-01' and '1988-12-31')
		and de.to_date = ('9999-01-01');

-- 2. Find the titles retiring
select 
	ce.emp_no,
	ce.first_name,
	ce.last_name,
	ttl.title,
	ttl.from_date,
	s.salary
into tbl_titles_retiring
from tbl_current_emp as ce
	inner join titles as ttl
		on (ce.emp_no = ttl.emp_no)
	inner join salaries as s
		on (ce.emp_no = s.emp_no)
order by ttl.from_date DESC;

-- 3. Count the number of titles retiring
select 
	count (title), 
	title
into tbl_count_titles_retiring
from tbl_titles_retiring
group by 
	title
order by count desc;

select * from tbl_current_emp;
select * from tbl_titles_retiring;
select * from tbl_count_titles_retiring;



-- TABLE 2: Only the Most Recent Titles
-- 1. Partition data to show most recent titles
select 
	emp_no, 
	first_name, 
	last_name, 
	to_date, 
	title 
into tbl_unique_titles_retiring
from 
	(select emp_no, 
	 first_name, 
	 last_name, 
	 to_date, 
	 title, row_number() over
	(partition by (first_name, last_name) 
	 order by to_date DESC) rn
	from tbl_titles_retiring
	) tmp where rn = 1
order by emp_no;

-- 2. Count the number of employees per title
select 
	count(title),
	title
into tbl_count_unique_titles_retiring
from tbl_unique_titles_retiring
group by
	title
order by count desc;

select * from tbl_unique_titles_retiring;
select * from tbl_count_unique_titles_retiring;



-- TABLE 3: Who's Ready for a Mentor?
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
	
select count(*) from tbl_mentor_ready;
select * from tbl_mentor_ready;