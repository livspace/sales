--http://reports.livspace.com/question/2278

select 

cm.name as BM,
count(distinct(case when (ps.weight>=250 and ps.weight<260 and pe1.event_date<CURRENT_DATE - INTERVAL '12 days') then prs.id end)) as "BD->PP Decay",
count(distinct(case when (ps.weight>=130 and ps.weight<250 and pe2.event_date<CURRENT_DATE - INTERVAL '3 days') then prs.id end)) as "BCS->BD Decay",
count(distinct(case when (ps.weight>=260 and ps.weight<400 and pe1.event_date<CURRENT_DATE - INTERVAL '21 days') then prs.id end)) as "PP -->DIP Decay"


from launchpad_backend.projects prs  
join launchpad_backend.project_stages ps on ps.id=prs.stage_id


left join launchpad_backend.project_settings pss on pss.project_id=prs.id and pss.is_deleted = 0 
left join launchpad_backend.bouncer_users as cm on pss.primary_cm_id = cm.bouncer_id
join launchpad_backend.cities ct on ct.id=prs.city_id

left join (select project_id as project_id,max(event_date) as event_date from flat_tables.flat_project_events where new_value=9 and event_type = 'STAGE_UPDATED' group by project_id) pe1 on pe1.project_id = prs.id 
left join (select project_id as project_id,max(event_date) as event_date from flat_tables.flat_project_events where new_value=23 and event_type = 'STAGE_UPDATED' group by project_id) pe2 on pe2.project_id = prs.id 
left join (select project_id as project_id,max(event_date) as event_date from flat_tables.flat_project_events where new_value=21 and event_type = 'STAGE_UPDATED' group by project_id) pe3 on pe3.project_id = prs.id 


where city_id = 12
and prs.status = 'ACTIVE'

group by 1
