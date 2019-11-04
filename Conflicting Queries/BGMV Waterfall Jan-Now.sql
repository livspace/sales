--http://reports.livspace.com/question/2203

select 
(case 
when project_city like '%angalor%' or project_city like '%yderaba%' or project_city like '%henn%' or project_city like '%une%' then project_city
when project_city like '%umba%' or project_city like '%han%' then 'Mumbai'
when project_city like '%urgao%' or project_city like '%wara%' then 'Gurgaon'
when project_city like '%elh%' or project_city like '%arid%' then 'Delhi'
when project_city like '%oid%' or project_city like '%haz%' then 'Noida'
end) as City,

prs.primary_gm,
prs.primary_cm as BM,

to_char(pvs.event_date,'YYYY-MM') as CM_Assigned,
to_char(tp.logged_month,'YYYY-MM') as Month_Booked,
sum(tp.amount) as Value

from flat_tables.flat_projects prs

left join flat_tables.flat_project_events pvs on prs.project_id=pvs.project_id

left join launchpad_backend.project_bgmvs tp on tp.project_id=prs.project_id


where logged_month >= '2018-01-01'::date and project_city is not null and project_city not like '%other%' and project_city not like '%singapo%'  and prs.is_test_project=false and tp.project_id not in (13212, 329777,	234935,	237754, 240322,	261576,	274745, 13212,	326849,	293430, 201113,	220181,	326308, 372090,	366171,	
 342931,	343004,	349821, 304431,	335554,	361870, 363072,	365514,	366044, 366061,	372620,	373004, 373931,	179868,	175078, 283496,	295126,	358094,
 168024,	261927,	207917, 181066,	25954,	30789,	262032, 272849,	286720,	18889,	18030, 175093,	330301,	0)
 and pvs.new_value=18 and pvs.event_date>='2019-01-01'::date
 
 

group BY 1,2,3,4,5

order by 1
