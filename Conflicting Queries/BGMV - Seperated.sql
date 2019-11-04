--http://live-data.livspace.com/question/2281

select pb.project_id,
case when pb.project_id = 271772 then 'Bangalore'
when pb.project_id = 263836 then 'Bangalore'
when pb.project_id = 288958 then 'Noida'  
when pb.project_id = 168024 then 'Chennai'
when pb.project_id = 3910 then 'Noida'
when pb.project_id = 74312 then 'Bangalore'
when pb.project_id = 78730 then 'Bangalore'
when pb.project_id = 175599 then 'Chennai'
when pb.project_id = 184809 then 'Mumbai'
when pb.project_id = 249725 then 'Noida'
when pb.project_id = 283496 then 'Delhi'
when lower(lbc.display_name) like 'bangalore' then 'Bangalore'
when lower(lbc.display_name) like 'chennai' then 'Chennai'
when lower(lbc.display_name) in ('delhi','faridabad') then 'Delhi'
when lower(lbc.display_name) in ('gurgaon','dwarka') then 'Gurgaon'
when lower(lbc.display_name) like 'hyderabad' then 'Hyderabad'
when lower(lbc.display_name) IN  ('mumbai','thane','navi mumbai') then 'Mumbai'
when lower(lbc.display_name) IN ('noida','ghaziabad') then 'Noida'
when lower(lbc.display_name) IN ('pune') then 'Pune'
ELSE 'Others' end as city,
to_char(pb.logged_month,'YYYY-MM') as logged_month,
bu1.name as GM_name,
bu2.name as CM_name,
bu3.name as designer_name,
case when lower(bu3.email) like '%dp%' then 'community'
else 'inhouse' end as designer_type,
pb.new_bgmv_value-pb.old_bgmv_value as GMV,
p.status,
tp.amount,
pst.display_name as stage,
pbs.bgmv as "BGMV- Total",
(case when bu2.name in ('Tanvi Mehta','Yamini Manickavasagam','Narzina Ahmed','Tawish Tayal','Shruthi R')
then 1 else 0 end) as "Commercial Project?",
to_char(pb.created_at,'YYYY-MM') as created_at,
pb.updated_by_id as "updated by_id",
pb.reason


from launchpad_backend.project_bgmv_ledger as pb

-- left join launchpad_backend.project_bgmv_ledger pbl on pbl.project_id=pb.project_id and pb.amount=pbl.new_bgmv_value-pbl.old_bgmv_value and pbl.updated_by_id=pb.updated_by_id and date(pbl.created_at)=date(pb.created_at)
--  and pb.logged_month=pbl.logged_month

left join (select project_id as project_id, sum(amount) as bgmv from launchpad_backend.project_bgmvs where is_deleted = 0  group by project_id) pbs on pbs.project_id=pb.project_id
left join launchpad_backend.projects as p on p.id = pb.project_id
left join launchpad_backend.project_stages pst on pst.id=p.stage_id
left join launchpad_backend.cities as lbc on lbc.id = p.city_id
 left join (
 select project_id, primary_cm_id , bu.name
From launchpad_backend.project_settings  as ps
left join launchpad_backend.bouncer_users as bu on ps.primary_cm_id = bu.bouncer_id
       where ps.is_deleted = 0
        ) as bu2 on bu2.project_id = pb.project_id
       
 
 left join (
 select project_id, primary_GM_id , bu.name
From launchpad_backend.project_settings  as ps
left join launchpad_backend.bouncer_users as bu on ps.primary_gm_id = bu.bouncer_id
       where ps.is_deleted = 0
        ) as bu1 on bu1.project_id = pb.project_id


 left join (
 select project_id, primary_designer_id , bu.name, bu.email
From launchpad_backend.project_settings  as ps
left join launchpad_backend.bouncer_users as bu on ps.primary_designer_id = bu.bouncer_id
       where ps.is_deleted = 0
        ) as bu3 on bu3.project_id = pb.project_id
       
left join (select id_project as id_project , sum(amount) as amount,min(date_txn) as created_at from fms_backend.ps_transactions where txn_type='CREDIT'
and status='4' and payment_stage in ('TEN_PERCENT','PRE_TEN_PERCENT') group by id_project) tp on p.id = tp.id_project

where pb.is_deleted = 0
-- and pbl.is_deleted = 0
and pb.project_id>0 and pb.project_id not in (13212, 329777, 234935, 237754, 240322, 261576, 274745, 326849, 293430, 201113, 220181, 326308, 372090, 366171, 342931, 343004, 349821, 304431, 335554, 361870,
363072, 365514, 366044, 366061, 372620, 373004, 373931, 179868, 175078, 283496, 295126, 358094, 168024, 261927, 207917, 181066, 25954, 30789, 262032, 272849, 286720, 18889, 18030, 175093, 391973,
8075, 21136, 30788, 30790, 41192, 72435, 72482, 101834, 87617, 68196, 46582, 45359, 87555, 109016, 117033, 5396, 34153, 30938, 44431, 57144, 47691, 165084, 194085, 119117, 199565,326308,
152616, 330586, 209475, 272877, 205554, 366074, 373736, 391971, 391975, 244482, 382074, 382047, 400526, 394450, 13212, 330301, 0, 95945, 44496, 4492, 189999 )

order by pb.logged_month asc
