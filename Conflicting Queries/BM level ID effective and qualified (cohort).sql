--http://reports.livspace.com/question/2050

Select 
prs.primary_cm,
to_char(prs.project_created_at,'YYYY-MM') as Month,
count(distinct(case when prs.project_stage_weight>=110 then project_id end)) as No_of_Effective_leads,
count(distinct(case when prs.project_stage_weight>=130 then project_id end)) as No_of_Qualified_leads,
prs.project_city

from
flat_tables.flat_projects prs
where prs.project_created_at>='2019-01-01'
and is_test_project=0
group by 1,2,5
Order by 5,2,1
