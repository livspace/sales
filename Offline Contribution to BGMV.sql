select City, 
concat(month(Conversion_date),"-",year(Conversion_date)) as Month,
count(case when lead_source = 163 then canvas_id end) as "Offline Leads",
count(canvas_id) as "Total_leads",
sum(case when lead_source = 163 then BGMV end) as "Offline BGMV",
sum(BGMV) as "Total BGMV",
sum(case when lead_source = 163 then BGMV end)/sum(BGMV)*100 as "Offline Contribution-BGMV(%)"
from
(select 
pr.id as canvas_id,
pr.lead_source_id as lead_source,
city.`display_name`as City,
amount as BGMV,
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
(select *
from
launchpad_backend.project_events
where event_type = "STAGE_UPDATED"
AND new_value in(4,9)
)pe 
on pr.id=pe.`project_id`

left join 
(select project_id, sum(amount) as amount
from `launchpad_backend`.`project_gmv_ledger`
group by project_id
)gmv 
on  pr.id= gmv.project_id

where 1=1
and ps.weight > 249
group by 
pr.id 
having 
Conversion_date >= '2018-12-01')a
group by City,concat(month(Conversion_date),"-",year(Conversion_date)) with rollup