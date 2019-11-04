--http://reports.livspace.com/question/1837

select 

prs.id,
ct.display_name,
prs.customer_display_name,
pss.display_name as stage,
gm.name as gm_name,
cm.name as cm_name,
dp.name as designer_name,
date(tp.created_at) as ten_percent_collected_date,
(case when ms.project_id is not null then 'Y' else 'N' end) as "created?",
(case when prs.plan_published=true then 'Y' else 'N' end) as "shared?",
ms.milestones as milestones,
ms.completed as completed,
ms.delayed missed,
date(prs.plan_published_at) as published,
ms.last_mile as next,
ms.last_mile_date as next_due,
gm.email as gm_email,
cm.email as bm_email,
dp.email as id_email,
sum(gmv.amount) as bgmv,
min(ms.kws_date) as kws_date,
min(ms.service_date) as service_date,
min(ms.fnd_date) as fnd_date,
min(ms.ho_date) as ho_date,
sum(cg.cgmv) as cgmv,
min(om.first_order) as first_order,
min(order_number) as orders_raised,
(case when min(tp.created_at) is not null and min(om.first_order) is not null then DATEDIFF(day,min(tp.created_at), min(om.first_order)) end) as dip_poc,
(case when min(tp.created_at) is not null and min(foc.event_date) is not null then DATEDIFF(day,min(tp.created_at), min(foc.event_date)) end) as dip_foc,
prs.status as status,
min(ms.site_validation_civil_works_expected_date) as site_validation_civil_works_expected_date,
min(ms.site_validation_civil_works_status) as site_validation_civil_works_status,
min(ms.site_validation_knw_expected_date) as site_validation_knw_expected_date,
min(ms.site_validation_knw_status) as site_validation_knw_status,
min(ms.kws_status) as kws_status,
min(ms.Service_status) as Service_status,
min(ms.fnd_status) as fnd_status

from launchpad_backend.projects prs 
left join launchpad_backend.project_stages pss on pss.id=prs.stage_id
left join ( select fact2.project_id, sum(fact2.order_products_wt) as order_products_wt, sum(fact2.order_discount) as order_discount,
sum(fact2.order_handling_fee) as order_handling_fee,
sum(coalesce(order_products_wt,0) + coalesce(order_handling_fee,0)) as CGMV
from
       (select fact.project_id, fact.order_state, sum(coalesce(order_products_wt,0)) as order_products_wt,
       sum(coalesce(order_handling_fee,0)) as order_handling_fee,
           sum(fact.order_discount) as order_discount
             from
             ( select Distinct project_id,id_order,order_state,order_discount,
             order_products_wt,order_handling_fee,order_created_at,order_client
             from flat_tables.flat_orders
			 ) as fact
             where fact.order_state not in ( 'Cancelled' , 'Blocked') and (order_created_at<'2019-08-18'::date or (order_created_at>='2019-08-18'::date and lower(order_client) !='oms'))
             and fact.id_order not in (1803210096,1803210159,1803210109,1803210083,1803210110,1803210169,1803210221,1803210196,1803210227,1803210205,1803210117,1803210139,1803210113,1803210153,1803210154,1803210224,1803210091,
1803210092,1803210093,1803210095,1803210098,1803210210,1803210107,1803210215,1803210194,1803210202,1803210203,1803210229,1803210207,1803210212,1803210213,1803210088,1803210108,1803210143,1803210178,1803210176,
1803210177,1803210184,1803210191,1803210180,1803210200,1803210085,1803210100,1803210208,1803210209,1803210105,1803210115,1803210211,1803210129,1803210130,1803210156,1803210163,1803210164,1803210219,1803210171,
1803210187,1803210195,1803210198,1803210094,1803210119,1803210166,1803210111,1803210116,1803210142,1803210150,1803210157,1803210172,1803210226,1803210145,1803210161,1803210183,1803210185,1803210186,1803210188,
1803210190,1803210147,1803210149,1803210182,1803210197,1803210087,1803210102,1803210103,1803210204,1803210089,1803210155,1803210168,1803210174,1803210123,1803210124,1803210125,1803210126,1803210127,1803210128,
1803210199,1803210106,1803210138,1803210104,1803210220,1803210084,1803210158,1803210120,1803210167,1803210189,1803210193,1803210090,1803210097,1803210118,1803210160,1803210165,1803210192,1803210082,1803210099 )
group by 1,2
) as fact2
group by 1
) cg on cg.project_id=prs.id
left join (select project_id, date(min(order_created_at)) as first_order, count(distinct id_order) as order_number from flat_tables.flat_orders where order_state not in ('Cancelled', 'Blocked') group by project_id) om on om.project_id=prs.id
left join 
(select project_id, sum(amount) as amount
from launchpad_backend.project_bgmvs
group by project_id
)gmv 
on  prs.id= gmv.project_id

