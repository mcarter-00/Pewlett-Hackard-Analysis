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