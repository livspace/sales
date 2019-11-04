--http://reports.livspace.com/question/1958

select 

prs.project_id AS "Project ID",
prs.primary_designer as "Primary designer",
prs.primary_cm as "Primary BM",
prs.primary_gm as "Primary GM",
prs.project_status as "Project Status",
prs.project_stage as "Project Stage",
min(date(fpe.event_date)) as "Stage Date",
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City


from flat_tables.flat_projects prs 
left join launchpad_backend.project_stages ps on ps.weight=prs.project_stage_weight
left join flat_tables.flat_project_events fpe on fpe.project_id=prs.project_id and fpe.new_value=ps.id

where prs.project_status = 'ACTIVE' and prs.is_test_project=false and lower(prs.primary_cm) not like '%dummy%' and lower(prs.primary_cm) not like '%test%'

group by 1,2,3,4,5,6,8

order by prs.project_id desc
