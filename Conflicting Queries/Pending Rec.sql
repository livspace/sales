--http://reports.livspace.com/question/2364

Select A.Project_id,A.Created_year, A.Created_month, A.City,
-- A.CGMV_Month, A.CGMV_year,
 A.Primary_CM, A.Primary_GM, A.Stage_name,
 A.project_Status,
 sum(coalesce((A.order_products_wt),0)) as order_products_wt,
 sum(coalesce((A.order_handling_fee),0)) as order_handling_fee,
 sum(coalesce((A.order_discount),0)) as order_discount,
 sum(coalesce((A.DISCOUNT_VOUCHER),0)) as discount_voucher,

 (sum(coalesce((A.order_products_wt),0)) + sum(coalesce((A.order_handling_fee),0)) )as CGMV,
 (sum(coalesce((A.order_products_wt),0)) + sum(coalesce((A.order_handling_fee),0)) - sum(coalesce((A.order_discount),0)) - sum(coalesce((A.discount_voucher),0))) as Net_CGMV,
 SUM(coalesce((A.REFUNDS),0)) AS REFUNDS,
 sum(coalesce((A.Total_collected_amount),0)) as Total_collected_amount,
 sum(coalesce((A.Total_collected_amount),0))- SUM(coalesce((A.REFUNDS),0)) as Net_collected_amount,
  -- sum(coalesce((pt.Total_collected_amount),0)) - SUM(coalesce((RF.REFUNDS),0)) as 'Collection including refund',
	  (sum(coalesce((A.order_products_wt),0)) + sum(coalesce((A.order_handling_fee),0)) - sum(coalesce((A.Total_collected_amount),0)) - sum(coalesce((A.DISCOUNT_VOUCHER),0))
		 - sum(coalesce((A.order_discount),0)) + SUM(coalesce((A.REFUNDS),0))
																			) as pending_recievable
  
  From
  (
select P.id as project_id,
extract(year from (P.created_at)) as created_year,
 extract(Month from (P.created_at)) as created_month,
 case when P.id = 288958 then 'Noida'  
     when P.id = 168024 then 'Chennai'
     when P.id = 3910 then 'Noida'
     when P.id = 74312 then 'Bangalore'
     when P.id = 78730 then 'Bangalore'
     when P.id = 175599 then 'Chennai'
     when P.id = 184809 then 'Mumbai'
     when P.id = 249725 then 'Noida'
     when P.id = 283496 then 'Delhi'
     when lower(C.display_name) like 'bangalore' then 'Bangalore'
	 when lower(C.display_name) like 'chennai' then 'Chennai' 
	 when lower(C.display_name) in ('delhi','faridabad') then 'Delhi'
	 when lower(C.display_name) in ('gurgaon','dwarka') then 'Gurgaon'
	 when lower(C.display_name) like 'hyderabad' then 'Hyderabad'
	 when lower(C.display_name) IN  ('mumbai','thane','navi mumbai') then 'Mumbai'
	 when lower(C.display_name) IN ('noida','ghaziabad') then 'Noida'
	 when lower(C.display_name) IN ('pune') then 'Pune'
	 ELSE 'Others' end as City, 
--  month(cm.cgmv_order_created_at) as CGMV_Month,
 --  year(cm.cgmv_order_created_at) as CGMV_year,
 P.customer_display_name,
 CM.name as Primary_cm,
 GM.name as Primary_gm,
  PS.display_name as stage_name,
P.status as project_status,
p.property_name,
ad.address,
 sum(VMBO.order_products_wt) as order_products_wt,
 sum(VMBO.order_handling_fee) as order_handling_fee,
 sum(VMBO.order_discount) as order_discount,
sum(pt.DISCOUNT_VOUCHER) as discount_voucher,
 (sum(VMBO.order_products_wt) + sum(VMBO.order_handling_fee)) as GMV,
 SUM(RF.REFUNDS) AS REFUNDS,
  sum(pt.Total_collected_amount) as Total_collected_amount 


From launchpad_backend.projects as P
left join launchpad_backend.project_stages as PS on PS.id = P.stage_id
left join launchpad_backend.cities as C ON C.id = P.city_id
left join ( 
Select B.project_id, B.address
from 
(
Select Distinct A.project_id, A.address, row_number() over (partition by A.project_id order by A.project_id) as row_num
From
(
Select distinct fo.project_id,fa.id_customer, fo.id_address_delivery, concat(fa.address1,fa.address2) as address
from flat_tables.flat_orders as fo 
join flat_tables.flat_address as fa on fa.id_address = fo.id_address_delivery
where active = 1 
and lower(type) = 'customer'  

) as A

where A.project_id is not NULL
-- and row_num = 1
order by project_id
) as B

where B.row_num = 1  ) as ad on ad.project_id = p.id




Left join ( select fact2.project_id, sum(fact2.order_products_wt) as order_products_wt, sum(fact2.order_discount) as order_discount,
		sum(fact2.order_handling_fee) as order_handling_fee
		from 
        (select fact.project_id, fact.order_state, sum(fact.order_products_wt) as order_products_wt,
        sum(fact.order_handling_fee) as order_handling_fee,
            sum(fact.order_discount) as order_discount 
              from
              ( select Distinct project_id,id_order,order_state,order_discount,
              order_products_wt,order_handling_fee
              from flat_tables.flat_orders) as fact
			  where fact.order_state not in ( 'Cancelled' , 'Blocked')
              and fact.id_order not in (1803210096,1803210159,1803210109,1803210083,1803210110,1803210169,1803210221,1803210196,1803210227,1803210205,1803210117,1803210139,1803210113,1803210153,1803210154,1803210224,1803210091,
1803210092,1803210093,1803210095,1803210098,1803210210,1803210107,1803210215,1803210194,1803210202,1803210203,1803210229,1803210207,1803210212,1803210213,1803210088,1803210108,1803210143,1803210178,1803210176,
1803210177,1803210184,1803210191,1803210180,1803210200,1803210085,1803210100,1803210208,1803210209,1803210105,1803210115,1803210211,1803210129,1803210130,1803210156,1803210163,1803210164,1803210219,1803210171,
1803210187,1803210195,1803210198,1803210094,1803210119,1803210166,1803210111,1803210116,1803210142,1803210150,1803210157,1803210172,1803210226,1803210145,1803210161,1803210183,1803210185,1803210186,1803210188,
1803210190,1803210147,1803210149,1803210182,1803210197,1803210087,1803210102,1803210103,1803210204,1803210089,1803210155,1803210168,1803210174,1803210123,1803210124,1803210125,1803210126,1803210127,1803210128,
1803210199,1803210106,1803210138,1803210104,1803210220,1803210084,1803210158,1803210120,1803210167,1803210189,1803210193,1803210090,1803210097,1803210118,1803210160,1803210165,1803210192,1803210082,1803210099,
1803210179,1803210225,1803210101,1803210086,1803210114,1803210131,1803210132,1803210140,1803210146,1803210216,1803210217,1803210175,1803210133,1803210170,1803210201,1803210206,1803210162,1803210222,1803210121,
1803210148,1803210151,1803210152,1803210218,1803210112,1803210122,1803210214,1803210141,1803210173,1803210223,1803210181,1803210134,1803210135,1803210136,1803210137,1803210144,1803210228)

              group by 1,2
              ) as fact2
			  group by 1 )
              as VMBO on VMBO.project_id = P.id
              
left join 	( select id_project, sum(case when lower(pt.pay_method) in ('payu','paytm','other','cheque','wire_transfer','card','demand_draft','cash','discount_voucher',
																														'auto_bank_transfer','razor_pay','wallet_transfer','ingenico') 
                                        and pt.pay_method !='DISCOUNT_VOUCHER'  then
										pt.amount else 0 end ) as Total_collected_amount,
										sum(case when pt.pay_method ='DISCOUNT_VOUCHER' then pt.amount else 0 end) as DISCOUNT_VOUCHER
										from ( select *  
													from fms_backend.ps_transactions as pt
													where  pt.deleted=0 
													and pt.status = 4  
													and pt.entity_type='CUSTOMER' 
													and pt.txn_type='CREDIT'
													) as pt
													
													Group by 1 ) as  pt on pt.id_project = P.id
													
LEFT JOIN ( SELECT ID_PROJECT,
sum( case when pt.txn_type in ('DEBIT') AND pt.PAY_METHOD IN ('CUSTOMER_REFUND') THEN AMOUNT end) AS REFUNDS
from fms_backend.ps_transactions as pt
where pt.deleted = 0
and pt.status = 4
 GROUP BY 1 ) as RF
ON RF.ID_PROJECT = P.ID
													
left join (	Select project_id, B.name
  from
   (select project_id,primary_cm_id as collaborator_id
   from launchpad_backend.project_settings
   -- where is_primary_cm = 1 
   where is_deleted = 0 ) as A
   left join launchpad_backend.bouncer_users as B on B.bouncer_id = A.collaborator_id) as CM on CM.project_id = P.id
   
   left join (	Select project_id, B.name
  from
   (select project_id,primary_gm_id as collaborator_id
   from launchpad_backend.project_settings
   -- where is_primary_Gm = 1
  where is_deleted = 0 ) as A
   left join launchpad_backend.bouncer_users as B on B.bouncer_id = A.collaborator_id) as GM on GM.project_id = P.id

where ps.weight >=400

group by 1,2,3,4,5,6,7,8,9,10,11
) as A 

        Group by 1,2,3,4,5,6,7,8
		
