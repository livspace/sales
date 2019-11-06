--http://reports.livspace.com/question/1219

select c.display_name as "City", r.project_id as "Project ID",p.customer_display_name as "Customer Name",pss.display_name as "Project Stage",r.id as "RFQ ID", r.name as "RFQ Name",	
to_char(r.published_at,'MM-DD-YYYY') as "RFQ_date",datediff(day,r.published_at,current_date) as "RFQ Age", r.status as "RFQ Status", r.max_budget as "Max Budget",	
coalesce(len(regexp_replace(listagg(DISTINCT u2.id, ','), '[^,]', '')) + 1, 0) as "Number of vendors RFQ broadcasted",	
listagg(distinct u2.name,',') as "Name of vendors RFQ broadcasted",	
coalesce(len(regexp_replace(listagg(DISTINCT u.id, ','), '[^,]', '')) + 1, 0) as "Total number of vendors interest shown",	
listagg(distinct u.name,',') as "Name of vendors Interest Shown",	
coalesce(len(regexp_replace(listagg(DISTINCT u1.id, ','), '[^,]', '')) + 1, 0) as "Number of vendors Quoted",	
listagg(distinct u1.name,',') as "Name of vendors Quoted",	
case when r.Status = 'CLOSED' then 'Yes' else 'No' end as "Is RFQ converted to order?",	
datediff(day,r.published_at,min(q.published_at)) as "RFQ to 1st Quote TAT in days",	
o.id as "Order ID",	
o.total_price as "Order value",	
fps.primary_designer as "DP Name",	
fps.primary_cm as "CM Name",	
fps.primary_gm as "GM Name",	
p.pincode as "Pincode",	
datediff(day,r.published_at,min(sr.created_at)) as "RFQ to 1st Shortlist in days",	
coalesce(len(regexp_replace(listagg(DISTINCT u3.id, ','), '[^,]', '')) + 1, 0) as "Current number of interest shown",	
listagg(distinct u3.name,',') as "Current name of vendors Interest Shown" ,
coalesce(len(regexp_replace(listagg(DISTINCT q.published_at, ','), '[^,]', '')) + 1, 0) as "No. of Iterations",
r.processing_model, listagg(DISTINCT q.published_at || ',' || q.customer_price,',') within group (order by q.published_at) as "Data",
u5.name as "Order raised to vendor"


	
	
	
from boq_backend.rfqs r	
left join boq_backend.quotes q4 on r.converted_quote_id = q4.id
left join community.user u5 on q4.created_by_entity_id=u5.login_id
left join launchpad_backend.projects p on r.project_id=p.id 	
left join launchpad_backend.cities c on c.id=p.city_id	
	
left join launchpad_backend.project_stages pss on pss.id=p.stage_id	
	
left join boq_backend.rfq_users rv on r.id=rv.rfq_id and rv.is_deleted=0	
left join community.user u2 on rv.bouncer_id=u2.login_id	
left join boq_backend.shortlisted_rfqs sr on r.id=sr.rfq_id	
left join community.user u on u.login_id=sr.entity_id	
left join boq_backend.quotes q on r.id=q.rfq_id and (q.status='PUBLISHED' or q.status='ACCEPTED' or q.status='CONVERTED' or q.status='CANCELLED')	
left join community.user u1 on u1.login_id=q.created_by_entity_id 	
left join boq_backend.quotes q1 on r.id=q1.rfq_id and q1.status='CONVERTED'	
left join boq_backend.oms_orders o on q1.canvas_po_id=o.source_entity_id 	
left join boq_backend.shortlisted_rfqs sr2 on r.id=sr2.rfq_id and sr2.is_deleted=0	
left join community.user u3 on u3.login_id=sr2.entity_id	
	
left join flat_tables.flat_project_settings fps on r.project_id=fps.project_id	
 left join community.user uav on q.created_by_entity_id=uav.login_id and q.status = 'CONVERTED'	
	
where p.status='ACTIVE' and (r.status='PUBLISHED' or r.status='CLOSED' or r.status='EXPIRED') [[and r.project_id={{Projectid}}]] 

Group by r.id,c.display_name,p.customer_display_name,r.project_id,pss.display_name,r.id,r.name,r.published_at,r.status,r.max_budget,o.id,o.total_price,fps.primary_designer,fps.primary_cm,fps.primary_gm,p.pincode,r.processing_model,u5.name

order by r.id desc	

limit 9000
	
;	
