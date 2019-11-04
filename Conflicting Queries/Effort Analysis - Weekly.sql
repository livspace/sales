--http://reports.livspace.com/question/1371

select 
prs.project_city as City,
prs.primary_gm as GM,
prs.primary_cm as CM,
DatePart(week, pe1.event_date) as Lead_Assignned_Week,
DatePart(week, pe2.event_date) as Briefing_Done_Week,
DatePart(week, pe3.event_date) as Proposal_Presented_Week,
DatePart(week, pe4.event_date) as DIP_Week,
DatePart(week, pe5.event_date) as FOC_Week,
DatePart(week, pe6.event_date) as POC_Week,
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

((pe1.event_date BETWEEN current_date -INTERVAL '4 WEEK' AND current_date ) or
(pe2.event_date BETWEEN current_date -INTERVAL '4 WEEK' AND current_date ) or
(pe3.event_date BETWEEN current_date -INTERVAL '4 WEEK' AND current_date ) or
(pe4.event_date BETWEEN current_date -INTERVAL '4 WEEK' AND current_date ) or
(pe5.event_date BETWEEN current_date -INTERVAL '4 WEEK' AND current_date ) or
(pe6.event_date BETWEEN current_date -INTERVAL '4 WEEK' AND current_date )) and ps.primary_gm is not null and prs.project_city is not null


group by 1,2,3,4,5,6,7,8,9
