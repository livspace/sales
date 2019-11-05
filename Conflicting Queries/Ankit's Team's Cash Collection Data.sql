--http://reports.livspace.com/question/2484

with COLL as 
(
SELECT
B.Managed_city,
/*coalesce(sum(case when  B.year = 2018 and B.month in (4,5,6,7,8,9) then (B.collected_amount)/100000 end),0) as  H1_FY_18_19,
coalesce(sum(case when (B.year = 2018  and B.month in (10,11,12)) or (B.year = 2019  and B.month in (1,2,3)) then (B.collected_amount)/100000 end),0) as H2_FY_18_19,
 -- coalesce(sum(case when B.month = 8 then (B.collected_amount)/100000 end),0) as Aug,
 -- coalesce(sum(case when B.month = 9 then (B.collected_amount)/100000 end),0) as Sep,
 -- coalesce(sum(case when B.month in (10,11,12) then (B.collected_amount)/100000 end),0) as Oct_Nov_Dec_Q3,
 --coalesce(sum(case when B.month = 10 then (B.collected_amount)/100000 end),0) as 'Oct',
 --coalesce(sum(case when B.month = 11 then (B.collected_amount)/100000 end),0) as 'Nov',
-- coalesce(sum(case when B.month = 12 then (B.collected_amount)/100000 end),0) as 'Dec',
-- coalesce(sum(case when B.month = 1 and B.year = 2019 then (B.collected_amount)/100000 end),0) as 'Jan',
-- coalesce(sum(case when B.month = 2 and B.year = 2019 then (B.collected_amount)/100000 end),0) as Feb,
coalesce(sum(case when B.month = 3 and B.year = 2019 then (B.collected_amount)/100000 end),0) as Mar,*/
coalesce(sum(case when B.month = extract(month from current_date-192) and B.year = extract(year from current_date-192) then (B.collected_amount)/100000 end),0) as M0_6,
coalesce(sum(case when B.month = extract(month from current_date-160) and B.year = extract(year from current_date-160) then (B.collected_amount)/100000 end),0) as M0_5,
coalesce(sum(case when B.month = extract(month from current_date-128) and B.year = extract(year from current_date-128) then (B.collected_amount)/100000 end),0) as M0_4,
coalesce(sum(case when B.month = extract(month from current_date-96) and B.year = extract(year from current_date-96) then (B.collected_amount)/100000 end),0) as M0_3,
coalesce(sum(case when B.month = extract(month from current_date-64) and B.year = extract(year from current_date-64) then (B.collected_amount)/100000 end),0) as M0_2,
coalesce(sum(case when B.month = extract(month from current_date-32) and B.year = extract(year from current_date-32) then (B.collected_amount)/100000 end),0) as M0_1,
coalesce(sum(case when B.month = extract(month from current_date) and B.year = extract(year from current_date) then (B.collected_amount)/100000 end),0) as M0,
/*coalesce(sum((B.collected_amount)/100000),0) as Total,*/
coalesce(sum(case when B.month = extract(month from current_date) and B.year = extract(year from current_date) then ((B.collected_amount)/(extract(day from (current_date))-1))*30 end)/100000,0) as M0_Projection
from
(
SELECT A.* from 
(
select 
pt.id_project,
bu1.name as Managed_city,
pt.payment_stage,
pt.pay_method,
extract(month from (pt.date_txn)) as month,
extract (year from (pt.date_txn)) as year,
sum(pt.amount) as collected_amount

from fms_backend.ps_transactions pt
left join launchpad_backend.projects fp on fp.id=pt.id_project
 left join launchpad_backend.cities as lbc on lbc.id = fp.city_id

left join 
(
select ps.Project_id, bu.name, bu.email
from launchpad_backend.project_settings as ps 
left join launchpad_backend.bouncer_users as bu on bu.bouncer_id = ps.primary_cm_id
where ps.is_deleted = 0 
) as bu1 on bu1.project_id = fp.id

where pt.deleted=0 
and pt.status = 4 
and pt.entity_type='CUSTOMER' 
and pt.txn_type='CREDIT'
and lower(pt.pay_method) in ('payu','PAYU','paytm','other','cheque','wire_transfer','card','demand_draft','cash','discount_voucher','auto_bank_transfer','razor_pay','wallet_transfer') 
and pt.deleted=0 
-- and pt.pay_method!='DISCOUNT_VOUCHER' 
and  to_date(pt.date_txn,'YYYY-MM-DD') >= '2018-04-01'
and pt.date_txn < current_date
and pt.id_project   not in (13212,	329777,	234935,	237754,	240322,	261576,	274745,	326849,	293430,	201113,	220181,	326308,	372090,	366171,	342931,	343004,	349821,	304431,	335554,	361870,
363072,	365514,	366044,	366061,	372620,	373004,	373931,	179868,	175078,	283496,	295126,	358094,	168024,	261927,	207917,	181066,	25954,	30789,	262032,	272849,	286720,	18889,	18030,	175093,	391973,	
8075,	21136,	30788,	30790,	41192,	72435,	72482,	101834,	87617,	68196,	46582,	45359,	87555,	109016,	117033,	5396,	34153,	30938,	44431,	57144,	47691,	165084,	194085,	119117,	199565,326308,
152616,	330586,	209475,	272877,	205554,	366074,	373736,	391971,	391975,	244482,	382074,	382047,	400526,	394450,	13212,	330301,	0,	95945,	44496,	4492,	189999 ) /*-- test projects, DVs, liquidation, Raw_material buyback, One Commercial */

and lower(lbc.display_name) not like '%singap%'
and bu1.name in  ('Rahul Jain','Gourav Goyal', 'Nikhil Malpani', 'Sampada Karmarkar','Praneet  Singh','Charu Gupta')


group by 1,2,3,4,5,6
) as A

-- where A.month >= 4
where A.year >= 2018 

) as B

where B.pay_method != 'DISCOUNT_VOUCHER'

group by 1 
),

 other as (

Select   COLL.Managed_city as BM,
	     /*to_char(COLL.H1_FY_18_19,'FM9,999D0') as H1_FY_18_19,
	     to_char(COLL.H2_FY_18_19,'FM9,999D0') as H2_FY_18_19,
	 -- (COLL.Jan,0,'en_IN') 'Jan_2019',
	 -- (COLL.Feb) Feb_2019,
	     to_char((COLL.Mar),'FM9,999D0') Mar_2019,*/
		 to_char((COLL.M0_6),'FM9,999D0') M0_6,
	     to_char((COLL.M0_5),'FM9,999D0') M0_5,
	     to_char((COLL.M0_4),'FM9,999D0') M0_4,
	     to_char((COLL.M0_3),'FM9,999D0') M0_3,
	     to_char((COLL.M0_2),'FM9,999D0') M0_2,
	     to_char((COLL.M0_1),'FM9,999D0') M0_1,
	     to_char((COLL.M0),'FM9,999D0') M0,
	     /*to_char((COLL.Total),'FM9,9999D0') Total,*/
	     to_char((COLL.M0_projection),'FM9,999D0') M0_2019_Projection,
	     concat(to_char((((COLL.M0_projection - COLL.M0_1)/nullif(COLL.M0_1,0))*100),'FM9,99D0'),'%')as MOM
	 
	 from COLL
	 Order by BM
		), 

 other_1 as (
	 select 'TOTAL' as TOTAL,
	 /*to_char(sum(COLL.H1_FY_18_19),'FM99,999D0')   as H1_FY_18_19,
	 to_char(sum(COLL.H2_FY_18_19),'FM99,999D0') as H2_FY_18_19,
	 --  (COLL.Jan,0,'en_IN') 'Jan_2019',
	 -- (COLL.Feb) Feb_2019,
	 to_char(sum((COLL.Mar)),'FM9,999D0') Mar_2019,*/
	 to_char(sum((COLL.M0_6)),'FM9,999D0') M0_6_2019,
	 to_char(sum((COLL.M0_5)),'FM9,999D0') M0_5_2019,
	 to_char(sum((COLL.M0_4)),'FM9,999D0') M0_4_2019,
	 to_char(sum((COLL.M0_3)),'FM9,999D0') M0_3_2019,
	 to_char(sum((COLL.M0_2)),'FM9,999D0') M0_2_2019,
	 to_char(sum((COLL.M0_1)),'FM9,999D0') M0_1_2019,
	 to_char(sum((COLL.M0)),'FM9,999D0') M0_2019,
	 /*to_char(sum((COLL.Total)),'FM9,9999D0') Total,*/
	 to_char(sum((COLL.M0_projection)),'FM9,999D0') M0_2019_Projection,
	 concat(to_char(((sum(COLL.M0_projection - COLL.M0_1)/nullif(sum(COLL.M0_1),0))*100),'FM9,99D0'),'%')as MOM
	  
	  from COLL
	  Group by 1
	 ),
	 
	 final as (
	 Select * from Other
	 union 
	 Select * from Other_1
				) 
				
				select * from final 
				order by BM
