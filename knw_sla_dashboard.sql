select 
prs.id as "Canvas ID",
gm.name as "GM",
cm.name as "CM",
dp.name as "Designer",
ct.display_name as "City",
prs.customer_display_name as "Customer",
(case when gmv.amount>0 and tp.amount>0 then least(tp.amount*10,gmv.amount) when gmv.amount>0 then gmv.amount else tp.amount*10 end) as "Tentative BGMV",
date(prs.created_at) as "Lead Generation Date",
s.display_name as "Current Stage",
date(pe1.created_at) as 'GM Assigned date',
date(pe2.created_at) as 'CM Assigned date',
date(pe3.created_at) as 'Prospective Lead date',
date(pe4.created_at) as 'Briefing Pending date',
date(pe5.created_at) as 'Briefing Rescheduled date',
date(pe6.created_at) as 'Briefing Done date',
date(pe7.created_at) as 'Proposal Created date',
date(pe8.created_at) as '10% Proposal WIP date',
date(pe9.created_at) as 'Proposal Ready date',
date(pe10.created_at) as 'Proposal Presented date',
date(pe11.created_at) as 'Awaiting 10% date',
date(pe12.created_at) as '10k/10% Collected date',
date(pe13.created_at) as 'Design In Progress date',
date(pe14.created_at) as 'Awaiting 50% date',
date(pe15.created_at) as 'Partial Order Confirmed date',
date(pe16.created_at) as 'Full Order Confirmed date',
date(pe17.created_at) as 'Execution in Progress date',
date(pe18.created_at) as 'Handover with Snags date',
date(pe19.created_at) as 'Handover with No Snags date',
date(pe20.created_at) as 'Closed date',
(case when pe3.created_at then TIMESTAMPDIFF(day,prs.created_at, pe3.created_at) end) as "Time from Lead Creation to Prospective Lead",
(case when pe10.created_at then TIMESTAMPDIFF(day,pe3.created_at, pe10.created_at) end) as "Time from PL to Proposal Presented",
(case when pe13.created_at then TIMESTAMPDIFF(day,pe10.created_at, pe13.created_at) end) as "Time from PP to DIP",
(case when gmv.amount>0 and tp.amount>0 then least(tp.amount*10,gmv.amount) when gmv.amount>0 then gmv.amount else tp.amount*10 end) as "Canvas BGMV",
s.weight as "Weight",
prs.status as "Status",
(case when s.weight <150 and prs.status = "INACTIVE" then "Disqualified-Presales" 
when cm.bouncer_id in (710,4203,94,4721,4801,4266,4597,4890,5143,4925,3829,3304,285) then "KnW"  
when ptc.collaborator_id in (713,689,4414,5052,5175,5288,4864,1030,4941) and cm.bouncer_id not in (710,4203,94,4721,4801,4266,4597,4890,5143,4925,3829,3304,285,713,689,4414,5052,5175,5288,4864,1030,4941)  then "FHD"
else "YTQ" end) as "Type",
(case when pe15.created_at then TIMESTAMPDIFF(day,pe13.created_at, pe15.created_at) end) as "Time from 10%-50%",
(case when pe16.created_at then TIMESTAMPDIFF(day,pe15.created_at, pe16.created_at) end) as "Time from 50%-100%",
(case when pe20.created_at then TIMESTAMPDIFF(day,pe16.created_at, pe20.created_at) end) as "Time from 100% to closure",
cgmv.amount as "CGMV",
round(sum(tp2.amount),2) as "collection"


from launchpad_backend.projects prs

left join (select id_project as "id_project", amount as "amount", date_add as "created_at" from fms_backend.ps_transactions where txn_type="CREDIT" and status="4") tp2 on prs.id = tp2.id_project

left join (select project_id,sum(ifnull(order_products_wt,0) + ifnull(order_handling_fee,0)) as "amount" from livspace_reports2.flat_orders where order_state not in ('Cancelled', 'Blocked') group by project_id) cgmv on cgmv.project_id=prs.id

