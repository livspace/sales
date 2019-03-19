select 

prs.id as "Canvas ID",
prs.customer_display_name as "Customer",
prs.status as "Status",
st.display_name as "Stage",
gm.name as "GM",
cm.name as "BM",
date(tp.created_at) as "10% Collection date",
sum(gmv.amount) as "BGMV",
(case when prs.plan_published=true then "Yes" else "No" end) as "Plan Published?",
(case when ms.project_id is not null then "Yes" end) as "# Project Timelines created",
(case when prs.plan_published=true then "Yes" end) as "# Project Timelines shared with Cx",
ms.milestones as "# Milestones",
ms.completed as "# Completed milestones",
prs.status as "Current Status",
ms.delayed as "# Milestones missed (Completion date > Scheduled date)",
om.created_at as "First PO Date"



from launchpad_backend.projects prs

left join (select id_project, min(date_add) as "created_at" from oms_backend.ps_orders group by id_project) om on om.id_project=prs.id
left join (select id_project as "id_project", sum(amount) as "amount",min(date_add) as "created_at" from fms_backend.ps_transactions where txn_type="CREDIT" and status="4" and payment_stage in ("TEN_PERCENT","PRE_TEN_PERCENT") group by id_project) tp on prs.id = tp.id_project
left join launchpad_backend.project_settings ps on ps.project_id=prs.id and ps.is_deleted = 0 
left join launchpad_backend.bouncer_users as cm on ps.primary_cm_id = cm.bouncer_id
left join launchpad_backend.bouncer_users as dp on ps.primary_designer_id = dp.bouncer_id
left join launchpad_backend.bouncer_users as gm on ps.primary_gm_id = gm.bouncer_id

left join launchpad_backend.project_stages st on st.id=prs.stage_id
left join (select sum(amount) as "amount" ,project_id as "pid" from launchpad_backend.project_gmv_ledger group by project_id) gmv on gmv.pid=prs.id

left join (select project_id,
count(*) as "milestones",
sum(case when current_status="COMPLETE" then 1 end) as "completed",
sum(case when current_status="COMPLETE" and expected_completion_date>updated_at then 1 end) as "delayed"
from launchpad_backend.project_plan_milestones 
where is_deleted=false 
group by project_id) ms on ms.project_id = prs.id 

where prs.status = "ACTIVE" and (st.display_name like "%partial%" or st.display_name like "%design%")
group by prs.id

ORDER BY prs.id desc
