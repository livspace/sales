--http://reports.livspace.com/question/2198

select 
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,

prs.primary_designer,
to_char(pe1.event_date,'YYYY-MM') as prospective_lead,
to_char(pe2.event_date,'YYYY-MM') as Briefing_Done,
to_char(pe3.event_date,'YYYY-MM') as Proposal_Presented,
to_char(pe4.event_date,'YYYY-MM') as DIP_month,
count(distinct prs.project_id)

from flat_tables.flat_projects prs

left join (select project_id as project_id,max(event_date) as event_date from flat_tables.flat_project_events where new_value=13 and event_type = 'STAGE_UPDATED' group by project_id) pe1 on pe1.project_id = prs.project_id 
left join (select project_id as project_id,max(event_date) as event_date from flat_tables.flat_project_events where new_value=9 and event_type = 'STAGE_UPDATED' group by project_id) pe2 on pe2.project_id = prs.project_id 
left join (select project_id as project_id,max(event_date) as event_date from flat_tables.flat_project_events where new_value=21 and event_type = 'STAGE_UPDATED' group by project_id) pe3 on pe3.project_id = prs.project_id 
left join (select project_id as project_id,max(event_date) as event_date from flat_tables.flat_project_events where new_value=4 and event_type = 'STAGE_UPDATED' group by project_id) pe4 on pe4.project_id = prs.project_id 

where 

((pe1.event_date >= (CURRENT_DATE- '9 months'::INTERVAL)) or
(pe2.event_date >= (CURRENT_DATE - '9 Months'::INTERVAL)) or
(pe3.event_date >= (CURRENT_DATE - '9 Months'::INTERVAL)) or
(pe4.event_date >= (CURRENT_DATE - '9 Months'::INTERVAL)))

group by 1,2,3,4,5,6
