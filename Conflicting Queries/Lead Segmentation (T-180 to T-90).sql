--http://reports.livspace.com/question/2429

select 
date(prs.project_created_at) as "lead creation date",
prs.project_id as "canvas id",
prs.primary_gm as "Primary GM",
prs.primary_cm as "Primary CM",
prs.primary_designer as "Primary Designer",
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%mumbai%' or lower(project_city) like '%navi mumbai%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
(case when lower(prs.brief_scope) like '%modul%' then 'KnW' else 'FHD' end) as "Scope ",
prs.budget_min as "minimum budget",
prs.budget_max as "maximum budget",
(case when prs.project_stage_weight>=400 then prs.gmv_amount else lbp.estimated_value end) as "estimated project value",
prs.project_stage as "Stage ",
prs.project_status as "Status ",
prs.project_property_type as "Property Type",
prs.project_service_type as "Service Type",
date(pe.created_at) as "Converted Date",
prs.project_stage_weight as "Weight ",
prs.gmv_amount as "BGMV Amount"


from flat_tables.flat_projects prs

left join launchpad_backend.projects lbp on lbp.id=prs.project_id

left join (select min(created_at) as created_at,project_id from launchpad_backend.project_events where new_value=4 and event_type = 'STAGE_UPDATED' group by project_id)
pe on pe.project_id = prs.project_id 

where prs.project_created_at >= (current_date - interval '180 days') and prs.project_created_at <= (current_date - interval '90 days') and lbp.estimated_value is not null
