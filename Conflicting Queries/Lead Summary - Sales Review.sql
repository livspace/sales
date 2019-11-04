--http://reports.livspace.com/question/1475

select 

(case 
when project_city like '%angalor%' or project_city like '%yderaba%' or project_city like '%henna%' or project_city like '%une' then project_city
when project_city like '%umba%' or project_city like '%han%' then 'Mumbai'
when project_city like '%urgao%' or project_city like '%wark%' then 'Gurgaon'
when project_city like '%elh%' or project_city like '%arida%' then 'Delhi'
when project_city like '%oid%' or project_city like '%haz%' then 'Noida'
end) as City,
to_char(prs.project_created_at,'YYYY-MM') as month,
primary_gm as GM,
primary_cm as BM,
count(*) as Total,
sum(case when prs.project_stage_weight<110 then 1 else 0 end) as Unassigned_to_GMs,
sum(case when prs.project_stage_weight>=110 then 1 else 0 end) as Total_Effective,
sum(case when prs.project_stage_weight>=250 then 1 else 0 end) as Total_Qualified,
sum(case when prs.project_stage_weight>=400 then 1 else 0 end) as Total_Convertions,
sum(case when prs.project_stage_weight>=110 and lead_medium_id in (167) then 1 else 0 end) as R_Effective,
sum(case when prs.project_stage_weight>=250 and lead_medium_id in (167) then 1 else 0 end) as R_Qualified,
sum(case when prs.project_stage_weight>=400 and lead_medium_id in (167)  then 1 else 0 end) as R_Convertions,
sum(case when prs.project_stage_weight>=110 and lead_source_id in (161,162,163) and lead_medium_id not in (167) AND lead_medium_id NOT in (171) then 1 else 0 end) as Offline_Effective,
sum(case when prs.project_stage_weight>=250 and lead_source_id in (161,162,163) and lead_medium_id not in (167) AND lead_medium_id NOT in (171)  then 1 else 0 end) as Offline_Qualified,
sum(case when prs.project_stage_weight>=400 and lead_source_id in (161,162,163) and lead_medium_id not in (167) AND lead_medium_id NOT in (171)  then 1 else 0 end) as Offline_Convertions,

sum(case when prs.project_stage_weight>=110 and ((lead_source_id in (164) and lead_medium_id not in (167,171))) then 1 else 0 end) as D_Effective,
sum(case when prs.project_stage_weight>=250 and ((lead_source_id in (164) and lead_medium_id not in (167,171))) then 1 else 0 end) as D_Qualified,
sum(case when prs.project_stage_weight>=400 and ((lead_source_id in (164) and lead_medium_id not in (167,171))) then 1 else 0 end) as D_Convertions,

sum(case when prs.project_stage_weight>=110 and lead_medium_id in (171) then 1 else 0 end) as W_Effective,
sum(case when prs.project_stage_weight>=250 and lead_medium_id in (171) then 1 else 0 end) as W_Qualified,
sum(case when prs.project_stage_weight>=400 and lead_medium_id in (171) then 1 else 0 end) as W_Convertions

from flat_tables.flat_projects prs  

where prs.project_created_at >= '2018-12-01'::date and prs.is_test_project =false

group by 1,2,3,4