left join (select project_id,id_order,order_state,order_discount,order_products_wt,order_handling_fee, order_created_at from livspace_reports2.flat_orders) vmbo on vmbo.project_id=prs.id
left join launchpad_backend.cities ct on ct.id=prs.city_id
left join launchpad_backend.project_stages s on s.id=prs.stage_id

left join launchpad_backend.project_settings ps on ps.project_id=prs.id and ps.is_deleted = 0 
left join launchpad_backend.bouncer_users as cm on ps.primary_cm_id = cm.bouncer_id
left join launchpad_backend.bouncer_users as dp on ps.primary_designer_id = dp.bouncer_id
left join launchpad_backend.bouncer_users as gm on ps.primary_gm_id = gm.bouncer_id
left join (select sum(amount) as "amount" ,project_id as "pid" from launchpad_backend.project_gmv_ledger group by project_id) gmv on gmv.pid=prs.id

left join (select id_project as "id_project", sum(amount) as "amount" from fms_backend.ps_transactions where txn_type="CREDIT" and status="4" and payment_stage in ("TEN_PERCENT","PRE_TEN_PERCENT") group by id_project) tp on prs.id = tp.id_project

left join launchpad_backend.project_to_collaborators ptc on prs.id = ptc.project_id


left join (select * from launchpad_backend.project_events where new_value=17 and event_type = 'STAGE_UPDATED') pe1 on pe1.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=18 and event_type = 'STAGE_UPDATED') pe2 on pe2.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=13 and event_type = 'STAGE_UPDATED') pe3 on pe3.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=2 and event_type = 'STAGE_UPDATED') pe4 on pe4.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=8 and event_type = 'STAGE_UPDATED') pe5 on pe5.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=9 and event_type = 'STAGE_UPDATED') pe6 on pe6.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=19 and event_type = 'STAGE_UPDATED') pe7 on pe7.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=11 and event_type = 'STAGE_UPDATED') pe8 on pe8.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=20 and event_type = 'STAGE_UPDATED') pe9 on pe9.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=21 and event_type = 'STAGE_UPDATED') pe10 on pe10.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=12 and event_type = 'STAGE_UPDATED') pe11 on pe11.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=3 and event_type = 'STAGE_UPDATED') pe12 on pe12.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=4 and event_type = 'STAGE_UPDATED') pe13 on pe13.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=7 and event_type = 'STAGE_UPDATED') pe14 on pe14.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=5 and event_type = 'STAGE_UPDATED') pe15 on pe15.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=14 and event_type = 'STAGE_UPDATED') pe16 on pe16.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=6 and event_type = 'STAGE_UPDATED') pe17 on pe17.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=15 and event_type = 'STAGE_UPDATED') pe18 on pe18.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=16 and event_type = 'STAGE_UPDATED') pe19 on pe19.project_id = prs.id 
left join (select * from launchpad_backend.project_events where new_value=10 and event_type = 'STAGE_UPDATED') pe20 on pe20.project_id = prs.id 

where prs.created_at > "2018-10-01" 
and 
(((ptc.collaborator_id in (710,4203,94,4721,4801,4266,4597,4890,5143,4925,3829,3304,285,713,689,4414,5052,5175,5288,4864,1030,4941) or cm.bouncer_id in (710,4203,94,4721,4801,4266,4597,4890,5143,4925,3829,3304,285,713,689,4414,5052,5175,5288,4864,1030,4941)) and city_id not in (5,14,15)) or

(( ptc.collaborator_id in (710,4203,94,4721,4801,4266,4597,4890,5143,4925,3829,3304,285,713,689,4414,5052,5175,5288,4864,1030,4941) or cm.bouncer_id in (710,4203,94,4721,4801,4266,4597,4890,5143,4925,3829,3304,285)) and city_id in (5,14,15))
) 
group by prs.id
