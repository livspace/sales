--http://reports.livspace.com/question/2219

Select 
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
prs.primary_gm,
prs.primary_cm as "BM",
to_char(pvs.event_date,'YYYY-MM') as "CM ASSIGNED DATE",
to_char(pvs2.event_date,'YYYY-MM') as "BCS Date",
to_char(pvs3.event_date,'YYYY-MM') as "PL date ",
to_char(pvs4.event_date,'YYYY-MM') as "BD date",
to_char(pvs5.event_date,'YYYY-MM') as "PP DATE",
to_char(pvs6.event_date,'YYYY-MM') as "DIP DATE",
count(distinct(prs.project_id))

from flat_tables.flat_projects prs
left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id and pvs.new_value=18
left join flat_tables.flat_project_events pvs2 on pvs.project_id=pvs2.project_id and pvs2.new_value=23
left join flat_tables.flat_project_events pvs3 on pvs.project_id=pvs3.project_id and pvs3.new_value=13
left join flat_tables.flat_project_events pvs4 on pvs.project_id=pvs4.project_id and pvs4.new_value=9
left join flat_tables.flat_project_events pvs5 on pvs.project_id=pvs5.project_id and pvs5.new_value=21
left join flat_tables.flat_project_events pvs6 on pvs.project_id=pvs6.project_id and pvs6.new_value=4


where (pvs.event_date>='2019-01-01'::date or pvs2.event_date>='2019-01-01'::date or pvs3.event_date>='2019-01-01'::date or pvs4.event_date>='2019-01-01'::date or 
pvs5.event_date>='2019-01-01'::date or pvs6.event_date>='2019-01-01'::date)

group by 1,2,3,4,5,6,7,8,9
