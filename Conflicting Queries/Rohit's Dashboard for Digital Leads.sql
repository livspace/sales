--http://reports.livspace.com/question/2521?gm=ALL&city=ALL&cm=ALL

Select 
prs.project_city,
to_char(prs.project_created_at,'YYYY-MM') as "Month",
count(distinct(case when prs.project_stage_weight>=120 then prs.project_id end)) as "Effective leads",
count(distinct(case when prs.project_stage_weight<=150 and prs.project_status='INACTIVE' then prs.project_id end)) as "Disqualified till PL",
count(distinct(case when prs.project_stage_weight<=150 and prs.project_status='ACTIVE' then prs.project_id end)) as "Active till PL",
count(distinct(case when prs.project_stage_weight>=250 and (prs.project_status in ('ACTIVE','INACTIVE')) then prs.project_id end)) as "BD",
count(distinct(case when prs.project_status='ONHOLD' then prs.project_id end)) as "Total Onhold",
count(distinct(case when prs.project_status='ONHOLD' and DATE_DIFF('days',prs.project_created_at,prs.on_hold_till)<=30 then prs.project_id end)) "ON HOLD (0-30) DAYS",
count(distinct(case when prs.project_status='ONHOLD' and (DATE_DIFF('days',prs.project_created_at,prs.on_hold_till)>30 and DATE_DIFF('days',prs.project_created_at,prs.on_hold_till)<=60) then prs.project_id end)) "ON HOLD (30-60) DAYS",
count(distinct(case when prs.project_status='ONHOLD' and (DATE_DIFF('days',prs.project_created_at,prs.on_hold_till)>60 and DATE_DIFF('days',prs.project_created_at,prs.on_hold_till)<=90) then prs.project_id end)) "ON HOLD (60-90) DAYS",
count(distinct(case when prs.project_status='ONHOLD' and DATE_DIFF('days',prs.project_created_at,prs.on_hold_till)>90 then prs.project_id end)) "ON HOLD (>90) DAYS"

from flat_tables.flat_projects prs 
left join launchpad_backend.projects lbp on prs.project_id=lbp.id
where 
prs.project_created_at>='2019-06-01'::date
and 
(case when lbp.lead_source_id in (15,164) then 0
when lbp.lead_source_id in (163,162,161,174,175,176) then 0
else 1 end )



and is_test_project=0
and 
(case when {{gm}}='ALL' then 1 
when prs.primary_gm={{gm}} then 1 else 0 end)

and 

(case when {{cm}}='ALL' then 1 
when prs.primary_cm={{cm}} then 1 else 0 end)

and 
(case when {{city}}='ALL' then 1 
when prs.project_city={{city}} then 1 else 0 end)
group by 1,2
order by 2
