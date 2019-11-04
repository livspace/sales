--http://reports.livspace.com/question/2070

select 

(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
prs.project_id,
prs.primary_gm,
prs.primary_cm as Primary_BM,
prs.customer_display_name,
prs.customer_email,
prs.project_stage,
prs.project_status

from flat_tables.flat_projects prs


left join (SELECT project_id as project_id,max(created_at) as event_date from launchpad_backend.project_events where lower(new_value) like '%inactive%' group by 1) 
dq on dq.project_id=prs.project_id

where (project_stage_weight<=280 and project_stage_weight>= 260 and project_status in ('ON HOLD','ACTIVE'))
or 
(project_stage_weight<=280 and project_stage_weight>= 260 and project_status in ('INACTIVE') and dq.event_date>='2019-04-01'::date)
