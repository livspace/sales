--http://reports.livspace.com/question/2104

select 

(case 
when project_city like '%angalor%' or project_city like '%yderaba%' or project_city like '%henna%' or project_city like '%une' then project_city
when project_city like '%umba%' or project_city like '%han%' then 'Mumbai'
when project_city like '%urgao%' or project_city like '%wark%' then 'Gurgaon'
when project_city like '%elh%' or project_city like '%arida%' then 'Delhi'
when project_city like '%oid%' or project_city like '%haz%' then 'Noida'
end) as City,
to_char(prs.project_created_at,'YYYY-MM') as month,
primary_designer as primary_designer,
count(*) as Total,
sum(case when prs.project_stage_weight>=150 then 1 else 0 end) as "PL or Beyond ",
sum(case when prs.project_stage_weight>=250 then 1 else 0 end) as "BD or Beyond",
sum(case when prs.project_stage_weight>=270 then 1 else 0 end) as "PP or Beyond",
sum(case when prs.project_stage_weight>=400 then 1 else 0 end) as "DIP or Beyond"

from flat_tables.flat_projects prs  

where prs.project_created_at >= '2018-12-01'::date and prs.is_test_project =false

group by 1,2,3
