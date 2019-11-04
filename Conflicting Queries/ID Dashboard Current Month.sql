--http://reports.livspace.com/question/2029

Select
prs.primary_designer as ID,
(case when 
lower(prs.project_designer_email) like '%.dp@%' then 'DP' else 'ID' end) as Type_of_ID,
count(distinct(case when prs.project_created_at>=date_trunc('month',current_date) and prs.project_stage_weight<400 then prs.project_id end)) as "Total_Incoming_lead(10-50% )",
count(distinct(case when pvs.new_value=23 then prs.project_id end) ) as Qualified_Lead,
count(distinct(case when pvs.new_value=21 then prs.project_id end) ) as Pitches,
count(distinct(case when pvs.new_value=4 then prs.project_id end)) as Conversions,
count(distinct(case when prs.project_stage_weight>=400 and prs.project_stage_weight<=500 then prs.project_id end)) as Total_DIP_POC,
count(distinct(case when prs.project_stage_weight>=400 and prs.project_stage_weight<=500 
and lower(prs.project_status)='on hold' then prs.project_id end)) as Total_DIP_POC_On_Hold


from flat_tables.flat_projects prs

left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id and pvs.event_date>=date_trunc('month',current_date)

group by 1,2

