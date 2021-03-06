--http://reports.livspace.com/question/2042

Select

prs.primary_designer,

(case when
lower(prs.project_designer_email) like '%.dp@%' then 'DP' else 'ID' end) as Type_of_ID,

prs.project_designer_email as Project_Designer_email,

(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,

sum(bgm.amount) as Bgmv 

from launchpad_backend.project_bgmvs bgm

left join flat_tables.flat_projects prs 

on prs.project_id=bgm.project_id

where (bgm.logged_month>=date_trunc('month',current_date))

and prs.project_city is not null and lower(prs.project_city) not like '%other%' and lower(prs.project_city) not like '%singapo%'  and prs.is_test_project=false and bgm.project_id not in (13212, 329777,	234935,	237754, 240322,	261576,	274745, 13212,	326849,	293430, 201113,	220181,	326308, 372090,	366171,	
 342931,	343004,	349821, 304431,	335554,	361870, 363072,	365514,	366044, 366061,	372620,	373004, 373931,	179868,	175078, 283496,	295126,	358094,
 168024,	261927,	207917, 181066,	25954,	30789,	262032, 272849,	286720,	18889,	18030, 175093,	330301,	0)
 
 and prs.primary_cm not in ('Narzina Ahmed', 'Yashashree Deshpande','Tanvi Mehta')
 and prs.primary_designer not in ('Kajal Sood',	'Shabina Shahin',	'Kriti Mehrotra',	'Hina Nigam',	'Pragati Bishnoi',	'Vashundhara Singh',	'Radhika Sharma')

group by 1,2,3,4 
order by City
