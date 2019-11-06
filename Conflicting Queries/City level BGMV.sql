--http://reports.livspace.com/question/2505?logged_date=2019-01-01&Project_city=ALL&cm=ALL&gm=ALL&designer=ALL

(select 
prs.project_id,

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

prs.primary_designer as "Designer Name",

(case when lower(prs.project_designer_email) like '%.dp@%' then 'DP' else 'ID' end) as "Type of Designer",

sum(bgm.amount) as BGMV,

(sum(case when fps.maxi=1 then bgm.amount end)) as Community_BGMV

from flat_tables.flat_projects prs

left join launchpad_backend.project_bgmvs bgm on bgm.project_id=prs.project_id

left join (select project_id,max((case when designer_email like '%.dp@livspace%' then 1 else 0 end)) as maxi from flat_tables.flat_project_settings group by project_id) fps on fps.project_id=prs.project_id

where bgm.logged_month>={{logged_date}} 
and (case when {{Project_city}}='ALL' then 1 when (prs.project_city)={{Project_city}} then 1 else 0 end)
and prs.is_test_project=false 
and bgm.project_id not in (13212,	329777,	234935,	237754,	240322,	261576,	274745,	326849,	293430,	201113,	220181,	326308,	372090,	366171,	342931,	343004,	349821,	304431,	335554,	361870,
363072,	365514,	366044,	366061,	372620,	373004,	373931,	179868,	175078,	283496,	295126,	358094,	168024,	261927,	207917,	181066,	25954,	30789,	262032,	272849,	286720,	18889,	18030,	175093,	391973,	
8075,	21136,	30788,	30790,	41192,	72435,	72482,	101834,	87617,	68196,	46582,	45359,	87555,	109016,	117033,	5396,	34153,	30938,	44431,	57144,	47691,	165084,	194085,	119117,	199565,326308,
152616,	330586,	209475,	272877,	205554,	366074,	373736,	391971,	391975,	244482,	382074,	382047,	400526,	394450,	13212,	330301,	0,	95945,	44496,	4492,	189999 )
and (case when {{gm}}='ALL' then 1 when prs.primary_gm={{gm}} then 1 else 0 end)
and (case when {{cm}} = 'ALL' then 1 when prs.primary_cm={{cm}} then 1 else 0 end)
and (case when {{designer}} = 'ALL' then 1 when prs.primary_designer={{designer}} then 1 else 0 end)
group BY 1,2,3,4,5,6,7)
