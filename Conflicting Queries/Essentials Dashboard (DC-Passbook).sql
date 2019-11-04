--http://reports.livspace.com/question/2216

select
prs.project_id as "Canvas id",
prs.primary_gm as "GM",
prs.primary_cm as "BM",
prs.primary_designer as "Designer Name",
(case when lower(prs.project_designer_email) like '%.dp@%' then 'DP' else 'ID' end) as "Type",
(case 
when lower(prs.project_city) like '%bangalore%' or lower(prs.project_city) like '%hyderabad%' or lower(prs.project_city) like '%chennai%' or lower(prs.project_city) like '%pune%' then project_city
when lower(prs.project_city) like '%mumbai%' or lower(prs.project_city) like '%thane%' then 'Mumbai'
when lower(prs.project_city) like '%gurgaon%' or lower(prs.project_city) like '%dwarka%' then 'Gurgaon'
when lower(prs.project_city) like '%delhi%' or lower(prs.project_city) like '%farida%' then 'Delhi'
when lower(prs.project_city) like '%noida%' or lower(prs.project_city) like '%ghaz%' then 'Noida'
end) as City,
date(prs.project_created_at) as "Project Created date",
prs.customer_display_name as "Customer Name",
pvs.new_value as "Stage weight",
stg.name as "Stage",
date(pvs.event_date) as "Evaluation Date"


from flat_tables.flat_projects prs
left join 
(select project_id, max(event_date)as event_date,new_value from flat_tables.flat_project_events group by project_id,event_date,new_value) as pvs on prs.project_id=pvs.project_id

left join launchpad_backend.project_stages stg on pvs.new_value=stg.id

where prs.is_test_project=0
group by 1,2,3,4,5,6,7,8,9,10,11
