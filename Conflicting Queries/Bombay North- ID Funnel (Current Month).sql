--http://reports.livspace.com/question/2308

select 

dp.name as Designer,
sum(case when ps.weight>=110 then 1 else 0 end) as Total_Effective,
sum(case when ps.weight>=250 then 1 else 0 end) as Qualified,
(sum(case when ps.weight>=250 then 1 else 0 end)::numeric/nullif(sum(case when ps.weight>=110 then 1 else 0 end)::numeric,0))*100 as Qualification_Percentage,
sum(case when ps.weight >=270 then 1 else 0 end) as Pitched,
(sum(case when ps.weight >=270 then 1 else 0 end)::numeric/nullif(sum(case when ps.weight>=250 then 1 else 0 end)::numeric,0))*100 as QL_to_Pitch_Percentage,
sum(case when ps.weight>=400 then 1 else 0 end) as Converted,
(sum(case when ps.weight>=400 then 1 else 0 end)::numeric/nullif(sum(case when ps.weight >=270 then 1 else 0 end)::numeric,0))*100 as Pitch_to_Converted_Percentage

from 

launchpad_backend.projects prs 
left join flat_tables.flat_projects fps on prs.id=fps.project_id
left join launchpad_backend.project_settings pss on pss.project_id=prs.id and pss.is_deleted = 0 
left join launchpad_backend.bouncer_users as dp on pss.primary_designer_id = dp.bouncer_id
join launchpad_backend.project_stages ps on ps.id=prs.stage_id
join launchpad_backend.cities ct on prs.city_id=ct.id

where (lower(ct.display_name) like '%mumb%' or lower(ct.display_name) like '%thane%')

and fps.primary_cm in ('Sampada Karmarkar','Gourav Goyal','Nikhil Malpani','Rahul Jain','Charu Gupta','Praneet  Singh')

and (prs.pincode=400078 or prs.pincode=400079 or prs.pincode=400080 or prs.pincode=400081 or prs.pincode=400082 or prs.pincode=400083 or prs.pincode=400084 or prs.pincode=400086 or prs.pincode=400086 or prs.pincode=400088 or prs.pincode=400089 or prs.pincode=400090 or prs.pincode=400091 or prs.pincode=400092 or prs.pincode=400093 or prs.pincode=400095 or prs.pincode=400096 or prs.pincode=400097 or prs.pincode=400098 or prs.pincode=400099 or prs.pincode=400101 or prs.pincode=400102 or prs.pincode=400103 or prs.pincode=400104 or prs.pincode=400601 or prs.pincode=400602 or prs.pincode=400603 or prs.pincode=400604 or prs.pincode=400606 or prs.pincode=400607 or prs.pincode=400608 or prs.pincode=400609 or prs.pincode=400610)


AND 

prs.created_at >= date_trunc('month', current_date)

group by 1

having sum(case when ps.weight>=110 then 1 else 0 end)>=1
