select 

cm.name as "BM",
sum(case when ps.weight>=110 then 1 else 0 end) as "Total Effective",
sum(case when ps.weight>=250 then 1 else 0 end) as "Qualified",
(sum(case when ps.weight>=250 then 1 else 0 end)/sum(case when ps.weight>=110 then 1 else 0 end))*100 as "Qualification %",
sum(case when ps.weight >=270 then 1 else 0 end) as "Pitched",
(sum(case when ps.weight >=270 then 1 else 0 end)/sum(case when ps.weight>=250 then 1 else 0 end))*100 as "Pitch to QL %",
sum(case when ps.weight>=300 then 1 else 0 end) as "Converted",
(sum(case when ps.weight>=300 then 1 else 0 end)/sum(case when ps.weight >=270 then 1 else 0 end))*100 as "Converted to Pitch %"



from launchpad_backend.projects prs  



join launchpad_backend.project_stages ps on ps.id=prs.stage_id
join launchpad_backend.cities ct on ct.id=prs.city_id

left join launchpad_backend.project_settings pss on pss.project_id=prs.id and pss.is_deleted = 0 
left join launchpad_backend.bouncer_users as cm on pss.primary_cm_id = cm.bouncer_id

where monthname(prs.created_at) = monthname(current_date()) and year(prs.created_at)=year(current_date()) and ct.name like "%bang%" and cm.name is not null

group by cm.name 

having sum(case when ps.weight>=110 then 1 else 0 end)>5
