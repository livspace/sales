select 

ct.display_name as "City",
monthname(prs.created_at) as "Month",
count(*) as "Total",
sum(case when ps.weight<110 then 1 else 0 end) as "Unassigned to GMs",
sum(case when ps.weight>=110 then 1 else 0 end) as "Total Effective",
sum(case when ps.weight>=250 then 1 else 0 end) as "Total Qualified",
sum(case when ps.weight>=400 then 1 else 0 end) as "Total Convertions",
sum(case when ps.weight>=110 and lead_source_id in (15,164) then 1 else 0 end) as "R/D Effective",
sum(case when ps.weight>=250 and lead_source_id in (15,164) then 1 else 0 end) as "R/D Qualified",
sum(case when ps.weight>=400 and lead_source_id in (15,164) then 1 else 0 end) as "R/D Convertions",
sum(case when ps.weight>=110 and lead_source_id in (161,162,163) then 1 else 0 end) as "Offline Effective",
sum(case when ps.weight>=250 and lead_source_id in (161,162,163) then 1 else 0 end) as "Offline Qualified",
sum(case when ps.weight>=400 and lead_source_id in (161,162,163) then 1 else 0 end) as "Offline Convertions"


from launchpad_backend.projects prs  

join launchpad_backend.cities ct on ct.id=prs.city_id

join launchpad_backend.project_stages ps on ps.id=prs.stage_id

where prs.created_at >= "2018-09-01" and prs.id not in (select prs.id from launchpad_backend.projects prs 
left join launchpad_backend.project_to_collaborators ptc on prs.id = ptc.project_id 
left join launchpad_backend.bouncer_users bu on bu.bouncer_id = ptc.collaborator_id 
where bu.name like "%Navi M%" group by prs.id)

group by ct.display_name,monthname(prs.created_at)
