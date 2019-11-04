--http://reports.livspace.com/question/2500


select
prs.primary_gm,
prs.primary_cm,
prs.primary_designer,
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,

(case when lower(prs.project_designer_email) like '%.dp@%' then 'DP' else 'ID' end) as "Type",

count(distinct(case when prs.project_stage_weight>=400 then prs.project_id end)) as "NO OF DIP and BEYOND",

count(distinct(case when prs.project_stage_weight>=250 then prs.project_id end)) as "NO OF BD and BEYOND",

count(distinct(case when prs.project_stage_weight>=400 then prs.project_id end)) * 1.0 
/
NULLIF(count(distinct(case when prs.project_stage_weight>=250 then prs.project_id end))::numeric,0) * 100 as "Conv % on BD"

from flat_tables.flat_projects prs

where 

date(prs.project_created_at)<=date_trunc('day',current_date-INTERVAL '90 DAYS') 
and date(prs.project_created_at)>=date_trunc('day',current_date-INTERVAL '180 DAYS')
and prs.is_test_project=0 

group by 1,2,3,4,5
