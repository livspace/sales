select 
pr.`customer_display_name` as Name,
pr.`customer_email` as Email_id,
pr.`customer_phone` as Phone_no,
city.`display_name`as City,
pr.id as canvas_id,
s.`display_name` as Canvas_Stage,
date(pr.`created_at`) as "canvas_lead_creation_date",
cm.name as "Primary CM",
gm.name as "Primary GM",
pr.last_note as "CM Feedback"
from 
launchpad_backend.projects pr 
left join
launchpad_backend.`cities` city
on pr.`city_id`=city.id

left join
launchpad_backend.project_stages s
on pr.`stage_id`=s.id

left join launchpad_backend.project_settings ps on ps.project_id=pr.id and ps.is_deleted = 0 
left join launchpad_backend.bouncer_users as cm on ps.primary_cm_id = cm.bouncer_id
left join launchpad_backend.bouncer_users as gm on ps.primary_gm_id = gm.bouncer_id

where 
pr.is_test=0  
and pr.status = "ACTIVE"
and pr.lead_source_id = 163
and s.weight < 250
group by 
pr.id 
