-- Determine retirement eligibility
select first_name, last_name
from employees
where birth_date between '1952-01-01' and '1955-12-31';

-- Determine employees born in 1952
select first_name, last_name
from employees
where birth_date between '1952-01-01' and '1952-12-31';

-- Determine employees born in 1953
select first_name, last_name
from employees
where birth_date between '1953-01-01' and '1953-12-31';

-- Determine employees born in 1954
select first_name, last_name
from employees
where birth_date between '1954-01-01' and '1954-12-31';

-- Determine employees born in 1955
select first_name, last_name
from employees
where birth_date between '1955-01-01' and '1955-12-31';

-- Narrow the Search for Retiremente Eligibility
select first_name, last_name
from employees
where (birth_date between '1955-01-01' and '1955-12-31') 
and (hire_date between '1985-01-01' and '1988-12-31');

-- Number of employees retiring
select count(first_name)
from employees
where (birth_date between '1952-01-01' and '1955-12-31')
and (hire_date between '1985-01-01' and '1988-12-31');

-- Save data into a new table "retirement info"
select first_name, last_name
into retirement_info
from employees
where (birth_date between '1952-01-01' and '1955-12-31')
and (hire_date between '1985-01-01' and '1988-12-31');