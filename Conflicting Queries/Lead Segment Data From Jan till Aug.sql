--http://reports.livspace.com/question/2207?City=Mumbai

select 
(extract ( month from date(prs.project_created_at))) as "Month",
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
(case when prs.project_stage_weight>=400 and prs.gmv_amount is not null then prs.gmv_amount 
when prs.project_stage_weight>=400 and prs.gmv_amount is null then prs.estimated_value 
else prs.estimated_value end) as "BGMV or Estimated BGMV",
 
prs.project_stage as "Stage ",
prs.project_status as "Status ",
prs.project_property_type as "Property Type",
prs.project_service_type as "Service Type",
pe.created_at as "Converted Date"


from flat_tables.flat_projects prs

left join (select min(event_date) as created_at,project_id from flat_tables.flat_project_events where new_value=4 and event_type = 'STAGE_UPDATED' group by project_id)
pe on pe.project_id = prs.project_id 

where prs.project_created_at >= '2019-01-01'::date and prs.project_created_at <= '2019-08-31'::date and prs.estimated_value is not null and (case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%mumbai%' or lower(project_city) like '%navi mumbai%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) ={{City}}
