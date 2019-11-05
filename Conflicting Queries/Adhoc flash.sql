--http://reports.livspace.com/question/2242

select (case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,prs.primary_designer,count(distinct(case when dq.event_date >= '2019-08-31'::date or dq.event_date is null then prs.project_id end)) as "Active leads on 31st  Aug",
count(distinct(case when dq.event_date >= '2019-09-06'::date or dq.event_date is null then prs.project_id end)) as "Active leads on 6th sep"


from flat_tables.flat_projects prs

left join launchpad_backend.project_settings ps on ps.project_id=prs.project_id and ps.is_deleted = 0 
left join launchpad_backend.bouncer_users as designer on ps.primary_designer_id = designer.bouncer_id

left join (SELECT project_id as project_id,max(created_at) as event_date from launchpad_backend.project_events where lower(new_value) like '%inactive%' group by 1) 
dq on dq.project_id=prs.project_id

where lower(designer.email) not like '%.dp@%'

group by 1,2

having count(distinct(case when dq.event_date >= '2019-08-31'::date or dq.event_date is null then prs.project_id end))>=10 and count(distinct(case when dq.event_date >= '2019-09-06'::date or dq.event_date is null then prs.project_id end)) >=10
