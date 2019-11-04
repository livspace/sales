--http://reports.livspace.com/question/2164

select 
prs.project_pincode,
sum(bgm.amount) as Value


from flat_tables.flat_projects prs

left join launchpad_backend.project_bgmvs bgm on bgm.project_id=prs.project_id

where bgm.logged_month >= '2019-01-01'::date and bgm.logged_month <= '2019-06-30'::date 
and (lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%') 
and prs.is_test_project=false 
and bgm.project_id not in (13212, 329777,	234935,	237754, 240322,	261576,	274745, 13212,	326849,	293430, 201113,	220181,	326308, 372090,	366171,	
 342931,	343004,	349821, 304431,	335554,	361870, 363072,	365514,	366044, 366061,	372620,	373004, 373931,	179868,	175078, 283496,	295126,	358094,
 168024,	261927,	207917, 181066,	25954,	30789,	262032, 272849,	286720,	18889,	18030, 175093,	330301,	0)

group BY 1

order by 1
