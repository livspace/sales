--http://live-data.livspace.com/question/2273

Select D.project_id,D.Primary_GM,D.Primary_CM,D.primary_designer,D.city,D.super_category, sum(D.GMV) as GMV
From
(
SELECT C.project_id,C.Primary_GM,C.Primary_CM,C.primary_designer,C.city,
C.order_year_month,C.super_category,C.design_sku,sum(C.GMV) as GMV, sum(C.Total_price_wt) as Total_price_wt, sum(Handling_fees) as Handling_fees
FROM(

SELECT B.project_id, B.primary_GM, B.Primary_CM, B.primary_designer, B.managed_city as city, B.order_year_month,B.super_category, B.design_sku,
sum(B.Total_price_wt + B.handling_fees ) as GMV, sum(B.Total_price_wt) as Total_price_wt, sum(B.handling_fees ) as Handling_fees
from 
(
SELECT A.Project_ID,
bu1.name as Primary_GM,
bu2.name as Primary_CM,
bu3.name as primary_designer,
case when A.project_id = 263836 then 'Bangalore'
	 when A.project_id = 288958 then 'Noida'  
     when A.project_id = 168024 then 'Chennai'
     when A.project_id = 3910 then 'Noida'
     when A.project_id = 74312 then 'Bangalore'
     when A.project_id = 78730 then 'Bangalore'
     when A.project_id = 175599 then 'Chennai'
     when A.project_id = 184809 then 'Mumbai'
     when A.project_id = 249725 then 'Noida'
     when A.project_id = 283496 then 'Delhi'
     when lower(lbc.display_name) like 'bangalore' then 'Bangalore'
	 when lower(lbc.display_name) like 'chennai' then 'Chennai' 
	 when lower(lbc.display_name) in ('delhi','faridabad') then 'Delhi'
	 when lower(lbc.display_name) in ('dwarka','gurgaon') then 'Gurgaon'
	 when lower(lbc.display_name) like 'hyderabad' then 'Hyderabad'
	 when lower(lbc.display_name) IN  ('mumbai','thane','navi mumbai') then 'Mumbai'
	 when lower(lbc.display_name) IN ('noida','ghaziabad') then 'Noida'
	 when lower(lbc.display_name) IN ('pune') then 'Pune'
	 ELSE 'Others' end as Managed_city, 
 A.super_category, 
 case when lower(A.product_name) like '%design%' then 'design_sku' else 'others' end as design_sku, 
 to_char(A.order_created_date,'YYYY-MM') as Order_year_month,
 sum(A.product_price*A.quantity) as Total_price_wt,
 sum((A.product_price*A.quantity)*0.08) as handling_fees
from 
(
select p.id as Project_ID,
p1.delivery_city,
p2.id_order,
p2.sku_code,
p2.product_name,
sum(p2.product_quantity) as Quantity,
p2.group_name,
p2.product_type,
p2.product_category,
pt.display_name prod_type,
pc.display_name category,
p2.product_price,
p.created_at as Project_Create_Date,
p2.create_time as Order_Created_date,
smpc.name as super_category,
p.city_id

from launchpad_backend.projects p

left join oms_backend.ps_orders p1 on p.id = p1.id_project
join oms_backend.ps_order_history as poh on p1.order_state = poh.id_order_history
left join oms_backend.ps_order_detail p2 on p1.id_order = p2.id_order 
left join cms_backend.cms_product_category pc on pc.id = p2.product_category
left join cms_backend.cms_product_type pt on pt.id = p2.product_type
left join cms_backend.cms_super_category as smpc on pt.super_category = smpc.id
   -- where p.id = 70364
 where 1=1 
 -- and to_date(p2.create_time,'YYYY-MM-DD') >= '2018-04-01'
 and poh.id_order_state != 6
 and p1.date_add < '2019-08-18'::date or (p1.date_add >='2019-08-18'::date and lower(p1.client) !='oms')
 and p.is_test = 0
 -- and lower(smpc.name) != 'services'

group by 1,2,3,4,5,7,8,9,10,11,12,13,14,15,16

) as A 

left join launchpad_backend.cities as lbc on lbc.id = A.city_id
	  left join (
 select project_id, primary_cm_id , bu.name
				From launchpad_backend.project_settings  as ps 
				left join launchpad_backend.bouncer_users as bu on ps.primary_cm_id = bu.bouncer_id
				        where ps.is_deleted = 0 
        ) as bu2 on bu2.project_id = A.project_id
        
  
 left join (
 select project_id, primary_GM_id , bu.name
				From launchpad_backend.project_settings  as ps 
				left join launchpad_backend.bouncer_users as bu on ps.primary_gm_id = bu.bouncer_id
				        where ps.is_deleted = 0 
        ) as bu1 on bu1.project_id = A.project_id


 left join (
 select project_id, primary_designer_id , bu.name
				From launchpad_backend.project_settings  as ps 
				left join launchpad_backend.bouncer_users as bu on ps.primary_designer_id = bu.bouncer_id
				        where ps.is_deleted = 0 
        ) as bu3 on bu3.project_id = A.project_id


-- where month(A.order_created_date) = 4
-- and year(A.order_created_date) >= 2018

group by 1,2,3,4,5,6,7,8

) as B

Group by 1,2,3,4,5,6,7,8

Union

Select    oo.Project_id,
	bu1.name as Primary_GM,
	bu2.name as Primary_CM,
	bu3.name as primary_designer,
case when oo.Project_id = 263836 then 'Bangalore'
	 when oo.Project_id = 288958 then 'Noida'  
     when oo.Project_id = 168024 then 'Chennai'
     when oo.Project_id = 3910 then 'Noida'
     when oo.Project_id = 74312 then 'Bangalore'
     when oo.Project_id = 78730 then 'Bangalore'
     when oo.Project_id = 175599 then 'Chennai'
     when oo.Project_id = 184809 then 'Mumbai'
     when oo.Project_id = 249725 then 'Noida'
     when oo.Project_id = 283496 then 'Delhi'
     when lower(lbc.display_name) like 'bangalore' then 'Bangalore'
	 when lower(lbc.display_name) like 'chennai' then 'Chennai' 
	 when lower(lbc.display_name) in ('delhi','faridabad') then 'Delhi'
	 when lower(lbc.display_name) in ('dwarka','gurgaon') then 'Gurgaon'
	 when lower(lbc.display_name) like 'hyderabad' then 'Hyderabad'
	 when lower(lbc.display_name) IN  ('mumbai','thane','navi mumbai') then 'Mumbai'
	 when lower(lbc.display_name) IN ('noida','ghaziabad') then 'Noida'
	 when lower(lbc.display_name) IN ('pune') then 'Pune'
	 ELSE 'Others' end as city, 
	 to_char(oo.created_at,'YYYY-MM') as order_year_month,
	 'PO Services' as super_category,
	 case when oo.fulfiller_entity_ID = 2527 then 'design_sku' else 'others' end as design_sku,
	 
	 sum(case when oo.processing_model is NULL then oo.total_price + oo.handling_fee else ((oo.total_price + oo.total_tax)/ ((100 - oo.margin)/100)) + oo.handling_fee end ) as GMV,
	 -- sum(oo.total_price + oo.handling_fee) as GMV,
	 sum(case when oo.processing_model is NULL then oo.total_price + oo.handling_fee else ((oo.total_price + oo.total_tax)/ ((100 - oo.margin)/100)) end ) as Total_price_wt,
	 sum(oo.handling_fee) as Handling_fees
	 
	 from boq_backend.oms_orders as oo
	 join launchpad_backend.projects p on p.id = oo.project_id
	 left join launchpad_backend.cities as lbc on lbc.id = p.city_id
	 
	  left join (
 select project_id, primary_cm_id , bu.name
				From launchpad_backend.project_settings  as ps 
				left join launchpad_backend.bouncer_users as bu on ps.primary_cm_id = bu.bouncer_id
				        where ps.is_deleted = 0 
        ) as bu2 on bu2.project_id = oo.project_id
        
  
 left join (
 select project_id, primary_GM_id , bu.name
				From launchpad_backend.project_settings  as ps 
				left join launchpad_backend.bouncer_users as bu on ps.primary_gm_id = bu.bouncer_id
				        where ps.is_deleted = 0 
        ) as bu1 on bu1.project_id = oo.project_id
		

 left join (
 select project_id, primary_designer_id , bu.name
				From launchpad_backend.project_settings  as ps 
				left join launchpad_backend.bouncer_users as bu on ps.primary_designer_id = bu.bouncer_id
				        where ps.is_deleted = 0 
        ) as bu3 on bu3.project_id = oo.project_id
		
	 
	 where  1= 1 
	 and oo.is_deleted = 0 
	 and p.is_test = 0
	 -- and id_project = 70364
	-- and to_date(oo.created_at,'YYYY-MM-DD') >= '2018-04-01'
	 -- and oo.vendor_type='CANVAS_VENDOR' 
	 
	 group by 1,2,3,4,5,6,7,8
	 
	 ) as C 
   
   where C.project_id not in (13212,	329777,	234935,	237754,	240322,	261576,	274745,	326849,	293430,	201113,	220181,	326308,	372090,	366171,	342931,	343004,	349821,	304431,	335554,	361870,
363072,	365514,	366044,	366061,	372620,	373004,	373931,	179868,	175078,	283496,	295126,	358094,	168024,	261927,	207917,	181066,	25954,	30789,	262032,	272849,	286720,	18889,	18030,	175093,	391973,	
8075,	21136,	30788,	30790,	41192,	72435,	72482,	101834,	87617,	68196,	46582,	45359,	87555,	109016,	117033,	5396,	34153,	30938,	44431,	57144,	47691,	165084,	194085,	119117,	199565,326308,
152616,	330586,	209475,	272877,	205554,	366074,	373736,	391971,	391975,	244482,	382074,	382047,	400526,	394450,	13212,	330301,	0,	95945,	44496,	4492,	189999 ) /*-- test projects, DVs, liquidation, Raw_material buyback, One Commercial */

   
	 Group by 1,2,3,4,5,6,7,8
	 
	 Having sum(C.GMV) > 0
) as D

Group by 1,2,3,4,5,6
