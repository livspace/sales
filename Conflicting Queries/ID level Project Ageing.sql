--http://reports.livspace.com/question/2467?from=2019-10-01&end=2019-10-15&status=ACTIVE&designer_name=Gurneet

select
prs.project_id as "Canvas Id",
prs.customer_display_name as "Client Name",
prs.customer_phone as "Phone number",
prs.project_stage as "Project Stage",
lbp.last_note as "Last Note",
lbp.conversion_probability "Conversion Probability",
max(pvs2.event_date) as "Last update date",
date_diff('day',"Last update date",current_date) as "Ageing"

from 
flat_tables.flat_projects prs 
left join launchpad_backend.projects lbp on prs.project_id=lbp.id
left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id and pvs.new_value=23 
left join flat_tables.flat_project_events pvs2 on prs.project_id=pvs2.project_id
where date(pvs.event_date)>={{from}} and date(pvs.event_date)<={{end}} and prs.project_status={{status}}
and prs.primary_designer={{designer_name}} and prs.primary_gm='Vinay Jaisingh'

group by 1,2,3,4,5,6
