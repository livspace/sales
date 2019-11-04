(select  

'Created' as Base,
primary_cm as bm,
to_char(project_created_at,'YYYY-MM') as month,
(case when prs.lead_medium_id in (167) then 'Referral'
when prs.lead_medium_id in (171) then 'Walk-In'
when (prs.lead_source_id in (164) and prs.lead_medium_id not in (167)) then 'Direct'
when prs.lead_source_id in ( 163,162,161) and prs.lead_medium_id not in (167) then 'Offline'
else 'Digital' end) AS Source,
avg(case when bd.event_date is not null then DATEDIFF(day,prs.project_created_at, bd.event_date) end) as LC_BD,
avg(case when bd.event_date is not null and pp.event_date is not null then DATEDIFF(day,bd.event_date,pp.event_date) end) as BD_PP,
avg(case when  pp.event_date is not null and dip.event_date is not null then DATEDIFF(day,pp.event_date,dip.event_date) end) as PP_DIP,
avg(case when  poc.event_date is not null and dip.event_date is not null then DATEDIFF(day,dip.event_date,poc.event_date) end) as DIP_POC,
avg(case when  foc.event_date is not null and dip.event_date is not null then DATEDIFF(day,dip.event_date,foc.event_date) end) as DIP_FOC

from flat_tables.flat_projects prs

left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%brefing_done%') bd on bd.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%proposal_presented%') pp on pp.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%design_in_progress%') dip on dip.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%50_percent_collected%') poc on poc.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%full_order_confirmed%') foc on foc.project_id=prs.project_id


where prs.project_created_at  >= '2018-12-01'::date and primary_cm is not null and primary_cm not like '%test%' and lower(project_city) not like '%singapo%' and prs.is_test_project=false

 

group by 2,3,4)

union 

(select  

'Created' as Base,
primary_cm as bm,
to_char(project_created_at,'YYYY-MM') as month,
'Cumulati' AS Source,
avg(case when bd.event_date is not null then DATEDIFF(day,prs.project_created_at, bd.event_date) end) as LC_BD,
avg(case when bd.event_date is not null and pp.event_date is not null then DATEDIFF(day,bd.event_date,pp.event_date) end) as BD_PP,
avg(case when  pp.event_date is not null and dip.event_date is not null then DATEDIFF(day,pp.event_date,dip.event_date) end) as PP_DIP,
avg(case when  poc.event_date is not null and dip.event_date is not null then DATEDIFF(day,dip.event_date,poc.event_date) end) as DIP_POC,
avg(case when  foc.event_date is not null and dip.event_date is not null then DATEDIFF(day,dip.event_date,foc.event_date) end) as DIP_FOC

from flat_tables.flat_projects prs

left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%brefing_done%') bd on bd.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%proposal_presented%') pp on pp.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%design_in_progress%') dip on dip.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%50_percent_collected%') poc on poc.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%full_order_confirmed%') foc on foc.project_id=prs.project_id


where prs.project_created_at  >= '2018-12-01'::date and primary_cm is not null and primary_cm not like '%test%' and lower(project_city) not like '%singapo%' and prs.is_test_project=false
 

group by 2,3,4)


union 


(select  

'Converted' as Base,
primary_cm as bm,
to_char(dip.event_date,'YYYY-MM') as month,
'Cumulati' AS Source,
avg(case when bd.event_date is not null then DATEDIFF(day,prs.project_created_at, bd.event_date) end) as LC_BD,
avg(case when bd.event_date is not null and pp.event_date is not null then DATEDIFF(day,bd.event_date,pp.event_date) end) as BD_PP,
avg(case when pp.event_date is not null and dip.event_date is not null then DATEDIFF(day,pp.event_date,dip.event_date) end) as PP_DIP,
avg(case when  poc.event_date is not null and dip.event_date is not null then DATEDIFF(day,dip.event_date,poc.event_date) end) as DIP_POC,
avg(case when  foc.event_date is not null and dip.event_date is not null then DATEDIFF(day,dip.event_date,foc.event_date) end) as DIP_FOC

from flat_tables.flat_projects prs

left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%brefing_done%') bd on bd.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%proposal_presented%') pp on pp.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%design_in_progress%') dip on dip.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%50_percent_collected%') poc on poc.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%full_order_confirmed%') foc on foc.project_id=prs.project_id


where prs.project_created_at  >= '2018-12-01'::date and primary_cm is not null and primary_cm not like '%test%' and lower(project_city) not like '%singapo%' and prs.is_test_project=false
 

group by 2,3,4)


union



(select  

'POC' as Base,
primary_cm as bm,
to_char(poc.event_date,'YYYY-MM') as month,
'Cumulati' AS Source,
avg(case when bd.event_date is not null then DATEDIFF(day,prs.project_created_at, bd.event_date) end) as LC_BD,
avg(case when bd.event_date is not null and pp.event_date is not null then DATEDIFF(day,bd.event_date,pp.event_date) end) as BD_PP,
avg(case when pp.event_date is not null and dip.event_date is not null then DATEDIFF(day,pp.event_date,dip.event_date) end) as PP_DIP,
avg(case when  poc.event_date is not null and dip.event_date is not null then DATEDIFF(day,dip.event_date,poc.event_date) end) as DIP_POC,
avg(case when  foc.event_date is not null and dip.event_date is not null then DATEDIFF(day,dip.event_date,foc.event_date) end) as DIP_FOC

from flat_tables.flat_projects prs

left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%brefing_done%') bd on bd.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%proposal_presented%') pp on pp.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%design_in_progress%') dip on dip.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%50_percent_collected%') poc on poc.project_id=prs.project_id
left join (select project_id as project_id, event_date as event_date from flat_tables.flat_project_events where new_value_name like '%full_order_confirmed%') foc on foc.project_id=prs.project_id


where prs.project_created_at  >= '2018-12-01'::date and primary_cm is not null and primary_cm not like '%test%' and lower(project_city) not like '%singapo%' and prs.is_test_project=false
 

group by 2,3,4)