left join launchpad_backend.cities ct on ct.id=prs.city_id
left join launchpad_backend.project_stages s on s.id=prs.stage_id
left join launchpad_backend.project_settings ps on ps.project_id=prs.id and ps.is_deleted = 0 
left join launchpad_backend.bouncer_users as cm on ps.primary_cm_id = cm.bouncer_id
left join launchpad_backend.bouncer_users as dp on ps.primary_designer_id = dp.bouncer_id
left join launchpad_backend.bouncer_users as gm on ps.primary_gm_id = gm.bouncer_id
left join (select project_id as project_id, min(event_date) as event_date from flat_tables.flat_project_events where new_value_name like '%full_order_confirmed%' group by project_id) foc on foc.project_id=prs.id


left join (
select
p.project_id,
sum(p.milestones) as milestones,
sum(p.completed) as completed,
sum(p.delayed) as delayed,
'' as last_mile,
min(p.last_mile_date) as last_mile_date,
min(p.kws_date) as kws_date,
min(p.service_date) as service_date,
min(p.fnd_date) as fnd_date,
min(p.ho_date) as ho_date,
min(p.site_validation_civil_works_expected_date) as site_validation_civil_works_expected_date,
min(p.site_validation_civil_works_status) as site_validation_civil_works_status,
min(p.site_validation_knw_expected_date) as site_validation_knw_expected_date,
min(p.site_validation_knw_status) as site_validation_knw_status,
min(p.kws_status) as kws_status,
min(p.Service_status) as Service_status,
min(p.fnd_status) as fnd_status

from

(
select project_id,
count(*) as milestones,
sum(case when current_status='COMPLETE' then 1 end) as completed,
sum(case when current_status='COMPLETE' and expected_completion_date>updated_at then 1 end) as delayed,
(case when current_status='PENDING' then milestone_display_name end) as last_mile,
(case when current_status='PENDING' then date(expected_completion_date) end) as last_mile_date,
min(case when lower(milestone_display_name) like '%sales order - kitchen%' then date(expected_completion_date) end) as kws_date,
min(case when lower(milestone_display_name) like '%sales order - civil work%' then date(expected_completion_date) end) as service_date,
min(case when lower(milestone_display_name) like '%sales order - furniture%' then date(expected_completion_date) end) as fnd_date,
min(case when lower(milestone_display_name) like '%project handover%' then date(expected_completion_date) end) as ho_date,
min(case when lower(milestone_display_name) like '%site validation - civil work & services%' then date(expected_completion_date) end) as site_validation_civil_works_expected_date,
min(case when lower(milestone_display_name) like '%site validation - civil work & services%' and current_status='COMPLETE' then 'Y'
when lower(milestone_display_name) like '%site validation - civil work & services%' and current_status='PENDING' then 'N'
end) as site_validation_civil_works_status,
min(case when lower(milestone_display_name) like '%site validation - kitchen, wardrobes & storages%' then date(expected_completion_date) end) as site_validation_knw_expected_date,
min(case when lower(milestone_display_name) like '%site validation - kitchen, wardrobes & storages%' and current_status='COMPLETE' then 'Y'
when lower(milestone_display_name) like '%site validation - kitchen, wardrobes & storages%' and current_status='PENDING' then 'N'
end) as site_validation_knw_status,

min(case when lower(milestone_display_name) like '%sales order - kitchen%' and current_status='COMPLETE' then 'Y' 
when lower(milestone_display_name) like '%sales order - kitchen%' and current_status='PENDING' then 'N' 
end) as kws_status,

min(case when lower(milestone_display_name) like '%sales order - civil work%' and current_status='COMPLETE' then 'Y' 
when lower(milestone_display_name) like '%sales order - civil work%' and current_status='PENDING' then 'N' 
end) as Service_status,

min(case when lower(milestone_display_name) like '%sales order - furniture%' and current_status='COMPLETE' then 'Y' 
when lower(milestone_display_name) like '%sales order - furniture%' and current_status='PENDING' then 'N' 
end) as fnd_status

from launchpad_backend.project_plan_milestones 
where is_deleted=false 

group by project_id,project_plan_milestones.current_status,project_plan_milestones.milestone_display_name,project_plan_milestones.expected_completion_date

order by expected_completion_date desc
) p 

group by p.project_id
) ms on ms.project_id = prs.id


left join (select id_project as id_project , sum(amount) as amount,min(date_txn) as created_at from fms_backend.ps_transactions where txn_type='CREDIT' and status='4' and payment_stage in ('TEN_PERCENT','PRE_TEN_PERCENT') group by id_project) tp on prs.id = tp.id_project


where pss.weight>=400 

group by prs.id,ct.display_name,prs.customer_display_name,gm.name,cm.name,dp.name,tp.created_at,ms.project_id,prs.plan_published,ms.milestones,ms.completed,ms.delayed,prs.plan_published_at
,ms.last_mile,ms.last_mile_date,gm.email,cm.email,dp.email,pss.display_name,prs.status
