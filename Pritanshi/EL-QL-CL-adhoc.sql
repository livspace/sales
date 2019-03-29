select 
project_property_name,
pr.project_city as "City",
sum(case when project_stage_weight>=0 then 1 else 0 end) as "Potential",
sum(case when project_stage_weight>=250 then 1 else 0 end) as "Qualified",
sum(case when project_stage_weight>=400 then 1 else 0 end) as "Converted"

from 
flat_tables.flat_projects pr 

where 
pr.`is_test_project`=0 
and lower(project_property_name) like "%satya%platina%" or
lower(project_property_name) like "%satya%hermitage%"
and project_city = "Gurgaon"
group by 1,2
;
