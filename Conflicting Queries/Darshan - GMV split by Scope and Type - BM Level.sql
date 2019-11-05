--http://reports.livspace.com/question/1725

select 

prs.primary_cm as primary_cm,
prs.project_service_type,
prs.brief_scope,
count(distinct prs.project_id) as total_effective,
count(distinct(case when prs.project_status='INACTIVE' then prs.project_id end)) as disqualified,
count(distinct(case when prs.project_stage_weight >=270 then prs.project_id end)) as pitched,
count(distinct(case when prs.project_stage_weight >=400 then prs.project_id end)) as converted,
sum(tp.amount) as BGMV

from flat_tables.flat_projects prs

left join launchpad_backend.project_bgmvs tp on tp.project_id=prs.project_id

where prs.project_city like '%umba%' or prs.project_city like '%han%'

group by 1,2,3

order by 1
