select 

cm.name as "CM",
sum(1) as "No. of DIPs",
count(distinct ppm.project_id) as "#Project timlines created",
sum(case when prs.plan_published=1 then 1 else 0 end) as "#Project timelines shared with Cx"

from 

launchpad_backend.projects prs 

left join (select min(created_at) as "created_at",project_id from launchpad_backend.project_events where new_value=4 and event_type = 'STAGE_UPDATED' group by project_id) pe on pe.project_id = prs.id 
left join launchpad_backend.project_settings ps on ps.project_id=prs.id and ps.is_deleted = 0 
left join launchpad_backend.bouncer_users as cm on ps.primary_cm_id = cm.bouncer_id

left join (select project_id from launchpad_backend.project_plan_milestones where is_deleted=false group by project_id) ppm on ppm.project_id=prs.id

left join launchpad_backend.project_stages s on s.id=prs.stage_id

join launchpad_backend.cities ct on ct.id=prs.city_id

where s.weight=400 and ct.name like "%hyd%" and TIMESTAMPDIFF(day,pe.created_at,current_date()) >90 and prs.status="ACTIVE" and cm.bouncer_id in (302,862,1025,1235,1782,1828,2211,2237,3213,3304,3462,3916,4012,4868,4925,4971,5420,5376) and prs.is_test=false
group by cm.id

order by count(*) desc
