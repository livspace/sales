select 

cm.name as "CM",
monthname(prs.created_at) as "Month",
count(*) as "Total",
sum(case when prs.status="ACTIVE" THEN 1 else 0 end) as "ACTIVE Projects",
sum(case when prs.status IN ("INACTIVE") THEN 1 else 0 end) as "INACTIVE/ONHOLD Projects",
sum(case when st.weight=400 then 1 end) as "DIP",
sum(case when st.weight=250 then 1 end) as "Briefing Done",
sum(case when st.weight=260 then 1 end) as "Proposal Created",
sum(case when st.weight=265 then 1 end) as "Proposal Ready",
sum(case when st.weight=270 then 1 end) as "Leads in Proposal Presented",
sum(case when st.weight=280 then 1 end) as "Leads in Awaiting 10%"

from launchpad_backend.projects prs 

left join launchpad_backend.project_settings ps on ps.project_id=prs.id and ps.is_deleted = 0 
left join launchpad_backend.bouncer_users as cm on ps.primary_cm_id = cm.bouncer_id
left join launchpad_backend.project_stages st on st.id=prs.stage_id

where prs.is_test=false and city_id=1 and prs.created_at >= "2018-09-01"

group by cm.name,monthname(prs.created_at)
