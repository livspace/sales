--http://reports.livspace.com/question/2108

Select 

prs.project_id,
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
to_char(fms.Ten_Percent_date,'YYYY-MM-DD') as Ten_Percent_date,
to_char(b.event_date,'YYYY-MM-DD') as DIP_date,
to_char(c.event_date,'YYYY-MM-DD') as POC_date,
to_char(d.event_date,'YYYY-MM-DD') as FOC_date,
prs.project_status


from flat_tables.flat_projects prs

left join (Select id_project,min(date_txn) as Ten_Percent_date from fms_backend.ps_transactions group by 1) as fms on fms.id_project=prs.project_id

left join flat_tables.flat_project_events b on prs.project_id=b.project_id and b.new_value=4

left join flat_tables.flat_project_events c on prs.project_id=c.project_id and c.new_value=5

left join flat_tables.flat_project_events d on prs.project_id=d.project_id and d.new_value=10

where c.event_date>='2019-06-01' and prs.is_test_project=0

order by 5
