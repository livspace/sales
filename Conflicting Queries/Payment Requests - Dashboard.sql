--http://reports.livspace.com/question/1955

select 
c.display_name as "City",
pr.id_project as "Project ID",
p.customer_display_name as "Customer Name", 
ua.company_name as "Vendor Name",
pr.source_type_id as "Order ID",
pr.id as "Payout Request ID",
Round(((oo.total_price+oo.total_tax)/(1-oo.margin/100))+oo.handling_fee) as "Cx price with handling fee",
oops.stage_name as "Payment Stage",
pr.status as "Payment Status",
w.balance as "Project Balance",
date(pr.date_add),
lbp.primary_designer as "Primary Designer",
lbp.primary_cm as "Primary BM",
lbp.primary_gm as "Primary GM",
fps.primary_pm as "Primary PM",
pr.amount as "Amount Requested"

from fms_backend.payout_request pr
-- left join to get the order value 
left join boq_backend.oms_orders oo on pr.source_type_id=oo.id and oo.is_deleted=0
-- left join to get the customer name
left join launchpad_backend.projects p on pr.id_project=p.id
left join flat_tables.flat_projects lbp on pr.id_project=lbp.project_id
-- left join to get the city name 
left join launchpad_backend.projects ps on pr.id_project=ps.id
left join launchpad_backend.cities c on ps.city_id=c.id
-- left join to get the vendor name
left join boq_backend.user_attributes ua on pr.payee_type_id=ua.bouncer_id
-- left join to get the payment stages 
left join boq_backend.oms_order_payment_stages oops on pr.payment_stage=oops.id
left join flat_tables.flat_projects fp on p.id=fp.project_id
left join flat_tables.flat_project_settings fps on fps.project_id=fp.project_id
left join fms_backend.wallet w on p.id=w.type_id
-- where oo.total_price is not NULL and oo.total_price <>0 
where oo.is_deleted=0 and (TIMESTAMP_CMP_DATE(oo.created_at,'2019-01-01'))=1 and pr.status not in ('APPROVED')
order by pr.date_upd 
