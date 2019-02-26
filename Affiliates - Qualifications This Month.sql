select City, count(distinct canvas_id) as "# Qualifications"
from
(select 
pr.id as canvas_id,
city.`display_name`as City,
min(case when pe.`new_value`=9 then date(pe.`created_at`) end) as "Qualification_date"
from 
launchpad_backend.projects pr 
left join
launchpad_backend.`cities` city
on pr.`city_id`=city.id

left join
launchpad_backend.project_stages ps
on pr.`stage_id`=ps.id

left join
(select *
from
launchpad_backend.project_events
where event_type = "STAGE_UPDATED"
AND new_value in(4,9)
)pe 
on pr.id=pe.`project_id`

where pr.lead_source_id = 163
and ps.weight > 249
group by 
pr.id 
having 
month(Qualification_date) = month(curdate()) and 
year(Qualification_date) = year(curdate()))a
group by City with rollup