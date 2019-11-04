--http://reports.livspace.com/question/2228

select
prs.primary_cm,
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
count(distinct(prs.project_id)) as total_leads,
count(distinct(case when lower(lpb.conversion_probability) like '%high%' then prs.project_id end)) as no_of_high_leads,
count(distinct(case when lower(lpb.conversion_probability) like '%medium%' then prs.project_id end))as no_of_medium_leads,
count(distinct(case when lower(lpb.conversion_probability) like '%low' then prs.project_id end))as no_of_low_leads

from flat_tables.flat_projects prs
left join launchpad_backend.projects lpb on prs.project_id=lpb.id
left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id 
where pvs.new_value=18 and pvs.event_date>=date_trunc('month',CURRENT_DATE) and prs.is_test_project=0
group by 1,2
