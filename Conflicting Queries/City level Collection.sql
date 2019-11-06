--http://reports.livspace.com/question/2507?cm=ALL&designer=ALL&gm=ALL&Project_city=ALL&txn_date=2019-01-01

(select 
prs.project_id,

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
prs.primary_designer as "Designer Name",
sum(pt.amount) as "Collection"

from flat_tables.flat_projects prs 

left join fms_backend.ps_transactions pt on prs.project_id=pt.id_project


where  pt.date_txn >={{txn_date}}
and (case when {{Project_city}}='ALL' then 1 when (prs.project_city)={{Project_city}} then 1 else 0 end)
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
and (case when {{gm}}='ALL' then 1 when prs.primary_gm={{gm}} then 1 else 0 end)
and (case when {{cm}} = 'ALL' then 1 when prs.primary_cm={{cm}} then 1 else 0 end)
and (case when {{designer}} = 'ALL' then 1 when prs.primary_designer={{designer}} then 1 else 0 end)

group by 1,2,3,4,5,6
)
