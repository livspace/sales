--http://reports.livspace.com/question/1843



With CGMV as 
(
	SELECT
	B.Managed_city,
	/*coalesce(sum(case when  B.year = 2018 and B.month in (4,5,6,7,8,9) then (B.gmv)/100000 end),0) as  H1_FY_18_19,
	coalesce(sum(case when (B.year = 2018  and B.month in (10,11,12)) or (B.year = 2019  and B.month in (1,2,3)) then (B.gmv)/100000 end),0) as H2_FY_18_19,
	coalesce(sum(case when B.month = 3 and B.year = 2019 then (B.gmv)/100000 end),0) as Mar,*/
	coalesce(sum(case when B.month = 4 and B.year = 2019 then (B.gmv)/100000 end),0) as Apr,
	coalesce(sum(case when B.month = 5 and B.year = 2019 then (B.gmv)/100000 end),0) as May,
	coalesce(sum(case when B.month = 6 and B.year = 2019 then (B.gmv)/100000 end),0) as Jun,
	coalesce(sum(case when B.month = 7 and B.year = 2019 then (B.gmv)/100000 end),0) as Jul,
	coalesce(sum(case when B.month = 8 and B.year = 2019 then (B.gmv)/100000 end),0) as Aug,
	/*coalesce(sum((B.gmv)/100000),0) as Total,*/
	coalesce(sum(case when B.month = 8 and B.year = 2019 then ((B.gmv)/(extract(day from (current_date))-1))*30 end)/100000,0) as Aug_Projection
	from
	(
				Select A.*
				from
				(
				select fo.project_id, 
				bu1.name as Managed_city,
				 extract (month from (fo.order_created_at)) as month,
				 extract (year from (fo.order_created_at)) as year,
				 fo.order_discount, 
				 fo.order_products_wt, 
				 fo.order_handling_fee,
				 coalesce(fo.order_products_wt,0) + coalesce(fo.order_handling_fee,0) as GMV


				 from (select Distinct project_id,id_order,order_state,order_discount,order_products_wt,order_handling_fee, order_created_at
				 from flat_tables.flat_orders)
				 as fo
				 left join launchpad_backend.projects as fp on fo.project_id = fp.id
				 left join launchpad_backend.cities as lbc on lbc.id = fp.city_id
				 left join 
				(
				select ps.Project_id, bu.name, bu.email
				from launchpad_backend.project_settings as ps 
				left join launchpad_backend.bouncer_users as bu on bu.bouncer_id = ps.primary_cm_id
				where ps.is_deleted = 0 
				) as bu1 on bu1.project_id = fp.id


				where fo.id_order not in (1803210096,1803210159,1803210109,1803210083,1803210110,1803210169,1803210221,1803210196,1803210227,1803210205,1803210117,1803210139,1803210113,1803210153,1803210154,1803210224,1803210091,
				1803210092,1803210093,1803210095,1803210098,1803210210,1803210107,1803210215,1803210194,1803210202,1803210203,1803210229,1803210207,1803210212,1803210213,1803210088,1803210108,1803210143,1803210178,1803210176,
				1803210177,1803210184,1803210191,1803210180,1803210200,1803210085,1803210100,1803210208,1803210209,1803210105,1803210115,1803210211,1803210129,1803210130,1803210156,1803210163,1803210164,1803210219,1803210171,
				1803210187,1803210195,1803210198,1803210094,1803210119,1803210166,1803210111,1803210116,1803210142,1803210150,1803210157,1803210172,1803210226,1803210145,1803210161,1803210183,1803210185,1803210186,1803210188,
				1803210190,1803210147,1803210149,1803210182,1803210197,1803210087,1803210102,1803210103,1803210204,1803210089,1803210155,1803210168,1803210174,1803210123,1803210124,1803210125,1803210126,1803210127,1803210128,
				1803210199,1803210106,1803210138,1803210104,1803210220,1803210084,1803210158,1803210120,1803210167,1803210189,1803210193,1803210090,1803210097,1803210118,1803210160,1803210165,1803210192,1803210082,1803210099,
				1803210179,1803210225,1803210101,1803210086,1803210114,1803210131,1803210132,1803210140,1803210146,1803210216,1803210217,1803210175,1803210133,1803210170,1803210201,1803210206,1803210162,1803210222,1803210121,
				1803210148,1803210151,1803210152,1803210218,1803210112,1803210122,1803210214,1803210141,1803210173,1803210223,1803210181,1803210134,1803210135,1803210136,1803210137,1803210144,1803210228)

				and fo.project_id not in (13212,	329777,	234935,	237754,	240322,	261576,	274745,	326849,	293430,	201113,	220181,	326308,	372090,	366171,	342931,	343004,	349821,	304431,	335554,	361870,
363072,	365514,	366044,	366061,	372620,	373004,	373931,	179868,	175078,	283496,	295126,	358094,	168024,	261927,	207917,	181066,	25954,	30789,	262032,	272849,	286720,	18889,	18030,	175093,	391973,	
8075,	21136,	30788,	30790,	41192,	72435,	72482,	101834,	87617,	68196,	46582,	45359,	87555,	109016,	117033,	5396,	34153,	30938,	44431,	57144,	47691,	165084,	194085,	119117,	199565,326308,
152616,	330586,	209475,	272877,	205554,	366074,	373736,	391971,	391975,	244482,	382074,	382047,	400526,	394450,	13212,	330301,	0,	95945,	44496,	4492,	189999 ) /*-- test projects, DVs, liquidation, Raw_material buyback, One Commercial */

					
					and to_date(fo.order_created_at,'YYYY-MM-DD') >= '2018-04-01'
					and fo.order_created_at < current_date
					and fo.order_state not in ('Cancelled', 'Blocked') 
					and bu1.name in ('Abhishek Kinariwala','Sayanti Mukherjee','Shikha Agarwal','Surender Reddy','Shruti Sharma','Raghu Satwik' )
					) as A
					
		where A.year >= 2018
		and lower(A.managed_city) not like '%singap%'
		

	) as B

 group by 1 
  
) ,

 other as (

Select   CGMV.Managed_city as BM,
	    /* to_char(CGMV.H1_FY_18_19,'FM9,999D0') as H1_FY_18_19,
	     to_char(CGMV.H2_FY_18_19,'FM9,999D0') as H2_FY_18_19,
	 -- (CGMV.Jan,0,'en_IN') 'Jan_2019',
	 -- (CGMV.Feb) Feb_2019,
	     to_char((CGMV.Mar),'FM9,999D0') Mar_2019,*/
		 to_char((CGMV.Apr),'FM9,999D0') Apr_2019,
	     to_char((CGMV.May),'FM9,999D0') May_2019,
	     to_char((CGMV.Jun),'FM9,999D0') Jun_2019,
	     to_char((CGMV.Jun),'FM9,999D0') Jul_2019,
	     to_char((CGMV.Jun),'FM9,999D0') Aug_2019,
	     /*to_char((CGMV.Total),'FM9,9999D0') Total,*/
	     to_char((CGMV.Aug_projection),'FM9,999D0') Aug_2019_Projection,
	     concat(to_char((((CGMV.Aug_projection - CGMV.Jul)/NULLIF(CGMV.Jul,0))*100),'FM9,99D0'),'%')as MOM
	 
	 from CGMV
	 Order by BM
		), 

 other_1 as (
	 select 'TOTAL' as TOTAL,
	 /*to_char(sum(CGMV.H1_FY_18_19),'FM99,999D0')   as H1_FY_18_19,
	 to_char(sum(CGMV.H2_FY_18_19),'FM99,999D0') as H2_FY_18_19,
	 --  (CGMV.Jan,0,'en_IN') 'Jan_2019',
	 -- (CGMV.Feb) Feb_2019,
	 to_char(sum((CGMV.Mar)),'FM9,999D0') Mar_2019,*/
	 to_char(sum((CGMV.Apr)),'FM9,999D0') Apr_2019,
	 to_char(sum((CGMV.May)),'FM9,999D0') May_2019,
	 to_char(sum((CGMV.Jun)),'FM9,999D0') Jun_2019,
	 to_char(sum((CGMV.Jul)),'FM9,999D0') Jul_2019,
	 to_char(sum((CGMV.Aug)),'FM9,999D0') Aug_2019,
	/* to_char(sum((CGMV.Total)),'FM9,9999D0') Total,*/
	 to_char(sum((CGMV.Aug_projection)),'FM9,999D0') Aug_2019_Projection,
	 concat(to_char(((sum(CGMV.Aug_projection - CGMV.Jul)/sum(CGMV.Jul))*100),'FM9,99D0'),'%')as MOM
	  
	  from CGMV
	  Group by 1
	 ),
	 
	 final as (
	 Select * from Other
	 union 
	 Select * from Other_1
				) 
				
				select * from final 
				order by BM
