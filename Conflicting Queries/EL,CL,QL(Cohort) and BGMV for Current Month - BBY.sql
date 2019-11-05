--http://reports.livspace.com/question/2306

select 
pr.project_pincode as Pincode,
count(distinct(case when project_stage_weight>=110 and pr.project_created_at > current_date - interval '1 month' then pr.project_id else 0 end)) as Effective,
count(distinct(case when project_stage_weight>=250 and pr.project_created_at > current_date - interval '1 month' then pr.project_id else 0 end)) as Qualified,
count(distinct(case when project_stage_weight>=400 and pr.project_created_at > current_date - interval '1 month' then pr.project_id else 0 end)) as Converted,
sum(bgm.amount) as BGMV

from 
flat_tables.flat_projects pr

left join launchpad_backend.project_bgmvs bgm on bgm.project_id=pr.project_id and bgm.logged_month > current_date - interval '1 month'

where 
pr.is_test_project=0 and pr.project_pincode>0
and (lower(pr.project_city) like '%mumb%' or lower(pr.project_city) like '%thane%')
group by 1
ORDER BY count(distinct(case when project_stage_weight>=110 then pr.project_id else 0 end)) DESC
