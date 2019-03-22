select 

prs.project_city as "City",
prs.project_id as "Project ID",
prs.customer_display_name as "Customer Name",
prs.customer_phone as "Mobile No.",
prs.primary_designer as "Designer",
prs.primary_cm as "BM",
prs.primary_gm as "GM",
date(prs.project_created_at) as "Lead created on",
date(tp.created_at) as "10% Collection date",
(case when tp.created_at then TIMESTAMPDIFF(day,prs.project_created_at, tp.created_at) end) as "Age from lead creation to 10% Paid (days)",
(case when tp.created_at and om.created_at  then TIMESTAMPDIFF(day,prs.tp.created_at, om.created_at) end) as "DIP Age from 10% to first order date  (days)",
TIMESTAMPDIFF(day,prs.project_created_at, current_date()) as "Project Age from Lead creation (Days)",
prs.project_stage as "Project Stage",
om.created_at as "Date of 1st PO if partial order confirmed",
"" as "Date of last PO if full order confirmed"



from flat_projects prs

left join (select project_id, min(order_created_at) as "created_at" from flat_orders group by project_id) om on om.project_id=prs.project_id
left join (select id_project as "id_project", sum(amount) as "amount",min(date_add) as "created_at" from flat_credit_transactions where status="4" and payment_stage in ("TEN_PERCENT","PRE_TEN_PERCENT") group by id_project) tp on prs.project_id = tp.id_project

where prs.project_stage_weight in (400,500)

order by prs.project_id desc
