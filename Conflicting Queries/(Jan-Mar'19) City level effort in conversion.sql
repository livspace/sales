--http://reports.livspace.com/question/1989

select 
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
when lower(project_city) like '%sing%' then 'Singapore'
else 'Other'
end) as City,
ps.display_name as Type,
count(distinct (b.project_id)) as Total,
count(distinct(c.project_id)) as Converted


from flat_tables.flat_projects a

left join flat_tables.flat_project_events b
on a.project_id=b.project_id and b.event_date>='2019-01-01'::date and b.event_date<='2019-03-31'::date and b.new_value::int in (1,17,18,22,23,13,9,19,20,21,12)

left join launchpad_backend.project_stages ps on ps.id=b.new_value

left join flat_tables.flat_project_events c
on b.project_id=c.project_id and c.new_value=4 and c.event_date<='2019-06-30'::date

where a.is_test_project=false 



group by 1,2
