--http://reports.livspace.com/question/2016

Select 
prs.primary_cm as Primary_BM,

prs.primary_designer as Primary_Designer,

(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,

sum(gml.amount) 

from launchpad_backend.project_gmv_ledger gml

left join flat_tables.flat_projects prs 

on prs.project_id=gml.project_id

where (gml.added_at>='2019-04-01'::date and gml.added_at<='2019-06-30'::date)
group by 1,2,3 order by City

