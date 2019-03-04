select prs.id as "Project ID",
prs.customer_display_name as "Customer Name",
dp.name as "Designer Name",
cm.name as "BM Name",
gm.name as "GM",
(case) as "# Project Timelines created"
-- (case) as "# Project Timelines shared with Cx",
-- (case) as "# Milestones",
-- (case) as "# Completed milestones",
-- prs.status as "Current Status",
-- (case ) as "# Milestones missed (Completion date > Scheduled date)",
--  as "Time taken in 10-50% stage",
 


from launchpad_backend.projects prs 

left join launchpad_backend.project_settings ps on ps.project_id=prs.id and ps.is_deleted = 0 
left join launchpad_backend.bouncer_users as cm on ps.primary_cm_id = cm.bouncer_id
left join launchpad_backend.bouncer_users as dp on ps.primary_designer_id = dp.bouncer_id
left join launchpad_backend.bouncer_users as gm on ps.primary_gm_id = gm.bouncer_id

