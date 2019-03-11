select 

prs.id as "Canvas ID",
prs.customer_display_name as "Customer",
prs.status as "Status",
st.display_name as "Stage",
gm.name as "GM",
cm.name as "BM",
date(tp.created_at) as "10% Collection date",
sum(gmv.amount) as "BGMV",
(case when prs.plan_published=true then "Yes" else "No" end) as "Plan Published?"



from projects prs


left join launchpad_backend.project_settings ps on ps.project_id=prs.id and ps.is_deleted = 0 
left join launchpad_backend.bouncer_users as cm on ps.primary_cm_id = cm.bouncer_id
left join launchpad_backend.bouncer_users as dp on ps.primary_designer_id = dp.bouncer_id
left join launchpad_backend.bouncer_users as gm on ps.primary_gm_id = gm.bouncer_id


