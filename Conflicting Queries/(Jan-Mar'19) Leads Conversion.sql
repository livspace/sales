--http://reports.livspace.com/question/2003

select 

date(prs.project_created_at) as "Lead Creation Date",
prs.project_id as "Project ID",
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
(case when lower(prs.brief_scope) like '%modular%' then 'KnW' else 'FHD' end) as "Scope KnW/FHD",
prs.budget_min as "Minimum Budget",
prs.budget_max as "Maximum Budget",
lbp.estimated_value as "Estimated Project Value",
prs.project_service_type as "Service Type",
prs.project_property_type as "Property Type",
bq.first_boq as "BOQ Value",
ps.display_name as "Current Stage",
date(prs.design_in_progress) as "Converted Date"


from flat_tables.flat_projects prs

left join launchpad_backend.projects lbp on lbp.id=prs.project_id

left join
(select project_id, min(created_at) as "BoQ_shared_on", sum(total_price - discount + handling_fee) as first_boq  
from 
boq_backend.pf_proposal

where deleted_at is not null

group by project_id
) bq
on prs.project_id = bq.project_id


left join (SELECT *
FROM 
(SELECT project_id, 
        new_value,new_value_name,
        rank() OVER (PARTITION BY project_id ORDER BY event_date desc) AS project_id_ranked
 FROM flat_tables.flat_project_events where event_date>='2019-01-01'::date and event_date<='2019-07-01' ORDER BY event_date desc
) AS ranked
WHERE ranked.project_id_ranked = 1) cs on cs.project_id=prs.project_id

left join launchpad_backend.project_stages ps on ps.id=cs.new_value

where prs.project_created_at>= '2019-01-01'::date and prs.project_created_at<= '2019-03-31'::date
