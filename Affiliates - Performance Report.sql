select City, 
count(case when month(Canvas_Creation_date) = month(curdate()) and 
year(Canvas_Creation_date) = year(curdate()) then canvas_id end) as "# Potential",
count(case when month(Qualification_date) = month(curdate()) and 
year(Qualification_date) = year(curdate()) then canvas_id end) as "# Qualifications",
count(case when month(Conversion_date) = month(curdate()) and 
year(Conversion_date) = year(curdate()) then canvas_id end) as "# Conversions",
sum(case when month(Conversion_date) = month(curdate()) and 
year(Conversion_date) = year(curdate()) then  `BGMV(in Cr)`/10000000 end) as "BGMV(in Cr)"
from
(select 
pr.id as canvas_id,
date(pr.created_at) as "Canvas_Creation_date",
amount as `BGMV(in Cr)`,
city.`display_name`as City,
min(case when pe.`new_value`=9 then date(pe.`created_at`) end) as "Qualification_date",
min(case when pe.`new_value`=4 then date(pe.`created_at`) end) as "Conversion_date"
from 
launchpad_backend.projects pr 
left join
launchpad_backend.`cities` city
on pr.`city_id`=city.id

left join
launchpad_backend.project_stages ps
on pr.`stage_id`=ps.id

left join 
(select project_id, sum(amount) as amount
from `launchpad_backend`.`project_gmv_ledger`
group by project_id
)gmv 
on  pr.id= gmv.project_id

left join
(select *
from
launchpad_backend.project_events
where event_type = "STAGE_UPDATED"
AND new_value in(4,9)
)pe 
on pr.id=pe.`project_id`

where pr.lead_source_id = 163
and pr.is_test = 0
group by 
pr.id )a
group by City with rollup