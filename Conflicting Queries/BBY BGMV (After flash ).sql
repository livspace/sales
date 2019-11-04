--http://reports.livspace.com/question/2266

Select
(case 
when lower(project_city) like '%bangalore%' or lower(project_city) like '%hyderabad%' or lower(project_city) like '%chennai%' or lower(project_city) like '%pune%' then project_city
when lower(project_city) like '%mumbai%' or lower(project_city) like '%thane%' then 'Mumbai'
when lower(project_city) like '%gurgaon%' or lower(project_city) like '%dwarka%' then 'Gurgaon'
when lower(project_city) like '%delhi%' or lower(project_city) like '%farida%' then 'Delhi'
when lower(project_city) like '%noida%' or lower(project_city) like '%ghaz%' then 'Noida'
end) as City,
prs.primary_gm as GM,
prs.primary_cm as BM,
prs.primary_designer as Designer,
(case when
lower(prs.project_designer_email) like '%.dp@%' then 'DP' else 'ID' end )as Type,
to_char(bgm.logged_month,'YYYY-MM') as "Logged date",

sum(bgm.amount) as Bgmv 

from launchpad_backend.project_bgmvs bgm

left join flat_tables.flat_projects prs 

on prs.project_id=bgm.project_id

where bgm.logged_month>='2019-01-01'::date
group by 1,2,3,4,5,6 order by City

