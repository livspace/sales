select 
pr.id as canvas_id,
city.`display_name`as City,
pr.status as "Status",
cm.name as "Primary CM",
gm.name as "Primary GM",
id.name as "Primary ID/DP",
pr.budget_min,
pr.budget_max,
bq.first_boq

from 
launchpad_backend.projects pr 
left join
launchpad_backend.`cities` city
on pr.`city_id`=city.id
left join
(select project_id, min(created_at) as "BoQ_shared_on", (total_price - discount + handling_fee) as first_boq  
from 
boq_backend.pf_proposal
group by project_id
)bq
on pr.id = bq.project_id

left join launchpad_backend.project_settings as s on s.project_id = pr.id
left join launchpad_backend.bouncer_users as cm on cm.bouncer_id = s.primary_cm_id  
left join launchpad_backend.bouncer_users as gm on gm.bouncer_id = s.primary_GM_id
left join launchpad_backend.bouncer_users as id on id.bouncer_id = s.primary_designer_id

where pr.created_at > curdate() - interval 6 month
group by 
pr.id 
