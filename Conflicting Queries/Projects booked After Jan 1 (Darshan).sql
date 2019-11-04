--http://reports.livspace.com/question/2222

select 
prs.project_id as "Canvas id",
prs.project_city,
prs.primary_gm as "GM",
prs.primary_cm as "BM",
prs.primary_designer "Designer",
prs.customer_display_name as "Client Name",
prs.brief_scope as "Scope",
prs.project_property_name as "Property name",
prs.project_property_type "Property type",
lpb.estimated_value as "Estimated Value",
date(pvs.event_date) as "DIP date",
date(fpp.ten_percent_payment_date) as "10% Date",
(fpp.ten_percent_payment) as "10% Amount"

from flat_tables.flat_projects prs
left join flat_tables.flat_project_payments fpp on fpp.id_project=prs.project_id

left join launchpad_backend.projects lpb on prs.project_id=lpb.id 
left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id and pvs.new_value=4

where pvs.event_date>='2019-01-01' and prs.is_test_project=0 and lower(prs.project_city) like '%hyderabad%'
group by 1,2,3,4,5,6,7,8,9,10,11,12,13
