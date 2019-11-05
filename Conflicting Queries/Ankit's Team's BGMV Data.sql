--http://reports.livspace.com/question/2483

with BGMV as
(
SELECT
B.Managed_city,
/*Coalesce(sum(case when  B.year = 2018 and B.month in (4,5,6,7,8,9) then (B.gmv)/100000 end),0) as  H1_FY_18_19,
Coalesce(sum(case when (B.year = 2018  and B.month in (10,11,12)) or (B.year = 2019  and B.month in (1,2,3)) then (B.gmv)/100000 end),0) as H2_FY_18_19,
Coalesce(sum(case when B.month = 3 and B.year = 2019 then (B.gmv)/100000 end),0) as Mar,*/
Coalesce(sum(case when B.month =extract(month from current_date-192) and B.year = extract(year from current_date-192) then (B.gmv)/100000 end),0) as M0_6,
Coalesce(sum(case when B.month =extract(month from current_date-160) and B.year = extract(year from current_date-160) then (B.gmv)/100000 end),0) as M0_5,
Coalesce(sum(case when B.month =extract(month from current_date-128) and B.year = extract(year from current_date-128) then (B.gmv)/100000 end),0) as M0_4,
Coalesce(sum(case when B.month =extract(month from current_date-96) and B.year = extract(year from current_date-96) then (B.gmv)/100000 end),0) as M0_3,
Coalesce(sum(case when B.month =extract(month from current_date-64) and B.year = extract(year from current_date-64) then (B.gmv)/100000 end),0) as M0_2,
Coalesce(sum(case when B.month =extract(month from current_date-32) and B.year = extract(year from current_date-32) then (B.gmv)/100000 end),0) as M0_1,
Coalesce(sum(case when B.month =extract(month from current_date) and B.year = extract(year from current_date) then (B.gmv)/100000 end),0) as M0,
Coalesce(sum((B.gmv)/100000),0) as Total,
Coalesce(sum(case when B.month = extract(month from current_date) and B.year = extract(year from current_date) then ((B.gmv)/(extract(day from (current_date))-1))*30 end)/100000,0) as M0_Projection
from
(
select 
	gmv.project_id,
	bu1.name as Managed_city,
	-- pr.customer_display_name as customer_name,
	bu1.name as primary_cm,
	bu2.name as primary_gm,
	bu3.name as primary_designer,
	extract(month from (gmv.logged_month)) as month,
	extract(year from (gmv.logged_month)) as year,
	to_char(gmv.logged_month,'YYYY-MM') as gmv_month,
	gmv.amount as gmv
		
from
	launchpad_backend.project_bgmvs as gmv	
left join
	 launchpad_backend.projects as p on p.id = gmv.project_id and p.is_test = 0
left join   
	 launchpad_backend.cities as lbc on lbc.id = p.city_id 

left join 
(
select ps.Project_id, bu.name, bu.email
from launchpad_backend.project_settings as ps 
left join launchpad_backend.bouncer_users as bu on bu.bouncer_id = ps.primary_cm_id
where ps.is_deleted = 0 
) as bu1 on bu1.project_id = gmv.project_id

left join 
(
select ps.Project_id, bu.name, bu.email
from launchpad_backend.project_settings as ps 
left join launchpad_backend.bouncer_users as bu on bu.bouncer_id = ps.primary_gm_id
where ps.is_deleted = 0 
) as bu2 on bu2.project_id = gmv.project_id

left join 
(
select ps.Project_id, bu.name, bu.email
from launchpad_backend.project_settings as ps 
left join launchpad_backend.bouncer_users as bu on bu.bouncer_id = ps.primary_designer_id
where ps.is_deleted = 0 
) as bu3 on bu3.project_id = gmv.project_id

where gmv.project_id not in (13212,	329777,	234935,	237754,	240322,	261576,	274745,	326849,	293430,	201113,	220181,	326308,	372090,	366171,	342931,	343004,	349821,	304431,	335554,	361870,
363072,	365514,	366044,	366061,	372620,	373004,	373931,	179868,	175078,	283496,	295126,	358094,	168024,	261927,	207917,	181066,	25954,	30789,	262032,	272849,	286720,	18889,	18030,	175093,	391973,	
8075,	21136,	30788,	30790,	41192,	72435,	72482,	101834,	87617,	68196,	46582,	45359,	87555,	109016,	117033,	5396,	34153,	30938,	44431,	57144,	47691,	165084,	194085,	119117,	199565,326308,
152616,	330586,	209475,	272877,	205554,	366074,	373736,	391971,	391975,	244482,	382074,	382047,	400526,	394450,	13212,	330301,	0,	95945,	44496,	4492,	189999 ) /*-- test projects, DVs, liquidation, Raw_material buyback, One Commercial */
and to_date(gmv.logged_month,'YYYY-MM-DD') >= '2018-04-01'
and lower(lbc.display_name) not like '%singap%'
and bu1.name in  ('Rahul Jain','Gourav Goyal', 'Nikhil Malpani', 'Sampada Karmarkar','Praneet  Singh','Charu Gupta')

) as B

where B.year >= 2018

group by 1

) ,


 other as (

Select   BGMV.Managed_city as BM,
	     /*to_char(BGMV.H1_FY_18_19,'FM9,999D0') as H1_FY_18_19,
	     to_char(BGMV.H2_FY_18_19,'FM9,999D0') as H2_FY_18_19,*/
	 -- (BGMVJan,0,'en_IN') 'Jan_2019',
	 -- (BGMVFeb) Feb_2019,
	     /*to_char((BGMV.Mar),'FM9,999D0') Mar_2019,*/
		 to_char((BGMV.M0_6),'FM9,999D0') M0_6,
	     to_char((BGMV.M0_5),'FM9,999D0') M0_5,
	     to_char((BGMV.M0_4),'FM9,999D0') M0_4,
	     to_char((BGMV.M0_3),'FM9,999D0') M0_3,
	     to_char((BGMV.M0_2),'FM9,999D0') M0_2,
	     to_char((BGMV.M0_1),'FM9,999D0') M0_1,
	     to_char((BGMV.M0),'FM9,999D0') M0,
	     to_char((BGMV.Total),'FM9,9999D0') Total,
	     to_char((BGMV.M0_projection),'FM9,999D0') M0_2019_Projection,
	     concat(to_char((((BGMV.M0_projection - BGMV.M0_1)/nullif(BGMV.M0_1,0))*100),'FM9,99D0'),'%')as MOM
	 
	 from BGMV
	 Order by BM
		), 

 other_1 as (
	 select 'TOTAL' as TOTAL,
	 /*to_char(sum(BGMV.H1_FY_18_19),'FM99,999D0')   as H1_FY_18_19,
	 to_char(sum(BGMV.H2_FY_18_19),'FM99,999D0') as H2_FY_18_19,
	 --  (BGMVJan,0,'en_IN') 'Jan_2019',
	 -- (BGMVFeb) Feb_2019,
	 to_char(sum((BGMV.Mar)),'FM9,999D0') Mar_2019,*/
	 to_char(sum((BGMV.M0_6)),'FM9,999D0') M0_6_2019,
	 to_char(sum((BGMV.M0_5)),'FM9,999D0') M0_5_2019,
	 to_char(sum((BGMV.M0_4)),'FM9,999D0') M0_4_2019,
	 to_char(sum((BGMV.M0_3)),'FM9,999D0') M0_3_2019,
	 to_char(sum((BGMV.M0_2)),'FM9,999D0') M0_2_2019,
	 to_char(sum((BGMV.M0_1)),'FM9,999D0') M0_1_2019,
	 to_char(sum((BGMV.M0)),'FM9,999D0') M0_2019,
	 to_char(sum((BGMV.Total)),'FM9,9999D0') Total,
	 to_char(sum((BGMV.M0_projection)),'FM9,999D0') M0_2019_Projection,
	 concat(to_char(((sum(BGMV.M0_projection - BGMV.M0_1)/sum(nullif(BGMV.M0_1,0)))*100),'FM9,99D0'),'%')as MOM
	  
	  from BGMV
	  Group by 1
	 ),
	 
	 final as (
	 Select * from Other
	 union 
	 Select * from Other_1
				) 
				
				select * from final 
				order by BM





