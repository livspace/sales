--http://reports.livspace.com/question/1372

select 
(case 
when project_city like '%angalor%' or project_city like '%yderaba%' or project_city like '%henna%' or project_city like '%une' then project_city
when project_city like '%umba%' or project_city like '%han%' then 'Mumbai'
when project_city like '%urgao%' or project_city like '%wark%' then 'Gurgaon'
when project_city like '%elh%' or project_city like '%arida%' then 'Delhi'
when project_city like '%oid%' or project_city like '%haz%' then 'Noida'
end) as City,
prs.primary_gm as GM,
prs.primary_cm as CM,
to_char(pe1.event_date,'YYYY-MM') as Lead_Assignned_month,
to_char(pe2.event_date,'YYYY-MM') as Briefing_Done_month,
to_char(pe3.event_date,'YYYY-MM') as Proposal_Presented_month,
to_char(pe4.event_date,'YYYY-MM') as DIP_month,
to_char(pe5.event_date,'YYYY-MM') as FOC_month,
to_char(pe6.event_date,'YYYY-MM') as POC_month,
count(distinct prs.project_id)

from flat_tables.flat_projects prs

left join (select project_id as project_id,max(event_date) as event_date from flat_tables.flat_project_events where new_value=17 and event_type = 'STAGE_UPDATED' group by project_id) pe1 on pe1.project_id = prs.project_id 
left join (select project_id as project_id,max(event_date) as event_date from flat_tables.flat_project_events where new_value=9 and event_type = 'STAGE_UPDATED' group by project_id) pe2 on pe2.project_id = prs.project_id 
left join (select project_id as project_id,max(event_date) as event_date from flat_tables.flat_project_events where new_value=21 and event_type = 'STAGE_UPDATED' group by project_id) pe3 on pe3.project_id = prs.project_id 
left join (select project_id as project_id,max(event_date) as event_date from flat_tables.flat_project_events where new_value=4 and event_type = 'STAGE_UPDATED' group by project_id) pe4 on pe4.project_id = prs.project_id 
left join (select project_id as project_id,max(event_date) as event_date from flat_tables.flat_project_events where new_value=5 and event_type = 'STAGE_UPDATED' group by project_id) pe5 on pe5.project_id = prs.project_id 
left join (select project_id as project_id,max(event_date) as event_date from flat_tables.flat_project_events where new_value=14 and event_type = 'STAGE_UPDATED' group by project_id) pe6 on pe6.project_id = prs.project_id 

left join flat_tables.flat_project_settings ps on ps.project_id=prs.project_id 


where 

((pe1.event_date >= (CURRENT_DATE- '6 months'::INTERVAL)) or
(pe2.event_date >= (CURRENT_DATE - '6 Months'::INTERVAL)) or
(pe3.event_date >= (CURRENT_DATE - '6 Months'::INTERVAL)) or
(pe4.event_date >= (CURRENT_DATE - '6 Months'::INTERVAL)) or
(pe5.event_date >= (CURRENT_DATE - '6 Months'::INTERVAL)) or
(pe6.event_date >= (CURRENT_DATE - '6 Months'::INTERVAL))) and ps.primary_gm is not null and prs.project_city is not null


group by 1,2,3,4,5,6,7,8,9
