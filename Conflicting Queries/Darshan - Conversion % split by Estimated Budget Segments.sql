--http://reports.livspace.com/question/1729

select 
fps.primary_designer as designer,
fps.primary_cm as BM,
count(distinct(case when prs.estimated_value < 500000 and prs.estimated_value >=0 then prs.id end)) as b1,
count(distinct(case when prs.estimated_value < 1000000 and prs.estimated_value >=500000 then prs.id end )) as b2,
count(distinct(case when prs.estimated_value < 1500000 and prs.estimated_value >=1000000 then prs.id end )) as b3,
count(distinct(case when prs.estimated_value < 2000000 and prs.estimated_value >=1500000 then prs.id end )) as b4,
count(distinct(case when prs.estimated_value < 3000000 and prs.estimated_value >=2000000 then prs.id end )) as b5,
count(distinct(case when prs.estimated_value < 5000000 and prs.estimated_value >=3000000 then prs.id end )) as b6,
count(distinct(case when prs.estimated_value >=5000000 then 1 end )) as b7

from launchpad_backend.projects prs

left join launchpad_backend.cities ct on ct.id=prs.city_id
left join launchpad_backend.project_stages ps on ps.id=prs.stage_id
left join flat_tables.flat_project_settings fps on fps.project_id=prs.id
where ps.weight>=400 and (ct.display_name like '%umba%' or ct.display_name like '%han%')

group by 1,2
