--http://reports.livspace.com/question/2255

Select

(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
prs.primary_cm,
prs.primary_designer,
to_char(logged_month,'YYYY-MM') as logged_month,

sum(bgm.amount) as Bgmv 

from launchpad_backend.project_bgmvs bgm

left join flat_tables.flat_projects prs 

on prs.project_id=bgm.project_id

where (bgm.logged_month>=date_trunc('month',current_date))
and prs.primary_cm in ('Nidhi Agarwal','Anjuli Gupta','Abhishek Sharma','Palak Jolly','Rinkesh Bafna','Gautam Gupta','Sri Harsha Ks','Mohammed Azharuddin','Tarun Garg','Prateek Bharadwaj','Himanshi Sharma','Abhishek Sharma','Heli Kumar','Chandana  Ainwale','Annu  Bala','Natasha Sharon Shah','Natasha .','Satish Prasad  Sahu','Mohammad Takki','Shuchi',
'Nitin Bhatia') and bgm.is_deleted=0 AND bgm.project_id not in (13212,	329777,	234935,	237754,	240322,	261576,	274745,	326849,	293430,	201113,	220181,	326308,	372090,	366171,	342931,	343004,	349821,	304431,	335554,	361870,
363072,	365514,	366044,	366061,	372620,	373004,	373931,	179868,	175078,	283496,	295126,	358094,	168024,	261927,	207917,	181066,	25954,	30789,	262032,	272849,	286720,	18889,	18030,	175093,	391973,	
8075,	21136,	30788,	30790,	41192,	72435,	72482,	101834,	87617,	68196,	46582,	45359,	87555,	109016,	117033,	5396,	34153,	30938,	44431,	57144,	47691,	165084,	194085,	119117,	199565,326308,
152616,	330586,	209475,	272877,	205554,	366074,	373736,	391971,	391975,	244482,	382074,	382047,	400526,	394450,	13212,	330301,	0,	95945,	44496,	4492,	189999 ) 


group by 1,2,3,4
order by City
