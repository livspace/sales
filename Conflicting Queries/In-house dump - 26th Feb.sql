--http://reports.livspace.com/question/2013

select 	
max(rfqi.id) as rfq_item_id,	
rfq.id as RFQ_ID,	
rfq."project_id",	
listagg(distinct pr.customer_display_name) as customer_name,	
rfqi."name" as "item_name",	
rfqi."description" as "item_description",	
rfqi."quantity",	
city."display_name" as City,	
ua."company_name" as "sp_name",	
rfq."published_at" as "rfq_published_at",	
sr."created_at" as "rfq_shortlisted",	
Cast(rfq.published_at as date) as "RFQ Published Date",	
Cast(sr."created_at" as date) as "Shortlist Date",	
datediff(day,sr.created_at,rfq.published_at) as "Shortlist TAT",	
rfq."pincode",	
pr."property_name",	
pr.address,	
pr."brief_scope",	
rfqi.specifications,	
rfq."max_budget" as budget,	
fps.primary_cm as "cm_name",	
fps.primary_gm as "gm_name",	
fps.primary_designer "dp_name",	
rfqi.unit as "UOM",	
ua.company_name as "Current Vendor shortlisted",	
rfq.status,
sr5."1st_shortlist_date",
Qp5."1st_Publish_date"
	
from boq_backend.rfqs as rfq	
	
left join (Select max(RFQ_ID) as RFQ_ID , min(created_at) as created_at from boq_backend.shortlisted_rfqs where is_deleted=0 group by RFQ_ID) sr on sr.RFQ_ID = rfq.id	
left join boq_backend.shortlisted_rfqs as en on en.rfq_id = rfq.id and en.created_at>= '2018-10-01' and en.is_deleted = 0	
left join boq_backend.rfq_items as rfqi on sr.rfq_id=rfqi.rfq_id and rfqi.created_at>= '2018-10-01'
left join launchpad_backend.projects as pr on rfq.project_id=pr.id	
left join (Select max(RFQ_ID) as RFQ_ID from boq_backend.shortlisted_rfqs where is_deleted=0 group by RFQ_ID) sr1 on sr1.RFQ_ID = rfq.id and rfq.created_at>= '2018-10-01'	
left join boq_backend.cities as city on pr.city_id=city.id	
left join boq_backend.rfq_vendors as rfqv on rfq.id=rfqv.rfq_id and rfqv.is_deleted=0	
left join boq_backend.user_attributes as ua1 on rfqv.vendor_bouncer_id=ua1.bouncer_id	
left join flat_tables.flat_project_settings as fps on rfq.project_id=fps.project_id	
	
left join (Select min(created_at) as "1st_shortlist_date", min(project_id) as project_id from boq_backend.shortlisted_rfqs where entity_id in (5943,3724,3380,4015,5839,4697,6514,7131) Group by project_id) sr5 on sr5.project_id=rfq.project_id	
inner join (Select min(published_at) as "1st_Publish_date", min(project_id) as project_id from boq_backend.rfqs group by project_id) Qp5 on Qp5.project_id = sr5.project_id
left join boq_backend.user_attributes as ua on ua.bouncer_id=en.entity_id	
	
where rfq.status in ('PUBLISHED', 'CLOSED', 'EXPIRED')	
and ua.company_name in ('Livspace Services Gurgaon','Bangalore- In house- Services','Livspace Services Pune','IC2-Delhi','Livspace Services Bangalore','Inhouse Services Mumbai','Inhouse services - Chennai','QS DELHI','In House - Hyderabad') and pr.is_test=0 and sr.created_at >= '2018-10-01'	
	
Group by rfqi.id,rfq.project_id,rfq.id,	
rfqi.name,rfqi.description,	
rfqi.quantity,city.display_name,	
ua.company_name,rfq.published_at,	
sr.created_at,rfq.pincode,	
fps.primary_cm,fps.primary_gm,	
fps.primary_designer,	
pr.property_name,pr.brief_scope,	
rfq.max_budget,ua.company_name,	
rfq.status,pr.customer_display_name,	
en.entity_id,pr.address,	
rfqi.specifications,	
rfqi.unit,sr5."1st_shortlist_date",
Qp5."1st_Publish_date"
	
order by sr5."1st_shortlist_date" desc
limit 25000
