--http://reports.livspace.com/question/2038

select
to_char(prs.project_created_at,'YYYY-MM') as month,
prs.primary_designer,
(case when lower(prs.project_designer_email) like '%.dp@%' then 'DP' else 'ID' end)as Type_of_ID,
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
count(distinct (case when prs.project_stage_weight>=0 then prs.project_id end))as Incoming_Leads,
count(distinct ( case when prs.project_stage_weight>=130 then prs.project_id end))as Total_BC_Scheduled,
count(distinct (case when prs.project_stage_weight>=400 then prs.project_id end))as Total_Converted

from flat_tables.flat_projects prs

where prs.project_created_at>='2019-05-01'::date

group by 1,2,3,4
order by 4
