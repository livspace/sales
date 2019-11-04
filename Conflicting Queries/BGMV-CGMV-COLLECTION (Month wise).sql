--http://reports.livspace.com/question/1421

(select 
'BGMV' as Type,
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
to_char(bgm.logged_month,'YYYY-MM') as month,
prs.primary_gm as GM,
prs.primary_cm as BM,
sum(bgm.amount) as Value,
COUNT(distinct bgm.project_id) as New_Projects,
(sum(case when fps.maxi=1 then bgm.amount end)) as Community_BGMV


from flat_tables.flat_projects prs

left join launchpad_backend.project_bgmvs bgm on bgm.project_id=prs.project_id

-- left join flat_project_payments tp on tp.id_project= prs.project_id
left join (select project_id,max((case when designer_email like '%.dp@livspace%' then 1 else 0 end)) as maxi from flat_tables.flat_project_settings group by project_id) fps on fps.project_id=prs.project_id

where bgm.logged_month >= '2018-07-01'::date and project_city is not null and lower(project_city) not like '%other%' and lower(project_city) not like '%singapo%'  
and prs.is_test_project=false and bgm.project_id not in (13212,	329777,	234935,	237754,	240322,	261576,	274745,	326849,	293430,	201113,	220181,	326308,	372090,	366171,	342931,	343004,	349821,	304431,	335554,	361870,
363072,	365514,	366044,	366061,	372620,	373004,	373931,	179868,	175078,	283496,	295126,	358094,	168024,	261927,	207917,	181066,	25954,	30789,	262032,	272849,	286720,	18889,	18030,	175093,	391973,	
8075,	21136,	30788,	30790,	41192,	72435,	72482,	101834,	87617,	68196,	46582,	45359,	87555,	109016,	117033,	5396,	34153,	30938,	44431,	57144,	47691,	165084,	194085,	119117,	199565,326308,
152616,	330586,	209475,	272877,	205554,	366074,	373736,	391971,	391975,	244482,	382074,	382047,	400526,	394450,	13212,	330301,	0,	95945,	44496,	4492,	189999 )
 
 and prs.primary_cm not in ('Narzina Ahmed', 'Yashashree Deshpande','Tanvi Mehta')
 and prs.primary_designer not in ('Kajal Sood',	'Shabina Shahin',	'Kriti Mehrotra',	'Hina Nigam',	'Pragati Bishnoi',	'Vashundhara Singh',	'Radhika Sharma')


group BY 1,2,3,4,5)

union


(select 
'CGMV' as Type,
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
to_char(order_created_at,'YYYY-MM') as month,
lbp.primary_gm as GM,
lbp.primary_cm as BM,
sum(coalesce(order_products_wt,0) + coalesce(order_handling_fee,0)) as GMV,
0 as New_Projects,
0 as Community_BGMV

from (select Distinct project_id,id_order,order_state,order_discount,order_products_wt,order_handling_fee, order_created_at
 from flat_tables.flat_orders
  where (order_created_at<'2019-08-18'::date or (order_created_at>='2019-08-18'::date and lower(order_client) !='oms')) and id_order not in (1803210096,1803210159,1803210109,1803210083,1803210110,1803210169,1803210221,1803210196,1803210227,1803210205,1803210117,1803210139,1803210113,1803210153,1803210154,1803210224,1803210091,
				1803210092,1803210093,1803210095,1803210098,1803210210,1803210107,1803210215,1803210194,1803210202,1803210203,1803210229,1803210207,1803210212,1803210213,1803210088,1803210108,1803210143,1803210178,1803210176,
				1803210177,1803210184,1803210191,1803210180,1803210200,1803210085,1803210100,1803210208,1803210209,1803210105,1803210115,1803210211,1803210129,1803210130,1803210156,1803210163,1803210164,1803210219,1803210171,
				1803210187,1803210195,1803210198,1803210094,1803210119,1803210166,1803210111,1803210116,1803210142,1803210150,1803210157,1803210172,1803210226,1803210145,1803210161,1803210183,1803210185,1803210186,1803210188,
				1803210190,1803210147,1803210149,1803210182,1803210197,1803210087,1803210102,1803210103,1803210204,1803210089,1803210155,1803210168,1803210174,1803210123,1803210124,1803210125,1803210126,1803210127,1803210128,
				1803210199,1803210106,1803210138,1803210104,1803210220,1803210084,1803210158,1803210120,1803210167,1803210189,1803210193,1803210090,1803210097,1803210118,1803210160,1803210165,1803210192,1803210082,1803210099,
				1803210179,1803210225,1803210101,1803210086,1803210114,1803210131,1803210132,1803210140,1803210146,1803210216,1803210217,1803210175,1803210133,1803210170,1803210201,1803210206,1803210162,1803210222,1803210121,
				1803210148,1803210151,1803210152,1803210218,1803210112,1803210122,1803210214,1803210141,1803210173,1803210223,1803210181,1803210134,1803210135,1803210136,1803210137,1803210144,1803210228)
)  as vmbo

 left join flat_tables.flat_projects as lbp on vmbo.project_id = lbp.project_id


where vmbo.order_state not in ('Cancelled', 'Blocked') AND order_created_at >= '2018-07-01'::date and project_city is not null and lower(project_city) not like '%other%' and lower(project_city) not like '%singapo%'  and lbp.is_test_project=false
and lbp.project_id not in (13212,	329777,	234935,	237754,	240322,	261576,	274745,	326849,	293430,	201113,	220181,	326308,	372090,	366171,	342931,	343004,	349821,	304431,	335554,	361870,
363072,	365514,	366044,	366061,	372620,	373004,	373931,	179868,	175078,	283496,	295126,	358094,	168024,	261927,	207917,	181066,	25954,	30789,	262032,	272849,	286720,	18889,	18030,	175093,	391973,	
8075,	21136,	30788,	30790,	41192,	72435,	72482,	101834,	87617,	68196,	46582,	45359,	87555,	109016,	117033,	5396,	34153,	30938,	44431,	57144,	47691,	165084,	194085,	119117,	199565,326308,
152616,	330586,	209475,	272877,	205554,	366074,	373736,	391971,	391975,	244482,	382074,	382047,	400526,	394450,	13212,	330301,	0,	95945,	44496,	4492,	189999 )
and lbp.primary_cm not in ('Narzina Ahmed', 'Yashashree Deshpande','Tanvi Mehta')
 and lbp.primary_designer not in ('Kajal Sood',	'Shabina Shahin',	'Kriti Mehrotra',	'Hina Nigam',	'Pragati Bishnoi',	'Vashundhara Singh',	'Radhika Sharma')

group by 2,3,4,5
    
    
)

