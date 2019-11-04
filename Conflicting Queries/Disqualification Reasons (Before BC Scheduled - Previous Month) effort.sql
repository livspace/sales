--http://reports.livspace.com/question/2001

select 

prs.primary_cm,
count(distinct prs.project_id) as "Total Inactive",
(count(distinct(case when prs.inactivation_reason like '%services%' then prs.project_id end))*100)/count(distinct prs.project_id) as "Services %",
(count(distinct(case when prs.inactivation_reason like '%rnr%' then prs.project_id end))*100)/count(distinct prs.project_id) as "RNR %",
(count(distinct(case when prs.inactivation_reason like '%posted_by_mistake%' then prs.project_id end))*100)/count(distinct prs.project_id) as "Posted By Mistake %",
(count(distinct(case when prs.inactivation_reason like '%city_not_serviceable%' then prs.project_id end))*100)/count(distinct prs.project_id) as "City Not Serviceable %",
(count(distinct(case when prs.inactivation_reason like '%budget%' then prs.project_id end))*100)/count(distinct prs.project_id) as "Budget %"

from flat_tables.flat_projects prs 
left join launchpad_backend.project_events pvs on prs.project_id=pvs.project_id and pvs.new_value='INACTIVE'

where (lower(prs.primary_cm) LIKE '%chandani%' or lower(prs.primary_cm) LIKE '%azharuddin%' or lower(prs.primary_cm) LIKE '%abhishek sharma%' or lower(prs.primary_cm) LIKE '%naufil%'
or lower(prs.primary_cm) LIKE '%natasha%' or lower(prs.primary_cm) LIKE '%jolly%'
or lower(prs.primary_cm) LIKE '%vidyuth%' or lower(prs.primary_cm) LIKE '%nidhi agarwal%' or lower(prs.primary_cm) LIKE '%aditi mukherjee%') 
and prs.project_stage_weight<130 and prs.project_status='INACTIVE' and ((pvs.created_at>= date_trunc('month', current_date- Interval '1 Month')) and (pvs.created_at < date_trunc('month', current_date)))

group by 1
