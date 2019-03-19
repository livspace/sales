
select pr.project_id,
city.`display_name`as City,
pr.`project_status` as 'status',
pr.`primary_cm` as " Primary CM",
pr.`primary_gm` as " Primary GM ",
pr.`primary_designer` as " Primary ID/DP",
"BoQ_shared_on", first_boq as "First_BOQ_amount", 
budget_min, 
budget_max
from flat_tables.flat_projects pr
left join
(select project_id, min(created_at) as "BoQ_shared_on", (total_price - discount + handling_fee) as first_boq  
from 
boq_backend.pf_proposal
group by project_id
) bq
on pr.project_id
where 
pr.`is_test_project`=0 and pr.`project_created_at`>='2018-10-01'

