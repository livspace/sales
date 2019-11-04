--http://reports.livspace.com/question/1977

Select 

to_char(a.added_at,'YYYY-MM') as month,
b.primary_gm,
b.primary_cm as Primary_BM,
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
sum(amount) 

from launchpad_backend.project_gmv_ledger a 

left join flat_tables.flat_projects b on a.project_id=b.project_id 

where a.added_at >= '2019-01-01'::date

group by 1,2,3,4
