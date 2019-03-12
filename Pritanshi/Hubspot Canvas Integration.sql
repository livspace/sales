select 
pr.`customer_display_name` as Name,
pr.`customer_email` as Email_id,
pr.`customer_phone` as Phone_no,
city.`display_name`as City,
pr.id as canvas_id,
ps.`display_name` as Canvas_Stage,
date(pr.`created_at`) as "canvas_lead_creation_date",
min(case when pe.`new_value`=9 then pe.`created_at` end) as "Qualification_date",
min(case when pe.`new_value`=4 then pe.`created_at` end) as "Conversion_date",
date(pst.`date_add`) as 'ten_percent_date',
pst.`amount` as 'ten_percent_amount',
case when gmv.amount is not null then gmv.amount else pst.amount*10 end as "BGMV",
pr.last_note as "CM_feedback",
case when ps.weight>399 then "Converted" else "Qualified" end as Stage,
case when ps.weight>399 then "Converted" else "Qualified" end as Final_Stage,
cm.name as "Primary CM",
gm.name as "Primary GM",
id.name as "Primary ID/DP",
cm.email as "CM email",
gm.email as "GM email",
id.email as "ID email"
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

left join
(select id_project, 
sum(amount) as amount,
min(date_add) as date_add
from
fms_backend.`ps_transactions`
where `entity_type`='CUSTOMER' and `txn_type`='CREDIT' and `status`=4 and `deleted`=0 and payment_stage in ('TEN_PERCENT','PRE_TEN_PRECENT')
group by id_project
)pst 
on pr.id=pst.id_project 

left join launchpad_backend.project_settings as s on s.project_id = pr.id
left join launchpad_backend.bouncer_users as cm on cm.bouncer_id = s.primary_cm_id  
left join launchpad_backend.bouncer_users as gm on gm.bouncer_id = s.primary_GM_id
left join launchpad_backend.bouncer_users as id on id.bouncer_id = s.primary_designer_id

where 
pr.is_test=0  
and pr.lead_source_id = 163
and ps.weight > 249
group by 
pr.id 
having 
Qualification_date >= '2019-01-01' or Conversion_date >= '2019-01-01'
order by qualification_date
