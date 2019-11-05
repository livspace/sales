--http://reports.livspace.com/question/2224

 select 

(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
prs.project_id as "Canvas ID",
date(prs.project_created_at) as "Project Created Date",
date(dq.event_date) as "Disqualification Date",
prs.inactivation_reason as "inactivation_reason",
prs.primary_gm as primary_gm,
prs.primary_cm as primary_cm,
prs.primary_designer as primary_designer,
prs.customer_display_name as Cx_Name,
prs.customer_phone as Cx_Mobile,
prs.customer_email as Cx_Email,
prs.project_stage as Stage,
prs.project_status as Status

from flat_tables.flat_projects prs

left join flat_tables.flat_project_events fpe on fpe.project_id=prs.project_id

left join (SELECT project_id as project_id,max(created_at) as event_date from launchpad_backend.project_events where lower(new_value) like '%inactive%' group by 1) 
dq on dq.project_id=prs.project_id

where dq.event_date>='2019-06-01'::date and prs.project_status = 'INACTIVE' and (case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end)={{City}}

group by 1,2,3,4,5,6,7,8,9,10,11,12,13