union


( select 
'Refunds' as Type,
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
to_char(pt.date_txn,'YYYY-MM') as month,
prs.primary_gm as GM,
prs.primary_cm as BM,
ABS(sum(pt.amount)) as Value,
1 as New_Projects,
1 as Community_BGMV

from flat_tables.flat_projects prs 

left join flat_tables.flat_credit_transactions pt on prs.project_id=pt.id_project


where  pt.date_txn >= '2018-12-01'::date and project_city is not null and lower(project_city) not like '%other%' and lower(project_city) not like '%singapo%'  and pt.status=4 and prs.is_test_project=false
and lower(pt.pay_method)  like '%refund%'
--  and pt.pay_method in ('payu','paytm','OTHER','CHEQUE','WIRE_TRANSFER','CARD','DEMAND_DRAFT','Cash','AUTO_BANK_TRANSFER','RAZOR_PAY')
and prs.project_id not in (13212,	329777,	234935,	237754,	240322,	261576,	274745,	326849,	293430,	201113,	220181,	326308,	372090,	366171,	342931,	343004,	349821,	304431,	335554,	361870,
363072,	365514,	366044,	366061,	372620,	373004,	373931,	179868,	175078,	283496,	295126,	358094,	168024,	261927,	207917,	181066,	25954,	30789,	262032,	272849,	286720,	18889,	18030,	175093,	391973,	
8075,	21136,	30788,	30790,	41192,	72435,	72482,	101834,	87617,	68196,	46582,	45359,	87555,	109016,	117033,	5396,	34153,	30938,	44431,	57144,	47691,	165084,	194085,	119117,	199565,326308,
152616,	330586,	209475,	272877,	205554,	366074,	373736,	391971,	391975,	244482,	382074,	382047,	400526,	394450,	13212,	330301,	0,	95945,	44496,	4492,	189999 )

and prs.primary_cm not in ('Narzina Ahmed', 'Yashashree Deshpande','Tanvi Mehta')
 and prs.primary_designer not in ('Kajal Sood',	'Shabina Shahin',	'Kriti Mehrotra',	'Hina Nigam',	'Pragati Bishnoi',	'Vashundhara Singh',	'Radhika Sharma')


group by 2,3,4,5

)

union  
(select 

'Collection' as Type,
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
to_char(pt.date_txn,'YYYY-MM') as month,
prs.primary_gm as GM,
prs.primary_cm as BM,
sum(pt.amount) as Value,
1 as New_Projects,
1 as Community_BGMV

from flat_tables.flat_projects prs 

left join fms_backend.ps_transactions pt on prs.project_id=pt.id_project


where  pt.date_txn >= '2018-07-01'::date and project_city is not null and lower(project_city) not like '%other%' and lower(project_city) not like '%singapo%'  
and pt.status=4 and prs.is_test_project=false and pt.deleted=0 
and pt.entity_type='CUSTOMER' 
and pt.txn_type='CREDIT'
and pt.date_txn < current_date
and lower(pt.pay_method) in 
('payu','PAYU','paytm','other','cheque','wire_transfer','card','demand_draft','cash','discount_voucher','auto_bank_transfer','razor_pay','wallet_transfer','ingenico')
and prs.project_id not in (13212,	329777,	234935,	237754,	240322,	261576,	274745,	326849,	293430,	201113,	220181,	326308,	372090,	366171,	342931,	343004,	349821,	304431,	335554,	361870,
363072,	365514,	366044,	366061,	372620,	373004,	373931,	179868,	175078,	283496,	295126,	358094,	168024,	261927,	207917,	181066,	25954,	30789,	262032,	272849,	286720,	18889,	18030,	175093,	391973,	
8075,	21136,	30788,	30790,	41192,	72435,	72482,	101834,	87617,	68196,	46582,	45359,	87555,	109016,	117033,	5396,	34153,	30938,	44431,	57144,	47691,	165084,	194085,	119117,	199565,326308,
152616,	330586,	209475,	272877,	205554,	366074,	373736,	391971,	391975,	244482,	382074,	382047,	400526,	394450,	13212,	330301,	0,	95945,	44496,	4492,	189999 )
    
    and prs.primary_cm not in ('Narzina Ahmed', 'Yashashree Deshpande','Tanvi Mehta')
 and prs.primary_designer not in ('Kajal Sood',	'Shabina Shahin',	'Kriti Mehrotra',	'Hina Nigam',	'Pragati Bishnoi',	'Vashundhara Singh',	'Radhika Sharma')


group by 2,3,4,5
)
