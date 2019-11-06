--http://reports.livspace.com/question/1240

select      
rfqi.id as rfq_item_id, 
rfq.id as RFQ_ID, 
rfq."project_id", 
pr.customer_display_name as customer_name,      
rfqi."name" as "item_name",   
rfqi."description" as "item_description", 
rfqi."quantity",  
city."display_name" as City,  
ua1."company_name" as "sp_name",    
rfq."pincode",    
rfq.sp_rfq_id,    
q.id as Quote_ID, 
pr."brief_scope", 
rfqi.specifications,    
rfq."max_budget" as budget,   
fps.primary_cm as "cm_name",  
fps.primary_gm as "gm_name",  
fps.primary_designer "dp_name",     
rfqi.unit as "UOM",     
rfq.rfv_stage as status, 
Cast(rfq.floated_at as date) as "RFQ Published Date",
Cast(QS.created_at as date) as "QS assigned date",
Cast(rfq.site_visit_scheduled_at as date),
Cast(q.created_at as date) as "Quote Created date",
Cast(q.published_at as date) as "Quote publish date",
Cast(rfq.customer_order_raised_at as date),
Cast(rfq.sp_rfq_floated_at as date) as "SP_RFQ_Date",
Cast(q2.created_at as date) as "SP Quote Created at",
Cast(q2.published_at as date) as "SP Quoute published_at",
Cast(rfq.sp_order_raised_at as date) as "SP_PO_Date",
wu.name as "QS assigned",
q."No. of iterations",rfq.status



from boq_backend.rfqs as rfq  
      
left join boq_backend.rfq_items as rfqi on rfq.id=rfqi.rfq_id
left join launchpad_backend.projects as pr on rfq.project_id=pr.id      
left join boq_backend.cities as city on pr.city_id=city.id  
left join boq_backend.rfq_users as rfqv on rfq.id=rfqv.rfq_id and rfqv.is_deleted=0 
left join (Select max(rfq_id) as "rfq_id",max(bouncer_id) as "bouncer_id" from boq_backend.rfq_users where is_deleted=0  and user_association_tag = ('QS') group by rfq_id) Users2 on Users2.rfq_id = rfq.id
left join flat_tables.flat_bouncer_user as wu on wu.bouncer_id = Users2.bouncer_id
left join boq_backend.user_attributes as ua1 on rfqv.bouncer_id=ua1.bouncer_id      
left join flat_tables.flat_project_settings as fps on rfq.project_id=fps.project_id
left join (Select max(id) as "RFV_ID" from boq_backend.rfqs where processing_model = 'RFV' group by id) RFV on RFV.RFV_ID=rfq.id
left join (Select min(id) as ID,rfq_id as rfq_id,min(created_at) as "created_at" ,min(published_at) as "published_at", count(customer_price) as "No. of iterations" from boq_backend.quotes where rfq_processing_model = 'RFV' and status in ('PUBLISHED','CONVERTED','EXPIRED','DRAFT','CANCELLED') group by rfq_id) q on q.rfq_id = RFV.RFV_ID
left join (Select min(RFQ_id) as "RFQ_ID", min(created_at) as "Created_at" from boq_backend.rfq_users where user_association_tag = 'QS' group by RFQ_ID) QS on QS.RFQ_ID = rfq.id
left join (Select min(RFQ_ID) as "QR_ID" ,min(created_at) as "created_at" ,min(published_at) as "published_at" from boq_backend.quotes where status = 'CONVERTED' and rfq_processing_model = 'RFQ_VIA_RFV' group by rfq_id) q2 on q2.QR_ID=rfq.sp_rfq_id


where rfq.status in ('PUBLISHED', 'CLOSED', 'EXPIRED','DRAFT','CANCELLED') 
-- and rfqv.user_association_tag in ('LEAD_QS')
--  and pr.is_test=0
and rfq.processing_model = 'RFV' and rfq.rfv_stage is not null
Group by rfqi.id,rfq.project_id,rfq.id,   
rfqi.name,rfqi.description,   
rfqi.quantity,city.display_name,    
ua1.company_name,rfq.floated_at,
rfq.pincode,      
fps.primary_cm,fps.primary_gm,      
fps.primary_designer,   
pr.property_name,pr.brief_scope,    
rfq.max_budget,   
rfq.rfv_stage,pr.customer_display_name,
pr.address, 
rfqi.specifications,    
rfqi.unit,
rfq.site_visit_scheduled_at,
rfq.customer_order_raised_at,
rfq.sp_rfq_floated_at,
rfq.sp_order_raised_at,
q.created_at,
q.published_at,
QS.created_at,
q2.created_at,
q2.published_at,
q.id,
wu.name,
rfq.sp_rfq_id
,rfqi.created_at,
q."No. of iterations",
rfq.status
order by rfq.floated_at
